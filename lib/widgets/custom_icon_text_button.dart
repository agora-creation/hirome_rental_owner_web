import 'package:fluent_ui/fluent_ui.dart';

class CustomIconTextButton extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomIconTextButton({
    required this.iconData,
    required this.iconColor,
    required this.labelText,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(backgroundColor: ButtonState.all(backgroundColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            labelText,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
