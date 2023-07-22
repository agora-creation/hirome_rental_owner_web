import 'package:fluent_ui/fluent_ui.dart';
import 'package:hirome_rental_owner_web/common/functions.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/providers/auth.dart';
import 'package:hirome_rental_owner_web/screens/home.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
import 'package:hirome_rental_owner_web/widgets/custom_big_button.dart';
import 'package:hirome_rental_owner_web/widgets/custom_text_box.dart';
import 'package:hirome_rental_owner_web/widgets/login_title.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ScaffoldPage(
      content: Stack(
        children: [
          const AnimationBackground(),
          Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginTitle(),
                  const SizedBox(height: 40),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InfoLabel(
                            label: 'ログインID',
                            child: CustomTextBox(
                              controller: authProvider.loginId,
                              placeholder: '',
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InfoLabel(
                            label: 'パスワード',
                            child: CustomTextBox(
                              controller: authProvider.password,
                              placeholder: '',
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 1,
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomBigButton(
                            labelText: 'ログイン',
                            labelColor: kWhiteColor,
                            backgroundColor: kBlueColor,
                            onPressed: () async {
                              String? error = await authProvider.signIn();
                              if (error != null) {
                                if (!mounted) return;
                                showMessage(context, error, false);
                                return;
                              }
                              authProvider.clearController();
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                FluentPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
