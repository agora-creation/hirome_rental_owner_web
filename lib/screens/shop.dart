import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/screens/shop_source.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_cell.dart';
import 'package:hirome_rental_owner_web/widgets/custom_data_grid.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_text_box.dart';
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
    List<ShopModel> tmpShops = await widget.shopProvider.getList();
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
                Expander(
                  header: Text('検索条件 : ${widget.shopProvider.searchText}'),
                  content: Column(
                    children: [
                      GridView(
                        shrinkWrap: true,
                        gridDelegate: kSearchGrid,
                        children: [
                          InfoLabel(
                            label: '店舗番号',
                            child: CustomTextBox(
                              controller: widget.shopProvider.searchNumber,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                          InfoLabel(
                            label: '店舗名',
                            child: CustomTextBox(
                              controller: widget.shopProvider.searchName,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                          InfoLabel(
                            label: '請求用店舗名',
                            child: CustomTextBox(
                              controller: widget.shopProvider.searchInvoiceName,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                          InfoLabel(
                            label: '権限',
                            child: ComboBox<int>(
                              value: widget.shopProvider.searchAuthority,
                              items: kAuthorityComboItems,
                              onChanged: (value) {
                                setState(() {
                                  widget.shopProvider.searchAuthority = value;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconTextButton(
                            iconData: FluentIcons.clear,
                            iconColor: kLightBlueColor,
                            labelText: '検索リセット',
                            labelColor: kLightBlueColor,
                            backgroundColor: kWhiteColor,
                            onPressed: () {
                              widget.shopProvider.searchClear();
                              _getShops();
                            },
                          ),
                          const SizedBox(width: 8),
                          CustomIconTextButton(
                            iconData: FluentIcons.search,
                            iconColor: kWhiteColor,
                            labelText: '検索する',
                            labelColor: kWhiteColor,
                            backgroundColor: kLightBlueColor,
                            onPressed: () => _getShops(),
                          ),
                        ],
                      ),
                    ],
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
                  height: 600,
                  child: CustomDataGrid(
                    source: ShopSource(
                      context: context,
                      shopProvider: widget.shopProvider,
                      shops: shops,
                      getShops: _getShops,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'number',
                        label: const CustomCell(label: '店舗番号'),
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: const CustomCell(label: '店舗名'),
                      ),
                      GridColumn(
                        columnName: 'invoiceName',
                        label: const CustomCell(label: '請求用店舗名'),
                      ),
                      GridColumn(
                        columnName: 'password',
                        label: const CustomCell(label: 'パスワード'),
                      ),
                      GridColumn(
                        columnName: 'priority',
                        label: const CustomCell(label: '表示順'),
                      ),
                      GridColumn(
                        columnName: 'authority',
                        label: const CustomCell(label: '権限'),
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
  @override
  void initState() {
    super.initState();
    widget.shopProvider.clearController();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '店舗アカウント - 新規登録',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: '店舗番号',
            child: CustomTextBox(
              controller: widget.shopProvider.inputNumber,
              placeholder: '例) 1234',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '店舗名',
            child: CustomTextBox(
              controller: widget.shopProvider.inputName,
              placeholder: '例) たこ焼き はっちゃん',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '請求書用店舗名',
            child: CustomTextBox(
              controller: widget.shopProvider.inputInvoiceName,
              placeholder: '例) 株式会社八ちゃん堂',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'パスワード',
            child: CustomTextBox(
              controller: widget.shopProvider.inputPassword,
              placeholder: '',
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '表示順',
            child: CustomTextBox(
              controller: widget.shopProvider.inputPriority,
              placeholder: '例) 0',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '権限',
            child: ComboBox<int>(
              value: widget.shopProvider.inputAuthority,
              items: kAuthorityComboItems,
              onChanged: (value) {
                setState(() {
                  widget.shopProvider.inputAuthority = value ?? 0;
                });
              },
            ),
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
            String? error = await widget.shopProvider.create();
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.shopProvider.clearController();
            widget.getShops();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
