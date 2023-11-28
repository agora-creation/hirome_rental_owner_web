import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/cart.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/screens/order_source.dart';
import 'package:hirome_rental_owner_web/services/product.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_range_box.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_month_box.dart';
import 'package:hirome_rental_owner_web/widgets/order_product_total_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _changeSearchRange() async {
    var selected = await showDataRangePickerDialog(
      context,
      widget.orderProvider.searchStart,
      widget.orderProvider.searchEnd,
    );
    if (selected != null && selected.first != null && selected.last != null) {
      var diff = selected.last!.difference(selected.first!);
      int diffDays = diff.inDays;
      if (diffDays > 31) {
        if (!mounted) return;
        showMessage(context, '1ヵ月以上の範囲が選択されています', false);
        return;
      }
      setState(() {
        widget.orderProvider.searchStart = selected.first!;
        widget.orderProvider.searchEnd = selected.last!;
      });
    }
  }

  void _importCSV() async {
    try {
      FilePickerResult? csvFile = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
        allowMultiple: false,
      );
      if (csvFile != null) {
        PlatformFile file = csvFile.files[0];
        final bytes = utf8.decode(file.bytes!);
        List<List<dynamic>> rowsAsListOfValues =
            const CsvToListConverter().convert(bytes);
        for (int i = 0; i < rowsAsListOfValues.length; i++) {
          for (int j = 0; j < rowsAsListOfValues.elementAt(i).length; j++) {
            print('${rowsAsListOfValues.elementAt(i).elementAt(0).toString()}');
            print('${rowsAsListOfValues.elementAt(i).elementAt(1).toString()}');
            print('${rowsAsListOfValues.elementAt(i).elementAt(2).toString()}');
          }
        }

        // for (int i = 0; i < rowsAsListOfValues[0].length; i++) {
        //   for (int j = 0; j < rowsAsListOfValues[0].elementAt(i).length; j++) {
        //     print(rowsAsListOfValues[0].elementAt(i));
        //     // String createdAt = rowsAsListOfValues.elementAt(i)[0];
        //     // String shopNumber = rowsAsListOfValues.elementAt(i)[1];
        //     // String status = rowsAsListOfValues.elementAt(i)[2];
        //     // String productNumber = rowsAsListOfValues.elementAt(i)[5];
        //     // String requestQuantity = rowsAsListOfValues.elementAt(i)[6];
        //     // String deliveryQuantity = rowsAsListOfValues.elementAt(i)[7];
        //     //
        //     // print(
        //     //     '$createdAt | $shopNumber | $status | $productNumber | $requestQuantity | $deliveryQuantity');
        //   }
        // }
      }
    } catch (e) {
      print(e.toString());
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
    return Stack(
      children: [
        const AnimationBackground(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '各店舗が注文して、食器センターが受注した注文データを表示しています。',
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
                                  onTap: _changeSearchRange,
                                ),
                              ),
                              InfoLabel(
                                label: '発注元店舗',
                                child: ComboBox<String>(
                                  value: widget.orderProvider.searchShopNumber,
                                  items: shops.map((shop) {
                                    return ComboBoxItem(
                                      value: shop.number,
                                      child: Text(shop.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.orderProvider.searchShopNumber =
                                          value;
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
                          iconData: FluentIcons.search_data,
                          iconColor: kWhiteColor,
                          labelText: 'バックアップシステムへ',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreyColor,
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://hirome.co.jp/rental/system/',
                            );
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        CustomIconTextButton(
                          iconData: FluentIcons.numbered_list,
                          iconColor: kWhiteColor,
                          labelText: '注文商品集計表示',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreyColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => OrderProductTotalDialog(
                              orders: orders,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomIconTextButton(
                          iconData: FluentIcons.download,
                          iconColor: kWhiteColor,
                          labelText: 'PDFダウンロード',
                          labelColor: kWhiteColor,
                          backgroundColor: kRedColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => PdfDialog(
                              orderProvider: widget.orderProvider,
                              shops: shops,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomIconTextButton(
                          iconData: FluentIcons.download,
                          iconColor: kWhiteColor,
                          labelText: 'CSVダウンロード',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreenColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => CsvDialog(
                              orderProvider: widget.orderProvider,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomIconTextButton(
                          iconData: FluentIcons.download,
                          iconColor: kWhiteColor,
                          labelText: '商魂用CSVダウンロード',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreenColor,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ShokonCsvDialog(
                              orderProvider: widget.orderProvider,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomIconTextButton(
                          iconData: FluentIcons.upload,
                          iconColor: kWhiteColor,
                          labelText: 'CSVアップロード',
                          labelColor: kWhiteColor,
                          backgroundColor: kGreenColor,
                          onPressed: () => _importCSV(),
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
        ),
      ],
    );
  }
}

class OrderProductTotalDialog extends StatefulWidget {
  final List<OrderModel> orders;

  const OrderProductTotalDialog({
    required this.orders,
    super.key,
  });

  @override
  State<OrderProductTotalDialog> createState() =>
      _OrderProductTotalDialogState();
}

class _OrderProductTotalDialogState extends State<OrderProductTotalDialog> {
  ProductService productService = ProductService();
  List<ProductModel> products = [];

  void _init() async {
    List<ProductModel> tmpProducts = await productService.selectList();
    setState(() {
      products = tmpProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> totalMap = {};
    for (OrderModel order in widget.orders) {
      for (CartModel cart in order.carts) {
        totalMap[cart.number] = cart.deliveryQuantity;
      }
    }
    return ContentDialog(
      title: const Text(
        '注文商品集計',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('注文データを、商品データ毎に集計しています。'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                ProductModel product = products[index];
                return OrderProductTotalList(
                  product: product,
                  total: totalMap[product.number],
                );
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

class PdfDialog extends StatefulWidget {
  final OrderProvider orderProvider;
  final List<ShopModel> shops;

  const PdfDialog({
    required this.orderProvider,
    required this.shops,
    super.key,
  });

  @override
  State<PdfDialog> createState() => _PdfDialogState();
}

class _PdfDialogState extends State<PdfDialog> {
  DateTime selectedMonth = DateTime.now();
  String? selectedShopNumber;

  void _init() {
    setState(() {
      selectedShopNumber = widget.shops.first.number;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'PDFダウンロード',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('店舗向けの納品書PDFファイルをダウンロードします。対象の年月と対象の店舗を選択してください。'),
          const SizedBox(height: 8),
          CustomMonthBox(
            value: selectedMonth,
            onTap: () async {
              var selected = await showMonthPicker(
                context: context,
                initialDate: selectedMonth,
                firstDate: kFirstDate,
                lastDate: kLastDate,
              );
              if (selected != null) {
                setState(() {
                  selectedMonth = selected;
                });
              }
            },
          ),
          const SizedBox(height: 8),
          ComboBox<String>(
            value: selectedShopNumber,
            items: widget.shops.map((shop) {
              return ComboBoxItem(
                value: shop.number,
                child: Text(shop.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedShopNumber = value;
              });
            },
            isExpanded: true,
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
          labelText: 'ダウンロード',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            if (selectedShopNumber != null) {
              await widget.orderProvider.pdfDownload(
                selectedMonth,
                selectedShopNumber!,
              );
            }
          },
        ),
      ],
    );
  }
}

class CsvDialog extends StatefulWidget {
  final OrderProvider orderProvider;

  const CsvDialog({
    required this.orderProvider,
    super.key,
  });

  @override
  State<CsvDialog> createState() => _CsvDialogState();
}

class _CsvDialogState extends State<CsvDialog> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'CSVダウンロード',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CSVファイルをダウンロードします。対象の年月を選択してください。'),
          const SizedBox(height: 8),
          CustomMonthBox(
            value: selectedMonth,
            onTap: () async {
              var selected = await showMonthPicker(
                context: context,
                initialDate: selectedMonth,
                firstDate: kFirstDate,
                lastDate: kLastDate,
              );
              if (selected != null) {
                setState(() {
                  selectedMonth = selected;
                });
              }
            },
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
          labelText: 'ダウンロード',
          labelColor: kWhiteColor,
          backgroundColor: kGreenColor,
          onPressed: () async {
            await widget.orderProvider.csvDownload(selectedMonth);
          },
        ),
      ],
    );
  }
}

class ShokonCsvDialog extends StatefulWidget {
  final OrderProvider orderProvider;

  const ShokonCsvDialog({
    required this.orderProvider,
    super.key,
  });

  @override
  State<ShokonCsvDialog> createState() => _ShokonCsvDialogState();
}

class _ShokonCsvDialogState extends State<ShokonCsvDialog> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '商魂用CSVダウンロード',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('商魂ソフトへ取り込むためのCSVファイルをダウンロードします。対象の年月を選択してください。'),
          const SizedBox(height: 8),
          CustomMonthBox(
            value: selectedMonth,
            onTap: () async {
              var selected = await showMonthPicker(
                context: context,
                initialDate: selectedMonth,
                firstDate: kFirstDate,
                lastDate: kLastDate,
              );
              if (selected != null) {
                setState(() {
                  selectedMonth = selected;
                });
              }
            },
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
          labelText: 'ダウンロード',
          labelColor: kWhiteColor,
          backgroundColor: kGreenColor,
          onPressed: () async {
            await widget.orderProvider.shokonCsvDownload(selectedMonth);
          },
        ),
      ],
    );
  }
}
