import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/order.dart';
import 'package:hirome_rental_owner_web/services/order.dart';

class OrderProvider with ChangeNotifier {
  OrderService orderService = OrderService();

  Future<List<OrderModel>> selectList() async {
    List<OrderModel> ret = [];
    await orderService.selectList().then((value) {
      ret = value;
    });
    return ret;
  }
}
