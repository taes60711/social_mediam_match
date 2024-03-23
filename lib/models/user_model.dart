import 'dart:convert';

import 'package:intl/intl.dart';

class UserModel {
  String uid;
  String? image;
  String? token;
  String? name;
  String? introduction;
  List<SkillInfo>? mainSkills;
  List<SkillInfo>? wantSkills;
  UserModel({
    required this.uid,
    this.image,
    this.token,
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
  int status;

  LoginUser({
    required String uid,
    String? image,
    String? token,
    String? name,
    String? introduction,
    required this.lastLogin,
    List<SkillInfo>? mainSkills,
    List<SkillInfo>? wantSkills,
    required this.email,
    required this.isEmailVerified,
    required this.status,
  }) : super(
          uid: uid,
          image: image,
          token: token,
          name: name,
          introduction: introduction,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

  factory LoginUser.jsonToModel(dynamic json) {
    //Map<String, dynamic> or dynamic
    List<SkillInfo> mainSkills =
        (json["skills"] as List<dynamic>).map((e) => SkillInfo(name: e['name'], level: e['level'], month: e['month'])).toList();
    List<SkillInfo> wantSkills = (json["wantSkills"] as List<dynamic>)
        .map((e) => SkillInfo(name: e['name'], level: e['level'], month: e['month']))
        .toList();

    DateTime dateUtc = DateTime.parse(json['lastlogin']).toUtc();
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
    String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

    return LoginUser(
      uid: json["uid"],
      image: json["image"],
      token: json["token"],
      email: json["email"],
      name: json["name"],
      lastLogin: formattedTime,
      status: json['status'],
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
    String? image,
    String? name,
    String? introduction,
    List<SkillInfo>? mainSkills,
    List<SkillInfo>? wantSkills,
    this.isEmailVerified,
    this.password,
  }) : super(
          uid: uid,
          image: image,
          name: name,
          introduction: introduction,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

  UpdateUser.updateToken({
    required String uid,
    String? token,
  }) : super(
          uid: uid,
          token: token,
        );

  String updateupdateTokenJson() {
    return jsonEncode({
      'uid': uid,
      "token": token,
    });
  }

  UpdateUser.lastTimupdate({
    required String uid,
    this.lastLogin,
  }) : super(
          uid: uid,
        );

  String updateLastLoginTimeJson() {
    return jsonEncode({
      'uid': uid,
      "lastlogin": lastLogin,
    });
  }

  Map toJson() {
    return {
      'uid': uid,
      'image': image,
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
