import 'package:client/UI/screens/discover/components/restaraunts_in_area.dart';
import 'package:flutter/cupertino.dart';

import 'components/discover_header.dart';
import 'components/restaraunts_in_area.dart';

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
          DiscoverHeader(pageController: pageController),
          RestaurantsInArea(),
          // SizedBox(height: getProportionateScreenWidth(30)),
        ],
      ),
    );
  }
}
