import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/services/order.dart';

class OrderProvider with ChangeNotifier {
  OrderService orderService = OrderService();

  DateTime searchStart = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime searchEnd = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  ).add(const Duration(days: -1));
  String? searchShop;
  String searchText = 'なし';

  void searchClear() {
    searchText = 'なし';
    searchStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );
    searchEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      1,
    ).add(const Duration(days: -1));
    searchShop = null;
  }

  Future<List<OrderModel>> selectList() async {
    if (searchShop != null) {
      searchText = '';
      searchText +=
          '[注文日]${dateText('yyyy-MM-dd', searchStart)} ～ ${dateText('yyyy-MM-dd', searchEnd)} ';
      if (searchShop != null) {
        searchText += '[発注元店舗]$searchShop ';
      }
    }
    return await orderService.selectList(
      shopName: searchShop,
      searchStart: searchStart,
      searchEnd: searchEnd,
    );
  }
}
