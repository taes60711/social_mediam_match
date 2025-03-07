class AppInfoModel {
  String iosVersion;
  String androidVersion;

  AppInfoModel({
    this.iosVersion = "",
    this.androidVersion = "",
  });

  factory AppInfoModel.toMap(dynamic json) {
    return AppInfoModel(
      iosVersion: json['iosVersion'],
      androidVersion: json['androidVersion'],
    );
  }
}
