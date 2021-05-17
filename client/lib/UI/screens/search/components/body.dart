import 'package:client/UI/screens/search/components/search_field.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            SearchField(),
            // SizedBox(height: getProportionateScreenWidth(10)),
            // Categories(),
            // SizedBox(height: getProportionateScreenWidth(30)),
            // PopularRestaurants(),
            // SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
