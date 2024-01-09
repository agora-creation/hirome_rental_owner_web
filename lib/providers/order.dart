import 'dart:html';

import 'package:csv/csv.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/cart.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/services/order.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  void searchDateChange(DateTime start, DateTime end) {
    searchStart = start;
    searchEnd = end;
    notifyListeners();
  }

  void searchShopChange(String? value) {
    searchShop = value;
    notifyListeners();
  }

  void searchClear() {
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
    notifyListeners();
  }

  Future pdfDownload(DateTime month, String shopNumber) async {
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final headerStyle = pw.TextStyle(
      font: ttf,
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );
    final shopStyle = pw.TextStyle(
      font: ttf,
      fontSize: 12,
    );
    final bodyStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final priceStyle = pw.TextStyle(
      font: ttf,
      fontSize: 14,
    );
    final productStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    const thDecoration = pw.BoxDecoration(color: PdfColors.grey300);
    DateTime monthStart = DateTime(month.year, month.month, 1);
    DateTime monthEnd = DateTime(month.year, month.month + 1, 1).add(
      const Duration(days: -1),
    );
    List<OrderModel> orders = await orderService.selectList(
      shopNumber: shopNumber,
      searchStart: monthStart,
      searchEnd: monthEnd,
    );
    List<pw.TableRow> rows = [];
    rows.add(pw.TableRow(
      decoration: thDecoration,
      children: [
        generateCell(label: '商品番号', style: productStyle, width: 20),
        generateCell(label: '商品名', style: productStyle),
        generateCell(label: '単価', style: productStyle, width: 10),
        generateCell(label: '納品数量', style: productStyle, width: 10),
        generateCell(label: '合計金額', style: productStyle, width: 10),
      ],
    ));
    List<pw.TableRow> rows2 = [];
    rows2.add(pw.TableRow(
      decoration: thDecoration,
      children: [
        generateCell(label: '商品番号', style: productStyle, width: 20),
        generateCell(label: '商品名', style: productStyle),
        generateCell(label: '単価', style: productStyle, width: 10),
        generateCell(label: '納品数量', style: productStyle, width: 10),
        generateCell(label: '合計金額', style: productStyle, width: 10),
      ],
    ));
    Map numberMap = {};
    Map nameMap = {};
    Map priceUnitMap = {};
    Map quantityMap = {};
    Map totalPriceMap = {};
    int allTotalPrice = 0;
    for (OrderModel order in orders) {
      for (CartModel cart in order.carts) {
        String key = cart.number;
        numberMap[key] = cart.number;
        nameMap[key] = cart.name;
        priceUnitMap[key] = '${cart.price}';
        if (quantityMap[key] == null) {
          quantityMap[key] = '${cart.deliveryQuantity}';
        } else {
          int addQuantity = int.parse(quantityMap[key]) + cart.deliveryQuantity;
          quantityMap[key] = '$addQuantity';
        }
        int totalPrice = cart.price * cart.deliveryQuantity;
        allTotalPrice += totalPrice;
        if (totalPriceMap[key] == null) {
          totalPriceMap[key] = '$totalPrice';
        } else {
          int addTotalPrice = int.parse(totalPriceMap[key]) + totalPrice;
          totalPriceMap[key] = '$addTotalPrice';
        }
      }
    }
    int rowCount = 0;
    numberMap.forEach((key, value) {
      rowCount++;
      if (rowCount < 35) {
        rows.add(pw.TableRow(
          children: [
            generateCell(
              label: '$value',
              style: productStyle,
              width: 20,
            ),
            generateCell(
              label: '${nameMap[value]}',
              style: productStyle,
            ),
            generateCell(
              label: '${priceUnitMap[value]}',
              style: productStyle,
              width: 10,
            ),
            generateCell(
              label: '${quantityMap[value]}',
              style: productStyle,
              width: 10,
            ),
            generateCell(
              label: '￥${addCommaToNum(int.parse(totalPriceMap[value]))}',
              style: productStyle,
              width: 10,
            ),
          ],
        ));
      } else {
        rows2.add(pw.TableRow(
          children: [
            generateCell(
              label: '$value',
              style: productStyle,
              width: 20,
            ),
            generateCell(
              label: '${nameMap[value]}',
              style: productStyle,
            ),
            generateCell(
              label: '${priceUnitMap[value]}',
              style: productStyle,
              width: 10,
            ),
            generateCell(
              label: '${quantityMap[value]}',
              style: productStyle,
              width: 10,
            ),
            generateCell(
              label: '￥${addCommaToNum(int.parse(totalPriceMap[value]))}',
              style: productStyle,
              width: 10,
            ),
          ],
        ));
      }
    });
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(32),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '${dateText('yyyy年MM月', month)}分の注文履歴書',
              style: headerStyle,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.black),
              ),
            ),
            child: pw.Text(
              '${orders.first.shopName} 御中',
              style: shopStyle,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '下記のとおり納品いたしました。',
            style: bodyStyle,
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.black),
              ),
            ),
            child: pw.Text(
              '合計金額　￥${addCommaToNum(allTotalPrice)}',
              style: priceStyle,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            children: rows,
          ),
        ],
      ),
    ));
    if (rows2.length > 1) {
      pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(32),
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              children: rows2,
            ),
          ],
        ),
      ));
    }
    final fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.pdf';
    await pdfWebDownload(pdf: pdf, fileName: fileName);
  }

  Future csvDownload(DateTime month) async {
    final fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.csv';
    List<String> header = [
      '注文日時',
      '注文番号',
      '発注元店舗番号',
      '発注元店舗名',
      '商品番号',
      '商品名',
      '単価',
      '単位',
      '希望数量',
      '納品数量',
      '合計金額',
      'ステータス',
    ];
    DateTime monthStart = DateTime(month.year, month.month, 1);
    DateTime monthEnd = DateTime(month.year, month.month + 1, 1).add(
      const Duration(days: -1),
    );
    List<OrderModel> orders = await orderService.selectList(
      searchStart: monthStart,
      searchEnd: monthEnd,
    );
    List<List<String>> rows = [];
    for (OrderModel order in orders) {
      for (CartModel cart in order.carts) {
        List<String> row = [];
        row.add(dateText('yyyy/MM/dd HH:mm', order.createdAt));
        row.add(order.number);
        row.add(order.shopNumber);
        row.add(order.shopName);
        row.add(cart.number);
        row.add(cart.name);
        row.add('${cart.price}');
        row.add(cart.unit);
        row.add('${cart.requestQuantity}');
        row.add('${cart.deliveryQuantity}');
        int totalPrice = cart.price * cart.deliveryQuantity;
        row.add('$totalPrice');
        row.add(order.statusText());
        rows.add(row);
      }
    }
    String csv = const ListToCsvConverter().convert(
      [header, ...rows],
    );
    String bom = '\uFEFF';
    String csvText = bom + csv;
    csvText = csvText.replaceAll('[', '');
    csvText = csvText.replaceAll(']', '');
    AnchorElement(href: 'data:text/plain;charset=utf-8,$csvText')
      ..setAttribute('download', fileName)
      ..click();
  }

  Future shokonCsvDownload(DateTime month) async {
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
      '摘要コード',
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
    DateTime monthStart = DateTime(month.year, month.month, 1);
    DateTime monthEnd = DateTime(month.year, month.month + 1, 1).add(
      const Duration(days: -1),
    );
    List<OrderModel> orders = await orderService.selectList(
      searchStart: monthStart,
      searchEnd: monthEnd,
    );
    List<List<String>> rows = [];
    int startNumber = 984179;
    for (OrderModel order in orders) {
      String number = startNumber.toString();
      for (CartModel cart in order.carts) {
        List<String> row = [];
        row.add('0');
        row.add(dateText('yyyyMMdd', order.createdAt));
        row.add(dateText('yyyyMMdd', order.createdAt));
        row.add(number);
        row.add(order.shopNumber);
        row.add(order.shopName);
        row.add('');
        row.add('');
        row.add('000');
        row.add('0000');
        row.add('0000');
        row.add('');
        row.add('');
        row.add('');
        row.add(cart.invoiceNumber);
        row.add('0');
        row.add(cart.name);
        row.add('0');
        row.add('0000');
        row.add('1');
        row.add('0');
        row.add('${cart.deliveryQuantity}');
        row.add('');
        row.add('${cart.price}');
        int totalPrice = cart.price * cart.deliveryQuantity;
        row.add('$totalPrice');
        row.add('0');
        row.add('0');
        row.add('$totalPrice');
        double tax = totalPrice * 0.1;
        row.add('${tax.round()}');
        row.add('0');
        row.add('2');
        row.add('0');
        row.add('');
        row.add('${cart.price}');
        row.add('0');
        row.add('${cart.price}');
        row.add('$totalPrice');
        row.add('');
        row.add('');
        row.add('');
        row.add('00');
        row.add('0');
        row.add('0');
        row.add('0');
        row.add('0');
        row.add('0');
        row.add('0');
        row.add('10.0');
        row.add('0');
        row.add('');
        row.add('');
        row.add('0');
        row.add('');
        row.add('0');
        row.add('');
        rows.add(row);
      }
      startNumber++;
    }
    String csv = const ListToCsvConverter().convert(
      [header, ...rows],
    );
    String bom = '\uFEFF';
    String csvText = bom + csv;
    csvText = csvText.replaceAll('[', '');
    csvText = csvText.replaceAll(']', '');
    AnchorElement(href: 'data:text/plain;charset=utf-8,$csvText')
      ..setAttribute('download', fileName)
      ..click();
  }
}
