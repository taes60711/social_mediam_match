import 'dart:convert';

class UserModel {
  String uid;
  String? name;
  String? introduction;
  List<SkillInfo>? mainSkills;
  List<SkillInfo>? wantSkills;
  UserModel({
    required this.uid,
    this.name,
    this.introduction,
    this.mainSkills,
    this.wantSkills,
  });
}

class LoginUser extends UserModel {
  String email;
  bool isEmailVerified;
  String lastLogin;

  LoginUser({
    required String uid,
    String? name,
    String? introduction,
    required this.lastLogin,
    List<SkillInfo>? mainSkills,
    List<SkillInfo>? wantSkills,
    required this.email,
    required this.isEmailVerified,
  }) : super(
          uid: uid,
          name: name,
          introduction: introduction,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

  factory LoginUser.fromMap(Map<String, dynamic> json) {
    print("json[]: ${json["skills"]}");
    List<SkillInfo> mainSkills =
        (json["skills"] as List<dynamic>).map((e) => SkillInfo(name: e['name'], level: e['level'], month: e['month'])).toList();
    List<SkillInfo> wantSkills = (json["wantSkills"] as List<dynamic>)
        .map((e) => SkillInfo(name: e['name'], level: e['level'], month: e['month']))
        .toList();

    return LoginUser(
      uid: json["uid"],
      email: json["email"],
      name: json["name"],
      lastLogin: json['lastlogin'],
      introduction: json['introduction'],
      isEmailVerified: json["isEmailVerified"],
      mainSkills: mainSkills,
      wantSkills: wantSkills,
    );
  }
}

class UpdateUser extends UserModel {
  String? email;
  String? password;
  bool? isEmailVerified;
  String? lastLogin;

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
    String? introduction,
    List<SkillInfo>? mainSkills,
    List<SkillInfo>? wantSkills,
    this.isEmailVerified,
    this.password,
  }) : super(
          uid: uid,
          name: name,
          introduction: introduction,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );
  UpdateUser.lastTimupdate({required String uid, this.lastLogin}) : super(uid: uid);

  String updateLastLoginTimeJson() {
    return jsonEncode({
      'uid': uid,
      "lastlogin": lastLogin,
    });
  }

  Map toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'isEmailVerified': isEmailVerified,
      'name': name,
      'introduction': introduction,
      'skills': mainSkills!.map((e) => e.toJson()).toList(),
      'wantSkills': wantSkills!.map((e) => e.toJson()).toList(),
    };
  }
}

class SkillInfo {
  String name;
  int level;
  int month;

  SkillInfo({required this.name, required this.level, required this.month});

  factory SkillInfo.fromMap(Map<String, dynamic> json) {
    return SkillInfo(
      name: json["name"],
      level: json["level"],
      month: json["month"],
    );
  }

  Map toJson() {
    return {
      'name': name,
      'level': level,
      'month': month,
    };
  }
}
