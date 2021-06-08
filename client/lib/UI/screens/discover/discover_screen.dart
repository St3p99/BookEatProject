import 'package:client/UI/screens/discover/components/restaraunts_in_area.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home.dart';


class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          DiscoverHeader(context),
          SizedBox(height: 1),
          RestaurantsInArea(),
          // SizedBox(height: getProportionateScreenWidth(30)),
        ],
      ),
    );
  }

  Widget DiscoverHeader(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight*0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 5,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          ],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:15, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                APP_NAME,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        )
    );
  }
}
