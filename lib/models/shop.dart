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
  String _tenantNumber = '';
  List<String> favorites = [];
  int _priority = 0;
  int _authority = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get invoiceName => _invoiceName;
  String get tenantNumber => _tenantNumber;
  int get priority => _priority;
  int get authority => _authority;
  DateTime get createdAt => _createdAt;

  ShopModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _invoiceName = map['invoiceName'] ?? '';
    _tenantNumber = map['tenantNumber'] ?? '';
    favorites = _convertFavorites(map['favorites']);
    _priority = map['priority'] ?? 0;
    _authority = map['authority'] ?? 0;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
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
    final accentStyle = pw.TextStyle(font: ttf, fontSize: 16);
    final qrAndroidByteData = await rootBundle.load(kQrAndroidImageUrl);
    final qrAndroidUint8List = qrAndroidByteData.buffer.asUint8List(
      qrAndroidByteData.offsetInBytes,
      qrAndroidByteData.lengthInBytes,
    );
    final qrAndroidImage = pw.MemoryImage(qrAndroidUint8List);
    final qrIosByteData = await rootBundle.load(kQrIosImageUrl);
    final qrIosUint8List = qrIosByteData.buffer.asUint8List(
      qrIosByteData.offsetInBytes,
      qrIosByteData.lengthInBytes,
    );
    final qrIosImage = pw.MemoryImage(qrIosUint8List);
    final ssLoginByteData = await rootBundle.load(kSSLoginImageUrl);
    final ssLoginUint8List = ssLoginByteData.buffer.asUint8List(
      ssLoginByteData.offsetInBytes,
      ssLoginByteData.lengthInBytes,
    );
    final ssLoginImage = pw.MemoryImage(ssLoginUint8List);
    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(40),
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              '食器注文専用アプリ - 初期設定',
              style: titleStyle,
            ),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'スマホから利用したい場合は、以下のQRコードからアプリストアを開き、アプリをインストールしてください。',
            style: bodyStyle,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Column(
                children: [
                  pw.Text('Androidの方', style: bodyStyle),
                  pw.SizedBox(
                    width: 200,
                    child: pw.Image(qrAndroidImage),
                  ),
                ],
              ),
              pw.Column(
                children: [
                  pw.Text('iOSの方', style: bodyStyle),
                  pw.SizedBox(
                    width: 200,
                    child: pw.Image(qrIosImage),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'PCやタブレットから注文したい場合は、以下のURLへアクセスしてください。',
            style: bodyStyle,
          ),
          pw.Text(
            'https://hirome-rental-shop.web.app/',
            style: accentStyle,
          ),
          pw.SizedBox(height: 32),
          pw.Center(
            child: pw.SizedBox(
              width: 250,
              child: pw.Image(ssLoginImage),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '上記の画面が表示されたら、店舗番号とお名前を入力して、ログインボタンを押してください。',
            style: bodyStyle,
          ),
          pw.Text(
            'あなたの店舗番号は『　　　』です。',
            style: accentStyle,
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'ログインを押すと、管理者宛にログイン申請が送信されます。承認されるまで、しばらくお待ちください。',
            style: bodyStyle,
          ),
          pw.Text(
            '承認されたら画面が変わり、ご利用が可能になります。',
            style: bodyStyle,
          ),
        ],
      ),
    ));
    await pdfWebDownload(pdf: pdf, fileName: '${name}_初期設定.pdf');
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
