import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/reservations/components/rating_handler.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/reservation.dart';
import 'package:client/model/support/date_time_utils.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'delete_reservation_handler.dart';

enum RESERVATION_STATE { INCOMING, REJECTED, PASSED }

class ReservationCard extends StatefulWidget {
  final Function() notifyParent;
  final Reservation reservation;

  const ReservationCard(
      {Key key, @required this.reservation, @required this.notifyParent})
      : super(key: key);

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  RESERVATION_STATE state;

  @override
  void initState() {
    state = _checkState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 7,
              spreadRadius: 5,
              color: Colors.black12,
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Visibility(
                visible: state != RESERVATION_STATE.PASSED,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        state == RESERVATION_STATE.REJECTED
                            ? AppLocalizations.of(context)
                                .translate("rejected")
                                .toUpperCase()
                            : AppLocalizations.of(context)
                                .translate("incoming")
                                .toUpperCase(),
                        style: TextStyle(
                            color: getColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        textAlign: TextAlign.right,
                      ),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Icon(
                          state == RESERVATION_STATE.REJECTED
                              ? Icons.cancel_outlined
                              : Icons.arrow_back_ios_outlined,
                          color: getColor()),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 5,
                child: Visibility(
                  visible: state == RESERVATION_STATE.PASSED &&
                      widget.reservation.review == null,
                  child: RatingHandler(
                      reservation: widget.reservation,
                      notifyParent: widget.notifyParent),
                )),
            Positioned(
              bottom: 0,
              right: 5,
              child: Visibility(
                  visible: state == RESERVATION_STATE.INCOMING,
                  child: DeleteReservationHandler(
                      reservation: widget.reservation,
                      notifyParent: widget.notifyParent)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: state == RESERVATION_STATE.PASSED &&
                        widget.reservation.review != null
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            "${widget.reservation.restaurant.name}",
                            style: TextStyle(
                                color: kTextLightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    Row(
                      children: [
                        AutoSizeText(
                          "${widget.reservation.date}",
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        AutoSizeText(
                          "${DateTimeUtils.hmsTohm(widget.reservation.startTime)}",
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        AutoSizeText(
                          "${widget.reservation.guests} " +
                              AppLocalizations.of(context).translate("guests"),
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    widget.reservation.review == null
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              Divider(
                                height: 5,
                                thickness: 2,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("my_rating")
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 15, color: kTextColor))),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildWidgetRating(
                                      AppLocalizations.of(context)
                                          .translate("food_rating"),
                                      widget.reservation.review.foodRating),
                                  _buildWidgetRating(
                                      AppLocalizations.of(context)
                                          .translate("location_rating"),
                                      widget.reservation.review.locationRating),
                                  _buildWidgetRating(
                                      AppLocalizations.of(context)
                                          .translate("service_rating"),
                                      widget.reservation.review.serviceRating)
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildWidgetRating(String name, int rating) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.2,
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 5.0,
            animation: true,
            animationDuration: 3000,
            percent: rating / 5,
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
      ),
    );
  }

  Color getColor() {
    switch (state) {
      case RESERVATION_STATE.REJECTED:
        return Color(0xE6EA5D5D);
      case RESERVATION_STATE.INCOMING:
        return Color(0xE63BE38E);
      case RESERVATION_STATE.PASSED:
        return Colors.white30;
    }
  }

  int cmpDateTime() {
    DateTime dateTime = DateTimeUtils.getDateTime(
        widget.reservation.date, widget.reservation.startTime);
    return dateTime.compareTo(DateTime.now());
  }

  RESERVATION_STATE _checkState() {
    if (widget.reservation.rejected)
      return RESERVATION_STATE.REJECTED;
    else if (cmpDateTime() >= 0) {
      return RESERVATION_STATE.INCOMING;
    } else
      return RESERVATION_STATE.PASSED;
  }
}
