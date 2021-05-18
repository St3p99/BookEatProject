class User {
 int id;
 String firstName;
 String lastName;
 String phone;
 String email;


  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
  };
}