import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/search/search_screen.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
