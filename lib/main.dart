import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './app/app_export.dart';

var appLaunch;
//jk!@#9634036394!@#$%
final navigatorKey = GlobalKey<NavigatorState>();
final localNotifications = FlutterLocalNotificationsPlugin();

Future<void> _showNotification(Map message) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'afrodateChannelId',
    'afrodate',
    'afrodate pvt ltd',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );
  var macOSPlatformChannelSpecifics = MacOSNotificationDetails();
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    macOS: macOSPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await localNotifications.show(
    Random().nextInt(2147483647),
    '${message['data']['title']}',
    message['data']['body'],
    platformChannelSpecifics,
    payload: jsonEncode(message),
  );
}

Future<dynamic> onBackgroundMessageHandler(Map message) async {
  print('onBackgroundMessage: $message');
  _showNotification(message);
  return Future<void>.value();
}

class NotificationHandler {
  static final NotificationHandler _singleton = NotificationHandler._internal();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  factory NotificationHandler() {
    return _singleton;
  }

  NotificationHandler._internal();

  NotificationHandler initialise() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettingsMacOS = MacOSInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      macOS: initializationSettingsMacOS,
      iOS: initializationSettingsIOS,
    );

    localNotifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage : $message');
        _showNotification(message);
      },
      onBackgroundMessage: Platform.isIOS ? null : onBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch : $message');
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume : $message');
        _showNotification(message);
      },
    );
    return this;
  }

  Future<void> register() => getToken().then(print);

  Future<String> getToken() async => _fcm.getToken();

  Future<void> onSelectNotification(String payload) async {
    Map result = jsonDecode(payload);
    if (appLaunch?.didNotificationLaunchApp ?? false) {
      print('SelectNotificationLaunchApp $result');
    }
    // app already opened
    else {
      print('SelectNotification $result');
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print('onDidReceiveLocalNotification $payload');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appLaunch = await localNotifications.getNotificationAppLaunchDetails();

  await Firebase.initializeApp();
  runApp(LocalisedApp());
}

class LocalisedApp extends StatefulWidget {
  const LocalisedApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale Locale) {
    LocalisedState state = context.findAncestorStateOfType<LocalisedState>();
    state.setLocale(Locale);
  }

  @override
  State createState() => LocalisedState();
}

class LocalisedState extends State<LocalisedApp> {
  Locale _locale;
  bool isLogin;

  @override
  void initState() {
    super.initState();
    final handler = NotificationHandler();
    handler.initialise().register();
    setLogin();
  }

  setLogin() async {
    // AppPreferences
    isLogin = await AppPreferences.getBool(IS_LOGIN);
  }

  setLocale(Locale locale) {
    setState(() {
      print('setLocale $locale');
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        print('didChangeDependencies $locale');
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        color: Colors.grey,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[800]),
          ),
        ),
      );
    }
    // wait for select language
    else {
      return MaterialApp(
        title: 'Afro Date',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: _locale,
        supportedLocales: LOCALES,
        localizationsDelegates: DELEGATES,
        localeResolutionCallback: localeCallback,
        home: isLogin ? HomeScreen() : LanguageScreen(),
        builder: (BuildContext context, Widget child) {
          return LoadingProvider(
            loadingWidgetBuilder: (context, data) => AppLoadingProvider(),
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: child,
            ),
          );
        },
      );
    }
  }

  Locale localeCallback(locale, supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      bool countryCode = supportedLocale.countryCode == locale.countryCode;
      bool languageCode = supportedLocale.languageCode == locale.languageCode;
      if (languageCode && countryCode) {
        print('localeCallback $supportedLocale');
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}

class LanguageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Choose Language'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: Language.languageList().map((language) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: ChoiceChip(
                      backgroundColor: Colors.transparent,
                      selectedColor: Colors.deepOrange[300],
                      label: Text(
                        language.name,
                        style: TextStyle(
                          color: language.name == selected
                              ? Colors.white
                              : Colors.deepOrange[300],
                        ),
                      ),
                      selected: language.name == selected,
                      onSelected: (value) {
                        setState(() {
                          selected = language.name;
                        });
                      },
                    ),
                  );

                  /*return ListTile(
              onTap: () async {
                //Locale _locale = await setLocale(language.languageCode);
                //LocalisedApp.setLocale(context, _locale);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarouselSplash(),
                  ),
                );
              },
              title: Text(
                language.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                ),
              )
              ,
            );*/
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 48),
          GFButton(
            size: 40,
            onPressed: () {
              if (selected.length > 1)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarouselSplash(),
                  ),
                );
            },
            text: getLocalized(context, 'continue'),
            padding: EdgeInsets.symmetric(horizontal: 80),
            color: selected.length > 1 ? Colors.deepOrange : Colors.grey,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class CarouselSplash extends StatefulWidget {
  @override
  State createState() => CarouselSplashState();
}

class CarouselSplashState extends State<CarouselSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GFCarousel(
                viewportFraction: 1.0,
                height: MediaQuery.of(context).size.height,
                pagination: true,
                items: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          AFRO_DATE,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Text(
                        getLocalized(context, 'splash_message'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        getLocalized(context, 'daters_growing'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 144),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          AFRO_DATE,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Text(
                        getLocalized(context, 'splash_message'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        getLocalized(context, 'daters_growing'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 144),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          AFRO_DATE,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Text(
                        getLocalized(context, 'splash_message'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        getLocalized(context, 'daters_growing'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 144),
                    ],
                  ),
                ],
                onPageChanged: (index) {
                  setState(() {
                    index;
                  });
                },
              ),
            ),
            Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: GFButton(
                    size: 45,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    color: Colors.deepOrange,
                    text: getLocalized(context, 'sign_up'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GFButton(
                    size: 45,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    color: Colors.deepOrange,
                    type: GFButtonType.outline,
                    text: getLocalized(context, 'sign_in'),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  State createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _contPassword = TextEditingController();
  final _contMobile = TextEditingController();
  final _contEmail = TextEditingController();
  bool btnVisible = false;

  void onChanged(value) {
    String password = _contPassword.text;
    String mobile = _contMobile.text;
    String email = _contEmail.text;

    setState(() {
      btnVisible = password.length > 0 && mobile.length > 0 && email.length > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          children: [
            Text(
              'Sing Up',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'It will take 30 second only',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: <Widget>[
            AppFormField(
              hintText: getLocalized(context, 'email_address'),
              keyboardType: TextInputType.emailAddress,
              controller: _contEmail,
              onChanged: onChanged,
            ),
            SizedBox(height: 18),
            AppFormField(
              hintText: getLocalized(context, 'mobile'),
              keyboardType: TextInputType.phone,
              controller: _contMobile,
              onChanged: onChanged,
            ),
            SizedBox(height: 18),
            AppFormField(
              hintText: getLocalized(context, 'password'),
              keyboardType: TextInputType.visiblePassword,
              controller: _contPassword,
              onChanged: onChanged,
            ),
            SizedBox(height: 36),
            GFButton(
              size: 40,
              onPressed: () {
                if (btnVisible)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registration(),
                    ),
                  );
              },
              text: getLocalized(context, 'continue'),
              padding: EdgeInsets.symmetric(horizontal: 80),
              color: btnVisible ? Colors.deepOrange : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _contPassword = TextEditingController();
  final _contEmail = TextEditingController();
  bool btnVisible = false;

  void onChanged(value) {
    String password = _contPassword.text;
    String email = _contEmail.text;

    setState(() {
      btnVisible = password.length > 0 && email.length > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Login',
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: <Widget>[
            AppFormField(
              hintText: getLocalized(context, 'email_address'),
              keyboardType: TextInputType.emailAddress,
              controller: _contEmail,
              onChanged: onChanged,
            ),
            SizedBox(height: 36),
            AppFormField(
              hintText: getLocalized(context, 'password'),
              keyboardType: TextInputType.visiblePassword,
              controller: _contPassword,
              onChanged: onChanged,
            ),
            SizedBox(height: 72),
            GFButton(
              size: 40,
              onPressed: () {
                if (btnVisible)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
              },
              text: getLocalized(context, 'continue'),
              padding: EdgeInsets.symmetric(horizontal: 80),
              color: btnVisible ? Colors.deepOrange : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  var _password = TextEditingController();
  var _name = TextEditingController();

  List<String> looking = ['Male', 'Female', 'Both'];
  List<String> genders = ['Male', 'Female'];

  String _looking;
  String _gender;

  File _imageFile;

  @override
  void initState() {
    super.initState();
  }

  onPressed() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GetReadyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          children: [
            Text(
              'Sing Up',
            ),
            Text(
              'Please provide following information about you',
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 72),
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(48),
                    ),
                    child: AppImage(
                      onGallery: () {
                        Navigator.of(context).pop();
                        UtilsImage.getFromGallery().then((value) => {
                              setState(() {
                                _imageFile = value;
                              })
                            });
                      },
                      onCamera: () {
                        Navigator.of(context).pop();
                        UtilsImage.getFromCamera().then((value) => {
                              setState(() {
                                _imageFile = value;
                              })
                            });
                      },
                      child: _imageFile == null
                          ? Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 96,
                            )
                          : Container(
                              width: 96,
                              height: 96,
                              child: Image.file(
                                _imageFile,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 25,
                  right: 12,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
          AppFormField(
            labelText: 'Name',
            controller: _name,
          ),
          SizedBox(height: 12),
          AppFormField(
            controller: _password,
            labelText: 'Password',
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _gender,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black87, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              labelText: 'Gender *',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            onChanged: (String value) {
              setState(() {
                _gender = value;
              });
            },
            items: genders.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _looking,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black87, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              labelText: 'Looking For *',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            onChanged: (String value) {
              setState(() {
                _looking = value;
              });
            },
            items: looking.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          AppFormField(
            labelText: 'City',
          ),
          SizedBox(height: 12),
          AppFormField(
            labelText: 'State',
          ),
          SizedBox(height: 12),
          AppFormField(
            labelText: 'Country',
          ),
          SizedBox(height: 24),
          GFButton(
            size: 40,
            onPressed: onPressed,
            text: getLocalized(context, 'continue'),
            padding: EdgeInsets.symmetric(horizontal: 80),
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }
}


class HeightScreen extends StatefulWidget {
  @override
  State createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  List<String> feet = [
    '3 FEET',
    '4 FEET',
    '5 FEET',
    '6 FEET',
    '7 FEET',
    '8 FEET',
    '9 FEET',
  ];
  List<String> inch = [
    '0 INCH',
    '1 INCH',
    '2 INCH',
    '3 INCH',
    '4 INCH',
    '5 INCH',
    '6 INCH',
    '7 INCH',
    '8 INCH',
    '9 INCH',
    '10 INCH',
    '11 INCH',
  ];

  String _feet;
  String _inch;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24, 72, 24, 72),
      shrinkWrap: true,
      children: <Widget>[
        DropdownButtonFormField<String>(
          value: _feet,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black87, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            labelText: 'Feet',
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          onChanged: (String value) {
            setState(() {
              _feet = value;
              _inch = '0 INCH';
            });
          },
          items: feet.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _inch,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black87, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Inch',
            contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          onChanged: (String value) {
            setState(() {
              _inch = value;
            });
          },
          items: inch.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class GetReadyScreen extends StatefulWidget {
  @override
  State createState() => GetReadyScreenState();
}

class GetReadyScreenState extends State<GetReadyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Image.asset(
          AFRO_DATE_LOGO,
          height: 40,
          width: 100,
          fit: BoxFit.scaleDown,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/ic_get_ready.png',
                fit: BoxFit.scaleDown,
                height: 180,
                width: 180,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  getLocalized(context, 'ready_meat'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 48),
                Text(
                  getLocalized(context, 'ready_meat_ii'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          GFButton(
            size: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressScreen(),
                ),
              );
            },
            color: Colors.deepOrange,
            text: getLocalized(context, 'continue'),
            padding: EdgeInsets.symmetric(horizontal: 60),
          ),
          SizedBox(height: 24),
          GFButton(
            size: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressScreen(),
                ),
              );
            },
            color: Colors.transparent,
            text: getLocalized(context, 'skip'),
            padding: EdgeInsets.symmetric(horizontal: 80),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<Map<String, dynamic>> list;

  const MultiSelectChip({Key key, this.list}) : super(key: key);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Wrap(
          children: widget.list.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: ChoiceChip(
                backgroundColor: Colors.transparent,
                selectedColor: Colors.deepOrange[300],
                label: Text(
                  item['value'],
                  style: TextStyle(
                    color: item['selected']
                        ? Colors.white
                        : Colors.deepOrange[300],
                  ),
                ),
                selected: item['selected'],
                onSelected: (selected) {
                  setState(() {
                    item['selected'] = selected;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProgressScreen extends StatefulWidget {
  @override
  State createState() => ProgressState();
}

class ProgressState extends State<ProgressScreen> {
  List<Map<String, dynamic>> interested = List();
  List<Map<String, dynamic>> bodyType = List();
  List<Map<String, dynamic>> ethnicity = List();
  List<Map<String, dynamic>> religion = List();
  List<Map<String, dynamic>> marital = List();
  List<Map<String, dynamic>> children = List();
  List<Map<String, dynamic>> wantChildren = List();
  List<Map<String, dynamic>> smokes = List();
  List<Map<String, dynamic>> interests = List();

  List<String> header = [
    'interested',
    'height',
    'body_type',
    'ethnicity',
    'religion',
    'marital',
    'children',
    'want_children',
    'smokes',
    'profession',
    'interests'
  ];
  List<Widget> body = List();

  int progress = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      interested.add({'value': 'Dating', 'selected': false});
      interested.add({'value': 'Activity Partner', 'selected': false});
      interested.add({'value': 'Friendship', 'selected': false});
      interested.add({'value': 'Marriage', 'selected': false});
      interested.add({'value': 'Relationship', 'selected': false});
      interested.add({'value': 'Intimate encounter', 'selected': false});

      body.add(MultiSelectChip(list: interested));

      bodyType.add({'value': 'Slender', 'selected': false});
      bodyType.add({'value': 'Athletic', 'selected': false});
      bodyType.add({'value': 'Average', 'selected': false});
      bodyType.add({'value': 'A few extra pounds', 'selected': false});
      bodyType.add({'value': 'Heavyset', 'selected': false});

      body.add(
        Expanded(
          child: HeightScreen(),
        ),
      );
      body.add(MultiSelectChip(list: bodyType));

      ethnicity.add({'value': 'White / caucasian', 'selected': false});
      ethnicity.add({'value': 'Asian', 'selected': false});
      ethnicity.add({'value': 'Black / African desent', 'selected': false});
      ethnicity.add({'value': 'East Indian', 'selected': false});
      ethnicity.add({'value': 'Latino / Hispanic', 'selected': false});
      ethnicity.add({'value': 'Middle Eastern', 'selected': false});
      ethnicity.add({'value': 'Native American', 'selected': false});
      ethnicity.add({'value': 'Pacific Islander', 'selected': false});
      ethnicity.add({'value': 'Other', 'selected': false});

      body.add(MultiSelectChip(list: ethnicity));

      religion.add({'value': 'Non-religious', 'selected': false});
      religion.add({'value': 'Agnostic', 'selected': false});
      religion.add({'value': 'Atheist', 'selected': false});
      religion.add({'value': 'Buddhist / Taoist', 'selected': false});
      religion.add({'value': 'Catholic', 'selected': false});
      religion.add({'value': 'Protestant', 'selected': false});
      religion.add({'value': 'Methodist', 'selected': false});
      religion.add({'value': 'Baptist', 'selected': false});
      religion.add({'value': 'Hindu', 'selected': false});
      religion.add({'value': 'Jewish', 'selected': false});
      religion.add({'value': 'Muslim/Islam', 'selected': false});
      religion.add({'value': 'Christian - Other', 'selected': false});
      religion.add({'value': 'Sikh', 'selected': false});
      religion.add({'value': 'Jain', 'selected': false});
      religion.add({'value': 'Parsi', 'selected': false});
      religion.add({'value': 'Inter-Religion', 'selected': false});
      religion.add({'value': 'Other', 'selected': false});

      body.add(MultiSelectChip(list: religion));

      marital.add({'value': 'Never married', 'selected': false});
      marital.add({'value': 'Divorced', 'selected': false});
      marital.add({'value': 'Separated', 'selected': false});
      marital.add({'value': 'Widowed', 'selected': false});
      marital.add({'value': 'Married', 'selected': false});

      body.add(MultiSelectChip(list: marital));

      children.add({'value': 'No', 'selected': false});
      children.add({'value': 'Yes, they live at home', 'selected': false});
      children
          .add({'value': 'Yes, they live away from home', 'selected': false});
      children.add(
          {'value': 'Yes, sometimes they live at home', 'selected': false});

      body.add(MultiSelectChip(list: children));

      wantChildren.add({'value': 'Yes', 'selected': false});
      wantChildren.add({'value': 'No', 'selected': false});
      wantChildren.add({'value': 'Undecided/Open', 'selected': false});

      body.add(MultiSelectChip(list: wantChildren));

      smokes.add({'value': 'Yes', 'selected': false});
      smokes.add({'value': 'No', 'selected': false});
      smokes.add({'value': 'Occasionally', 'selected': false});
      smokes.add({'value': 'Often', 'selected': false});

      body.add(MultiSelectChip(list: smokes));

      interests.add({'value': 'Anything outdoors', 'selected': false});
      interests.add({'value': 'Art & Museums', 'selected': false});
      interests.add({'value': 'Baseball', 'selected': false});
      interests.add({'value': 'Basketball', 'selected': false});
      interests.add({'value': 'Billiards', 'selected': false});
      interests.add({'value': 'Bowling', 'selected': false});
      interests.add({'value': 'Camping', 'selected': false});
      interests.add({'value': 'Cars', 'selected': false});
      interests.add({'value': 'Cats', 'selected': false});
      interests.add({'value': 'Concerts', 'selected': false});
      interests.add({'value': 'Cooking', 'selected': false});
      interests.add({'value': 'Crafting', 'selected': false});
      interests.add({'value': 'Cycling', 'selected': false});
      interests.add({'value': 'Dancing', 'selected': false});
      interests.add({'value': 'Dining out', 'selected': false});
      interests.add({'value': 'Dogs', 'selected': false});
      interests.add({'value': 'Fashion', 'selected': false});
      interests.add({'value': 'Fishing', 'selected': false});

      body.add(
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                AppFormField(
                  labelText: 'Profession',
                )
              ],
            ),
          ),
        ),
      );
      body.add(MultiSelectChip(list: interests));
    });
  }

  double getProgress() {
    if (0 >= progress) return 0;
    if (progress > 10) return 1;
    return progress / 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Image.asset(
          AFRO_DATE_LOGO,
          height: 40,
          width: 100,
          fit: BoxFit.scaleDown,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 12),
            child: LinearProgressIndicator(
              value: getProgress(),
            ),
          ),
          Text(
            getLocalized(context, header[progress]),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          body[progress],
          GFButton(
            size: 40,
            onPressed: () {
              if (10 > progress)
                setState(() {
                  progress += 1;
                });
              else
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
            },
            color: Colors.deepOrange,
            text: getLocalized(context, 'continue'),
            padding: EdgeInsets.symmetric(horizontal: 60),
          ),
          SizedBox(height: 24),
          GFButton(
            size: 40,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            color: Colors.transparent,
            text: getLocalized(context, 'skip'),
            padding: EdgeInsets.symmetric(horizontal: 80),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
