import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '$kCompanyName $kSystemName - $kForName',
      style: TextStyle(fontSize: 14),
    );
  }
}
