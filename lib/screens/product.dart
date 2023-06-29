import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/screens/product_source.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_text_box.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProductScreen extends StatefulWidget {
  final ProductProvider productProvider;

  const ProductScreen({
    required this.productProvider,
    super.key,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel> products = [];

  void _getProducts() async {
    List<ProductModel> tmpProducts = await widget.productProvider.selectList();
    if (mounted) {
      setState(() => products = tmpProducts);
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '店舗が注文するための食器データを一覧で表示します。検索で絞り込んだり、登録・編集・削除することができます。',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Expander(
                  header: Text('検索条件 : ${widget.productProvider.searchText}'),
                  content: Column(
                    children: [
                      GridView(
                        shrinkWrap: true,
                        gridDelegate: kSearchGrid,
                        children: [
                          InfoLabel(
                            label: '食器番号',
                            child: CustomTextBox(
                              controller: widget.productProvider.searchNumber,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                          InfoLabel(
                            label: '食器名',
                            child: CustomTextBox(
                              controller: widget.productProvider.searchName,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                          InfoLabel(
                            label: '請求用食器番号',
                            child: CustomTextBox(
                              controller:
                                  widget.productProvider.searchInvoiceNumber,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconTextButton(
                            iconData: FluentIcons.clear,
                            iconColor: kLightBlueColor,
                            labelText: '検索リセット',
                            labelColor: kLightBlueColor,
                            backgroundColor: kWhiteColor,
                            onPressed: () {
                              widget.productProvider.searchClear();
                              _getProducts();
                            },
                          ),
                          const SizedBox(width: 8),
                          CustomIconTextButton(
                            iconData: FluentIcons.search,
                            iconColor: kWhiteColor,
                            labelText: '検索する',
                            labelColor: kWhiteColor,
                            backgroundColor: kLightBlueColor,
                            onPressed: () => _getProducts(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconTextButton(
                      iconData: FluentIcons.add,
                      iconColor: kWhiteColor,
                      labelText: '新規登録',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddProductDialog(
                          productProvider: widget.productProvider,
                          getProducts: _getProducts,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 600,
                  child: CustomDataGrid(
                    source: ProductSource(
                      context: context,
                      productProvider: widget.productProvider,
                      products: products,
                      getProducts: _getProducts,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'number',
                        label: const CustomCell(label: '食器番号'),
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: const CustomCell(label: '食器名'),
                      ),
                      GridColumn(
                        columnName: 'invoiceNumber',
                        label: const CustomCell(label: '請求用食器番号'),
                      ),
                      GridColumn(
                        columnName: 'price',
                        label: const CustomCell(label: '単価'),
                      ),
                      GridColumn(
                        columnName: 'unit',
                        label: const CustomCell(label: '単位'),
                      ),
                      GridColumn(
                        columnName: 'image',
                        label: const CustomCell(label: '画像'),
                      ),
                      GridColumn(
                        columnName: 'priority',
                        label: const CustomCell(label: '表示の優先順位'),
                      ),
                      GridColumn(
                        columnName: 'display',
                        label: const CustomCell(label: '表示の有無'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final ProductProvider productProvider;
  final Function() getProducts;

  const AddProductDialog({
    required this.productProvider,
    required this.getProducts,
    super.key,
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  PlatformFile? pickedImage;

  @override
  void initState() {
    super.initState();
    widget.productProvider.clearController();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '食器 - 新規登録',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '食器番号',
              child: CustomTextBox(
                controller: widget.productProvider.number,
                placeholder: '例) 1234',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '食器名',
              child: CustomTextBox(
                controller: widget.productProvider.name,
                placeholder: '例) ジョッキ',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '請求書用食器番号',
              child: CustomTextBox(
                controller: widget.productProvider.invoiceNumber,
                placeholder: '例) 1234',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '単価',
              child: CustomTextBox(
                controller: widget.productProvider.price,
                placeholder: '例) 20',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '単位',
              child: CustomTextBox(
                controller: widget.productProvider.unit,
                placeholder: '例) 枚',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '画像',
              child: GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result == null) return;
                  setState(() {
                    pickedImage = result.files.first;
                  });
                },
                child: pickedImage == null
                    ? Image.asset(
                        'assets/images/no_image.png',
                        fit: BoxFit.fitWidth,
                      )
                    : Image.memory(
                        Uint8List.fromList(pickedImage!.bytes!),
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '表示の優先順位',
              child: CustomTextBox(
                controller: widget.productProvider.priority,
                placeholder: '例) 0',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '表示の有無',
              child: ComboBox<bool>(
                value: widget.productProvider.display,
                items: const [
                  ComboBoxItem(
                    value: true,
                    child: Text('表示'),
                  ),
                  ComboBoxItem(
                    value: false,
                    child: Text('非表示'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    widget.productProvider.display = value ?? true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: '登録する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.productProvider.create();
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.productProvider.clearController();
            widget.getProducts();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
