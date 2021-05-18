import 'package:client/model/objects/reservation.dart';
import 'package:client/model/objects/user.dart';

class Review {
  int id;
  String foodRating;
  String serviceRating;
  String locationRating;
  // String reviewText;
  Reservation reservation;
  User user;


  Review({
    this.id,
    this.foodRating,
    this.serviceRating,
    this.locationRating,
    this.reservation,
    this.user
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      foodRating: json['foodRating'],
      serviceRating: json['serviceRating'],
      locationRating: json['locationRating'],
      reservation: json['reservation'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'foodRating': foodRating,
    'serviceRating': serviceRating,
    'locationRating': locationRating,
    'reservation': reservation,
    'user': user,
  };

  @override
  String toString() {
    return 'Review{id: $id, foodRating: $foodRating, serviceRating: $serviceRating, locationRating: $locationRating, reservation: $reservation, user: $user}';
  }
}