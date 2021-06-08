import 'package:client/UI/screens/reservations/components/reservation_card.dart';
import 'package:client/model/objects/reservation.dart';
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

class ReservationsContentPage extends StatefulWidget {
  const ReservationsContentPage({
    Key key,
  }) : super(key: key);

  @override
  _ReservationsContentPageState createState() => _ReservationsContentPageState();
}

class _ReservationsContentPageState extends State<ReservationsContentPage> {
  final RefreshController _refreshController = RefreshController();
  Future<List<Reservation>> result;


  @override
  void initState() {
    _pullData();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.83,
      child: FutureBuilder<List<Reservation>>(
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
                else return _buildContent(context, snapshot.data);
            }
          },
        ),
    );
  }

  Widget _buildContent(BuildContext context, List<Reservation> reservations) {
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          _pullData();
          _refreshController.refreshCompleted();
        },
        enablePullDown: true,
        header: WaterDropHeader(
          waterDropColor: kPrimaryColor,
          completeDuration: Duration(milliseconds:500),
        ),
        child:  ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () async{
                            await Model.sharedInstance.loadRestaurantReviews(reservations[index].restaurant);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                    new DetailScreen(
                                        restaurant: reservations[index].restaurant))).then((
                                value) => setState(() {}));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: ReservationCard(reservation: reservations[index], notifyParent: () => _pullData()),
                    ));
                  }),
    );
  }

  Future<void> _pullData() async{
    List<Reservation> freshReservations = await Model.sharedInstance.getReservations(Model.sharedInstance.currentUser);
    setState(() {
      result = Future.value(freshReservations);
    });
  }

}
