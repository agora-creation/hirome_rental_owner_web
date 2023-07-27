import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';

class CustomMonthBox extends StatelessWidget {
  final DateTime? value;
  final Function()? onTap;

  const CustomMonthBox({
    this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (value != null) {
      text = dateText('yyyy/MM', value);
    }

    return TextBox(
      controller: TextEditingController(text: text),
      placeholder: '年/月',
      suffix: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          FluentIcons.calendar,
          color: kGreyColor,
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
