import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_text_box.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShopSource extends DataGridSource {
  final BuildContext context;
  final ShopProvider shopProvider;
  final List<ShopModel> shops;

  ShopSource({
    required this.context,
    required this.shopProvider,
    required this.shops,
  }) {
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
    ShopModel shop = shops.singleWhere(
      (e) => e.number == '${row.getCells()[0].value}',
    );
    cells.add(CustomCell(
      label: '${row.getCells()[0].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModShopDialog(
          shopProvider: shopProvider,
          shop: shop,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[1].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModShopDialog(
          shopProvider: shopProvider,
          shop: shop,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[2].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModShopDialog(
          shopProvider: shopProvider,
          shop: shop,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[3].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModShopDialog(
          shopProvider: shopProvider,
          shop: shop,
        ),
      ),
    ));
    cells.add(CustomCell(
      label: '${row.getCells()[4].value}',
      onTap: () => showDialog(
        context: context,
        builder: (context) => ModShopDialog(
          shopProvider: shopProvider,
          shop: shop,
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

class ModShopDialog extends StatefulWidget {
  final ShopProvider shopProvider;
  final ShopModel shop;

  const ModShopDialog({
    required this.shopProvider,
    required this.shop,
    super.key,
  });

  @override
  State<ModShopDialog> createState() => _ModShopDialogState();
}

class _ModShopDialogState extends State<ModShopDialog> {
  @override
  void initState() {
    super.initState();
    widget.shopProvider.setController(widget.shop);
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '店舗 - 編集',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '店舗番号',
            child: Text(widget.shop.number),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '店舗名',
            child: CustomTextBox(
              controller: widget.shopProvider.name,
              placeholder: '例) たこ焼き はっちゃん',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '請求書用店舗番号',
            child: CustomTextBox(
              controller: widget.shopProvider.invoiceNumber,
              placeholder: '例) 0000000001234',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '請求書用店舗名',
            child: CustomTextBox(
              controller: widget.shopProvider.invoiceName,
              placeholder: '例) 株式会社八ちゃん堂',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'パスワード',
            child: CustomTextBox(
              controller: widget.shopProvider.password,
              placeholder: '',
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
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
            String? error = await widget.shopProvider.delete(widget.shop);
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.shopProvider.clearController();
            widget.shopProvider.getData();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.shopProvider.update(widget.shop);
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.shopProvider.clearController();
            widget.shopProvider.getData();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
