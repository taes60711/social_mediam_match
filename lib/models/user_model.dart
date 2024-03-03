class UserModel {
  String uid;
  String? name;
  List<dynamic>? mainSkills;
  List<dynamic>? wantSkills;
  UserModel({
    required this.uid,
    this.name,
    this.mainSkills,
    this.wantSkills,
  });
}

class LoginUser extends UserModel {
  String email;
  bool isEmailVerified;

  LoginUser({
    required String uid,
    String? name,
    List<dynamic>? mainSkills,
    List<dynamic>? wantSkills,
    required this.email,
    required this.isEmailVerified,
  }) : super(
          uid: uid,
          name: name,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

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

  UpdateUser.signUp({
    required String uid,
    String? name,
    required this.isEmailVerified,
    required this.email,
    required this.password,
  }) : super(
          uid: uid,
          name: name,
        );

  UpdateUser.update({
    required String uid,
    String? name,
    List<dynamic>? mainSkills,
    List<dynamic>? wantSkills,
    this.isEmailVerified,
    this.password,
  }) : super(
          uid: uid,
          name: name,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

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
