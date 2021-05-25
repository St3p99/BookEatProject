import 'package:shared_preferences/shared_preferences.dart';

class User {
 int id;
 String firstName;
 String lastName;
 String phone;
 String email;
 String city;


  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.city
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'city': city
  };

 void setUserPrefs() async{
   SharedPreferences userData = await SharedPreferences.getInstance();
   userData.setInt("id", id);
   userData.setString("email", email);
   userData.setString("firstName", firstName);
   userData.setString("lastName", lastName);
   userData.setString("phone", phone);
   userData.setString("city", city);
 }
}