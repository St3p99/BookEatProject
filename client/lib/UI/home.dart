import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/discover/discover_screen.dart';
import 'package:client/UI/screens/profile/profile_screen.dart';
import 'package:client/UI/screens/reservations/reservations_screen.dart';
import 'package:client/UI/screens/search/search_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'screens/detail/detail_screen.dart';

enum NavPage { home, search, reservation, profile }

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();
  NavPage _selectedPage = NavPage.home;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children:[
            DiscoverScreen(pageController: pageController),
            SearchScreen(), ReservationsScreen(), ProfileScreen()
          ],
          controller: pageController,
          onPageChanged: (page){
            setState(() {
              _selectedPage = NavPage.values[page];
            });
          },
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }

  Widget CustomBottomNavBar() {
    return SafeArea(
      child: Container(
        height: SizeConfig.screenHeight * 0.06,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft:Radius.circular(15),
                topRight:Radius.circular(15)
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 15,
                color: Colors.black.withOpacity(0.4),
                offset: Offset(0, 10),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: GNav(
              hoverColor: kPrimaryColor.withOpacity(0.1),
              // tabActiveBorder: Border.all(color: kPrimaryColor, width: 1),
              // tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
              tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 15)], // tab button shadow
              curve: Curves.easeOutExpo,
              // tab animation curves
              duration: Duration(milliseconds: 500),
              // tab animation duration
              gap: 8,
              // the tab button gap between icon and text
              color: Colors.grey[600],
              // unselected icon color
              activeColor: kPrimaryColor,
              // selected icon and text color
              iconSize: 24,
              // tab button icon size
              // tabBackgroundColor: kPrimaryColor.withOpacity(0.1), // selected tab background color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              // navigation bar padding
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: AppLocalizations.of(context).translate("home").capitalize,
                ),
                GButton(
                  icon: LineIcons.search,
                  text: AppLocalizations.of(context).translate("search").capitalize,
                ),
                GButton(
                  icon: LineIcons.utensils,
                  text: AppLocalizations.of(context).translate("reservation").capitalize,
                ),
                GButton(
                  icon: LineIcons.user,
                  text: AppLocalizations.of(context).translate("profile").capitalize,
                ),
              ],
              selectedIndex: _selectedPage.index,
              onTabChange: (index) {
                setState(() {
                  _selectedPage = NavPage.values[index];
                });
                pageController.jumpToPage(_selectedPage.index);
              }
          ),
        ),
      ),
    );
  }
}

