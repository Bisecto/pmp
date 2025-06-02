import 'package:pim/model/property_model.dart';

class UserModel {
  final int id;
  final String email;
  final String username;
  final String mobilePhone;
  final String profilePic;
  final String firstName;
  final String lastName;
  final String? lastLogin;
  final List<Occupant> occupiedSpaces;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.mobilePhone,
    required this.profilePic,
    required this.firstName,
    required this.lastName,
    this.lastLogin,
    required this.occupiedSpaces,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']??0,
      email: json['email'] ?? '',
      username: json['username'],
      mobilePhone: json['mobile_phone'],
      profilePic: json['profile_pic'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      lastLogin: json['last_login'],
      occupiedSpaces: json['occupied_spaces'] != null
          ? List<Occupant>.from(
              json['occupied_spaces'].map((x) => Occupant.fromJson(x)))
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'mobile_phone': mobilePhone,
      'profile_pic': profilePic,
      'first_name': firstName,
      'last_name': lastName,
      'last_login': lastLogin,
      'occupied_spaces': occupiedSpaces.map((x) => x.toJson()).toList(),
    };
  }

}
