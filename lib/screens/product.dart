import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/product.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';

class ProductScreen extends StatefulWidget {
  final ProductProvider productProvider;

  const ProductScreen({
    required this.productProvider,
    super.key,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<ProductModel> products = [];

  void _getProducts() async {
    List<ProductModel> tmpProducts = await widget.productProvider.selectList();
    if (mounted) {
      setState(() => products = tmpProducts);
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
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
                  '店舗が注文するための食器データを一覧で表示します。検索で絞り込んだり、登録・編集・削除することができます。',
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
                        builder: (context) => AddProductDialog(
                          productProvider: widget.productProvider,
                          getProducts: _getProducts,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final ProductProvider productProvider;
  final Function() getProducts;

  const AddProductDialog({
    required this.productProvider,
    required this.getProducts,
    super.key,
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController unit = TextEditingController();
  TextEditingController priority = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '食器 - 新規登録',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '食器番号',
            child: TextBox(controller: number),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '食器名',
            child: TextBox(controller: name),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '単価',
            child: TextBox(controller: price),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '単位',
            child: TextBox(controller: unit),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '表示の優先順位',
            child: TextBox(controller: priority),
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
            String? error = await widget.productProvider.create(
              number: number.text,
              name: name.text,
              price: int.parse(price.text),
              unit: unit.text,
              priority: int.parse(priority.text),
            );
            if (error != null) return;
            widget.getProducts;
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
