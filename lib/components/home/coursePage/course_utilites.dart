import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_edit_page/course_edit_page.dart';

import '../../../models/course_model.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'course_detail.dart';
import 'course_page.dart';

class CourseUtilites {
  ///コース作るボタン
  static Widget courseCreateButton(BuildContext context) {
    return MainBtn(
      onPress: () {
        CourseEditPage().show(context);
      },
      child: Container(
        width: ScreenSize.fitPxWidth(40),
        height: ScreenSize.fitPxWidth(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.whiteColor,
        ),
        child: Icon(
          FontAwesomeIcons.pen,
          size: 16,
          color: AppColors.orangeColor,
        ),
      ),
    );
  }

  Widget courseItemContent(BuildContext context, WidgetRef ref, {required CourseModel data}) {
    return MainBtn(
      onPress: () {
        ref.read(choicedCourseProvider.notifier).update((state) => data);
        CourseDetailPage().show(context);
      },
      child: Container(
        width: ScreenSize.width,
        color: AppColors.black37,
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.fitPxHeight(8),
          horizontal: ScreenSize.fitPxHeight(15),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                UserIcon(
                  iconSize: 24,
                  image: data.courseCreateduserInfo.image,
                ),
                SizedBox(width: ScreenSize.fitPxWidth(5)),
                Text(
                  data.courseCreateduserInfo.name ?? "",
                  style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                )
              ],
            ),
            Text(
              data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxWidth(5)),
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      FontAwesomeIcons.tag,
                      color: AppColors.whiteColor.withOpacity(.6),
                      size: ScreenSize.fontSize16,
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(2)),
                    Text(
                      "前端",
                      style: TextStyle(color: AppColors.whiteColor.withOpacity(.6), fontSize: ScreenSize.fontSize12),
                    ),
                  ],
                ),
                SizedBox(width: ScreenSize.fitPxWidth(5)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: data.courseLearningSkills.map((e) {
                        return Container(
                          margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(3)),
                          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.greyColor98,
                          ),
                          child: Text(
                            e,
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: ScreenSize.fontSize12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.book,
                  color: AppColors.whiteColor,
                  size: ScreenSize.fontSize14,
                ),
                SizedBox(width: ScreenSize.fitPxWidth(5)),
                Text(
                  "大綱",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              data.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.greyColor130,
                fontSize: ScreenSize.fontSize12,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.wrench,
                  color: AppColors.whiteColor,
                  size: ScreenSize.fontSize14,
                ),
                SizedBox(width: ScreenSize.fitPxWidth(5)),
                Text(
                  "前置需求",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: ScreenSize.fitPxWidth(5)),
                Padding(
                  padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(3)),
                  child: Text(
                    "難度 ${data.needLevel}",
                    style: TextStyle(
                      color: AppColors.greyColor130,
                      fontSize: ScreenSize.fontSize12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              data.beforeNeed,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.greyColor130,
                fontSize: ScreenSize.fontSize12,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            Text(
              "最終更新日:${data.postTime}",
              style: TextStyle(
                color: AppColors.whiteColor.withOpacity(.6),
                fontSize: ScreenSize.fontSize12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
