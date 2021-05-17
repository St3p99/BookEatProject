import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/search/search_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/UI/support/theme.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight * 0.05,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          onPressed: () { Navigator.pushNamed(context, SearchScreen.routeName); },
          child: Row(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(5))),
            Icon(Icons.search, color: kTextColor),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(5))),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).translate("search_what").capitalize,
                style: textTheme().bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
