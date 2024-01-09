import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherModel {
  String _id = '';
  int _no = 0;

  String get id => _id;
  int get no => _no;

  VoucherModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _no = map['no'] ?? 0;
  }
}
