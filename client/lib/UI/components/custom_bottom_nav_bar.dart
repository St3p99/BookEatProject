import 'package:client/UI/screens/home/home_screen.dart';
import 'package:client/UI/screens/search/search_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

enum NavState { home, search, reservation, profile }

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({
    Key key, @required this.selectedItem
  }) : super(key: key);

  final NavState selectedItem;

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.symmetric(horizontal: 18,vertical: 5);
    final double _gap = 10;
    final Color _iconActiveColor = kPrimaryColor;
    return Container(
      height: SizeConfig.screenHeight*0.05,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: [
            BoxShadow(
              spreadRadius: -10,
              blurRadius: 60,
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0,25),
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
        child: GNav(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 900),
          tabs: [
            GButton(
              onPressed: () => {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => new HomeScreen()))
              },
              gap: _gap,
              icon: LineIcons.home,
              iconColor: Colors.black,
              iconActiveColor: _iconActiveColor,
              text: 'Home',
              textColor: _iconActiveColor,
              backgroundColor: _iconActiveColor.withOpacity(0.2),
              iconSize: 25,
              padding: _padding,
            ),
            GButton(
              onPressed: () => {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => new SearchScreen()))
              },
              gap: _gap,
              icon: LineIcons.search,
              iconColor: Colors.black,
              iconActiveColor: _iconActiveColor,
              text: 'Search',
              textColor: _iconActiveColor,
              backgroundColor: _iconActiveColor.withOpacity(0.2),
              iconSize: 24,
              padding: _padding,
            ),
            GButton(
              onPressed: () => {
                // Navigator.push(context, CupertinoPageRoute(builder: (context) => new SearchScreen()))
              },
              gap: _gap,
              icon: LineIcons.utensils,
              iconColor: Colors.black,
              iconActiveColor: _iconActiveColor,
              text: 'Reservation',
              textColor: _iconActiveColor,
              backgroundColor: _iconActiveColor.withOpacity(0.2),
              iconSize: 24,
              padding: _padding,
            ),
            GButton(
              onPressed: () => {
                // Navigator.push(context, CupertinoPageRoute(builder: (context) => new SearchScreen()))
              },
              gap: _gap,
              icon: LineIcons.user,
              iconColor: Colors.black,
              iconActiveColor: _iconActiveColor,
              text: 'Profile',
              textColor: _iconActiveColor,
              backgroundColor: _iconActiveColor.withOpacity(0.2),
              iconSize: 24,
              padding: _padding,
            ),
          ],
          selectedIndex: selectedItem.index,
        ),
      ),
    );
  }
}
