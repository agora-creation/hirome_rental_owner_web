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
}
