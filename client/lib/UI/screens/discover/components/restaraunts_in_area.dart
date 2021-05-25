import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/objects/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../detail/detail_screen.dart';

class RestaurantsInArea extends StatefulWidget {
  const RestaurantsInArea({
    Key key,
  }) : super(key: key);

  @override
  _RestaurantsInAreaState createState() => _RestaurantsInAreaState();
}

class _RestaurantsInAreaState extends State<RestaurantsInArea> {
  final RefreshController _refreshController = RefreshController();
  Future<List<Restaurant>> result;


  @override
  void initState() {
    super.initState();
    _pullData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight * 0.79,
        child: FutureBuilder<List<Restaurant>>(
          future: result,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                {
                  return Center(
                      child: SizedBox(
                          height: SizeConfig.screenHeight * 0.05,
                          width: SizeConfig.screenHeight * 0.05,
                          child: CircularProgressIndicator()
                      )
                  );
                }
              default:
                if (snapshot.hasError){
                  return Center(
                      child: SizedBox(
                          height: SizeConfig.screenHeight * 0.20,
                          width: SizeConfig.screenWidth * 0.70,
                          child: Text('Error: ${snapshot.error}')
                      )
                  );
                }
                else if (snapshot.data.isEmpty){
                  return Center(
                      child: SizedBox(
                          height: SizeConfig.screenHeight * 0.10,
                          width: SizeConfig.screenHeight * 0.10,
                          child: Text("NO RESULT!")
                      )
                  );
                }
                else return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: () async {
                        _pullData();
                        _refreshController.refreshCompleted();
                      },
                      enablePullDown: true,
                      header: WaterDropHeader(
                        completeDuration: Duration(milliseconds:500),
                      ),
                      child: _buildContent(context, snapshot.data)
                  );
            }
          },
        ),
    );
  }

  Widget _buildContent(BuildContext context, List<Restaurant> restaurants) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              color: Colors.black12,
            )
          ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                    Icons.location_on,
                    color: kTextLightColor,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate("discover")
                        .toUpperCase(),
                    style: TextStyle(
                        color: kTextLightColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    "  " +
                        restaurants.length.toString() +
                        " " +
                        AppLocalizations.of(context).translate("result_area"),
                    style: TextStyle(
                        color: kTextLightColor, fontWeight: FontWeight.w400),
                  ),
                ]),
              ],
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.only(bottom: 5)),
        Expanded(
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () =>
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                new DetailScreen(
                                    restaurant: restaurants[index]))).then((
                            value) => setState(() {})),
                    child: _buildItem(context, restaurants[index]));
              }),
        )
      ],
    );
  }

  Widget _buildItem(BuildContext context, Restaurant restaurant) {
    return Container(
        height: SizeConfig.screenHeight * 0.3,
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
                height: SizeConfig.screenHeight * 0.25,
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

  Future<void> _pullData() async{
    SharedPreferences userData = await SharedPreferences.getInstance();
    print(userData.toString());
    List<Restaurant> freshRestaurant = await Model.sharedInstance.searchRestaurantByCity(userData.getString("city"));
    for(Restaurant restaurant in freshRestaurant){
      List<Review> freshReviews = await Model.sharedInstance.searchReviewByRestaurant(restaurant.id);
      restaurant.setRatings(freshReviews);
    }
    setState(() {
      result = Future.value(freshRestaurant);
    });
  }

}
