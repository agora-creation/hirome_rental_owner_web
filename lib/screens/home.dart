import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop_login.dart';
import 'package:hirome_rental_owner_web/providers/auth.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop_login.dart';
import 'package:hirome_rental_owner_web/screens/login.dart';
import 'package:hirome_rental_owner_web/screens/order.dart';
import 'package:hirome_rental_owner_web/screens/product.dart';
import 'package:hirome_rental_owner_web/screens/shop.dart';
import 'package:hirome_rental_owner_web/screens/shop_login.dart';
import 'package:hirome_rental_owner_web/services/shop_login.dart';
import 'package:hirome_rental_owner_web/widgets/app_bar_title.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ShopLoginService shopLoginService = ShopLoginService();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final shopLoginProvider = Provider.of<ShopLoginProvider>(context);

    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: const AppBarTitle(),
        actions: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: CustomIconButton(
              iconData: FluentIcons.settings,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => SignOutDialog(
                  authProvider: authProvider,
                ),
              ),
            ),
          ),
        ),
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          setState(() => selectedIndex = index);
        },
        displayMode: PaneDisplayMode.top,
        items: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.shopping_cart),
            title: const Text('注文管理'),
            body: OrderScreen(orderProvider: orderProvider),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('店舗アカウント管理'),
            body: ShopScreen(shopProvider: shopProvider),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.account_activity),
            title: const Text('店舗ログイン申請'),
            body: ShopLoginScreen(shopLoginProvider: shopLoginProvider),
            infoBadge: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: shopLoginService.streamList(),
              builder: (context, snapshot) {
                List<ShopLoginModel> shopLogins = [];
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    shopLogins.add(ShopLoginModel.fromSnapshot(doc));
                  }
                }
                if (shopLogins.isEmpty) return Container();
                return InfoBadge(
                  source: Text('${shopLogins.length}'),
                  color: kRedColor,
                );
              },
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.beer_mug),
            title: const Text('商品管理'),
            body: ProductScreen(productProvider: productProvider),
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}

class SignOutDialog extends StatefulWidget {
  final AuthProvider authProvider;

  const SignOutDialog({
    required this.authProvider,
    super.key,
  });

  @override
  State<SignOutDialog> createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'システム情報',
        style: TextStyle(fontSize: 18),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最終更新日: 2023/07/04 15:49'),
          Text('ログインID: owner'),
        ],
      ),
      actions: [
        CustomButton(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            await widget.authProvider.signOut();
            if (!mounted) return;
            showMessage(context, 'ログアウトしました', true);
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
