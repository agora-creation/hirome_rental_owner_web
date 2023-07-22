import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/widgets/animation_background.dart';
import 'package:hirome_rental_owner_web/widgets/login_title.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Stack(
        children: [
          AnimationBackground(),
          Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginTitle(),
                  SizedBox(height: 24),
                  SpinKitWaveSpinner(
                    color: kWhiteColor,
                    waveColor: kWhiteColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
