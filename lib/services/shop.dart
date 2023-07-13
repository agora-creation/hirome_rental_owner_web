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
    required String number,
    required String name,
    required String invoiceName,
    required int? authority,
  }) async {
    List<ShopModel> ret = [];
    String? isEqualToNumber;
    String? isEqualToName;
    String? isEqualToInvoiceName;
    int? isEqualToAuthority;
    if (number != '') {
      isEqualToNumber = number;
    }
    if (name != '') {
      isEqualToName = name;
    }
    if (invoiceName != '') {
      isEqualToInvoiceName = invoiceName;
    }
    if (authority != null) {
      isEqualToAuthority = authority;
    }
    await firestore
        .collection(collection)
        .where('number', isEqualTo: isEqualToNumber)
        .where('name', isEqualTo: isEqualToName)
        .where('invoiceName', isEqualTo: isEqualToInvoiceName)
        .where('authority', isEqualTo: isEqualToAuthority)
        .orderBy('priority', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(ShopModel.fromSnapshot(map));
      }
    });
    return ret;
  }
}
