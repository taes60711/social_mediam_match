import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/services/black_list_service.dart';

import '../../../../../models/BlockUser_model.dart';
import '../../../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../../../utilities/apiListView/api_list_controller.dart';
import '../../../../utilities/bottomSheets/user_profile_bottom_sheet.dart';

class BlockUserManagerBtmSheet extends BaseBottomSheet {
  StateNotifierProvider<APIListControllerNotifier<BlockUser>, APIListController<BlockUser>> listController;

  int dataIndex;
  BlockUserManagerBtmSheet(this.listController, {required this.dataIndex});

  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxWidth(10)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.user,
            text: "用戶詳細",
            onPress: () {
              UserProfileAllInfoBottomSheet(
                userData: ref.read(listController).listData[dataIndex].userInfo,
              ).show(context);
            },
          ),
          SizedBox(height: ScreenSize.fitPxWidth(15)),
          managerPageMainBtn(
            iconData: FontAwesomeIcons.trash,
            text: "移除黑名單",
            onPress: () {
              ConfirmDilaog(
                title: "提示",
                content: "確定要移除該用戶?",
                conirmFunc: () async {
                  ProfileData myData = ref.read(loginUserData.notifier).state;
                  ProfileData blockedUserData = ref.read(listController).listData[dataIndex].userInfo;
                  bool isSucess = await BlackListService().deleteBlackUserFromList(
                    uid: myData.uid,
                    blockUID: blockedUserData.uid,
                  );
                  if (isSucess) {
                    ref.read(listController.notifier).removeData(dataIndex);
                    render();
                    closePage();
                  }
                },
              ).show(context);
            },
          ),
        ],
      ),
    );
  }

  Widget managerPageMainBtn({required IconData iconData, required String text, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(20),
          vertical: ScreenSize.fitPxWidth(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxWidth(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.greyColor54,
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize14,
            ),
            SizedBox(width: ScreenSize.fitPxWidth(10)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
