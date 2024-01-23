import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as storage;
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
  TextEditingController singleQuantity = TextEditingController();
  int category = 0;
  TextEditingController priority = TextEditingController();
  String? searchNumber;
  String? searchName;
  String? searchInvoiceNumber;
  int? searchCategory;
  String searchText = 'なし';

  void setController(ProductModel product) {
    name.text = product.name;
    invoiceNumber.text = product.invoiceNumber;
    price.text = product.price.toString();
    unit.text = product.unit;
    singleQuantity.text = product.singleQuantity.toString();
    category = product.category;
    priority.text = product.priority.toString();
  }

  void clearController() {
    number.clear();
    name.clear();
    invoiceNumber.clear();
    price.clear();
    unit.clear();
    singleQuantity.clear();
    category = 0;
    priority.clear();
  }

  void searchClear() {
    searchText = 'なし';
    searchNumber = null;
    searchName = null;
    searchInvoiceNumber = null;
    searchCategory = null;
  }

  Future<List<ProductModel>> selectList() async {
    if (searchNumber != null ||
        searchName != null ||
        searchInvoiceNumber != null ||
        searchCategory != null) {
      searchText = '';
      if (searchNumber != null) {
        searchText += '[商品番号]$searchNumber ';
      }
      if (searchName != null) {
        searchText += '[商品名]$searchName ';
      }
      if (searchInvoiceNumber != null) {
        searchText += '[請求用商品番号]$searchInvoiceNumber ';
      }
      if (searchCategory != null) {
        searchText += '[カテゴリ]${categoryIntToString(searchCategory)}';
      }
    }
    return await productService.selectList(
      number: searchNumber,
      name: searchName,
      invoiceNumber: searchInvoiceNumber,
      category: searchCategory,
    );
  }

  Future<String?> create(Uint8List? imageBytes) async {
    String? error;
    if (number.text == '') return '商品番号は必須です';
    if (name.text == '') return '商品名は必須です';
    if (await productService.select(number.text) != null) {
      return '商品番号が重複しています';
    }
    try {
      String image = '';
      if (imageBytes != null) {
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('product')
            .child('/${number.text}.jpeg');
        final metadata = storage.SettableMetadata(contentType: 'image/jpeg');
        uploadTask = ref.putData(imageBytes, metadata);
        await uploadTask.whenComplete(() => null);
        image = await ref.getDownloadURL();
      }
      String id = productService.id();
      productService.create({
        'id': id,
        'number': number.text,
        'name': name.text,
        'invoiceNumber': invoiceNumber.text,
        'price': int.parse(price.text),
        'unit': unit.text,
        'singleQuantity': int.parse(singleQuantity.text),
        'image': image,
        'category': category,
        'priority': int.parse(priority.text),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '登録に失敗しました';
    }
    return error;
  }

  Future<String?> update(
    ProductModel product,
    Uint8List? imageBytes,
  ) async {
    String? error;
    if (name.text == '') return '商品名は必須です';
    try {
      String image = product.image;
      if (imageBytes != null) {
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('product')
            .child('/${product.number}.jpeg');
        final metadata = storage.SettableMetadata(contentType: 'image/jpeg');
        uploadTask = ref.putData(imageBytes, metadata);
        await uploadTask.whenComplete(() => null);
        image = await ref.getDownloadURL();
      }
      productService.update({
        'id': product.id,
        'name': name.text,
        'invoiceNumber': invoiceNumber.text,
        'price': int.parse(price.text),
        'unit': unit.text,
        'singleQuantity': int.parse(singleQuantity.text),
        'image': image,
        'category': category,
        'priority': int.parse(priority.text),
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
