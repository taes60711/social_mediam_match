import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../utilities/app_common_tools.dart';
import '../../utilities/common_scaffold.dart';
import '../../utilities/main_button.dart';
import '../../utilities/style/app_colors.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/user_icon.dart';
import '../skillExChangePage/skill_utilites.dart';
import 'about_page.dart';
import 'myCourse/my_courses.dart';
import 'my_notification_page/my_notification_page.dart';
import 'my_posts.dart';
import 'setting/privacy_setting.dart';
import 'user_profile_edit_page.dart';
import 'user_profile_share_page.dart';

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
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
                child: Row(
                  children: [
                    MainBtn(
                      onPress: () {
                        UserProfileEditPage().show(context);
                      },
                      child: Container(
                        height: ScreenSize.fitPxHeight(63),
                        width: ScreenSize.fitPxHeight(63),
                        color: AppColors.transparent,
                        child: Stack(
                          children: [
                            UserIcon(
                              image: userData.image,
                              iconSize: ScreenSize.fitPxHeight(60),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(5)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.fitPxHeight(10),
                          vertical: ScreenSize.fitPxHeight(8),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    userData.name ?? " ",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: ScreenSize.fontSize18,
                                    ),
                                  ),
                                ),
                                SizedBox(width: ScreenSize.fitPxWidth(5)),
                                MainBtn(
                                  onPress: () {
                                    UserProfileEditPage().show(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(ScreenSize.fitPxHeight(5)),
                                    decoration: BoxDecoration(
                                      color: AppColors.greyColor98,
                                      borderRadius: BorderRadius.circular(
                                        ScreenSize.fitPxHeight(20),
                                      ),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.pen,
                                      color: AppColors.whiteColor,
                                      size: ScreenSize.fontSize10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  userData.email,
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: ScreenSize.fontSize12,
                                  ),
                                ),
                                SizedBox(width: ScreenSize.fitPxWidth(10)),

                                ///シャアボタン
                                GestureDetector(
                                  onTap: () async {
                                    UserProfileSharePage().show(context);
                                  },
                                  child: Container(
                                    width: 30,
                                    alignment: Alignment.centerLeft,
                                    color: AppColors.transparent,
                                    child: Icon(
                                      FontAwesomeIcons.arrowUpRightFromSquare,
                                      color: AppColors.greyColor180A221,
                                      size: ScreenSize.fontSize14,
                                    ),
                                  ),
                                ),
                              ],
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
                      userData.introduction == "" ? "目前沒有填寫自我介紹" : userData.introduction ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: userData.introduction == "" ? AppColors.greyColor : AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(5)),
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
                      userData.job == "" ? "目前沒有填寫職業" : userData.job ?? "",
                      style: TextStyle(
                        color: userData.job == "" ? AppColors.greyColor : AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(5)),
                    Row(
                      children: [
                        ///タイトル
                        Container(
                          padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor138,
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
                            color: AppColors.oragneColor123,
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
                icon: FontAwesomeIcons.bookOpenReader,
                text: "技術分享",
                onPress: () => MyCoursePage().show(context),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              infoBtn(
                icon: Icons.notifications,
                text: "通知",
                onPress: () => MyNotificationPage().show(context),
                ref: ref,
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              infoBtn(
                icon: FontAwesomeIcons.splotch,
                text: "程度劃分",
                onPress: () => AboutPage().show(context),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(10)),
              infoBtn(
                icon: FontAwesomeIcons.gear,
                text: "一般／設定",
                onPress: () => PrivacySettingPage().show(context),
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
                  child: AppCommonTools().notificationDotWidget(ref.watch(loginUserNotReadNotificationCount) > 0),
                )
              : Container()
        ],
      ),
    ),
  );
}
