import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShopSource extends DataGridSource {
  final List<ShopModel> shops;

  ShopSource({required this.shops}) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = shops.map<DataGridRow>((shop) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'number',
          value: shop.number,
        ),
        DataGridCell(
          columnName: 'name',
          value: shop.name,
        ),
        DataGridCell(
          columnName: 'invoiceNumber',
          value: shop.invoiceNumber,
        ),
        DataGridCell(
          columnName: 'invoiceName',
          value: shop.invoiceName,
        ),
        DataGridCell(
          columnName: 'password',
          value: shop.password,
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
    cells.add(CustomCell('${row.getCells()[0].value}'));
    cells.add(CustomCell('${row.getCells()[1].value}'));
    cells.add(CustomCell('${row.getCells()[2].value}'));
    cells.add(CustomCell('${row.getCells()[3].value}'));
    cells.add(CustomCell('${row.getCells()[4].value}'));
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
