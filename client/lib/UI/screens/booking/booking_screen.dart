import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/material.dart';

import 'components/booking_page.dart';

class BookingScreen extends StatelessWidget {
  final Restaurant restaurant;

  const BookingScreen({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BookingHeader(context),
            BookingPage(restaurant: restaurant),
          ],
        ),
      ),
    );
  }

  Widget BookingHeader(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.15,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    restaurant.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.black, size: 25))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${restaurant.category.toUpperCase()}",
                  style: TextStyle(
                      color: kTextColor, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
                Icon(
                  Icons.location_on,
                  color: kTextLightColor,
                ),
                Flexible(
                  child: Text("${restaurant.address.capitalizeFirstOfEach}",
                      style: TextStyle(
                          color: kTextColor, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
