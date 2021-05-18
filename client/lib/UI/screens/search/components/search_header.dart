import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight*0.1,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(
              AppLocalizations.of(context).translate("search").capitalize,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 35,
                fontWeight: FontWeight.w800,
              )
            )],
            ),
          ),
        );
  }
}