import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/theme.dart';
import 'package:client/model/objects/table_service.dart';
import 'package:client/model/support/constants.dart';
import 'package:client/model/support/date_time_utils.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';


class BookingPage extends StatefulWidget {
  final Restaurant restaurant;

  const BookingPage({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController notesController = TextEditingController();
  final List<TableService> tableServices = tableServicesTest;
  String notes = "";
  int selectedService = -1;
  int selectedTime = -1;
  int selectedNOP = -1;
  int currentStep = 0;
  DateTime selectedDate = DateTime.now();
  final int N_STEP = 4;

  next() {
    if(currentStep + 1 != N_STEP)
        goTo(currentStep + 1);
  }

  goTo(int step) {
    switch(step){
      case 2: // TimeStep
        if(selectedService == -1)
          return;
        break;
      case 3: // NOPStep
        if(selectedTime == -1)
          return;
        break;
      default:
        break;
    }
    setState(() {
      currentStep = step;
    });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.8,
      child: Stack(children: [
        Theme(
          data: ThemeData(
              primaryColor: kPrimaryColor,
              colorScheme: ColorScheme.light(primary: kPrimaryColor)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stepper(
              steps: [
                DateStep(),
                ServiceStep(),
                TimeStep(),
                NOPStep(),
              ],
              currentStep: currentStep, // STEP.date.index,
              onStepContinue: next,
              onStepCancel: cancel,
              onStepTapped: (step) => goTo(step),
              type: StepperType.vertical,
              physics: BouncingScrollPhysics(),
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                 return Row();
              },
            ),
          ),
        ),
        Visibility(
          visible: currentStep+1 == N_STEP && selectedNOP!=-1,
          child: Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                print("BOOKED");
              },
              label: Row(
                children: [
                  Text(AppLocalizations.of(context)
                      .translate("confirm")
                      .toUpperCase()),
                  Icon(LineIcons.angleRight)
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Refer step 1
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData(
                  primaryColor: kPrimaryColor,
                  colorScheme: ColorScheme.light(primary: kPrimaryColor)),
              child: child);
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        next();
      });
  }

  Step DateStep() {
    return Step(
      title: Text(currentStep <= 0
          ? AppLocalizations.of(context).translate("date").capitalize
          : "${AppLocalizations.of(context).translate("date").capitalize}: ${DateTimeUtils.getDateFormatted(selectedDate)}"),
      isActive: currentStep >= 0,
      content: TextButton(
          onPressed: () => _selectDate(context),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  DateTimeUtils.compareToDate(selectedDate, DateTime.now()) == 0
                      ? AppLocalizations.of(context)
                          .translate("today")
                          .toUpperCase()
                      : DateTimeUtils.compareToDate(selectedDate,
                                  DateTime.now().add(new Duration(days: 1))) ==
                              0
                          ? AppLocalizations.of(context)
                              .translate("tomorrow")
                              .toUpperCase()
                          : DateTimeUtils.getDateFormatted(DateTime.now()),
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.calendar_today, color: Colors.grey[800]),
              ),
            ],
          )),
    );
  }

  Step ServiceStep() {
    return Step(
      title:
      Text(
          currentStep <= 1
          ? AppLocalizations.of(context).translate("service").capitalize
          : "${AppLocalizations.of(context).translate("service").capitalize}: ${tableServices[selectedService].serviceName.capitalize}"
      ),
      isActive: currentStep >= 1,
      content: Wrap(
        direction: Axis.horizontal,
        children: List.generate(tableServices.length, (index) {
          return buildServiceChip(context, index);
        }),
      ),
    );
  }

  Widget buildServiceChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
          label: Text(
            tableServices[index].serviceName.toUpperCase(),
            style:
                TextStyle(
                    color: Colors.grey[800],
                    fontWeight: selectedService == index ? FontWeight.w900 : FontWeight.w400,
                ),
          ),
          selected: selectedService == index,
          onSelected: (bool val) {
            setState(() {
              selectedService = val ? index : -1;
              if(val) next();
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.white,
          shape: StadiumBorder(
              side: BorderSide(
                  color: Colors.grey[800],
                  width: selectedService == index ? 3 : 1))),
    );
  }

  Step TimeStep() {
    return Step(
      title: Text(currentStep <= 2
          ? AppLocalizations.of(context).translate("time").capitalize
          : "${AppLocalizations.of(context).translate("time").capitalize}: ${DateTimeUtils.hmsTohm(times[selectedTime]).toUpperCase()}"),
      isActive: currentStep >= 2,
      content: Wrap(
        direction: Axis.horizontal,
        children: List.generate(times.length, (index) {
          return buildTimeChip(context, index);
        }),
      ),
    );
  }

  Widget buildTimeChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
          label: Text(
            DateTimeUtils.hmsTohm(times[index]),
            style:
            TextStyle(
                color: Colors.grey[800],
                fontWeight: selectedTime == index ? FontWeight.w900 : FontWeight.w400,
            ),
          ),
          selected: selectedTime == index,
          onSelected: (bool val) {
            setState(() {
              selectedTime = val ? index : -1;
              if(val) next();
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.white,
          shape: StadiumBorder(
              side: BorderSide(
                  color: Colors.grey[800],
                  width: selectedTime == index ? 3 : 1))),
    );
  }

  Step NOPStep() {
    return Step(
      title: Text(currentStep <= 3
          ? AppLocalizations.of(context).translate("nop").capitalize
          : "${AppLocalizations.of(context).translate("nop").capitalize}: ${selectedNOP}"),
      isActive: currentStep >= 3,
      content: Wrap(
        direction: Axis.horizontal,
        children: List.generate(MAX_NOP, (index) {
          return buildNOPChip(context, index + 1);
        }),
      ),
    );
  }

  Widget buildNOPChip(BuildContext context, int nop) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              (nop).toString(),
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: selectedNOP == nop ? FontWeight.w900 : FontWeight.w400,
              ),
            ),
          ),
          selected: selectedNOP == nop,
          onSelected: (bool val) {
            setState(() {
              selectedNOP = val ? nop : -1;
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.white,
          shape: StadiumBorder(
              side: BorderSide(
                  color: Colors.grey[800],
                  width: selectedNOP == nop ? 3 : 1))),
    );
  }
}
