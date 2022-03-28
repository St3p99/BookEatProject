import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/reservation.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DeleteReservationHandler extends StatefulWidget {
  final Reservation reservation;
  final Function() notifyParent;

  const DeleteReservationHandler(
      {Key key, @required this.reservation, @required this.notifyParent})
      : super(key: key);

  @override
  _DeleteReservationHandlerState createState() =>
      _DeleteReservationHandlerState();
}

class _DeleteReservationHandlerState extends State<DeleteReservationHandler> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.confirm,
            backgroundColor: kSecondaryColor,
            confirmBtnColor: kPrimaryColor,
            title: AppLocalizations.of(context)
                    .translate("delete_reservation")
                    .toUpperCase() +
                "!",
            text: AppLocalizations.of(context)
                .translate("delete_reservation_text")
                .toUpperCase(),
            confirmBtnText:
                AppLocalizations.of(context).translate("yes").toUpperCase(),
            cancelBtnText: "NO",
            onConfirmBtnTap: () {
              _deleteReservation();
              widget.notifyParent();
              Navigator.pop(context);
            });
      },
      icon: Icon(LineIcons.trash, color: kSecondaryColor),
    );
  }

  void _deleteReservation() async {
    await Model.sharedInstance.deleteReservation(widget.reservation);
  }
}
