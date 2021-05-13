import 'package:client/UI/behaviors/AppLocalizations.dart';
import 'package:client/model/support/extensions/StringCapitalization.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {


  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                AppLocalizations.of(context).translate("welcome").capitalize + "!",
                style: TextStyle(
                  fontSize: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 300,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }


}
