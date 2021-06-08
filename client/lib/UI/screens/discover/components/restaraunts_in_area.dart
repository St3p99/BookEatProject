import 'package:client/model/objects/user.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/components/restaurant_card.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    _pullData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.83,
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
                        child: CircularProgressIndicator()));
              }
            default:
              if (snapshot.hasError) {
                return Center(
                    child: SizedBox(
                        height: SizeConfig.screenHeight * 0.20,
                        width: SizeConfig.screenWidth * 0.70,
                        child: Text('Error: ${snapshot.error}')));
              } else
                return _buildContent(context, snapshot.data);
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Restaurant> restaurants) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        _pullData();
        _refreshController.refreshCompleted();
      },
      enablePullDown: true,
      header: WaterDropHeader(
        waterDropColor: kPrimaryColor,
        completeDuration: Duration(milliseconds: 500),
      ),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: restaurants.length + 1,
          itemBuilder: (context, index) {
            if (index == 0)
              return _buildBanner(context, restaurants.length);
            else {
              index = index - 1;
              return GestureDetector(
                  onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => new DetailScreen(
                                  restaurant: restaurants[index])))
                      .then((value) => setState(() {})),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: RestaurantCard(restaurant: restaurants[index])));
            }
          }),
    );
  }

  Widget _buildBanner(BuildContext context, int length) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
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
                      length.toString() +
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
    );
  }

  Future<void> _pullData() async {
    User currentUser = Model.sharedInstance.currentUser;
    print(currentUser.toString());
    List<Restaurant> freshRestaurant =
        await Model.sharedInstance.searchRestaurantByCity(currentUser.city);
    await Model.sharedInstance.loadRestaurantsReviews(freshRestaurant);
    setState(() {
      result = Future.value(freshRestaurant);
    });
  }


}
