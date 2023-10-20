import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ProductModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _invoiceNumber = '';
  int _price = 0;
  String _unit = '';
  String _image = '';
  int _category = 0;
  int _priority = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get invoiceNumber => _invoiceNumber;
  int get price => _price;
  String get unit => _unit;
  String get image => _image;
  int get category => _category;
  int get priority => _priority;
  DateTime get createdAt => _createdAt;

  ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _invoiceNumber = map['invoiceNumber'] ?? '';
    _price = map['price'] ?? 0;
    _unit = map['unit'] ?? '';
    _image = map['image'] ?? '';
    _category = map['category'] ?? 0;
    _priority = map['priority'] ?? 0;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }

  String categoryText() {
    String ret = '';
    switch (category) {
      case 0:
        ret = '食器';
        break;
      case 1:
        ret = '雑品';
        break;
      case 9:
        ret = '洗浄';
        break;
    }
    return ret;
  }
}

String categoryIntToString(int? value) {
  String ret = '';
  switch (value) {
    case 0:
      ret = '食器';
      break;
    case 1:
      ret = '雑品';
      break;
    case 9:
      ret = '洗浄';
      break;
  }
  return ret;
}

List<ComboBoxItem<int>> kCategoryComboItems = const [
  ComboBoxItem(
    value: 0,
    child: Text('食器'),
  ),
  ComboBoxItem(
    value: 1,
    child: Text('雑品'),
  ),
  ComboBoxItem(
    value: 9,
    child: Text('洗浄'),
  ),
];
