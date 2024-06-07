import 'dart:convert';

import 'package:social_mediam_match/models/skill_model.dart';

class UserModel {
  String uid;
  String? image;
  String? token;
  String? name;
  String? job;
  String? introduction;
  List<RequestUserSkillData>? mainSkills;
  List<RequestUserSkillData>? wantSkills;
  UserModel({
    required this.uid,
    this.image,
    this.token,
    this.name,
    this.job,
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
    String? job,
    String? introduction,
    required this.lastLogin,
    List<RequestUserSkillData>? mainSkills,
    List<RequestUserSkillData>? wantSkills,
    required this.email,
    required this.isEmailVerified,
    required this.status,
  }) : super(
          uid: uid,
          image: image,
          token: token,
          name: name,
          job: job,
          introduction: introduction,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

  factory LoginUser.toModel(Map<String, dynamic> json) {
    //Map<String, dynamic> or dynamic
    List<RequestUserSkillData> mainSkills = (json["skills"] as List<dynamic>)
        .map((e) => RequestUserSkillData(name: e['name'], level: e['level'], month: e['month']))
        .toList();
    List<RequestUserSkillData> wantSkills = (json["wantSkills"] as List<dynamic>)
        .map((e) => RequestUserSkillData(name: e['name'], level: e['level'], month: e['month']))
        .toList();

    String formattedTime = "";
    if (json['lastlogin'] != null) {
      DateTime dateUtc = DateTime.parse(json['lastlogin']).toUtc();
      Duration duration = DateTime.now().toUtc().difference(dateUtc);
      String durationTime = "";
      if (duration.inMinutes < 60) {
        durationTime = "${duration.inMinutes} 分";
      } else if (duration.inMinutes >= 60 && duration.inMinutes < 1440) {
        durationTime = "${duration.inHours} 時";
      } else if (duration.inMinutes >= 1440) {
        durationTime = "${duration.inDays} 天";
      }
      formattedTime = durationTime;
    }

    return LoginUser(
      uid: json["uid"],
      image: json["image"],
      token: json["token"],
      email: json["email"],
      name: json["name"],
      job: json["job"],
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

  String signUpFormJson() {
    return jsonEncode({
      'uid': uid,
      "email": email,
      "password": password,
      "isEmailVerified": isEmailVerified,
    });
  }

  UpdateUser.update({
    required String uid,
    String? image,
    String? name,
    String? job,
    String? introduction,
    List<RequestUserSkillData>? mainSkills,
    List<RequestUserSkillData>? wantSkills,
    this.isEmailVerified,
    this.password,
  }) : super(
          uid: uid,
          image: image,
          name: name,
          job: job,
          introduction: introduction,
          mainSkills: mainSkills,
          wantSkills: wantSkills,
        );

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'image': image,
      'email': email,
      'password': password,
      'isEmailVerified': isEmailVerified,
      'name': name,
      'job': job,
      'introduction': introduction,
      'skills': mainSkills!.map((e) => e.toMap()).toList(),
      'wantSkills': wantSkills!.map((e) => e.toMap()).toList(),
    };
  }
}
