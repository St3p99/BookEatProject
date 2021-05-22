import 'package:client/model/objects/reservation.dart';
import 'package:client/model/objects/user.dart';

class Review {
  int id;
  int foodRating;
  int serviceRating;
  int locationRating;
  String reviewText;
  Reservation reservation;
  User user;


  Review({
    this.id,
    this.foodRating,
    this.serviceRating,
    this.locationRating,
    this.reviewText,
    this.reservation,
    this.user
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      foodRating: json['foodRating'],
      serviceRating: json['serviceRating'],
      locationRating: json['locationRating'],
      reviewText: json['reviewText'],
      reservation: json['reservation'] == null ? null : Reservation.fromJson(json["reservation"]),
      user: json['user'] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'foodRating': foodRating,
    'serviceRating': serviceRating,
    'locationRating': locationRating,
    'reviewText': reviewText,
    'reservation': reservation == null ? null : reservation.toJson(),
    'user': user == null ? null : user.toJson(),
  };

  @override
  String toString() {
    return 'Review{id: $id, foodRating: $foodRating, serviceRating: $serviceRating, locationRating: $locationRating, reviewText: $reviewText, reservation: $reservation, user: $user}';
  }
}