class Product {
  int id;
  String name;
  String barCode;
  String description;


  Product({this.id, this.name, this.barCode, this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barCode: json['barCode'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'barCode': barCode,
    'description': description,
  };

  @override
  String toString() {
    return name;
  }


}