import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';

class ShopProvider with ChangeNotifier {
  ShopService shopService = ShopService();

  TextEditingController inputNumber = TextEditingController();
  TextEditingController inputName = TextEditingController();
  TextEditingController inputInvoiceName = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  TextEditingController inputPriority = TextEditingController();
  int inputAuthority = 0;
  TextEditingController searchNumber = TextEditingController();
  TextEditingController searchName = TextEditingController();
  TextEditingController searchInvoiceName = TextEditingController();
  String searchText = 'なし';

  void setController(ShopModel shop) {
    inputName.text = shop.name;
    inputInvoiceName.text = shop.invoiceName;
    inputPassword.text = shop.password;
    inputPriority.text = shop.priority.toString();
    inputAuthority = shop.authority;
  }

  void clearController() {
    inputNumber.clear();
    inputName.clear();
    inputInvoiceName.clear();
    inputPassword.clear();
    inputPriority.clear();
    inputAuthority = 0;
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
    if (inputNumber.text == '') return '店舗番号は必須です';
    if (inputName.text == '') return '店舗名は必須です';
    if (await shopService.select(number: inputNumber.text) != null) {
      return '店舗番号が重複しています';
    }
    int priority = 0;
    if (inputPriority.text != '') {
      priority = int.parse(inputPriority.text);
    }
    try {
      String id = shopService.id();
      shopService.create({
        'id': id,
        'number': inputNumber.text,
        'name': inputName.text,
        'invoiceName': inputInvoiceName.text,
        'password': inputPassword.text,
        'favorites': [],
        'priority': priority,
        'authority': inputAuthority,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '登録に失敗しました';
    }
    return error;
  }

  Future<String?> update(ShopModel shop) async {
    String? error;
    if (inputName.text == '') return '店舗名は必須です';
    int priority = 0;
    if (inputPriority.text != '') {
      priority = int.parse(inputPriority.text);
    }
    try {
      shopService.update({
        'id': shop.id,
        'name': inputName.text,
        'invoiceName': inputInvoiceName.text,
        'password': inputPassword.text,
        'priority': priority,
        'authority': inputAuthority,
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
