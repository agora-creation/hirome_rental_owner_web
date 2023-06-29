import 'package:fluent_ui/fluent_ui.dart';

class CustomImageCell extends StatelessWidget {
  final String path;
  final Function()? onTap;

  const CustomImageCell({
    required this.path,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/no_image.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
