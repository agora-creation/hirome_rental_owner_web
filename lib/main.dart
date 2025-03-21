import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hirome_rental_owner_web/common/style.dart';
import 'package:hirome_rental_owner_web/providers/login.dart';
import 'package:hirome_rental_owner_web/providers/order.dart';
import 'package:hirome_rental_owner_web/providers/product.dart';
import 'package:hirome_rental_owner_web/providers/shop.dart';
import 'package:hirome_rental_owner_web/providers/shop_login.dart';
import 'package:hirome_rental_owner_web/screens/home.dart';
import 'package:hirome_rental_owner_web/screens/login.dart';
import 'package:hirome_rental_owner_web/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDoKtCTMcCCkBU7GFdQDjqIM-YUoRBLLwE",
      authDomain: "hirome-rental.firebaseapp.com",
      projectId: "hirome-rental",
      storageBucket: "hirome-rental.appspot.com",
      messagingSenderId: "449757426730",
      appId: "1:449757426730:web:ae098c9966a5f0cad0bf53",
      measurementId: "G-VYHZTJWHN4",
    ),
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  if (FirebaseAuth.instance.currentUser == null) {
    await Future.any([
      FirebaseAuth.instance.userChanges().firstWhere((e) => e != null),
      Future.delayed(const Duration(milliseconds: 3000)),
    ]);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginProvider.initialize()),
        ChangeNotifierProvider.value(value: OrderProvider()),
        ChangeNotifierProvider.value(value: ProductProvider()),
        ChangeNotifierProvider.value(value: ShopProvider()),
        ChangeNotifierProvider.value(value: ShopLoginProvider()),
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FluentLocalizations.delegate,
          SfGlobalLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja')],
        locale: const Locale('ja'),
        title: '$kCompanyName $kSystemName - $kForName',
        theme: customTheme(),
        home: const SplashController(),
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    switch (loginProvider.status) {
      case AuthStatus.uninitialized:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return const HomeScreen();
    }
  }
}
