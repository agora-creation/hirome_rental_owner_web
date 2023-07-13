import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/widgets/custom_button.dart';

class ShopLoginList extends StatelessWidget {
  const ShopLoginList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ログイン日時 : 2023/07/13 13:37',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '端末名 : SHIMAMURA-PC',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '珍味堂',
                style: TextStyle(
                  color: kBlackColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomButton(
                labelText: '承認',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              CustomButton(
                labelText: '却下',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
