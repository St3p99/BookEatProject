import 'package:client/model/support/extensions/StringCapitalization.dart';
import 'package:client/UI/behaviors/AppLocalizations.dart';
import 'package:client/UI/pages/Home.dart';
import 'package:client/UI/pages/Search.dart';
import 'package:client/UI/pages/UserRegistration.dart';
import 'package:flutter/material.dart';


class Layout extends StatefulWidget {
  final String title;


  Layout({Key key, this.title}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState(title);
}

class _LayoutState extends State<Layout> {
  String title;


  _LayoutState(String title) {
    this.title = title;
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context).translate("home").capitalize, icon: Icon(Icons.home_rounded)),
              Tab(text: AppLocalizations.of(context).translate("search").capitalize, icon: Icon(Icons.search_rounded)),
              Tab(text: AppLocalizations.of(context).translate("user").capitalize, icon: Icon(Icons.person_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Home(),
            Search(),
            UserRegistration(),
          ],
        ),
      ),
    );
  }


}
