import 'package:fluent_ui/fluent_ui.dart';

class CustomBigButton extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomBigButton({
    required this.labelText,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: ButtonState.all(backgroundColor)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            labelText,
            style: TextStyle(
              color: labelColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
