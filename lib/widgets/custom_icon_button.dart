import 'package:fluent_ui/fluent_ui.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Function()? onPressed;

  const CustomIconButton({
    required this.iconData,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        iconData,
        size: 18,
      ),
      onPressed: onPressed,
    );
  }
}
