import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirome_rental_owner_web/models/voucher.dart';

class VoucherService {
  String collection = 'voucher';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<VoucherModel?> select() async {
    VoucherModel? ret;
    await firestore.collection(collection).doc('1').get().then((value) {
      ret = VoucherModel.fromSnapshot(value);
    });
    return ret;
  }
}
