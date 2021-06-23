import 'package:client/model/objects/reservation.dart';

class Review {
  int id;
  int foodRating;
  int serviceRating;
  int locationRating;
  Reservation reservation;

  Review({
    this.id,
    this.foodRating,
    this.serviceRating,
    this.locationRating,
    this.reservation,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      foodRating: json['foodRating'],
      serviceRating: json['serviceRating'],
      locationRating: json['locationRating'],
      reservation: json['reservation'] == null
          ? null
          : Reservation.fromJson(json["reservation"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodRating': foodRating,
        'serviceRating': serviceRating,
        'locationRating': locationRating,
        'reservation': reservation == null ? null : reservation.toJson(),
      };

  @override
  String toString() {
    return 'Review{id: $id, foodRating: $foodRating, serviceRating: $serviceRating, locationRating: $locationRating, reservation: $reservation}';
  }
}
