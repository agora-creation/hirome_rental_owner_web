import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop_login.dart';
import 'package:hirome_rental_owner_web/providers/shop_login.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShopLoginSource extends DataGridSource {
  final BuildContext context;
  final ShopLoginProvider shopLoginProvider;
  final List<ShopLoginModel> shopLogins;

  ShopLoginSource({
    required this.context,
    required this.shopLoginProvider,
    required this.shopLogins,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = shopLogins.map<DataGridRow>((shopLogin) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: shopLogin.id,
        ),
        DataGridCell(
          columnName: 'createdAt',
          value: shopLogin.createdAt,
        ),
        DataGridCell(
          columnName: 'shopName',
          value: shopLogin.shopName,
        ),
        DataGridCell(
          columnName: 'deviceName',
          value: shopLogin.deviceName,
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
    ShopLoginModel shopLogin = shopLogins.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomCell(label: '${row.getCells()[1].value}'));
    cells.add(CustomCell(label: '${row.getCells()[2].value}'));
    cells.add(CustomCell(label: '${row.getCells()[3].value}'));
    cells.add(Row(
      children: [
        CustomButton(
          labelText: '承認',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ShopLoginDetailsDialog(
              shopLoginProvider: shopLoginProvider,
              shopLogin: shopLogin,
              accept: true,
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButton(
          labelText: '却下',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ShopLoginDetailsDialog(
              shopLoginProvider: shopLoginProvider,
              shopLogin: shopLogin,
              accept: false,
            ),
          ),
        ),
      ],
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

class ShopLoginDetailsDialog extends StatefulWidget {
  final ShopLoginProvider shopLoginProvider;
  final ShopLoginModel shopLogin;
  final bool accept;

  const ShopLoginDetailsDialog({
    required this.shopLoginProvider,
    required this.shopLogin,
    required this.accept,
    super.key,
  });

  @override
  State<ShopLoginDetailsDialog> createState() => _ShopLoginDetailsDialogState();
}

class _ShopLoginDetailsDialogState extends State<ShopLoginDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        widget.accept ? '店舗アカウントログイン - 承認' : '店舗アカウントログイン - 承認',
        style: const TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.accept
              ? const Text('以下のログインを承認しますか？')
              : const Text('以下のログインを却下しますか？'),
          const SizedBox(height: 8),
          Text(
            'ログイン日時 : ${dateText('yyyy/MM/dd HH:mm', widget.shopLogin.createdAt)}',
          ),
          Text('店舗アカウント名 : ${widget.shopLogin.shopName}'),
          Text('端末名 : ${widget.shopLogin.deviceName}'),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        widget.accept
            ? CustomButton(
                labelText: '承認する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error =
                      await widget.shopLoginProvider.accept(widget.shopLogin);
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '承認しました', true);
                  Navigator.pop(context);
                },
              )
            : CustomButton(
                labelText: '却下する',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () async {
                  String? error =
                      await widget.shopLoginProvider.reject(widget.shopLogin);
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '却下しました', true);
                  Navigator.pop(context);
                },
              ),
      ],
    );
  }
}
