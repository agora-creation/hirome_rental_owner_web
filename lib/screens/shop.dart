import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/screens/shop_source.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShopScreen extends StatefulWidget {
  final ShopProvider shopProvider;

  const ShopScreen({
    required this.shopProvider,
    super.key,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<ShopModel> shops = [];

  void _getShops() async {
    List<ShopModel> tmpShops = await widget.shopProvider.selectList();
    if (mounted) {
      setState(() => shops = tmpShops);
    }
  }

  @override
  void initState() {
    super.initState();
    _getShops();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '店舗アカウントデータを一覧で表示します。検索で絞り込んだり、登録・編集・削除することができます。',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Expander(
                  header: Text('検索条件 : なし'),
                  content: Column(
                    children: [],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconTextButton(
                      iconData: FluentIcons.add,
                      iconColor: kWhiteColor,
                      labelText: '新規登録',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddShopDialog(
                          shopProvider: widget.shopProvider,
                          getShops: _getShops,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 450,
                  child: CustomDataGrid(
                    source: ShopSource(shops: shops),
                    columns: [
                      GridColumn(
                        columnName: 'number',
                        label: const CustomCell('店舗番号'),
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: const CustomCell('店舗名'),
                      ),
                      GridColumn(
                        columnName: 'invoiceNumber',
                        label: const CustomCell('請求用店舗番号'),
                      ),
                      GridColumn(
                        columnName: 'invoiceName',
                        label: const CustomCell('請求用店舗名'),
                      ),
                      GridColumn(
                        columnName: 'password',
                        label: const CustomCell('パスワード'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddShopDialog extends StatefulWidget {
  final ShopProvider shopProvider;
  final Function() getShops;

  const AddShopDialog({
    required this.shopProvider,
    required this.getShops,
    super.key,
  });

  @override
  State<AddShopDialog> createState() => _AddShopDialogState();
}

class _AddShopDialogState extends State<AddShopDialog> {
  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController invoiceName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '店舗 - 新規登録',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '店舗番号',
            child: TextBox(controller: number),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '店舗名',
            child: TextBox(controller: name),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '請求書用店舗番号',
            child: TextBox(controller: invoiceNumber),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '請求書用店舗名',
            child: TextBox(controller: invoiceName),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'パスワード',
            child: TextBox(controller: password),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: '登録する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.shopProvider.create(
              number: number.text,
              name: name.text,
              invoiceNumber: invoiceNumber.text,
              invoiceName: invoiceName.text,
              password: password.text,
            );
            if (error != null) return;
            widget.getShops;
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
