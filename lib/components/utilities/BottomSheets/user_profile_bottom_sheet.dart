import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/BottomSheets/base_bottom_sheet.dart';

import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../strings/skillExChangePage/skill_change_page_string.dart';
import '../style/screen_size.dart';
import '../style/style_config.dart';
import '../user_icon.dart';

/// AllInfo Ver
class UserProfileAllInfoBottomSheet extends BaseBottomSheet {
  final ProfileData userData;
  UserProfileAllInfoBottomSheet({required this.userData});

  @override
  Widget build(WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          UserIcon(
            image: userData.image,
            iconSize: ScreenSize.fitPxHeight(80),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userData.name ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize18,
                        ),
                      ),
                    ),
                    Text(
                      "${userData.lastLogin}${SkillChangePageString.skExChpagebeforDays}",
                      style: TextStyle(
                        color: AppColors.greyColor130,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData.email,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                Text(
                  userData.introduction ?? "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(15)),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.fitPxHeight(15),
                        vertical: ScreenSize.fitPxHeight(5),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.greyColor54,
                      ),
                      child: Text(
                        "新增好友",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
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
                SizedBox(height: ScreenSize.fitPxHeight(5)),

                ///得意なスキル
                skillBar(skills: userData.mainSkills!),
                SizedBox(height: ScreenSize.fitPxHeight(5)),

                Row(
                  children: [
                    ///タイトル
                    Container(
                      padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                      margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 123, 77),
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
                skillBar(skills: userData.wantSkills!),
                SizedBox(height: ScreenSize.fitPxHeight(15)),

                Row(
                  children: [
                    Text(
                      "信箱認證",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(10)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ScreenSize.fitPxWidth(5),
                          ),
                          color: userData.isEmailVerified ? Color.fromARGB(255, 68, 197, 72) : AppColors.greyColor98),
                      child: Text(
                        userData.isEmailVerified ? "已認證" : "未認證",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxHeight(5)),
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(15)),
        ],
      ),
    );
  }
}

Widget skillBar({required List<RequestUserSkillData> skills}) {
  return Row(
    children: [
      ///スキル
      Row(
        children: skills.isEmpty
            ? [
                Container(
                  margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                  padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.greyColor98,
                  ),
                  child: Text(
                    "暫無",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                  ),
                )
              ]
            : skills.map((e) {
                return Container(
                  margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                  padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.greyColor98,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: ScreenSize.fitPxWidth(15),
                        height: ScreenSize.fitPxWidth(15),
                        margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                        decoration: BoxDecoration(
                          color: AppColors.black37,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "${e.level}",
                            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize10),
                          ),
                        ),
                      ),
                      Text(
                        e.name,
                        style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    ],
  );
}

///
class UserProfileBottomSheet extends BaseBottomSheet {
  final ProfileData userData;
  UserProfileBottomSheet({required this.userData});

  @override
  Widget build(WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          UserIcon(
            image: userData.image,
            iconSize: ScreenSize.fitPxHeight(80),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userData.name ?? "",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize18,
                        ),
                      ),
                    ),
                    Text(
                      "${userData.lastLogin}${tr("skExChpage_beforDays")}",
                      style: TextStyle(
                        color: AppColors.greyColor130,
                        fontSize: ScreenSize.fontSize12,
                      ),
                    ),
                  ],
                ),
                Text(
                  userData.email,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                Text(
                  userData.introduction ?? "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(15)),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.fitPxHeight(15),
                        vertical: ScreenSize.fitPxHeight(5),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.greyColor54,
                      ),
                      child: Text(
                        "新增好友",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          Container(
            width: ScreenSize.width,
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxHeight(10),
              vertical: ScreenSize.fitPxHeight(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "職業",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize14,
                  ),
                ),
                Text(
                  userData.job ?? "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: ScreenSize.fontSize12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "信箱認證",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(10)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ScreenSize.fitPxWidth(5),
                          ),
                          color: userData.isEmailVerified ? Color.fromARGB(255, 68, 197, 72) : AppColors.greyColor98),
                      child: Text(
                        userData.isEmailVerified ? "已認證" : "未認證",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: ScreenSize.fontSize14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxHeight(5)),
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(15)),
        ],
      ),
    );
  }
}
