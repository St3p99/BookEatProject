import 'package:client/UI/support/size_config.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/search/search_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight*0.05,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
            AppLocalizations.of(context).translate("discover").capitalize,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 30,
                fontWeight: FontWeight.w800),
            ),
            IconButton(
              icon: Icon(Icons.search, color: kPrimaryColor),
              onPressed: () => Navigator.pushNamed(context, SearchScreen.routeName)
            ),
          ],
        ),
      )
    );
  }



}