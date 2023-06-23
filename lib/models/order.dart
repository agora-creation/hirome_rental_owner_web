import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_owner_web/models/order_product.dart';

//status
//0=配達待ち,1=配達完了,9=キャンセル

class OrderModel {
  String _id = '';
  String _number = '';
  String _shopId = '';
  String _shopName = '';
  List<OrderProductModel> orderProducts = [];
  int _status = 0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get number => _number;
  String get shopId => _shopId;
  String get shopName => _shopName;
  int get status => _status;
  DateTime get createdAt => _createdAt;

  OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _number = map['number'] ?? '';
    _shopId = map['shopId'] ?? '';
    _shopName = map['shopName'] ?? '';
    orderProducts = _convertOrderProducts(map['orderProducts']);
    _status = map['invoiceName'] ?? 0;
    _createdAt = map['createdAt'].toDate() ?? DateTime.now();
  }

  List<OrderProductModel> _convertOrderProducts(List orderProducts) {
    List<OrderProductModel> ret = [];
    for (Map map in orderProducts) {
      ret.add(OrderProductModel.fromMap(map));
    }
    return ret;
  }
}
