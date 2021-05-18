import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
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
                height: SizeConfig.screenHeight*.6,
                child: Image.asset(
                  "assets/images/item_${restaurant.category}.png",
                  fit: BoxFit.cover,
                )
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 25, top: 25),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.white)
                  )
                )
              ),
              DraggableScrollableSheet(
                initialChildSize: .5, minChildSize: .5, maxChildSize: .8,
                builder: (context, controller){
                  return SingleChildScrollView(
                    controller: controller,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:25),
                          height: SizeConfig.screenHeight*.8,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)
                            )
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Icon( Icons.drag_handle_rounded, color: Colors.black38),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child:Text(
                                          restaurant.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30
                                          ),
                                        ),
                                      ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    "${restaurant.category.toUpperCase()}",
                                    style: TextStyle(
                                        color: kTextColor, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 0),
                                    child:Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: kTextLightColor,
                                          ),
                                          Text(
                                              "${restaurant.address.capitalizeFirstOfEach}",
                                              style: TextStyle(
                                                  color: kTextColor, fontWeight: FontWeight.normal),
                                              textAlign: TextAlign.left),
                                        ],
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildWidgetRating(
                                        AppLocalizations.of(context).translate("food_rating"),
                                        restaurant.avgFoodRating ),
                                      _buildWidgetRating(
                                          AppLocalizations.of(context).translate("location_rating"),
                                          restaurant.avgLocationRating ),
                                      _buildWidgetRating(
                                          AppLocalizations.of(context).translate("service_rating"),
                                          restaurant.avgServiceRating )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                                  child: ExpandablePanel(
                                        header: Text(AppLocalizations.of(context).translate("description").toUpperCase()),
                                        collapsed: Text(restaurant.description, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                        expanded: Text(restaurant.description, softWrap: true, ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                  );
                },
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton.extended(
                  backgroundColor: kPrimaryColor,
                  onPressed: () => print('book!'),
                  label: Row(
                    children: [
                      Text(AppLocalizations.of(context).translate("book_now").toUpperCase()),
                      Icon(LineIcons.angleRight)
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  Widget _buildWidgetRating(String name, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 5.0,
          animation: true,
          animationDuration: 1000,
          percent: rating/5,
          center: Text(
            rating.toString(),
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
    );
  }


}