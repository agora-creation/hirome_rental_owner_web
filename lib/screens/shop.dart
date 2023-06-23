import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShopScreen extends StatefulWidget {
  final ShopProvider shopProvider;

  const ShopScreen({
    required this.shopProvider,
    super.key,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<ShopModel> shops = [];

  void _getShops() async {
    List<ShopModel> tmpShops = await widget.shopProvider.selectList();
    if (mounted) {
      setState(() => shops = tmpShops);
    }
  }

  @override
  void initState() {
    super.initState();
    _getShops();
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
                  '店舗アカウントデータを一覧で表示します。検索で絞り込んだり、登録・編集・削除することができます。',
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
                      iconData: FluentIcons.add,
                      iconColor: kWhiteColor,
                      labelText: '新規登録',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 450,
                  child: CustomDataGrid(
                    source: _ShopSource(shops: shops),
                    columns: [
                      GridColumn(
                        columnName: 'number',
                        label: const CustomCell('店舗番号'),
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: const CustomCell('店舗名'),
                      ),
                      GridColumn(
                        columnName: 'invoiceNumber',
                        label: const CustomCell('請求用店舗番号'),
                      ),
                      GridColumn(
                        columnName: 'invoiceName',
                        label: const CustomCell('請求用店舗名'),
                      ),
                      GridColumn(
                        columnName: 'password',
                        label: const CustomCell('パスワード'),
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

class _ShopSource extends DataGridSource {
  final List<ShopModel> shops;

  _ShopSource({required this.shops}) {
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
