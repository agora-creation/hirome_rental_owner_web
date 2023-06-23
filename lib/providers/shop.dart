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
}
