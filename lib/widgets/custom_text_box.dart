import 'package:fluent_ui/fluent_ui.dart';

class CustomTextBox extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? obscureText;
  final Function(String)? onChanged;

  const CustomTextBox({
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.maxLines,
    this.obscureText,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      expands: false,
      maxLines: maxLines,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
    );
  }
}
