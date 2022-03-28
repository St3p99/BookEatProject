import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/login/login_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/theme.dart';
import 'package:client/model/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale defaultLanguage = Locale("it");
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: theme(),
      navigatorKey: NavigationService.instance.navigationKey,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      home: LoginScreen(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('it', null), const Locale('en', null)],
      localeResolutionCallback: (locale, supportedLocales) {
        if (defaultLanguage != null) {
          Intl.defaultLocale = defaultLanguage.toLanguageTag();
          return defaultLanguage;
        }
        if (locale == null) {
          Intl.defaultLocale = supportedLocales.first.toLanguageTag();
          return supportedLocales.first;
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            Intl.defaultLocale = supportedLocale.toLanguageTag();
            return supportedLocale;
          }
        }
        Intl.defaultLocale = supportedLocales.first.toLanguageTag();
        return supportedLocales.first;
      },
    );
  }
}
