import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/screens/order_source.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_range_box.dart';
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
  ShopService shopService = ShopService();
  List<OrderModel> orders = [];
  List<ShopModel> shops = [];

  void _getOrders() async {
    List<OrderModel> tmpOrders = await widget.orderProvider.selectList();
    if (mounted) {
      setState(() => orders = tmpOrders);
    }
  }

  void _getShops() async {
    List<ShopModel> tmpShops = await shopService.selectList();
    if (mounted) {
      setState(() => shops = tmpShops);
    }
  }

  @override
  void initState() {
    super.initState();
    _getOrders();
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
                  '各店舗が注文したデータを一覧で表示します。検索で絞り込んだり、帳票の出力を行うことができます。',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Expander(
                  header: Text('検索条件 : ${widget.orderProvider.searchText}'),
                  content: Column(
                    children: [
                      GridView(
                        shrinkWrap: true,
                        gridDelegate: kSearchGrid,
                        children: [
                          InfoLabel(
                            label: '注文日',
                            child: CustomDateRangeBox(
                              startValue: widget.orderProvider.searchStart,
                              endValue: widget.orderProvider.searchEnd,
                              onTap: () async {
                                var selected = await showDataRangePickerDialog(
                                  context,
                                  widget.orderProvider.searchStart,
                                  widget.orderProvider.searchEnd,
                                );
                                if (selected != null &&
                                    selected.first != null &&
                                    selected.last != null) {
                                  setState(() {
                                    widget.orderProvider.searchStart =
                                        selected.first!;
                                    widget.orderProvider.searchEnd =
                                        selected.last!;
                                  });
                                }
                              },
                            ),
                          ),
                          InfoLabel(
                            label: '発注元店舗',
                            child: ComboBox<String>(
                              value: widget.orderProvider.searchShop,
                              items: shops.map((shop) {
                                return ComboBoxItem(
                                  value: shop.name,
                                  child: Text(shop.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  widget.orderProvider.searchShop = value;
                                });
                              },
                              isExpanded: true,
                            ),
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
                            onPressed: () {
                              widget.orderProvider.searchClear();
                              _getOrders();
                            },
                          ),
                          const SizedBox(width: 8),
                          CustomIconTextButton(
                            iconData: FluentIcons.search,
                            iconColor: kWhiteColor,
                            labelText: '検索する',
                            labelColor: kWhiteColor,
                            backgroundColor: kLightBlueColor,
                            onPressed: () => _getOrders(),
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
                      onPressed: () async {
                        await widget.orderProvider.csvDownload();
                      },
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
                        columnName: 'details',
                        label: const CustomCell(label: '詳細'),
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
