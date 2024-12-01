import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import 'package:social_mediam_match/components/utilities/main_button.dart';

import '../../../models/skill_model.dart';
import '../../../provider/account/signUpPage/sign_up_step_last_view_model.dart';
import '../../home/skillExChangePage/skill_utilites.dart';
import '../../utilities/endDrawers/user_skill_choice_page.dart';
import '../../utilities/inputField/label_input.dart';
import '../../utilities/inputField/mutl_input.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import '../account_main_page.dart';
import '../account_page_utilites.dart';

class SignUpStepLastPage extends BaseEndDrawer {
  @override
  bool needGestureDetectorClosePage() {
    return false;
  }

  SignUpStepLastViewModel viewModel = SignUpStepLastViewModel();

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = SignUpStepLastViewModel(ref: ref, context: context);
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
        child: Column(
      children: [
        BaseTopBar(
          backFunc: () {
            ref.read(viewModelProvider.notifier).state.resetAllData();

            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          title: "註冊(2/2)",
          rightWidget: MainBtn(
            onPress: () {
              ref.read(viewModelProvider.notifier).state.resetAllData();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ref.read(pageControllerProvider).jumpToPage(2);
            },
            title: "略過",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              UserIcon(iconSize: 100, image: viewModel.editImg),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              //アイコン選択
              MainBtn(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(20), vertical: ScreenSize.fitPxWidth(8)),
                onPress: () async {
                  await viewModel.imageChange();
                  render();
                },
                title: "選擇圖像",
              ),
              inputField(hintText: "職業", editingController: viewModel.jobController),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
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
                      iconBgColor: const Color.fromARGB(255, 138, 138, 138),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(5)),
                    SkillUtilites().skillBar(skills: viewModel.mainSkillList),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize.fitPxWidth(16)),

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
                      iconBgColor: const Color.fromARGB(255, 240, 123, 77),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(5)),
                    SkillUtilites().skillBar(skills: viewModel.wantSkillList),
                  ],
                ),
              ),

              SizedBox(height: ScreenSize.fitPxWidth(16)),

              // 自己紹介
              multiInputField(hintText: "自我介紹", editingController: viewModel.jobController),

              SizedBox(height: ScreenSize.fitPxWidth(25)),

              AccountPageUtilites().btnContainer(
                onPress: () async {
                  await viewModel.uploadProfileData();
                  ref.read(viewModelProvider.notifier).state.resetAllData();

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ref.read(pageControllerProvider).jumpToPage(2);
                },
                btnText: "完成",
              ),
            ],
          ),
        ),
      ],
    ));
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

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return LabelInput(
      controller: editingController,
      label: hintText,
      hintStyle: TextStyle(color: AppColors.greyColor98, fontSize: fs),
      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
    );
  }
}
