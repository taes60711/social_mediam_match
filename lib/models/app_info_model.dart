class AppInfoModel {
  String iosVersion;
  String androidVersion;
  String testVersion;
  String androidTestVersion;

  AppInfoModel({
    this.iosVersion = "",
    this.androidVersion = "",
    this.testVersion = "",
    this.androidTestVersion = "",
  });

  factory AppInfoModel.toMap(dynamic json) {
    return AppInfoModel(
      iosVersion: json['iosVersion'],
      androidVersion: json['androidVersion'],
      testVersion: json['testVersion'],
      androidTestVersion: json['androidTestVersion'],
    );
  }
}
