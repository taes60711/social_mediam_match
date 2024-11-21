import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/global/shared_preference.dart';

import '../models/user_model.dart';
import '../provider/account/user_provider.dart';
import '../provider/friend/chat_ws_model.dart';
import '../services/user_service.dart';

final loginedUserUID = StateProvider<String>((ref) => "");

class UserLoginStatusController {
  static UserLoginStatusController? _instance;

  UserLoginStatusController._();

  factory UserLoginStatusController() {
    return _instance ??= UserLoginStatusController._();
  }
  late WidgetRef ref;
  late SharedPreference sharedPreference;
  late Function render;
  Future<void> init({
    required WidgetRef initRef,
    required Function initRender,
    required SharedPreference initSharedPreference,
  }) async {
    ref = initRef;
    render = initRender;

    sharedPreference = initSharedPreference;
    await loginedCheck();
  }

  bool isLogin() {
    return ref.watch(loginedUserUID) != "";
  }

  Future<void> loginedCheck() async {
    String userUID = SharedPreference().loginCheckGetuserUID();
    print("loginCheck LoginUserUID : $userUID");
    ref.read(loginedUserUID.notifier).update((state) => userUID);
    if (ref.watch(loginedUserUID) != "") {
      /// ユーザデータ取得
      ProfileData requestUserData = await UserService().requestGetUserData(userUID);

      ref.read(loginUserData.notifier).update((state) => requestUserData);

      /// チャットルームリストWS初始化
      ChatWSModel().init(ref, () => render(), userId: ref.watch(loginUserData).uid);
    }
  }

  Future<bool> login({required String userUID}) async {
    bool loginSuccess = false;

    /// ユーザデータ取得
    ProfileData requestUserData = await UserService().requestGetUserData(userUID);

    print("LoginUserUID: ${requestUserData.uid}");
    if (requestUserData.uid != "-1") {
      ref.read(loginUserData.notifier).update((state) => requestUserData);
      await sharedPreference.loginSetUserUID(userUID);
      ref.read(loginedUserUID.notifier).update((state) => userUID);

      /// チャットルームリストWSWS初期化
      ChatWSModel().init(ref, () => render(), userId: ref.watch(loginUserData).uid);
      loginSuccess = true;
    }

    render();
    return loginSuccess;
  }

  Future<void> logOut() async {
    await sharedPreference.loginOutRemoveUserUID();

    ref.read(loginedUserUID.notifier).update((state) => "");
    ref.read(loginUserData.notifier).update((state) => ProfileData());

    /// チャットルームリストWS スローズ
    ChatWSModel().closeStream();
    render();
  }
}
