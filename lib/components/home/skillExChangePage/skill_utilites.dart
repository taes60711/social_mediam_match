import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/enum/date_format_utilities.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../models/skill_model.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';

import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';

class SkillUtilites {
  Widget noDataBuilder() {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.height,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(8)),
              child: Icon(
                FontAwesomeIcons.userSlash,
                size: 50,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            Text(
              "沒有使用者",
              style: TextStyle(
                fontSize: ScreenSize.fontSize20,
                color: AppColors.greyColor130,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget skillUserChangeContent(BuildContext context, {required ProfileData data}) {
    return MainBtn(
      onPress: () {
        UserProfileAllInfoBottomSheet(userData: data).show(context);
      },
      child: Container(
        width: ScreenSize.width,
        decoration: BoxDecoration(
            color: AppColors.black37,
            borderRadius: BorderRadius.circular(
              ScreenSize.fitPxWidth(15),
            )),
        margin: EdgeInsets.only(
          left: ScreenSize.fitPxHeight(10),
          right: ScreenSize.fitPxHeight(10),
          top: ScreenSize.fitPxHeight(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.fitPxHeight(8),
          horizontal: ScreenSize.fitPxHeight(15),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserIcon(
                  iconSize: ScreenSize.fitPxWidth(55),
                  image: data.image,
                  borderRadius: 15,
                ),
                SizedBox(width: ScreenSize.fitPxWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data.name ?? "",
                            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(5)),
                          Visibility(
                            visible: data.job != null,
                            child: Icon(
                              FontAwesomeIcons.briefcase,
                              color: AppColors.greyColor130,
                              size: ScreenSize.fontSize12,
                            ),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(2)),
                          Text(
                            data.job ?? "",
                            style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                          ),
                        ],
                      ),
                      Text(
                        data.introduction ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormatUtilities().noYYYYMMDDformat(data.lastLogin),
                  style: TextStyle(color: AppColors.greyColor176, fontSize: ScreenSize.fontSize10),
                ),
              ],
            ),

            SizedBox(height: ScreenSize.fitPxHeight(5)),

            ///得意なスキル
            Row(
              children: [
                ///タイトル
                Container(
                  padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                  margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 138, 138, 138),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.reply,
                    color: AppColors.whiteColor,
                    size: ScreenSize.fitPxWidth(8),
                  ),
                ),

                ///スキル
                SkillUtilites().skillBar(skills: data.mainSkills!),
              ],
            ),

            SizedBox(height: ScreenSize.fitPxHeight(3)),

            ///弱いスキル
            Row(
              children: [
                ///タイトル
                Container(
                  padding: EdgeInsets.all(ScreenSize.fitPxWidth(4)),
                  margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 123, 77),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.share,
                    color: AppColors.whiteColor,
                    size: ScreenSize.fitPxWidth(8),
                  ),
                ),

                ///スキル
                SkillUtilites().skillBar(skills: data.wantSkills!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget skillBar({required List<RequestUserSkillData> skills}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
                    List<Map<String, Color>> levelColor = [
                      {"textColor": const Color(0xFF000000), "bgColor": const Color(0xFFE0E0E0)},
                      {"textColor": const Color(0xFF191919), "bgColor": const Color(0xFFDDDBDB)},
                      {"textColor": const Color(0xFF1F1E1E), "bgColor": const Color(0xFFADACAC)},
                      {"textColor": const Color(0xFFFFFFFF), "bgColor": const Color(0xFF3C3C3C)},
                      {"textColor": const Color(0xFFFFFFFF), "bgColor": const Color(0xFF212121)}
                    ];

                    return Container(
                      margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.greyColor98,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenSize.fitPxWidth(15),
                            height: ScreenSize.fitPxWidth(15),
                            margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                            decoration: BoxDecoration(
                              color: levelColor[e.level - 1]['bgColor'],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${e.level}",
                                style: TextStyle(color: levelColor[e.level - 1]['textColor'], fontSize: ScreenSize.fontSize10),
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
      ),
    );
  }
}
