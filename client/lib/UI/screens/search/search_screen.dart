import 'package:client/UI/screens/search/components/body.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
