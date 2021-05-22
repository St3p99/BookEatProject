import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Noniiiiiiii",style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
          )
          // SizedBox(height: getProportionateScreenWidth(30)),
        ],
      ),
    );
  }
}