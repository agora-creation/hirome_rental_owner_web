import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
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
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final titleStyle = pw.TextStyle(font: ttf, fontSize: 18);
    final bodyStyle = pw.TextStyle(font: ttf, fontSize: 12);
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(40),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '$name - 初期設定マニュアル',
              style: titleStyle,
            ),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'スマホから注文したい場合は、以下のURLからアプリをダウンロードしてください。',
            style: bodyStyle,
          ),
          pw.Text(
            '[iOS]',
            style: bodyStyle,
          ),
          pw.Text(
            '[Android]',
            style: bodyStyle,
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'PCやタブレットから注文したい場合は、以下のURLへアクセスしてください。',
            style: bodyStyle,
          ),
          pw.Text(
            'https://hirome-rental-shop.web.app/',
            style: bodyStyle,
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            '店舗番号「$number」を入力して、ログインボタンを押してください。',
            style: bodyStyle,
          ),
          pw.Text(
            'ログイン申請が管理者とインフォメーション宛に送信されます。承認されるまで、暫くお待ちください。',
            style: bodyStyle,
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            '承認されたら画面が変わり、注文が可能になります。',
            style: bodyStyle,
          ),
        ],
      ),
    ));
    await pdfWebDownload(pdf: pdf, fileName: '${name}_初期設定マニュアル.pdf');
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
