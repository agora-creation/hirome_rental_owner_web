import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_image_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_input_image.dart';
import 'package:hirome_rental_owner_web/widgets/custom_text_box.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProductSource extends DataGridSource {
  final BuildContext context;
  final ProductProvider productProvider;
  final List<ProductModel> products;
  final Function() getProducts;

  ProductSource({
    required this.context,
    required this.productProvider,
    required this.products,
    required this.getProducts,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = products.map<DataGridRow>((product) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'number',
          value: product.number,
        ),
        DataGridCell(
          columnName: 'name',
          value: product.name,
        ),
        DataGridCell(
          columnName: 'invoiceNumber',
          value: product.invoiceNumber,
        ),
        DataGridCell(
          columnName: 'price',
          value: product.price,
        ),
        DataGridCell(
          columnName: 'unit',
          value: product.unit,
        ),
        DataGridCell(
          columnName: 'image',
          value: product.image,
        ),
        DataGridCell(
          columnName: 'category',
          value: product.categoryText(),
        ),
        DataGridCell(
          columnName: 'priority',
          value: product.priority,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = kWhiteColor;
    }
    List<Widget> cells = [];
    ProductModel product = products.singleWhere(
      (e) => e.number == '${row.getCells()[0].value}',
    );
    cells.add(CustomCell(
      label: '${row.getCells()[0].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[1].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[2].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[3].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[4].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomImageCell(
      image: '${row.getCells()[5].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[6].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[7].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModProductDialog(
          productProvider: productProvider,
          product: product,
          getProducts: getProducts,
        ),
      ),
    ));
    return DataGridRowAdapter(color: backgroundColor, cells: cells);
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(
      String value,
      EdgeInsets padding,
      Alignment alignment,
    ) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value, softWrap: false),
      );
    }

    widget = buildCell(
      summaryValue,
      const EdgeInsets.all(4),
      Alignment.centerLeft,
    );
    return widget;
  }

  void updateDataSource() {
    notifyListeners();
  }
}

class ModProductDialog extends StatefulWidget {
  final ProductProvider productProvider;
  final ProductModel product;
  final Function() getProducts;

  const ModProductDialog({
    required this.productProvider,
    required this.product,
    required this.getProducts,
    super.key,
  });

  @override
  State<ModProductDialog> createState() => _ModProductDialogState();
}

class _ModProductDialogState extends State<ModProductDialog> {
  Uint8List? pickedImage;

  @override
  void initState() {
    super.initState();
    widget.productProvider.setController(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '商品 - 編集',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '商品番号',
              child: Text(widget.product.number),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '商品名',
              child: CustomTextBox(
                controller: widget.productProvider.inputName,
                placeholder: '例) ジョッキ',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '請求書用商品番号',
              child: CustomTextBox(
                controller: widget.productProvider.inputInvoiceNumber,
                placeholder: '例) 1234',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '単価',
              child: CustomTextBox(
                controller: widget.productProvider.inputPrice,
                placeholder: '例) 20',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '単位',
              child: CustomTextBox(
                controller: widget.productProvider.inputUnit,
                placeholder: '例) 枚',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '画像',
              child: CustomInputImage(
                url: widget.product.image,
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
                value: widget.productProvider.inputCategory,
                items: const [
                  ComboBoxItem(
                    value: 0,
                    child: Text('食器'),
                  ),
                  ComboBoxItem(
                    value: 1,
                    child: Text('雑品'),
                  ),
                  ComboBoxItem(
                    value: 9,
                    child: Text('洗浄'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    widget.productProvider.inputCategory = value ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '表示順',
              child: CustomTextBox(
                controller: widget.productProvider.inputPriority,
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
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await widget.productProvider.delete(widget.product);
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
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.productProvider.update(
              widget.product,
              pickedImage,
            );
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
