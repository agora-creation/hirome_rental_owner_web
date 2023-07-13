import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ShopModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _invoiceName = '';
  String _password = '';
  List<String> favorites = [];
  int _priority = 0;
  int _authority = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get invoiceName => _invoiceName;
  String get password => _password;
  int get priority => _priority;
  int get authority => _authority;
  DateTime get createdAt => _createdAt;

  ShopModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _invoiceName = map['invoiceName'] ?? '';
    _password = map['password'] ?? '';
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
