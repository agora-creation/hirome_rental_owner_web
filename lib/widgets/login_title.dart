import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          kCompanyName,
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 16,
          ),
        ),
        Text(
          kSystemName,
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        Text(
          kForName,
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
