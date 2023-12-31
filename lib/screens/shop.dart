import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/models/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/screens/shop_source.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
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
                      '店舗アカウントデータを表示しています。各店舗が注文するアプリにログインするには、『店舗番号』が必要になりますので、お伝えください。',
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
                                  controller: TextEditingController(
                                    text: widget.shopProvider.searchNumber,
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != '') {
                                        widget.shopProvider.searchNumber =
                                            value;
                                      } else {
                                        widget.shopProvider.searchNumber = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '店舗名',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: widget.shopProvider.searchName,
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != '') {
                                        widget.shopProvider.searchName = value;
                                      } else {
                                        widget.shopProvider.searchName = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '請求用店舗名',
                                child: CustomTextBox(
                                  controller: TextEditingController(
                                    text: widget.shopProvider.searchInvoiceName,
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != '') {
                                        widget.shopProvider.searchInvoiceName =
                                            value;
                                      } else {
                                        widget.shopProvider.searchInvoiceName =
                                            null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              InfoLabel(
                                label: '権限',
                                child: ComboBox<int>(
                                  value: widget.shopProvider.searchAuthority,
                                  items: kAuthorityComboItems,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.shopProvider.searchAuthority =
                                          value;
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
                            columnName: 'tenantNumber',
                            label: const CustomCell(label: 'テナント番号'),
                          ),
                          GridColumn(
                            columnName: 'priority',
                            label: const CustomCell(label: '表示順'),
                          ),
                          GridColumn(
                            columnName: 'authority',
                            label: const CustomCell(label: '権限'),
                          ),
                          GridColumn(
                            columnName: 'edit_favorites',
                            label: const CustomCell(label: '操作'),
                            width: 320,
                          ),
                        ],
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
              controller: widget.shopProvider.number,
              placeholder: '例) 1234',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '店舗名',
            child: CustomTextBox(
              controller: widget.shopProvider.name,
              placeholder: '例) たこ焼き はっちゃん',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '請求書用店舗名',
            child: CustomTextBox(
              controller: widget.shopProvider.invoiceName,
              placeholder: '例) 株式会社八ちゃん堂',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'テナント番号',
            child: CustomTextBox(
              controller: widget.shopProvider.tenantNumber,
              placeholder: '例) 1',
              keyboardType: TextInputType.number,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '表示順',
            child: CustomTextBox(
              controller: widget.shopProvider.priority,
              placeholder: '例) 0',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: '権限',
            child: ComboBox<int>(
              value: widget.shopProvider.authority,
              items: kAuthorityComboItems,
              onChanged: (value) {
                setState(() {
                  widget.shopProvider.authority = value ?? 0;
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
            showMessage(context, '店舗アカウントを登録しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
