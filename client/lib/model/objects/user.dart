import 'package:client/model/managers/persistent_storage_manager.dart';
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

 @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, city: $city}';
 }

  void setUserPrefs() async{
   PersistentStorageManager persistentStorageManager = PersistentStorageManager();
   persistentStorageManager.setInt("id", id);
   persistentStorageManager.setString("email", email);
   persistentStorageManager.setString("firstName", firstName);
   persistentStorageManager.setString("lastName", lastName);
   persistentStorageManager.setString("phone", phone);
   persistentStorageManager.setString("city", city);
 }
}