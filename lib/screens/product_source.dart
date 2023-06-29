import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_image_cell.dart';
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
          columnName: 'priority',
          value: product.priority,
        ),
        DataGridCell(
          columnName: 'display',
          value: product.display ? '表示' : '非表示',
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
      path: '${row.getCells()[5].value}',
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
  @override
  void initState() {
    super.initState();
    widget.productProvider.setController(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '食器 - 編集',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '食器番号',
            child: Text(widget.product.number),
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
            String? error = await widget.productProvider.update(widget.product);
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
