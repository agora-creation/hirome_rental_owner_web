import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/screens/order_source.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_text_box.dart';
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
                  '各店舗が注文したデータを一覧で表示します。検索で絞り込んだり、帳票の出力を行うことができます。',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Expander(
                  header: const Text('検索条件 : なし'),
                  content: Column(
                    children: [
                      GridView(
                        shrinkWrap: true,
                        gridDelegate: kSearchGrid,
                        children: [
                          InfoLabel(
                            label: '注文期間',
                            child: const CustomTextBox(),
                          ),
                          InfoLabel(
                            label: '発注元店舗',
                            child: const CustomTextBox(),
                          ),
                          InfoLabel(
                            label: 'ステータス',
                            child: const CustomTextBox(),
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
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                          CustomIconTextButton(
                            iconData: FluentIcons.search,
                            iconColor: kWhiteColor,
                            labelText: '検索する',
                            labelColor: kWhiteColor,
                            backgroundColor: kLightBlueColor,
                            onPressed: () {},
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
                  height: 600,
                  child: CustomDataGrid(
                    source: OrderSource(
                      context: context,
                      orders: orders,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'createdAt',
                        label: const CustomCell(label: '注文日時'),
                      ),
                      GridColumn(
                        columnName: 'number',
                        label: const CustomCell(label: '注文番号'),
                      ),
                      GridColumn(
                        columnName: 'shopName',
                        label: const CustomCell(label: '発注元店舗'),
                      ),
                      GridColumn(
                        columnName: 'carts',
                        label: const CustomCell(label: '注文商品'),
                      ),
                      GridColumn(
                        columnName: 'status',
                        label: const CustomCell(label: 'ステータス'),
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
