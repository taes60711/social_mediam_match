class UserModel {
  String uid;
  UserModel({required this.uid});
}

class LoginUser extends UserModel {
  String email;
  bool isEmailVerified;
  String? name;
  List<dynamic>? mainSkills;
  List<dynamic>? wantSkills;

  LoginUser(
      {required super.uid, required this.email, required this.isEmailVerified, this.name, this.mainSkills, this.wantSkills});

  factory LoginUser.fromMap(Map<String, dynamic> json) {
    return LoginUser(
      uid: json["uid"],
      email: json["email"],
      name: json["name"],
      isEmailVerified: json["isEmailVerified"],
      mainSkills: json["mainSkills"],
      wantSkills: json["wantSkills"],
    );
  }
}

class UpdateUser extends UserModel {
  String? email;
  String? password;
  bool? isEmailVerified;
  String? name;
  List<dynamic>? mainSkills;
  List<dynamic>? wantSkills;

  UpdateUser.signUp({required super.uid, required this.isEmailVerified, this.name, required this.email, required this.password});

  UpdateUser.update({required super.uid, this.isEmailVerified, this.name, this.password, this.mainSkills, this.wantSkills});

  Map toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'isEmailVerified': isEmailVerified,
      'name': name,
      'mainSkills': mainSkills,
      'wantSkills': wantSkills,
    };
  }
}
