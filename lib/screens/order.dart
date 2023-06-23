import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderScreen extends StatefulWidget {
  final OrderProvider orderProvider;

  const OrderScreen({
    required this.orderProvider,
    super.key,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderModel> orders = [];

  void _getOrders() async {
    List<OrderModel> tmpOrders = await widget.orderProvider.selectList();
    if (mounted) {
      setState(() => orders = tmpOrders);
    }
  }

  @override
  void initState() {
    super.initState();
    _getOrders();
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
                  '店舗が注文したデータを一覧で表示します。検索で絞り込んだり、帳票の出力を行うことができます。',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Expander(
                  header: Text('検索条件 : なし'),
                  content: Column(
                    children: [],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconTextButton(
                      iconData: FluentIcons.download,
                      iconColor: kWhiteColor,
                      labelText: 'PDFダウンロード',
                      labelColor: kWhiteColor,
                      backgroundColor: kRedColor,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    CustomIconTextButton(
                      iconData: FluentIcons.download,
                      iconColor: kWhiteColor,
                      labelText: 'CSVダウンロード',
                      labelColor: kWhiteColor,
                      backgroundColor: kGreenColor,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 450,
                  child: CustomDataGrid(
                    source: _OrderSource(orders: orders),
                    columns: [
                      GridColumn(
                        columnName: 'createdAt',
                        label: const CustomCell('注文日時'),
                      ),
                      GridColumn(
                        columnName: 'number',
                        label: const CustomCell('注文番号'),
                      ),
                      GridColumn(
                        columnName: 'shopName',
                        label: const CustomCell('発注元店舗'),
                      ),
                      GridColumn(
                        columnName: 'orderProducts',
                        label: const CustomCell('注文商品'),
                      ),
                      GridColumn(
                        columnName: 'status',
                        label: const CustomCell('ステータス'),
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

class _OrderSource extends DataGridSource {
  final List<OrderModel> orders;

  _OrderSource({required this.orders}) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = orders.map<DataGridRow>((order) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'createdAt',
          value: dateText('yyyy/MM/dd HH:mm', order.createdAt),
        ),
        DataGridCell(
          columnName: 'number',
          value: order.number,
        ),
        DataGridCell(
          columnName: 'shopName',
          value: order.shopName,
        ),
        DataGridCell(
          columnName: 'orderProducts',
          value: order.getProducts(),
        ),
        DataGridCell(
          columnName: 'status',
          value: order.getStatus(),
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
