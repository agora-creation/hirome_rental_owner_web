import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/widgets/custom_icon_text_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
                  '店舗が注文したデータを一覧で表示します。検索で絞り込んだり、帳票の出力を行うことができます。',
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
                      iconData: FluentIcons.download,
                      iconColor: kWhiteColor,
                      labelText: 'PDFダウンロード',
                      labelColor: kWhiteColor,
                      backgroundColor: kRedColor,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    CustomIconTextButton(
                      iconData: FluentIcons.download,
                      iconColor: kWhiteColor,
                      labelText: 'CSVダウンロード',
                      labelColor: kWhiteColor,
                      backgroundColor: kGreenColor,
                      onPressed: () {},
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
