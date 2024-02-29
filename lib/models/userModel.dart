class userModel {
  String uid;
  String name;
  String email;
  bool isEmailVerified;
  List<dynamic> mainSkills;
  List<dynamic> wantSkills;

  userModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.isEmailVerified,
      required this.mainSkills,
      required this.wantSkills});

  factory userModel.fromMap(Map<String, dynamic> json) {
    return userModel(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      isEmailVerified: json["isEmailVerified"],
      mainSkills: json["mainSkills"],
      wantSkills: json["wantSkills"],
    );
  }
}
