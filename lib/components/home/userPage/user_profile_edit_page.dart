import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/dialog/confirm_dialog.dart';
import 'package:social_mediam_match/components/utilities/inputField/label_input.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';
import 'package:social_mediam_match/provider/account/user_profile_edit_view_model.dart';
import 'package:social_mediam_match/services/user_service.dart';
import 'package:uuid/uuid.dart';

import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/image_service.dart';
import '../../utilities/appBar/basic_top_bar.dart';
import '../../utilities/lodaing_dialog.dart';
import '../../utilities/main_button.dart';
import '../../utilities/endDrawers/user_skill_choice_page.dart';
import '../../utilities/inputField/mutl_input.dart';
import '../../utilities/user_icon.dart';
import '../skillExChangePage/skill_utilites.dart';

class UserProfileEditPage extends BaseBottomSheet {
  bool isInit = true;
  @override
  double buildHeight() {
    return 0.9;
  }

  @override
  BottomSheetPageType bottomSheetPageType() {
    return BottomSheetPageType.edit;
  }

  @override
  bool buildneedbarrerierClose() {
    return false;
  }

  UserProfileEditViewModel viewModel = UserProfileEditViewModel();

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel.init(context, ref, () => render());
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        BaseTopBar(
          leftWidget: Row(
            children: [
              MainBtn(
                  title: "關閉",
                  backgroundColor: AppColors.transparent,
                  onPress: () {
                    if (viewModel.closePageCheck()) {
                      closePage();
                    } else {
                      ConfirmDilaog(
                          title: '提示',
                          content: '正在編輯中, 確定要離開嗎？',
                          conirmFunc: () {
                            closePage();
                          }).show(context);
                    }
                  }),
            ],
          ),
          title: "個人資料",
          rightWidget: MainBtn(
            onPress: () async {
              if (viewModel.sendBeforeCheck()) {
                ProfileData updateData = ref.read(loginUserData);
                String httpImg = viewModel.editImg ?? "";

                LoadingDialog().show();

                if (viewModel.editImg != null) {
                  if (!viewModel.editImg!.contains("http") && viewModel.editImg != "") {
                    String uid = const Uuid().v1();
                    if (await ImageService().imageIsExist(viewModel.editImg ?? "") != "-1") {
                      uid = await ImageService().imageIsExist(viewModel.editImg ?? "");
                    } else {
                      await ImageService().saveImg(uid, viewModel.editImg ?? "");
                    }
                    httpImg = "http://\$ip:\$port/images/$uid";
                  }
                }

                updateData = updateData.copyWith(
                  data: ProfileData(
                    uid: updateData.uid,
                    email: updateData.email,
                    image: httpImg,
                    name: viewModel.nameController.text,
                    mainSkills: List.from(viewModel.mainSkillList),
                    wantSkills: List.from(viewModel.wantSkillList),
                    job: viewModel.jobController.text,
                    introduction: viewModel.introductionController.text,
                    isEmailVerified: updateData.isEmailVerified,
                    status: updateData.status,
                    lastLogin: updateData.lastLogin,
                  ),
                );
                UpdateUser sqlUpdateData = UpdateUser.update(
                  uid: updateData.uid,
                  name: updateData.name,
                  image: updateData.image,
                  job: updateData.job,
                  introduction: updateData.introduction,
                  mainSkills: updateData.mainSkills,
                  wantSkills: updateData.wantSkills,
                );

                await UserService().updateUserData(updateData.uid, sqlUpdateData);

                ref.read(loginUserData.notifier).update((state) => updateData);
                render();
                LoadingDialog().close();
                closePage();
                Toast().showCenter(msg: "更新成功");
              }
            },
            title: "更新",
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
              child: Column(
                children: [
                  UserIcon(iconSize: 100, image: viewModel.editImg),
                  SizedBox(height: ScreenSize.fitPxWidth(15)),
                  //アイコン選択
                  MainBtn(
                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(20), vertical: ScreenSize.fitPxWidth(8)),
                    onPress: () async {
                      await viewModel.avatarChange();
                    },
                    title: "選擇圖像",
                  ),
                  inputField(hintText: "名稱", editingController: viewModel.nameController),
                  errMsg(errMsg: viewModel.nameErrMsg),
                  inputField(hintText: "職業", editingController: viewModel.jobController),
                  SizedBox(height: ScreenSize.fitPxWidth(8)),
                  SizedBox(height: ScreenSize.fitPxWidth(8)),
                  //強いスキル設定
                  MainBtn(
                    onPress: () {
                      UserSkillChoicePage(
                        initSkillData: viewModel.mainSkillList,
                        updateSkillDate: (List<RequestUserSkillData> value) {
                          viewModel.mainSkillList = value;
                          render();
                        },
                      ).show(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        skillTitle(
                          titile: "能教的技能",
                          iconData: FontAwesomeIcons.reply,
                          iconBgColor: AppColors.greyColor138,
                        ),
                        SizedBox(height: ScreenSize.fitPxWidth(5)),
                        SkillUtilites().skillBar(skills: viewModel.mainSkillList),
                      ],
                    ),
                  ),
                  errMsg(errMsg: viewModel.skillErrMsg),
                  SizedBox(height: ScreenSize.fitPxWidth(8)),
                  //弱いスキル設定
                  MainBtn(
                    onPress: () {
                      UserSkillChoicePage(
                        initSkillData: viewModel.wantSkillList,
                        updateSkillDate: (List<RequestUserSkillData> value) {
                          viewModel.wantSkillList = value;
                          render();
                        },
                      ).show(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        skillTitle(
                          titile: "想學的技能",
                          iconData: FontAwesomeIcons.share,
                          iconBgColor: AppColors.oragneColor123,
                        ),
                        SizedBox(height: ScreenSize.fitPxWidth(5)),
                        SkillUtilites().skillBar(skills: viewModel.wantSkillList),
                      ],
                    ),
                  ),
                  errMsg(errMsg: viewModel.wantSkillErrMsg),

                  SizedBox(height: ScreenSize.fitPxWidth(8)),
                  // 自己紹介
                  multiInputField(hintText: "自我介紹", editingController: viewModel.introductionController),
                  SizedBox(height: ScreenSize.fitPxWidth(8)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget skillTitle({required Color iconBgColor, required IconData iconData, required String titile}) {
    return Row(
      children: [
        ///タイトル
        Container(
          padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            iconData,
            color: AppColors.whiteColor,
            size: ScreenSize.fitPxWidth(12),
          ),
        ),
        Text(
          titile,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: ScreenSize.fontSize18,
          ),
        ),
      ],
    );
  }

  Widget errMsg({required String errMsg}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Visibility(
        visible: errMsg != "",
        child: Text(
          errMsg,
          style: TextStyle(color: AppColors.redColor),
        ),
      ),
    );
  }

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return LabelInput(
      controller: editingController,
      label: hintText,
      hintStyle: TextStyle(color: AppColors.greyColor98, fontSize: fs),
      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
    );
  }

  Widget multiInputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(5)),
        MultInput(
          controller: viewModel.introductionController,
          hintText: hintText,
          minLines: 5,
          maxLines: 5,
          editPageMaxLines: 12,
          editPageMinLines: 12,
          hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
          inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
        ),
      ],
    );
  }
}
