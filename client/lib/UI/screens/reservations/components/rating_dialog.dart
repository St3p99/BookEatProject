import 'package:client/UI/support/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;
  final Color ratingColor;
  final int initialRating;
  final String submitButton;
  final Function(int) onSubmitted;
  final Function onCancelled;


  const RatingDialog({
    @required this.title,
    @required this.message,
    @required this.submitButton,
    @required this.onSubmitted,
    @required this.onCancelled,
    this.ratingColor = kPrimaryColor,
    this.initialRating = MAX_RATING,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    int _rating = initialRating;

    final _content = Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                image == null ? SizedBox.shrink() :
                Padding(
                  child: image,
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 15),
                Center(
                  child: RatingBar.builder(
                    initialRating: initialRating.toDouble(),
                    glowColor: ratingColor,
                    minRating: 1.0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) =>
                    _rating = rating.toInt(),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: ratingColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: Text(
                    submitButton,
                    style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () {
                    onSubmitted.call(_rating);
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom:30),),
        IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              onCancelled.call();
            },
          )
        ]
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: _content,
    );
  }
}
