import 'app_export.dart';

const List<Locale> LOCALES = [Locale(ENGLISH, 'US'), Locale(HINDI, 'IN')];
const List<LocalizationsDelegate<dynamic>> DELEGATES = [
  AppLocalization.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const String HINDI = 'hi';
const String ENGLISH = 'en';

Color afroRed = Color.fromARGB(255, 231, 76, 60);
Color afroGray = Color.fromARGB(255, 102, 102, 102);

const String AFRO_DATE = 'assets/ic_afro_date.png';
const String AFRO_DATE_LOGO = 'assets/ic_afro_date_logo.png';

const String USER_ID = 'com.afro.date.app.user.id';
const String USER_NAME = 'com.afro.date.app.user.name';
const String USER_EMAIL = 'com.afro.date.app.user.email';
const String USER_MOBILE = 'com.afro.date.app.user.mobile';
const String USER_PASSWORD = 'com.afro.date.app.user.password';

const String IS_LOGIN = 'com.afro.date.app.user.is.login';
const String SAVE_LANGUAGE = 'com.afro.date.app.save.language';
