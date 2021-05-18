import 'package:client/UI/components/custom_bottom_nav_bar.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedItem:NavState.home),
    );
  }
}
