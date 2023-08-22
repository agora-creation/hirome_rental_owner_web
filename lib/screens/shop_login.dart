import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/models/shop_login.dart';
import 'package:hirome_rental_owner_web/providers/shop_login.dart';
import 'package:hirome_rental_owner_web/screens/shop_login_source.dart';
import 'package:hirome_rental_owner_web/services/shop_login.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShopLoginScreen extends StatefulWidget {
  final ShopLoginProvider shopLoginProvider;

  const ShopLoginScreen({
    required this.shopLoginProvider,
    super.key,
  });

  @override
  State<ShopLoginScreen> createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  ShopLoginService shopLoginService = ShopLoginService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimationBackground(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '店舗アカウントのログインがあった場合に、二段階認証の為、管理者宛に申請が送られます。\n『承認』するまでは、店舗はログインできません。身に覚えのないログインは『却下』してください。',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 600,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: shopLoginService.streamList(),
                        builder: (context, snapshot) {
                          List<ShopLoginModel> shopLogins = [];
                          if (snapshot.hasData) {
                            for (DocumentSnapshot<Map<String, dynamic>> doc
                                in snapshot.data!.docs) {
                              shopLogins.add(ShopLoginModel.fromSnapshot(doc));
                            }
                          }
                          return CustomDataGrid(
                            source: ShopLoginSource(
                              context: context,
                              shopLoginProvider: widget.shopLoginProvider,
                              shopLogins: shopLogins,
                            ),
                            columns: [
                              GridColumn(
                                columnName: 'createdAt',
                                label: const CustomCell(label: 'ログイン日時'),
                              ),
                              GridColumn(
                                columnName: 'shopName',
                                label: const CustomCell(label: '店舗アカウント名'),
                              ),
                              GridColumn(
                                columnName: 'requestName',
                                label: const CustomCell(label: '申請者名'),
                              ),
                              GridColumn(
                                columnName: 'deviceName',
                                label: const CustomCell(label: '端末名'),
                              ),
                              GridColumn(
                                columnName: 'accept_reject',
                                label: const CustomCell(label: '操作'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
