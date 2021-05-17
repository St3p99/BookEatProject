import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantsInArea extends StatefulWidget {
  const RestaurantsInArea({
    Key key,
  }) : super(key: key);

  @override
  _RestaurantsInAreaState createState() => _RestaurantsInAreaState();
}

class _RestaurantsInAreaState extends State<RestaurantsInArea> {
  List<Restaurant> result = restaurantsData;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight*0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                result.length.toString()+" "+AppLocalizations.of(context).translate("result_area"),
                style: TextStyle(color: kTextLightColor, fontWeight: FontWeight.w400),
              ),
              Expanded(
                child:ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: result.length,
                      itemBuilder: (context, index) {
                        return _buildItem(context, index);
                      }
                     ),
              )],
        ),
      ),
    );
  }
  Widget _buildItem(BuildContext context, int index){
    return Container(
        height: SizeConfig.screenHeight*0.25,
        padding: const EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: SizeConfig.screenWidth*.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)
                  ),
                  image: DecorationImage(
                    image: ExactAssetImage("assets/images/item_${result[index].category}.png"),
                    fit: BoxFit.cover
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                       color: Colors.black12,
                  )]
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: SizeConfig.screenWidth*.5,
              height: SizeConfig.screenHeight*0.18,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      spreadRadius: 1,
                      color: Colors.black12,
                    )]
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                            "${result[index].name}",
                          style: TextStyle(
                            color: kTextColor, fontWeight: FontWeight.w900
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${result[index].address} - ${result[index].category}",
                          style: TextStyle(
                              color: kTextColor, fontWeight: FontWeight.w400
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "+39 ${result[index].publicPhone}",
                        style: TextStyle(
                            color: kTextColor, fontWeight: FontWeight.w400, fontSize: 13
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: result[index].avgRating,
                        itemSize: 12,
                        itemCount: ratingItems,
                        itemBuilder: (context, index) =>
                            Icon(Icons.star, color: kPrimaryColor),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "(${result[index].nReviews})",
                        style: TextStyle(
                            color: kTextColor, fontWeight: FontWeight.w400
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
    )
    );
  }
}

