import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/home/home_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/routes.dart';
import 'package:client/UI/support/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: theme(),
      initialRoute: HomeScreen.routeName,
      routes: routes,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
