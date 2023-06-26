import 'package:fluent_ui/fluent_ui.dart';

class CustomCell extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const CustomCell({required this.label, this.onTap,super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.centerLeft,
        child: Text(label, softWrap: false),
      ),
    );
  }
}
