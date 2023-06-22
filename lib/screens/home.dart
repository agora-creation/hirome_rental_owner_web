import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/screens/order.dart';
import 'package:hirome_rental_owner_web/widgets/app_bar_title.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
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
            body: const OrderScreen(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.bank),
            title: const Text('店舗管理'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.beer_mug),
            title: const Text('食器管理'),
            body: Container(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.analytics_view),
            title: const Text('データ分析'),
            body: Container(),
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}
