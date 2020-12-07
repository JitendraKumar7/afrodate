import 'app_export.dart';

class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  //ENGLISH, FRENCH & SWAHILI
  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇺🇸', 'English', ENGLISH),
      Language(2, '🇺🇸', 'SWAHILI', ENGLISH),
      Language(3, '🇺🇸', 'FRENCH', ENGLISH),
    ];
  }
}

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String localized(String key) {
    return _localizedValues[key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<AppLocalization> delegate =
      TranslationsDelegate ();
}

class TranslationsDelegate  extends LocalizationsDelegate<AppLocalization> {
  const TranslationsDelegate ();

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(TranslationsDelegate  old) => false;

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }
}

Future<Locale> getLocale() async {
  String languageCode = await AppPreferences.getString(SAVE_LANGUAGE);
  print('get locale language code $languageCode');
  return _locale(languageCode ?? ENGLISH);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case HINDI:
      return Locale(HINDI, 'IN');
    default:
      return Locale(ENGLISH, 'US');
  }
}

Future<Locale> setLocale(String languageCode) async {
  await AppPreferences.setString(SAVE_LANGUAGE, languageCode);
  print('set locale language code $languageCode');
  return _locale(languageCode ?? ENGLISH);
}

String getLocalized(BuildContext context, String key) {
  var value = AppLocalization.of(context).localized(key);
  return value ?? '$key not found!';
}

/* void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }




{
    "name": "Sanjeev Rawan",
    "email": "rawan@family.com",
    "mobile": "8860963401",
    "password": "123456",
    "createdAt": "2020-11-07T06:41:38.550Z",
    "updatedAt": "2020-11-07T06:41:38.550Z",
    "id": "5fa641a21d0c39394d79ea5d"
}


79872.00 + 2710.00
343744.00


4,27,184.00
2,50,000.00
--------------

6,77,184.00
--------------



  getLocalized(context, 'home_page');

  DropdownButton<Language>(
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(e.name)
                    ],
                  ),
                ),
              )
                  .toList(),
            )
  */
