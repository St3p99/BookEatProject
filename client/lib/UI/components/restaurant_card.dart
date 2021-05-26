import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantCard extends StatelessWidget{
  final Restaurant restaurant;

  const RestaurantCard({
    Key key,
    @required this.restaurant,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight * 0.25,
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: SizeConfig.screenWidth * .5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        image: ExactAssetImage(
                            "assets/images/item_${restaurant.category}.png"),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        spreadRadius: 1,
                        color: Colors.black12,
                      )
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: SizeConfig.screenWidth * .6,
                height: SizeConfig.screenHeight * 0.21,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        spreadRadius: 1,
                        color: Colors.black12,
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${restaurant.name}",
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${restaurant.address}",
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "+39 ${restaurant.publicPhone}",
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    Visibility(
                      visible: restaurant.nReviews != 0,
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            rating: ((restaurant.avgFoodRating +
                                restaurant.avgLocationRating +
                                restaurant.avgServiceRating )/3),
                            itemSize: 15,
                            itemCount: ratingItems,
                            itemBuilder: (context, index) =>
                                Icon(Icons.star, color: kPrimaryColor),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Text(
                            "(${restaurant.nReviews})",
                            style: TextStyle(
                                color: kTextColor, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }



}