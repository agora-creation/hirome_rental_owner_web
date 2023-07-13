import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/cart.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/widgets/cart_list.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderSource extends DataGridSource {
  final BuildContext context;
  final List<OrderModel> orders;

  OrderSource({
    required this.context,
    required this.orders,
  }) {
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
          columnName: 'carts',
          value: order.cartsText(),
        ),
        DataGridCell(
          columnName: 'status',
          value: order.statusText(),
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
    OrderModel order = orders.singleWhere(
      (e) => e.number == '${row.getCells()[1].value}',
    );
    cells.add(CustomCell(
      label: '${row.getCells()[0].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => OrderDetailsDialog(order: order),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[1].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => OrderDetailsDialog(order: order),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[2].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => OrderDetailsDialog(order: order),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[3].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => OrderDetailsDialog(order: order),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[4].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => OrderDetailsDialog(order: order),
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

class OrderDetailsDialog extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsDialog({
    required this.order,
    super.key,
  });

  @override
  State<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '注文 - 詳細',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '注文日時 : ${dateText('yyyy/MM/dd HH:mm', widget.order.createdAt)}',
          ),
          Text('注文番号 : ${widget.order.number}'),
          Text('発注元店舗 : ${widget.order.shopName}'),
          Text('ステータス : ${widget.order.statusText()}'),
          const SizedBox(height: 8),
          const Text('注文商品 : '),
          SizedBox(
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.order.carts.length,
              itemBuilder: (context, index) {
                CartModel cart = widget.order.carts[index];
                return CartList(cart: cart);
              },
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
