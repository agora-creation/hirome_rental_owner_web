import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/providers/auth.dart';
import 'package:hirome_rental_owner_web/screens/home.dart';
import 'package:hirome_rental_owner_web/widgets/login_title.dart';
import 'package:provider/provider.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ScaffoldPage(
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          String? error = await authProvider.signIn();
          if (error != null) return;
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            FluentPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
        child: const Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LoginTitle(),
                SizedBox(height: 24),
                Text(
                  '画面をクリックして始める',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
