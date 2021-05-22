import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils{
  static const String DATE_FORMAT = "yyyy-MM-dd";
  static const String TIME_FORMAT = "HH:mm:ss";

  static String getDateFormatted(DateTime date){
    return DateFormat(DATE_FORMAT).format(date);
  }

  static String formatDate(DateTime date){
    return DateFormat(DATE_FORMAT).format(date);
  }

  static TimeOfDay timeOfDayParser(String hms){
    return TimeOfDay(
        hour:int.parse(hms.split(":")[0]),
        minute: int.parse(hms.split(":")[1]));
  }

  static String DateTimeCustomToString(TimeOfDay timeOfDay){
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }


  static String TODCustomToString(TimeOfDay timeOfDay){
    return "${timeOfDay.hour}:${timeOfDay.minute}";
  }

  static String hmsTohm(String hms){
    return "${hms.split(":")[0]}:${hms.split(":")[1]}";
  }

  static String hmTohms(String hm){
    return "$hm:00";
  }

    static int compareToDate(DateTime date1, DateTime date2){
      if(date1.year < date2.year){
        return -1;
      }
      else if( date1.year > date2.year){
        return 1;
      }
      else if(date1.month < date2.month){
        return -1;
      }
      else if( date1.month > date2.month){
        return 1;
      }
      else return date1.day - date2.day;
    }
}