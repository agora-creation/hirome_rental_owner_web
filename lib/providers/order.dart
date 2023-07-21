import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/services/order.dart';

class OrderProvider with ChangeNotifier {
  OrderService orderService = OrderService();

  DateTime searchStart = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime searchEnd = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  ).add(const Duration(days: -1));
  String? searchShop;
  String searchText = 'なし';

  void searchClear() {
    searchText = 'なし';
    searchStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );
    searchEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      1,
    ).add(const Duration(days: -1));
    searchShop = null;
  }

  Future<List<OrderModel>> selectList() async {
    searchText =
        '[注文日]${dateText('yyyy-MM-dd', searchStart)} ～ ${dateText('yyyy-MM-dd', searchEnd)} ';
    if (searchShop != null) {
      searchText += '[発注元店舗]$searchShop ';
    }
    return await orderService.selectList(
      shopName: searchShop,
      searchStart: searchStart,
      searchEnd: searchEnd,
    );
  }

  Future csvDownload() async {
    final fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.csv';
    List<String> header = [
      '伝区',
      '売上日',
      '請求日',
      '伝票No',
      '得意先コード',
      '得意先名',
      '直送先コード',
      '先方担当者名',
      '部門コード',
      '担当者コード',
      '摘要名',
      '分類コード',
      '伝票区分',
      '商品コード',
      'マスター区分',
      '商品名',
      '区',
      '倉庫コード',
      '※入数',
      '※箱数',
      '数量',
      '※単位',
      '単価',
      '売上金額',
      '原単価',
      '原価金額',
      '粗利益',
      '外税額',
      '内税額',
      '税区分',
      '税込区分',
      '備考',
      '標準価格',
      '同時入荷区分',
      '売単価',
      '売価金額',
      '※規格・型番',
      '※色',
      '※サイズ',
      '計算式コード',
      '※商品項目１',
      '※商品項目２',
      '※商品項目３',
      '※売上項目１',
      '※売上項目２',
      '※売上項目３',
      '税率',
      '伝票消費税額',
      '※ﾌﾟﾛｼﾞｪｸﾄコード',
      '※伝票No2',
      'データ区分',
      '※商品名２',
      '単位区分',
      'ロットNo',
    ];
    List<List<String>> rows = [];
    String csv = const ListToCsvConverter().convert(
      [header, ...rows],
    );
    String bom = '\uFEFF';
    String csvText = bom + csv;
    csvText = csvText.replaceAll('[', '');
    csvText = csvText.replaceAll(']', '');
    String? path = await getSavePath(
      acceptedTypeGroups: [
        const XTypeGroup(
          label: 'csv',
          extensions: ['csv'],
        )
      ],
      suggestedName: fileName,
    );
    if (path == null) return;
    final data = const Utf8Encoder().convert(csvText);
    final file = XFile.fromData(data, mimeType: 'text/plain');
    await file.saveTo(path);
  }
}
