import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  String _id = '';
  String _number = '';
  String _name = '';
  String _invoiceNumber = '';
  String _invoiceName = '';
  String _password = '';
  List<String> favoriteList = [];
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
    _groupId = snapshot.data()!['groupId'] ?? '';
    userId = snapshot.data()!['userId'] ?? '';
    startedAt = snapshot.data()!['startedAt'].toDate() ?? DateTime.now();
    startedLat = snapshot.data()!['startedLat'].toDouble() ?? 0;
    startedLon = snapshot.data()!['startedLon'].toDouble() ?? 0;
    endedAt = snapshot.data()!['endedAt'].toDate() ?? DateTime.now();
    endedLat = snapshot.data()!['endedLat'].toDouble() ?? 0;
    endedLon = snapshot.data()!['endedLon'].toDouble() ?? 0;
    breaks = _convertBreaks(snapshot.data()!['breaks']);
    state = snapshot.data()!['state'] ?? '';
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }
}
