import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_utilites.dart';
import 'package:social_mediam_match/components/home/userPage/my_posts.dart';
import 'package:social_mediam_match/components/home/userPage/user_profile_edit_page.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../../models/user_model.dart';

import '../../utilities/style/screen_size.dart';
import 'custom_service_page.dart';
import 'myCourse/my_courses.dart';

import 'privacy_setting.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);

    return CommonScaffold(
      type: PageType.main,
      child: Container(
        height: ScreenSize.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: ScreenSize.fitPxHeight(15)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        UserProfileEditPage().show(context);
                      },
                      child: Container(
                        height: ScreenSize.fitPxHeight(83),
                        width: ScreenSize.fitPxHeight(83),
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            UserIcon(
                              image: userData.image,
                              iconSize: ScreenSize.fitPxHeight(80),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(ScreenSize.fitPxHeight(5)),
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor98,
                                  borderRadius: BorderRadius.circular(
                                    ScreenSize.fitPxHeight(30),
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.pen,
                                  color: AppColors.whiteColor,
                                  size: ScreenSize.fontSize12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(15)),
              Container(
                width: ScreenSize.width,
                margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.fitPxHeight(10),
                  vertical: ScreenSize.fitPxHeight(10),
                ),
                decoration: BoxDecoration(
                  color: AppColors.black37,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.name ?? "",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize18,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          userData.email,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenSize.fontSize12,
                          ),
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(5)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(5)),
                              color: userData.isEmailVerified ? const Color.fromARGB(255, 68, 197, 72) : AppColors.greyColor98),
                          child: Text(
                            userData.isEmailVerified ? "已認證" : "未認證",
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: ScreenSize.fontSize12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      userData.introduction ?? "",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              Container(
                width: ScreenSize.width,
                margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.fitPxHeight(10),
                  vertical: ScreenSize.fitPxHeight(15),
                ),
                decoration: BoxDecoration(
                  color: AppColors.black37,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.briefcase,
                          color: AppColors.whiteColor,
                          size: ScreenSize.fontSize14,
                        ),
                        SizedBox(width: ScreenSize.fitPxWidth(5)),
                        Text(
                          "職業",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      userData.job ?? "",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(5)),
                    Row(
                      children: [
                        ///タイトル
                        Container(
                          padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                          margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 138, 138, 138),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            FontAwesomeIcons.reply,
                            color: AppColors.whiteColor,
                            size: ScreenSize.fitPxWidth(8),
                          ),
                        ),
                        Text(
                          "能教的技能",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(8)),

                    ///得意なスキル
                    SkillUtilites().skillBar(skills: userData.mainSkills!),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    Row(
                      children: [
                        ///タイトル
                        Container(
                          padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 123, 77),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            FontAwesomeIcons.share,
                            color: AppColors.whiteColor,
                            size: ScreenSize.fitPxWidth(8),
                          ),
                        ),
                        Text(
                          "想學的技能",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(5)),

                    ///弱いスキル
                    SkillUtilites().skillBar(skills: userData.wantSkills!),
                  ],
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(5)),
              Padding(
                padding: EdgeInsets.only(left: ScreenSize.fitPxHeight(15)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "更多功能",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(5)),
              infoBtn(
                icon: FontAwesomeIcons.solidNewspaper,
                text: "我的文章",
                onPress: () => MyPostPage().show(context),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              infoBtn(
                icon: FontAwesomeIcons.school,
                text: "技術分享",
                onPress: () => MyCoursePage().show(context),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              infoBtn(
                icon: FontAwesomeIcons.gear,
                text: "一般",
                onPress: () => PrivacySettingPage().show(context),
                ref: ref,
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              infoBtn(
                icon: Icons.question_answer,
                text: "問題回報",
                onPress: () => CustomServicePage().show(context),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(65))
            ],
          ),
        ),
      ),
    );
  }
}

/// ref 通知ドット用に
Widget infoBtn({IconData? icon, String text = "", Function? onPress, WidgetRef? ref}) {
  return MainBtn(
    onPress: () {
      if (onPress != null) {
        onPress();
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor98,
        borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(10)),
      ),
      margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.fitPxWidth(15),
        vertical: ScreenSize.fitPxWidth(5),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.whiteColor,
            size: ScreenSize.fitPxWidth(24),
          ),
          SizedBox(width: ScreenSize.fitPxWidth(10)),
          Text(
            text,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: ScreenSize.fontSize12,
            ),
          ),

          ///  通知ドット
          ref != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: ScreenSize.fitPxWidth(8), left: ScreenSize.fitPxWidth(4)),
                  child: AppCommonTools().notificationDotWidget(ref.watch(loginUserNotReadNotificationCount) != 0),
                )
              : Container()
        ],
      ),
    ),
  );
}
