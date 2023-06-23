import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _invoiceNumber = '';
  String _invoiceName = '';
  String _password = '';
  List<String> favorites = [];
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get invoiceNumber => _invoiceNumber;
  String get invoiceName => _invoiceName;
  String get password => _password;
  DateTime get createdAt => _createdAt;

  ShopModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _name = map['name'] ?? '';
    _invoiceNumber = map['invoiceNumber'] ?? '';
    _invoiceName = map['invoiceName'] ?? '';
    _password = map['password'] ?? '';
    favorites = _convertFavorites(map['favorites']);
    _createdAt = map['createdAt'].toDate() ?? DateTime.now();
  }

  List<String> _convertFavorites(List<String> list) {
    List<String> ret = [];
    for (String id in list) {
      ret.add(id);
    }
    return ret;
  }
}
