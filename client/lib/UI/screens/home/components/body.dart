import 'package:client/UI/screens/home/components/restaraunts_in_area.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';

import 'home_header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: getProportionateScreenWidth(10)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            RestaurantsInArea(),
            // SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
    );
  }
}
