import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../components/utilities/custom_button.dart';
import '../../components/utilities/style/style_config.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import 'skill_map_provider.dart';
import 'user_setting_view_provider.dart';

class UserSettingViewModel {
  BuildContext context;
  UserSettingViewModel({required this.context});

  /// ユーザ元々データ
  Future<void> init() async {
    ProfileData userData = context.read<UserProvider>().userData;

    SkillMapProvider skillProvider = context.read<SkillMapProvider>();
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();

    await skillProvider.userSkillList(userData: userData);
    userSettingViewProvider.getUserSettingData(userData);
  }

  /// 編集あるかどうかチェック
  void checkIsEdit() {
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
    ProfileData userData = context.read<UserProvider>().userData;
    bool isChange = false;

    if (userData.image != userSettingViewProvider.base64Img) {
      isChange = true;
      print("image Change");
    }
    if (userData.name != userSettingViewProvider.nameInput.text) {
      isChange = true;
      print("name Change");
    }
    if (userData.introduction != userSettingViewProvider.introductionInput.text) {
      isChange = true;
      print("introduction Change");
    }
    if (userData.job != userSettingViewProvider.jobInput.text) {
      isChange = true;
      print("job Change");
    }
    if (userSettingViewProvider.haveSkillList != userData.mainSkills) {
      isChange = true;
      print("mainSkills Change");
    }
    if (userSettingViewProvider.wantSkillList != userData.wantSkills) {
      isChange = true;
      print("wantSkills Change");
    }

    if (isChange) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(15),
              width: 150,
              height: 160,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Expanded(
                    child: Text('個人資料已經被編輯\n確認要離開?'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextBtn(
                          title: '取消',
                          titleColor: normalTextColor,
                          btnColor: hintTextColor,
                          onPress: () {
                            RouteOptions.pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextBtn(
                          title: '確認',
                          titleColor: normalTextColor,
                          btnColor: normalBgColor,
                          onPress: () {
                            RouteOptions.popUntilToHome();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      RouteOptions.pop();
    }
  }

  /// ユーザデータ更新する
  Future<void> updateUserData() async {
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
    ProfileData userData = context.read<UserProvider>().userData;

    UpdateUser updateData = UpdateUser.update(
      uid: userData.uid,
      name: userSettingViewProvider.nameInput.text,
      job: userSettingViewProvider.jobInput.text,
      introduction: userSettingViewProvider.introductionInput.text,
      mainSkills: userSettingViewProvider.haveSkillList,
      wantSkills: userSettingViewProvider.wantSkillList,
    );

    print(
        "name : ${userSettingViewProvider.nameInput.text} job : ${userSettingViewProvider.jobInput.text} introduction : ${userSettingViewProvider.introductionInput.text}");
    print("haveSkillList : ${userSettingViewProvider.haveSkillList} wantSkillList : ${userSettingViewProvider.wantSkillList}");
    print("updateData $updateData");

    await UserService().sqlUpdateUserData(userData.uid, updateData).then(
      (isSucess) async {
        if (isSucess) {
          context.read<UserProvider>().updateProfile(userData.uid, updateData);
          RouteOptions.pop();
        }
      },
    );
  }
}
