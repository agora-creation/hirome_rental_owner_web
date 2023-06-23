import 'package:fluent_ui/fluent_ui.dart';

class CustomCell extends StatelessWidget {
  final String label;

  const CustomCell(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.centerLeft,
      child: Text(label, softWrap: false),
    );
  }
}
