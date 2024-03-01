class UserSignUpModel {
  String uid;
  String email;
  bool isEmailVerified;
  UserSignUpModel({required this.uid, required this.email, required this.isEmailVerified});
}

class UserLoginModel extends UserSignUpModel {
  String? name;
  List<dynamic>? mainSkills;
  List<dynamic>? wantSkills;
  UserLoginModel(
      {required super.uid, this.name, required super.email, required super.isEmailVerified, this.mainSkills, this.wantSkills});

  factory UserLoginModel.fromMap(Map<String, dynamic> json) {
    return UserLoginModel(
      uid: json["uid"],
      email: json["email"],
      name: json["name"],
      isEmailVerified: json["isEmailVerified"],
      mainSkills: json["mainSkills"],
      wantSkills: json["wantSkills"],
    );
  }
}
