import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';

class ShopProvider with ChangeNotifier {
  ShopService shopService = ShopService();

  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController invoiceName = TextEditingController();
  TextEditingController password = TextEditingController();

  void setController(ShopModel shop) {
    name.text = shop.name;
    invoiceNumber.text = shop.invoiceNumber;
    invoiceName.text = shop.invoiceName;
    password.text = shop.password;
    notifyListeners();
  }

  void clearController() {
    number.clear();
    name.clear();
    invoiceNumber.clear();
    invoiceName.clear();
    password.clear();
    notifyListeners();
  }

  List<ShopModel> shops = [];

  Future getData() async {
    shops = await shopService.selectList();
    notifyListeners();
  }

  Future<String?> create() async {
    String? error;
    if (number.text == '') return '店舗番号は必須です';
    if (name.text == '') return '店舗名は必須です';
    if (await shopService.select(number.text) != null) {
      return '店舗番号が重複しています';
    }
    try {
      String id = shopService.id();
      shopService.create({
        'id': id,
        'number': number.text,
        'name': name.text,
        'invoiceNumber': invoiceNumber.text,
        'invoiceName': invoiceName.text,
        'password': password.text,
        'favorites': [],
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '登録に失敗しました';
    }
    return error;
  }

  Future<String?> update(ShopModel shop) async {
    String? error;
    if (name.text == '') return '店舗名は必須です';
    try {
      shopService.update({
        'id': shop.id,
        'name': name.text,
        'invoiceNumber': invoiceNumber.text,
        'invoiceName': invoiceName.text,
        'password': password.text,
      });
    } catch (e) {
      error = '保存に失敗しました';
    }
    return error;
  }

  Future<String?> delete(ShopModel shop) async {
    String? error;
    try {
      shopService.delete({'id': shop.id});
    } catch (e) {
      error = '削除に失敗しました';
    }
    return error;
  }
}
