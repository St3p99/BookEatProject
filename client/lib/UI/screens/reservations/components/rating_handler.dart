import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/screens/reservations/components/rating_dialog.dart';
import 'package:client/UI/screens/reservations/reservations_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/reservation.dart';
import 'package:client/model/objects/review.dart';
import 'package:client/model/support/review_response.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:page_transition/page_transition.dart';

class RatingHandler extends StatefulWidget {
  final Reservation reservation;
  final Function() notifyParent;

  const RatingHandler({
    Key key,
    @required this.reservation,
    @required this.notifyParent
  }) : super(key: key);

  @override
  _RatingHandlerState createState() => _RatingHandlerState();
}

class _RatingHandlerState extends State<RatingHandler> {
  int foodRating = MAX_RATING;
  int locationRating = MAX_RATING;
  int serviceRating = MAX_RATING;
  int currentRatingDialog = 0;
  String ratingDialogTitle = "food_rating";
  String submitButton = "next";


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: TextButton(
        onPressed: () {
          showRatingDialog();
        },
        child: AutoSizeText(
          AppLocalizations.of(context).translate("review").toUpperCase(),
          style: TextStyle(
              color: kTextLightColor,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  void showRatingDialog() {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return RatingDialog(
              title: AppLocalizations.of(context)
                  .translate(ratingDialogTitle)
                  .capitalize,
              message: AppLocalizations.of(context)
                  .translate("rating_subtitle")
                  .capitalize,
              submitButton: AppLocalizations.of(context)
                  .translate(submitButton)
                  .toUpperCase(),
              initialRating: MAX_RATING,
              onSubmitted: (rating) {
                setState(() {
                  currentRatingDialog == 0
                      ? foodRating = rating
                      : currentRatingDialog == 1
                          ? locationRating = rating
                          : serviceRating = rating;
                });
                Navigator.pop(context);
                nextDialog();
              },
              onCancelled: () => Navigator.pop(context),
              // image: const FlutterLogo(size: 100),
            );
          });
        });
  }

  void nextDialog() {
    setState(() {
      if (currentRatingDialog == 0) {
        ratingDialogTitle = "location_rating";
        currentRatingDialog++;
        showRatingDialog();
      } else if (currentRatingDialog == 1) {
        ratingDialogTitle = "service_rating";
        submitButton = "submit";
        currentRatingDialog++;
        showRatingDialog();
      } else {
        currentRatingDialog = 0;
        ratingDialogTitle = "food_rating";
        submitButton = "next";
        postReview();
      }
    });
  }

  void postReview() async {
    ReviewResponse reviewResponse = await Model.sharedInstance.newReview(
        new Review(
            foodRating: foodRating,
            locationRating: locationRating,
            serviceRating: serviceRating,
            reservation: new Reservation(id: widget.reservation.id)));
    handleResponse(reviewResponse);
  }

  void handleResponse(ReviewResponse reviewResponse) {
    switch (reviewResponse.state) {
      case REVIEW_RESPONSE_STATE.CREATED:
        {
          _successDialog();
        }
        break;
      case REVIEW_RESPONSE_STATE.ERROR_UNKNOWN:
        {
          _errorDialog("");
        }
        break;
      default:
        break;
    }
  }

  _errorDialog(String text) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        backgroundColor: kSecondaryColor,
        confirmBtnColor: kPrimaryColor,
        title:
            AppLocalizations.of(context).translate("error").toUpperCase() + "!",
        text: text);
  }

  _successDialog() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      title: AppLocalizations.of(context)
              .translate("success_title")
              .toUpperCase() +
          "!",
      text: AppLocalizations.of(context)
          .translate("review_success_text")
          .capitalize,
      backgroundColor: kSecondaryColor,
      confirmBtnColor: kPrimaryColor,
      onConfirmBtnTap: ()  {
        widget.notifyParent();
        Navigator.of(context).pop();
      }
    );
  }
}
