import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
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
          value: product.display,
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
    cells.add(CustomCell(label: '${row.getCells()[0].value}'));
    cells.add(CustomCell(label: '${row.getCells()[1].value}'));
    cells.add(CustomCell(label: '${row.getCells()[2].value}'));
    cells.add(CustomCell(label: '${row.getCells()[3].value}'));
    cells.add(CustomCell(label: '${row.getCells()[4].value}'));
    cells.add(CustomCell(label: '${row.getCells()[5].value}'));
    cells.add(CustomCell(label: '${row.getCells()[6].value}'));
    cells.add(CustomCell(label: '${row.getCells()[7].value}'));
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
