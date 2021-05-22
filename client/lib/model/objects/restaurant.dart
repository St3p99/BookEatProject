import 'package:client/model/objects/review.dart';
import 'package:client/model/objects/table_service.dart';

class Restaurant {
  int id;
  String name;
  String city;
  String category;
  String address;
  String publicPhone;
  String privateMail;
  String publicMail;
  String description;
  int seatingCapacity;
  int nReviews;
  double avgFoodRating = -1;
  double avgServiceRating = -1;
  double avgLocationRating = -1;

  Restaurant(
      {this.id,
      this.name,
      this.city,
      this.category,
      this.address,
      this.description,
      this.publicPhone,
      this.privateMail,
      this.publicMail,
      this.seatingCapacity,
      this.nReviews=0,
      this.avgFoodRating=-1,
      this.avgServiceRating=-1,
      this.avgLocationRating=-1,
      });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      category: json['category'],
      address: json['address'],
      description: json['description'],
      publicPhone: json['publicPhone'],
      privateMail: json['privateMail'],
      publicMail: json['publicMail'],
      seatingCapacity: json['seatingCapacity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'category': category,
        'address': address,
        'description': description,
        'publicPhone': publicPhone,
        'privateMail': privateMail,
        'publicMail': publicMail,
        'seatingCapacity': seatingCapacity,
      };

  void setRatings(List<Review> reviews){
    this.nReviews = reviews.length;
    this.avgFoodRating = 0; this.avgServiceRating = 0; this.avgLocationRating = 0;
    for( int i = 0; i < reviews.length; i++ ){
      this.avgFoodRating += reviews[i].foodRating;
      this.avgServiceRating += reviews[i].serviceRating;
      this.avgLocationRating += reviews[i].locationRating;
    }
    if(reviews.length != 0){
      this.avgFoodRating = this.avgFoodRating/reviews.length;
      this.avgServiceRating = this.avgFoodRating/reviews.length;
      this.avgFoodRating = this.avgFoodRating/reviews.length;
    }
  }

  @override
  String toString() {
    return name;
  }
}

List<Restaurant> restaurantsData = [pizzAmore, accademia, nuSushi, barConti, bufaloBianco];
Restaurant pizzAmore = new Restaurant(
    name: "PizzAmore",
    city: "Cosenza",
    category: "pizza",
    address: "Via delle Medaglie d'oro, 81",
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    publicPhone: "3815981165",
    nReviews: 142,
    avgServiceRating: 4.7,
    avgLocationRating: 4.5,
    avgFoodRating: 4.3
);

List<TableService> tableServicesTest = [
  new TableService(
    serviceName: "pranzo",
    daysOfWeek: [
      'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
    ],
    startTime: "12:00:00",
    endTime: "14:30:00",
    avgMealDuration: 60,
    restaurant: pizzAmore
  ),
  new TableService(
      serviceName: "cena",
      daysOfWeek: [
        'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY',
      ],
      startTime: "19:00:00",
      endTime: "22:30:00",
      avgMealDuration: 90,
      restaurant: pizzAmore
  ),
  new TableService(
      serviceName: "pranzo",
      daysOfWeek: [
        'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
      ],
      startTime: "12:00:00",
      endTime: "14:30:00",
      avgMealDuration: 60,
      restaurant: pizzAmore
  ),
  new TableService(
      serviceName: "cena",
      daysOfWeek: [
        'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY',
      ],
      startTime: "19:00:00",
      endTime: "22:30:00",
      avgMealDuration: 90,
      restaurant: pizzAmore
  ),  new TableService(
      serviceName: "pranzo",
      daysOfWeek: [
        'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
      ],
      startTime: "12:00:00",
      endTime: "14:30:00",
      avgMealDuration: 60,
      restaurant: pizzAmore
  ),
  new TableService(
      serviceName: "cena",
      daysOfWeek: [
        'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY',
      ],
      startTime: "19:00:00",
      endTime: "22:30:00",
      avgMealDuration: 90,
      restaurant: pizzAmore
  ),
];

List<String> times = ["12:00:00", "12:30:00", "13:00:00", "13:30:00", "14:00:00", "14:30:00"];


Restaurant accademia = new Restaurant(
    name: "Accademia Club House",
    city: "Cosenza",
    category: "pub",
    address: "Via caloprese, 86",
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    publicPhone: "3264893156",
    nReviews: 302,
    avgServiceRating: 3.7,
    avgLocationRating: 4.1,
    avgFoodRating: 3.3
);


Restaurant nuSushi = new Restaurant(
    name: "Nu sushi",
    city: "Cosenza",
    category: "sushi",
    address: "Via Nicola Serra, 43",
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    publicPhone: "3337594116",
    nReviews: 87,
    avgServiceRating: 2.7,
    avgLocationRating: 3.6,
    avgFoodRating: 3.8
);

Restaurant barConti = new Restaurant(
    name: "Bar Conti",
    city: "Cosenza",
    category: "cafe",
    address: "Via Antonio Amato, 16",
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    publicPhone: "3451598116",
    nReviews: 34,
    avgServiceRating: 1.7,
    avgLocationRating: 2.1,
    avgFoodRating: 1.3
);

Restaurant bufaloBianco = new Restaurant(
    name: "Bufalo bianco",
    city: "Cosenza",
    category: "grill",
    address: "Via caloprese, 86",
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    publicPhone: "3751395791",
    nReviews: 259,
    avgServiceRating: 2.7,
    avgLocationRating: 4.1,
    avgFoodRating: 3.3
);
