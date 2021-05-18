import 'package:intl/intl.dart';

class DateTimeUtils{
  static const String DATE_FORMAT = "yyyy-MM-dd";
  static const String TIME_FORMAT = "HH:mm:ss";

  DateTime getDateNowFormatted(){
    DateFormat(DATE_FORMAT).format(DateTime.now());
  }

  DateTime formatDate(DateTime date){
    DateFormat(DATE_FORMAT).format(date);
  }

  DateTime getTimeNowFormatted(){
    DateFormat(TIME_FORMAT).format(DateTime.now());
  }

  DateTime formatTime(DateTime time){
    DateFormat(TIME_FORMAT).format(time);
  }

  // Map<String, int> dayOfWeek =  {
  //   'MONDAY': 1,
  //   'TUESDAY': 2,
  //   'WEDNESDAY': 3,
  //   'THURSDAY': 4,
  //   'FRIDAY': 5,
  //   'SATURDAY': 6,
  //   'SUNDAY': 7,
  // };


}