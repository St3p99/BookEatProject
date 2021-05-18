import 'package:client/UI/screens/search/search_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight*0.1,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left:15, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                APP_NAME,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                  onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => new SearchScreen()))
              ),
            ],
          ),
        ));
  }
}
