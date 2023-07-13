import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/services/product.dart';

class ProductProvider with ChangeNotifier {
  ProductService productService = ProductService();

  TextEditingController inputNumber = TextEditingController();
  TextEditingController inputName = TextEditingController();
  TextEditingController inputInvoiceNumber = TextEditingController();
  TextEditingController inputPrice = TextEditingController();
  TextEditingController inputUnit = TextEditingController();
  int inputCategory = 0;
  TextEditingController inputPriority = TextEditingController();
  TextEditingController searchNumber = TextEditingController();
  TextEditingController searchName = TextEditingController();
  TextEditingController searchInvoiceNumber = TextEditingController();
  int? searchCategory;
  String searchText = 'なし';

  void setController(ProductModel product) {
    inputName.text = product.name;
    inputInvoiceNumber.text = product.invoiceNumber;
    inputPrice.text = product.price.toString();
    inputUnit.text = product.unit;
    inputCategory = product.category;
    inputPriority.text = product.priority.toString();
  }

  void clearController() {
    inputNumber.clear();
    inputName.clear();
    inputInvoiceNumber.clear();
    inputPrice.clear();
    inputUnit.clear();
    inputCategory = 0;
    inputPriority.clear();
  }

  void searchClear() {
    searchText = 'なし';
    searchNumber.clear();
    searchName.clear();
    searchInvoiceNumber.clear();
    searchCategory = null;
  }

  Future<List<ProductModel>> selectList() async {
    if (searchNumber.text != '' ||
        searchName.text != '' ||
        searchInvoiceNumber.text != '') {
      searchText = '';
      if (searchNumber.text != '') {
        searchText += '[商品番号]${searchNumber.text} ';
      }
      if (searchName.text != '') {
        searchText += '[商品名]${searchName.text} ';
      }
      if (searchInvoiceNumber.text != '') {
        searchText += '[請求用商品番号]${searchInvoiceNumber.text} ';
      }
      if (searchCategory != null) {
        searchText += '[カテゴリ]${categoryIntToString(searchCategory)}';
      }
    }
    return await productService.selectList(
      number: searchNumber.text,
      name: searchName.text,
      invoiceNumber: searchInvoiceNumber.text,
      category: searchCategory,
    );
  }

  Future<String?> create(Uint8List? imageBytes) async {
    String? error;
    if (inputNumber.text == '') return '食器番号は必須です';
    if (inputName.text == '') return '食器名は必須です';
    if (await productService.select(number: inputNumber.text) != null) {
      return '食器番号が重複しています';
    }
    int price = 0;
    if (inputPrice.text != '') {
      price = int.parse(inputPrice.text);
    }
    int priority = 0;
    if (inputPriority.text != '') {
      priority = int.parse(inputPriority.text);
    }
    try {
      String image = '';
      if (imageBytes != null) {
        storage.UploadTask uploadTask;
        storage.Reference ref = storage.FirebaseStorage.instance
            .ref()
            .child('product')
            .child('/${inputNumber.text}.jpeg');
        final metadata = storage.SettableMetadata(contentType: 'image/jpeg');
        uploadTask = ref.putData(imageBytes, metadata);
        await uploadTask.whenComplete(() => null);
        image = await ref.getDownloadURL();
      }
      String id = productService.id();
      productService.create({
        'id': id,
        'number': inputNumber.text,
        'name': inputName.text,
        'invoiceNumber': inputInvoiceNumber.text,
        'price': price,
        'unit': inputUnit.text,
        'image': image,
        'category': inputCategory,
        'priority': priority,
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
    if (inputName.text == '') return '食器名は必須です';
    int price = 0;
    if (inputPrice.text != '') {
      price = int.parse(inputPrice.text);
    }
    int priority = 0;
    if (inputPriority.text != '') {
      priority = int.parse(inputPriority.text);
    }
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
        'name': inputName.text,
        'invoiceNumber': inputInvoiceNumber.text,
        'price': price,
        'unit': inputUnit.text,
        'image': image,
        'category': inputCategory,
        'priority': priority,
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
