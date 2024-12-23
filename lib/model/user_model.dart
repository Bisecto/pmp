class UserModel {
  String email;
  String profilePic;
  String mobilePhone;
  String username;
  String firstName;
  String lastName;

  UserModel({
    required this.email,
    required this.profilePic,
    required this.mobilePhone,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"] ?? '',
        profilePic: json["profile_pic"],
        mobilePhone: json["mobile_phone"],
        username: json["username"],
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "profile_pic": profilePic,
        "mobile_phone": mobilePhone,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
      };
}
