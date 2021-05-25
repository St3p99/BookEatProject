import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/home.dart';
import 'package:client/UI/screens/login/login_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/theme.dart';
import 'package:client/model/support/login_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<App> {
  bool _logged = false;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: theme(),
      home: _logged ? Home() : LoginScreen(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }

  Future<void> checkUserLoggedIn() async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    setState(() {
      _logged = userData.getString('token') != null;
    });
  }

}
