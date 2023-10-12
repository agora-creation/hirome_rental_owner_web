import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/services/shop.dart';

class ShopProvider with ChangeNotifier {
  ShopService shopService = ShopService();

  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController invoiceName = TextEditingController();
  TextEditingController tenantNumber = TextEditingController();
  TextEditingController priority = TextEditingController();
  int authority = 0;
  String? searchNumber;
  String? searchName;
  String? searchInvoiceName;
  int? searchAuthority;
  String searchText = 'なし';

  void setController(ShopModel shop) {
    name.text = shop.name;
    invoiceName.text = shop.invoiceName;
    tenantNumber.text = shop.tenantNumber;
    priority.text = shop.priority.toString();
    authority = shop.authority;
  }

  void clearController() {
    number.clear();
    name.clear();
    invoiceName.clear();
    tenantNumber.clear();
    priority.clear();
    authority = 0;
  }

  void searchClear() {
    searchText = 'なし';
    searchNumber = null;
    searchName = null;
    searchInvoiceName = null;
    searchAuthority = null;
  }

  Future<List<ShopModel>> selectList() async {
    if (searchNumber != null ||
        searchName != null ||
        searchInvoiceName != null ||
        searchAuthority != null) {
      searchText = '';
      if (searchNumber != null) {
        searchText += '[店舗番号]$searchNumber ';
      }
      if (searchName != null) {
        searchText += '[店舗名]$searchName ';
      }
      if (searchInvoiceName != null) {
        searchText += '[請求用店舗名]$searchInvoiceName ';
      }
      if (searchAuthority != null) {
        searchText += '[権限]${authorityIntToString(searchAuthority)}';
      }
    }
    return await shopService.selectList(
      number: searchNumber,
      name: searchName,
      invoiceName: searchInvoiceName,
      authority: searchAuthority,
    );
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
        'invoiceName': invoiceName.text,
        'tenantNumber': tenantNumber.text,
        'favorites': [],
        'priority': int.parse(priority.text),
        'authority': authority,
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
        'tenantNumber': tenantNumber.text,
        'priority': int.parse(priority.text),
        'authority': authority,
      });
    } catch (e) {
      error = '保存に失敗しました';
    }
    return error;
  }

  Future<String?> updateFavorites(
    ShopModel shop,
    List<String> favorites,
  ) async {
    String? error;
    try {
      shopService.update({
        'id': shop.id,
        'favorites': favorites,
      });
    } catch (e) {
      error = 'お気に入り設定に失敗しました';
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
