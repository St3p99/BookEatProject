import 'package:client/model/objects/restaurant.dart';
import 'package:flutter/material.dart';

class TableService {
  int id;
  String serviceName;
  List<dynamic> daysOfWeek;
  String startTime;
  String endTime;
  int avgMealDuration;
  Restaurant restaurant;


  TableService({
    this.id,
    this.serviceName,
    this.daysOfWeek,
    this.startTime,
    this.endTime,
    this.avgMealDuration,
    this.restaurant
  });

  factory TableService.fromJson(Map<String, dynamic> json) {
    return TableService(
      id: json['id'],
      serviceName: json['serviceName'],
      daysOfWeek: json['daysOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      avgMealDuration: json['avgMealDuration'],
      restaurant: json['restaurant'] == null ? null : Restaurant.fromJson(json["restaurant"]),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'serviceName': serviceName,
        'startTime': startTime,
        'daysOfWeek': daysOfWeek,
        'endTime': endTime,
        'avgMealDuration': avgMealDuration,
        'restaurant': restaurant == null ? null : restaurant.toJson(),
      };

  @override
  String toString() {
    return 'TableService{id: $id, serviceName: $serviceName, daysOfWeek: $daysOfWeek, startTime: $startTime, endTime: $endTime, avgMealDuration: $avgMealDuration, restaurant: $restaurant}';
  }
}