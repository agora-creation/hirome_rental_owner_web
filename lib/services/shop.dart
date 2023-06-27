import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';

class ShopService {
  String collection = 'shop';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<ShopModel?> select({String? number}) async {
    ShopModel? ret;
    await firestore
        .collection(collection)
        .where('number', isEqualTo: number ?? 'error')
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret = ShopModel.fromSnapshot(map);
      }
    });
    return ret;
  }

  Future<List<ShopModel>> selectList({
    String? number,
    String? name,
    String? invoiceNumber,
    String? invoiceName,
  }) async {
    List<ShopModel> ret = [];
    await firestore
        .collection(collection)
        .where('number', isEqualTo: number)
        .where('name', isEqualTo: name)
        .where('invoiceNumber', isEqualTo: invoiceNumber)
        .where('invoiceName', isEqualTo: invoiceName)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(ShopModel.fromSnapshot(map));
      }
    });
    return ret;
  }
}
