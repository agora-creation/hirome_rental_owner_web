import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/services/product.dart';

class ProductProvider with ChangeNotifier {
  ProductService productService = ProductService();

  Future<List<ProductModel>> selectList() async {
    List<ProductModel> ret = [];
    await productService.selectList().then((value) {
      ret = value;
    });
    return ret;
  }

  Future<String?> create({
    required String number,
    required String name,
    required int price,
    required String unit,
    required int priority,
  }) async {
    String? error;
    try {
      String id = productService.id();
      productService.create({
        'id': id,
        'number': number,
        'name': name,
        'invoiceNumber': '',
        'invoiceName': '',
        'price': price,
        'unit': unit,
        'image': '',
        'priority': priority,
        'display': true,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '登録に失敗しました';
    }
    return error;
  }
}
