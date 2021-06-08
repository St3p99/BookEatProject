import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/objects/review.dart';
import 'package:client/model/objects/table_service.dart';
import 'package:client/model/objects/user.dart';

class Reservation {
  int id;
  String date;
  String startTime;
  int guests;
  bool rejected;
  User user;
  Restaurant restaurant;
  TableService tableService;
  Review review;

  Reservation({
        this.id,
        this.date,
        this.startTime,
        this.guests,
        this.rejected,
        this.user,
        this.restaurant,
        this.tableService,
        this.review,
      });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      date: json['date'],
      startTime: json['startTime'],
      guests: json['guests'],
      rejected: json['rejected'],
      user: json['user'] == null ? null : User.fromJson(json["user"]),
      restaurant: json['restaurant'] == null ? null : Restaurant.fromJson(json["restaurant"]),
      tableService: json['tableService'] == null ? null : TableService.fromJson(json["tableService"]),
      review: json['review'] == null ? null : Review.fromJson(json["review"]),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'startTime': startTime,
    'guests': guests,
    'rejected': rejected,
    'user': user == null ? null : user.toJson(),
    'restaurant': restaurant == null ? null : restaurant.toJson(),
    'tableService': tableService == null ? null : tableService.toJson(),
    'review': review == null ? null : review.toJson(),
  };

  @override
  String toString() {
    return 'Reservation{id: $id, date: $date, startTime: $startTime, guests: $guests, rejected: $rejected, user: $user, restaurant: $restaurant, tableService: $tableService, review: $review}';
  }
}
