import 'package:client/UI/screens/discover/components/restaraunts_in_area.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home.dart';


class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    Key key,
    @required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          DiscoverHeader(context),
          RestaurantsInArea(),
          // SizedBox(height: getProportionateScreenWidth(30)),
        ],
      ),
    );
  }

  Widget DiscoverHeader(BuildContext context) {
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
                  onPressed: () => pageController.jumpToPage(NavPage.search.index)
              ),
            ],
          ),
        )
    );
  }
}
