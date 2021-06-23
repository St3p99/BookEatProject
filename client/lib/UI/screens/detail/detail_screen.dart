import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/booking/booking_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const DetailScreen({Key key, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
              height: SizeConfig.screenHeight * .6,
              child: Image.asset(
                "assets/images/item_${restaurant.category}.png",
                fit: BoxFit.cover,
              )),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: 25, top: 25),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Colors.black12,
                      )
                    ]),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              )),
          DraggableScrollableSheet(
            initialChildSize: .5,
            minChildSize: .5,
            maxChildSize: .8,
            builder: (context, controller) {
              return SingleChildScrollView(
                controller: controller,
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  height: SizeConfig.screenHeight * .75,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Icon(Icons.drag_handle_rounded,
                            color: Colors.black38),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                            restaurant.name,
                            style: TextStyle(
                                color: kTextLightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Text(
                          "${restaurant.category.toUpperCase()}",
                          style: TextStyle(
                              color: kTextColor, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: kTextLightColor,
                              ),
                              Text(
                                  "${restaurant.address.capitalizeFirstOfEach}",
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: restaurant.nReviews != 0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 30, 10),
                          child: Column(
                            children: [
                              Divider(
                                height: 5,
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildWidgetRating(
                                      AppLocalizations.of(context)
                                          .translate("food_rating"),
                                      restaurant.avgFoodRating),
                                  _buildWidgetRating(
                                      AppLocalizations.of(context)
                                          .translate("location_rating"),
                                      restaurant.avgLocationRating),
                                  _buildWidgetRating(
                                      AppLocalizations.of(context)
                                          .translate("service_rating"),
                                      restaurant.avgServiceRating)
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${restaurant.nReviews} " +
                                            AppLocalizations.of(context)
                                                .translate("reviews") +
                                            " " +
                                            AppLocalizations.of(context)
                                                .translate("on_bookit"),
                                        style:
                                            TextStyle(color: Colors.grey[800]))
                                  ]),
                              Divider(
                                height: 5,
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 20, 5),
                        child: ExpandablePanel(
                          header: Text(AppLocalizations.of(context)
                              .translate("description")
                              .toUpperCase()),
                          collapsed: Text(
                            restaurant.description,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          expanded: Text(
                            restaurant.description,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              backgroundColor: kPrimaryColor,
              onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => new BookingScreen(
                            restaurant: restaurant,
                          ))),
              label: Row(
                children: [
                  Text(AppLocalizations.of(context)
                      .translate("book_now")
                      .toUpperCase()),
                  Icon(LineIcons.angleRight)
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildWidgetRating(String name, double rating) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 5.0,
            animation: true,
            animationDuration: 3000,
            percent: (rating / MAX_RATING),
            center: Text(
              rating.toStringAsFixed(1),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name.capitalize,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: kPrimaryColor,
          )
        ],
      ),
    );
  }
}
