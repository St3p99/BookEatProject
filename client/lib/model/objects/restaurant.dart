class Restaurant {
  int id;
  String name;
  String city;
  String category;
  String address;
  String publicPhone;
  String privateMail;
  String publicMail;
  int seatingCapacity;
  double avgRating;
  int nReviews;

  Restaurant({
    this.id,
    this.name,
    this.city,
    this.category,
    this.address,
    this.publicPhone,
    this.privateMail,
    this.publicMail,
    this.seatingCapacity,
    this.avgRating,
    this.nReviews
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      category: json['category'],
      address: json['address'],
      publicPhone: json['publicPhone'],
      privateMail: json['privateMail'],
      publicMail: json['publicMail'],
      seatingCapacity: json['seatingCapacity'],
      // avgRating: json['avgReview'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'city': city,
    'category': category,
    'address': address,
    'publicPhone': publicPhone,
    'privateMail': privateMail,
    'publicMail': publicMail,
    'seatingCapacity': seatingCapacity,
    // 'avgReview': avgRating,
  };

  @override
  String toString() {
    return name;
  }

}

List<Restaurant> restaurantsData = [r1, r2, r3, r4 ,r5];
Restaurant r1 = new Restaurant(
  name: "PizzAmore",
  city: "Cosenza",
  category: "pizza",
  address: "Via delle Medaglie d'oro, 81",
    publicPhone: "3815981165",
  avgRating: 4.3,
  nReviews: 142
);

Restaurant r2 = new Restaurant(
  name: "Accademia Club House",
  city: "Cosenza",
  category: "pub",
  address: "Via caloprese, 86",
    publicPhone: "3264893156",
    avgRating: 2.8,
  nReviews: 302
);

Restaurant r3 = new Restaurant(
  name: "Nu sushi",
  city: "Cosenza",
  category: "sushi",
  address: "Via Nicola Serra, 43",
    publicPhone: "3337594116",
  avgRating: 4.0,
  nReviews: 87
);

Restaurant r4 = new Restaurant(
  name: "Bar Conti",
  city: "Cosenza",
  category: "cafe",
  address: "Via Antonio Amato, 16",
    publicPhone: "3451598116",
    avgRating: 1,
    nReviews: 34
);

Restaurant r5 = new Restaurant(
  name: "Bufalo bianco",
  city: "Cosenza",
  category: "grill",
  address: "Via caloprese, 86",
    publicPhone: "3751395791",
    avgRating: 3.7,
    nReviews: 259
);