import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';

class ShopProvider with ChangeNotifier {
  ShopService shopService = ShopService();

  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController invoiceName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController searchNumber = TextEditingController();
  TextEditingController searchName = TextEditingController();
  TextEditingController searchInvoiceName = TextEditingController();
  String searchText = 'なし';

  void setController(ShopModel shop) {
    name.text = shop.name;
    invoiceName.text = shop.invoiceName;
    password.text = shop.password;
    priority.text = shop.priority.toString();
  }

  void clearController() {
    number.clear();
    name.clear();
    invoiceName.clear();
    password.clear();
    priority.clear();
  }

  void searchClear() {
    searchText = 'なし';
    searchNumber.clear();
    searchName.clear();
    searchInvoiceName.clear();
  }

  Future<List<ShopModel>> getList() async {
    if (searchNumber.text != '' ||
        searchName.text != '' ||
        searchInvoiceName.text != '') {
      searchText = '';
      if (searchNumber.text != '') {
        searchText += '[店舗番号]${searchNumber.text} ';
      }
      if (searchName.text != '') {
        searchText += '[店舗名]${searchName.text} ';
      }
      if (searchInvoiceName.text != '') {
        searchText += '[請求用店舗名]${searchInvoiceName.text} ';
      }
    }
    return await shopService.selectList(
      number: searchNumber.text,
      name: searchName.text,
      invoiceName: searchInvoiceName.text,
    );
  }

  Future<String?> create() async {
    String? error;
    if (number.text == '') return '店舗番号は必須です';
    if (name.text == '') return '店舗名は必須です';
    if (await shopService.select(number: number.text) != null) {
      return '店舗番号が重複しています';
    }
    try {
      String id = shopService.id();
      shopService.create({
        'id': id,
        'number': number.text,
        'name': name.text,
        'invoiceName': invoiceName.text,
        'password': password.text,
        'favorites': [],
        'priority': int.parse(priority.text),
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
        'invoiceName': invoiceName.text,
        'password': password.text,
        'priority': int.parse(priority.text),
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
