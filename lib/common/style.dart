import 'package:fluent_ui/fluent_ui.dart';

const kCompanyName = 'ひろめ市場';
const kSystemName = '食器レンタルシステム';
const kForName = '管理者専用';

const kBaseColor = Color(0xFF90A4AE);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kLightBlueColor = Color(0xFF03A9F4);
const kGreenColor = Color(0xFF4CAF50);
const kOrangeColor = Color(0xFFFF9800);

FluentThemeData customTheme() {
  return FluentThemeData(
    fontFamily: 'SourceHanSansJP-Regular',
    activeColor: kBaseColor,
    cardColor: kWhiteColor,
    scaffoldBackgroundColor: kBaseColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    navigationPaneTheme: const NavigationPaneThemeData(
      backgroundColor: kWhiteColor,
      highlightColor: kBaseColor,
    ),
    checkboxTheme: CheckboxThemeData(
      checkedDecoration: ButtonState.all<Decoration>(
        BoxDecoration(
          color: kBlueColor,
          border: Border.all(color: kBlackColor),
        ),
      ),
      uncheckedDecoration: ButtonState.all<Decoration>(
        BoxDecoration(
          color: kWhiteColor,
          border: Border.all(color: kBlackColor),
        ),
      ),
    ),
  );
}
