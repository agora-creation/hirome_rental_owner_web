import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_owner_web/models/product.dart';

class ProductService {
  String collection = 'product';
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

  Future<ProductModel?> select(String? number) async {
    ProductModel? ret;
    await firestore
        .collection(collection)
        .where('number', isEqualTo: number ?? 'error')
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret = ProductModel.fromSnapshot(map);
      }
    });
    return ret;
  }

  Future<List<ProductModel>> selectList({
    String? number,
    String? name,
    String? invoiceNumber,
    int? category,
  }) async {
    List<ProductModel> ret = [];
    await firestore
        .collection(collection)
        .where('number', isEqualTo: number)
        .where('name', isEqualTo: name)
        .where('invoiceNumber', isEqualTo: invoiceNumber)
        .where('category', isEqualTo: category)
        .orderBy('priority', descending: false)
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> map in value.docs) {
        ret.add(ProductModel.fromSnapshot(map));
      }
    });
    return ret;
  }
}
