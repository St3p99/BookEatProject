import 'package:flutter/material.dart';


class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const CircularIconButton({Key key, this.icon, this.onPressed}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        fillColor: Theme.of(context).primaryColor,
        child: Icon(icon, color: Theme.of(context).backgroundColor),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      )
    );
  }


}