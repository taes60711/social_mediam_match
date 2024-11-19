import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreference? _instance;

  SharedPreference._();

  factory SharedPreference() {
    return _instance ??= SharedPreference._();
  }

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginSetUserUID(String userId) async {
    await prefs.setString('loginUserUID', userId);
    print("sharedPreference loginSetUserUID Success: userId: $userId ");
  }

  Future<void> loginOutRemoveUserUID() async {
    await prefs.setString('loginUserUID', "");
    print("sharedPreference loginOutRemoveUserUID Success ");
  }

  String loginCheckGetuserUID() {
    String uid = "";

    uid = prefs.getString('loginUserUID') ?? "";
    print("sharedPreference loginCheckGetuserUID uid $uid");
    return uid;
  }
}
