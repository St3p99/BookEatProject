import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/objects/table_service.dart';
import 'package:client/model/objects/user.dart';

class Reservation {
  int id;
  String date;
  String startTime;
  int nGuests;
  String notes;
  bool rejected;
  User user;
  Restaurant restaurant;
  TableService tableService;

  Reservation({
        this.id,
        this.date,
        this.startTime,
        this.nGuests,
        this.notes,
        this.rejected,
        this.user,
        this.restaurant,
        this.tableService,
      });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      date: json['date'],
      startTime: json['startTime'],
      notes: json['notes'],
      nGuests: json['nGuests'],
      rejected: json['rejected'],
      user: json['user'],
      restaurant: json['restaurant'],
      tableService: json['tableService'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'startTime': startTime,
    'nGuests': nGuests,
    'notes': notes,
    'rejected': rejected,
    'user': user,
    'restaurant': restaurant,
    'tableService': tableService,
  };

  @override
  String toString() {
    return 'Reservation{id: $id, date: $date, startTime: $startTime, nGuests: $nGuests, notes: $notes, rejected: $rejected, user: $user, restaurant: $restaurant, tableService: $tableService}';
  }
}
