//imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

//User entity
//User info can be stored & retrieved throughout app
class User {
  String bestFood;
  String bestMovie;
  String dob;
  String email;
  String fullName;
  String major;
  String password;
  String residenceStatus;
  String spiritAnimal;
  String studentId;
  String yearGroup;

  User({
    required this.bestFood,
    required this.bestMovie,
    required this.dob,
    required this.email,
    required this.fullName,
    required this.major,
    required this.password,
    required this.residenceStatus,
    required this.spiritAnimal,
    required this.studentId,
    required this.yearGroup,
  });

  // create a user entity from JSON data received from a GET request to the API
  factory User.createUser(Map<String, dynamic> json) {
    return User(
      bestFood: json['best_food'],
      bestMovie: json['best_movie'],
      dob: json['dob'],
      email: json['email'],
      fullName: json['full_name'],
      major: json['major'],
      password: json['password'],
      residenceStatus: json['residence_status'],
      spiritAnimal: json['spirit_animal'],
      studentId: json['student_id'],
      yearGroup: json['year_group'],
    );
  }
}

// manage state with ChangeNotifier
class UserState extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
  User? getUser() {
    return _user;
  }
}

