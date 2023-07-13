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

  Future<ProductModel?> select({String? number}) async {
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
    required String number,
    required String name,
    required String invoiceNumber,
    required int? category,
  }) async {
    List<ProductModel> ret = [];
    String? isEqualToNumber;
    String? isEqualToName;
    String? isEqualToInvoiceNumber;
    int? isEqualToCategory;
    if (number != '') {
      isEqualToNumber = number;
    }
    if (name != '') {
      isEqualToName = name;
    }
    if (invoiceNumber != '') {
      isEqualToInvoiceNumber = invoiceNumber;
    }
    if (category != null) {
      isEqualToCategory = category;
    }
    await firestore
        .collection(collection)
        .where('number', isEqualTo: isEqualToNumber)
        .where('name', isEqualTo: isEqualToName)
        .where('invoiceNumber', isEqualTo: isEqualToInvoiceNumber)
        .where('category', isEqualTo: isEqualToCategory)
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
