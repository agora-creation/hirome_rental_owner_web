import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/services/product.dart';

class ProductProvider with ChangeNotifier {
  ProductService productService = ProductService();

  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController searchNumber = TextEditingController();
  TextEditingController searchName = TextEditingController();
  TextEditingController searchInvoiceNumber = TextEditingController();
  String searchText = 'なし';

  void setController(ProductModel product) {
    name.text = product.name;
    invoiceNumber.text = product.invoiceNumber;
    price.text = product.price.toString();
    unit.text = product.unit;
    priority.text = product.priority.toString();
  }

  void clearController() {
    number.clear();
    name.clear();
    invoiceNumber.clear();
    price.clear();
    unit.clear();
    priority.clear();
  }

  void searchClear() {
    searchText = 'なし';
    searchNumber.clear();
    searchName.clear();
    searchInvoiceNumber.clear();
  }

  Future<List<ProductModel>> selectList() async {
    List<ProductModel> ret = [];
    await productService.selectList().then((value) {
      ret = value;
    });
    return ret;
  }

  Future<String?> create() async {
    String? error;
    if (number.text == '') return '食器番号は必須です';
    if (name.text == '') return '食器名は必須です';
    if (await productService.select(number: number.text) != null) {
      return '食器番号が重複しています';
    }
    try {
      String id = productService.id();
      productService.create({
        'id': id,
        'number': number.text,
        'name': name.text,
        'invoiceNumber': invoiceNumber.text,
        'price': int.parse(price.text),
        'unit': unit.text,
        'image': '',
        'priority': int.parse(priority.text),
        'display': true,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '登録に失敗しました';
    }
    return error;
  }

  Future<String?> update(ProductModel product) async {
    String? error;
    if (name.text == '') return '食器名は必須です';
    try {
      productService.update({
        'id': product.id,
        'name': name.text,
        'invoiceNumber': invoiceNumber.text,
        'price': int.parse(price.text),
        'unit': unit.text,
        'image': '',
        'priority': int.parse(priority.text),
        'display': true,
      });
    } catch (e) {
      error = '保存に失敗しました';
    }
    return error;
  }

  Future<String?> delete(ProductModel product) async {
    String? error;
    try {
      productService.delete({'id': product.id});
    } catch (e) {
      error = '削除に失敗しました';
    }
    return error;
  }
}
