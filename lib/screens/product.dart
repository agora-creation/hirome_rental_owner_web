import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/screens/product_source.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_input_image.dart';
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
    return Stack(
      children: [
        const AnimationBackground(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '各店舗が注文するための商品データを表示しています。',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Expander(
                      header:
                          Text('検索条件 : ${widget.productProvider.searchText}'),
                      content: Column(
                        children: [
                          GridView(
                            shrinkWrap: true,
                            gridDelegate: kSearchGrid,
                            children: [
                              InfoLabel(
                                label: '商品番号',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: widget.productProvider.searchNumber,
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != '') {
                                        widget.productProvider.searchNumber =
                                            value;
                                      } else {
                                        widget.productProvider.searchNumber =
                                            null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '商品名',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: widget.productProvider.searchName,
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != '') {
                                        widget.productProvider.searchName =
                                            value;
                                      } else {
                                        widget.productProvider.searchName =
                                            null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '請求用商品番号',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: widget
                                        .productProvider.searchInvoiceNumber,
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != '') {
                                        widget.productProvider
                                            .searchInvoiceNumber = value;
                                      } else {
                                        widget.productProvider
                                            .searchInvoiceNumber = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: 'カテゴリ',
                                child: ComboBox<int>(
                                  value: widget.productProvider.searchCategory,
                                  items: kCategoryComboItems,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.productProvider.searchCategory =
                                          value;
                                    });
                                  },
                                  isExpanded: true,
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
                            label: const CustomCell(label: '商品番号'),
                          ),
                          GridColumn(
                            columnName: 'name',
                            label: const CustomCell(label: '商品名'),
                          ),
                          GridColumn(
                            columnName: 'invoiceNumber',
                            label: const CustomCell(label: '請求用商品番号'),
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
                            columnName: 'singleQuantity',
                            label: const CustomCell(label: '単数'),
                          ),
                          GridColumn(
                            columnName: 'image',
                            label: const CustomCell(label: '画像'),
                          ),
                          GridColumn(
                            columnName: 'category',
                            label: const CustomCell(label: 'カテゴリ'),
                          ),
                          GridColumn(
                            columnName: 'priority',
                            label: const CustomCell(label: '表示順'),
                          ),
                          GridColumn(
                            columnName: 'edit',
                            label: const CustomCell(label: '操作'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
  Uint8List? pickedImage;

  @override
  void initState() {
    super.initState();
    widget.productProvider.clearController();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '商品 - 新規登録',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '商品番号',
              child: CustomTextBox(
                controller: widget.productProvider.number,
                placeholder: '例) 1234',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '商品名',
              child: CustomTextBox(
                controller: widget.productProvider.name,
                placeholder: '例) ジョッキ',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '請求書用商品番号',
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
              label: '単数',
              child: CustomTextBox(
                controller: widget.productProvider.singleQuantity,
                placeholder: '例) 1',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '画像',
              child: CustomInputImage(
                picked: pickedImage,
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    setState(() {
                      pickedImage = result.files.first.bytes;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'カテゴリ',
              child: ComboBox<int>(
                value: widget.productProvider.category,
                items: kCategoryComboItems,
                onChanged: (value) {
                  setState(() {
                    widget.productProvider.category = value ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '表示順',
              child: CustomTextBox(
                controller: widget.productProvider.priority,
                placeholder: '例) 0',
                keyboardType: TextInputType.text,
                maxLines: 1,
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
            String? error = await widget.productProvider.create(pickedImage);
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.productProvider.clearController();
            widget.getProducts();
            if (!mounted) return;
            showMessage(context, '商品を登録しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
