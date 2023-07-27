import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ShopModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _invoiceName = '';
  List<String> favorites = [];
  int _priority = 0;
  int _authority = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get invoiceName => _invoiceName;
  int get priority => _priority;
  int get authority => _authority;
  DateTime get createdAt => _createdAt;

  ShopModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _invoiceName = map['invoiceName'] ?? '';
    favorites = _convertFavorites(map['favorites']);
    _priority = map['priority'] ?? 0;
    _authority = map['authority'] ?? 0;
    _createdAt = map['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertFavorites(List list) {
    List<String> ret = [];
    for (dynamic id in list) {
      ret.add('$id');
    }
    return ret;
  }

  String authorityText() {
    String ret = '';
    switch (authority) {
      case 0:
        ret = '一般';
        break;
      case 1:
        ret = 'インフォメーション';
        break;
    }
    return ret;
  }

  Future manualDownload() async {
    final pdf = pw.Document();
    final font = await rootBundle.load(
      'assets/fonts/GenShinGothic-Regular.ttf',
    );
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(font: ttf, fontSize: 18);
    final bodyStyle = pw.TextStyle(font: ttf, fontSize: 14);
    final urlStyle = pw.TextStyle(font: ttf, fontSize: 12);
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        children: [
          pw.Center(
            child: pw.Text('$name - 初期設定マニュアル', style: titleStyle),
          ),
          pw.SizedBox(height: 40),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '① スマホから注文したい場合は、以下のURLからアプリをダウンロードしてください。',
                style: bodyStyle,
              ),
              pw.Text(
                '[iOS]\nhttps://apps.apple.com/jp/app/',
                style: urlStyle,
              ),
              pw.Text(
                '[Android]\nhttps://play.google.com/store/apps/details?id=com.agoracreation.hatarakujikan_tablet',
                style: urlStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '② PCやタブレット端末から注文したい場合は、以下のURLへアクセスしてください。',
                style: bodyStyle,
              ),
              pw.Text(
                'https://hirome-rental-shop.web.app/',
                style: urlStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '③ 以下の店舗番号を入力してログインしてください。\nログイン申請が管理者宛に送信されます。',
                style: bodyStyle,
              ),
              pw.Text(
                '[店舗番号] $number',
                style: urlStyle,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                '④ ログイン申請が承認されると、注文が可能な画面になります。',
                style: bodyStyle,
              ),
            ],
          ),
        ],
      ),
    ));
    await pdfWebDownload(pdf: pdf, fileName: 'shop_manual.pdf');
  }
}

String authorityIntToString(int? value) {
  String ret = '';
  switch (value) {
    case 0:
      ret = '一般';
      break;
    case 1:
      ret = 'インフォメーション';
      break;
  }
  return ret;
}

List<ComboBoxItem<int>> kAuthorityComboItems = const [
  ComboBoxItem(
    value: 0,
    child: Text('一般'),
  ),
  ComboBoxItem(
    value: 1,
    child: Text('インフォメーション'),
  ),
];
