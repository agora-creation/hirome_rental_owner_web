import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';

class ShopProvider with ChangeNotifier {
  ShopService shopService = ShopService();

  Future<List<ShopModel>> selectList() async {
    List<ShopModel> ret = [];
    await shopService.selectList().then((value) {
      ret = value;
    });
    return ret;
  }

  Future<String?> create({
    required String number,
    required String name,
    required String invoiceNumber,
    required String invoiceName,
    required String password,
  }) async {
    String? error;
    try {
      String id = shopService.id();
      shopService.create({
        'id': id,
        'number': number,
        'name': name,
        'invoiceNumber': invoiceNumber,
        'invoiceName': invoiceName,
        'password': password,
        'favorites': [],
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '登録に失敗しました';
    }
    return error;
  }
}
