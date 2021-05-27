import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/components/restaurant_card.dart';
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
                          child: Text(AppLocalizations.of(context).translate("no_result").capitalize+"!")
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
                    child: RestaurantCard(restaurant: restaurants[index]));
              }),
        )
      ],
    );
  }

  Future<void> _pullData() async{
    SharedPreferences userData = await SharedPreferences.getInstance();
    print(userData.toString());
    List<Restaurant> freshRestaurant = await Model.sharedInstance.searchRestaurantByCity(userData.getString("city"));
    await Model.sharedInstance.loadRestaurantReviews(freshRestaurant);
    // for(Restaurant restaurant in freshRestaurant){
    //   List<Review> freshReviews = await Model.sharedInstance.searchReviewByRestaurant(restaurant.id);
    //   restaurant.setRatings(freshReviews);
    // }
    setState(() {
      result = Future.value(freshRestaurant);
    });
  }

}
