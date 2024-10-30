import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';

import '../../utilities/style/screen_size.dart';

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
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxHeight(25)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
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
                Row(
                  children: [
                    Text(
                      "信箱",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(5)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(5)),
                          color: userData.isEmailVerified ? Color.fromARGB(255, 68, 197, 72) : AppColors.greyColor98),
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
              ],
            ),
          ),
          SizedBox(height: ScreenSize.fitPxHeight(30)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10)),
            child: Column(
              children: [
                Row(
                  children: [
                    infoBtn(icon: FontAwesomeIcons.solidNewspaper, text: "文章"),
                    infoBtn(icon: FontAwesomeIcons.school, text: "技術分享"),
                    infoBtn(icon: FontAwesomeIcons.gear, text: "設定"),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxHeight(25)),
                Row(
                  children: [
                    infoBtn(icon: FontAwesomeIcons.solidBell, text: "通知"),
                    infoBtn(icon: Icons.question_answer, text: "問題回報"),
                    infoBtn(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget infoBtn({IconData? icon, String text = ""}) {
  return Expanded(
    child: Column(
      children: [
        icon == null
            ? Container(
                width: ScreenSize.fitPxWidth(22),
              )
            : Icon(
                icon,
                color: AppColors.whiteColor,
                size: ScreenSize.fitPxWidth(24),
              ),
        SizedBox(height: ScreenSize.fitPxWidth(10)),
        Text(
          text,
          style: TextStyle(
            color: AppColors.whiteColor.withOpacity(.8),
            fontSize: ScreenSize.fontSize12,
          ),
        ),
      ],
    ),
  );
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
                  margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(5)),
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
