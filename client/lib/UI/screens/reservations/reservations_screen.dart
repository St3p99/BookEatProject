import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home.dart';
import 'components/reservations_content_page.dart';


class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          ReservationsHeader(context),
          SizedBox(height: 1),
          ReservationsContentPage(),
          // SizedBox(height: getProportionateScreenWidth(30)),
        ],
      ),
    );
  }

  Widget ReservationsHeader(BuildContext context) {
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
                AppLocalizations.of(context).translate("my_reservations").toUpperCase(),
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        )
    );
  }
}

