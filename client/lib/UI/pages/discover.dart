import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Discover extends StatefulWidget {
  final String title;

  Discover({Key key, this.title}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState(title);
}

class _DiscoverState extends State<Discover> {
  String _title;

  bool _pinned = true;
  bool _snap = false;
  bool _floating = true;
  double _expandedHeight = 200;

  _DiscoverState(String title) {
    this._title = title;
  }

  // SliverAppBar is declared in Scaffold.body, in slivers of a
  // CustomScrollView.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                height: 300,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user_avatar/default_man.png',),
                      minRadius: 100,
                    ),
                    Text(
                        "Stefano Perna",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        )
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text(
                        "Cosenza, CS",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        )
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              pinned: this._pinned,
              snap: this._snap,
              floating: this._floating,
              expandedHeight: this._expandedHeight,
              flexibleSpace: FlexibleSearchBar()
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Container( height: 1000000 ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget FlexibleSearchBar() {
    return FlexibleSpaceBar(
      background: Column(
        children: <Widget>[
          SizedBox(height: 90.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Container(
            height: 100,
            width: double.infinity,
            child: Column(
              children: [
                CustomTextField("search_what", Icons.search),
                Padding(
                    padding: EdgeInsets.only(top:10)
                ),
                CustomTextField("search_where", Icons.map)
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }


  Widget CustomTextField(String keyText, IconData icon){
    return CupertinoTextField(
      keyboardType: TextInputType.text,
      placeholder: AppLocalizations.of(context).translate(keyText).capitalize,
      placeholderStyle: TextStyle(
        color: Color(0xffC4C6CC),
        fontSize: 15.0,
      ),
      prefix: Padding(
        padding:
        const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
        child: Icon(
          icon,
          color: Color(0xffC4C6CC),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffF0F1F5),
      ),
    );
  }
}