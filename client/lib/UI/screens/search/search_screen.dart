import 'package:client/UI/components/custom_bottom_nav_bar.dart';
import 'package:client/UI/screens/search/components/body.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedItem:NavState.search),
    );
  }
}
