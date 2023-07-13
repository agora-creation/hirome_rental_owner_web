import 'package:cloud_firestore/cloud_firestore.dart';

class ShopLoginService {
  String collection = 'shopLogin';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('accept', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
