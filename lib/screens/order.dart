import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/cart.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/screens/order_source.dart';
import 'package:hirome_rental_owner_web/services/order.dart';
import 'package:hirome_rental_owner_web/services/product.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_range_box.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_month_box.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
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
  OrderService orderService = OrderService();
  ShopService shopService = ShopService();
  List<ShopModel> shops = [];

  void _init() async {
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
      widget.orderProvider.searchDateChange(
        selected.first!,
        selected.last!,
      );
    }
  }

  void _importCSV() async {
    try {
      final List finalCsvContent = [];
      FilePickerResult? result = (await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv'],
      ));
      var file = result?.files.first.bytes;
      String s = String.fromCharCodes(file!);
      var outputAsUint8List = Uint8List.fromList(s.codeUnits);
      var csvFileContentList = utf8.decode(outputAsUint8List).split('\n');
      csvFileContentList.removeAt(0);
      for (String data in csvFileContentList) {
        List currentRow = [];
        data.toString().split(",").forEach((items) {
          currentRow.add(items.trim());
        });
        finalCsvContent.add(currentRow);
      }
      for (dynamic data in finalCsvContent) {
        String id = OrderService().id();
        DateTime createdAt = DateTime.parse(data[0].toString());
        ShopModel? shop = await ShopService().select(data[1].toString());
        if (shop == null) continue;
        String number =
            '${shop.number}-${dateText('yyyyMMddHHmmss', createdAt)}';
        print(number);
        String shopId = shop.id;
        String shopNumber = shop.number;
        String shopName = shop.name;
        String shopInvoiceName = shop.invoiceName;
        int status = int.parse(data[2].toString());
        ProductModel? product =
            await ProductService().select(data[3].toString());
        if (product == null) continue;
        Map cart = {
          'id': product.id,
          'number': product.number,
          'name': product.name,
          'invoiceNumber': product.invoiceNumber,
          'price': product.price,
          'unit': product.unit,
          'category': product.category,
          'requestQuantity': int.parse(data[4].toString()),
          'deliveryQuantity': int.parse(data[5].toString()),
        };
        OrderModel? order = await OrderService().select(number);
        if (order != null) {
          List<Map> carts = [];
          for (CartModel tmpCart in order.carts) {
            carts.add(tmpCart.toMap());
          }
          carts.add(cart);
          OrderService().update({
            'id': order.id,
            'carts': carts,
          });
        } else {
          List<Map> carts = [];
          carts.add(cart);
          OrderService().create({
            'id': id,
            'number': number,
            'shopId': shopId,
            'shopNumber': shopNumber,
            'shopName': shopName,
            'shopInvoiceName': shopInvoiceName,
            'carts': carts,
            'status': status,
            'updatedAt': createdAt,
            'createdAt': createdAt,
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
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
                      header: const Text('検索条件'),
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
                                  value: widget.orderProvider.searchShop,
                                  items: shops.map((shop) {
                                    return ComboBoxItem(
                                      value: shop.number,
                                      child: Text(shop.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    widget.orderProvider
                                        .searchShopChange(value);
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
                                },
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
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 600,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: orderService.streamList(
                          searchStart: widget.orderProvider.searchStart,
                          searchEnd: widget.orderProvider.searchEnd,
                          searchShop: widget.orderProvider.searchShop,
                        ),
                        builder: (context, snapshot) {
                          List<OrderModel> orders = [];
                          if (snapshot.hasData) {
                            for (DocumentSnapshot<Map<String, dynamic>> doc
                                in snapshot.data!.docs) {
                              orders.add(OrderModel.fromSnapshot(doc));
                            }
                          }
                          return CustomDataGrid(
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
                          );
                        },
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
