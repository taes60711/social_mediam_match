// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_mediam_match/components/home/coursePage/course_manager/course_manager_bottom_sheet.dart';
import 'package:social_mediam_match/components/home/coursePage/course_manager/my_course_manager.bottom.sheet.dart';
import 'package:social_mediam_match/components/utilities/lodaing_dialog.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';
import 'package:social_mediam_match/enum/skill_type.dart';
import 'package:social_mediam_match/services/course_service.dart';
import '../../../enum/date_format_utilities.dart';
import '../../../global.dart';
import '../../../global/home_global_view_model.dart';

import '../../../models/course_model.dart';
import '../../../models/user_model.dart';

import '../../../provider/account/user_provider.dart';
import '../../../provider/course/course_provider.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';

import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/app_colors.dart';
import '../../utilities/user_icon.dart';
import 'course_detail.dart';
import 'course_manager/course_create_page.dart';

class CourseUtilites {
  ///データなレイアウト
  static Widget noCourseData() {
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
                FontAwesomeIcons.commentSlash,
                size: 50,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            Text(
              "沒有文章",
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

  ///コース作るボタン
  static Widget courseCreateButton(BuildContext context, WidgetRef ref) {
    return MainBtn(
      onPress: () {
        HomeGlobalViewModel().needLoginCheckFunc(func: () {
          CourseCreatePage().show(context);
        });
      },
      child: Container(
        width: ScreenSize.fitPxWidth(40),
        height: ScreenSize.fitPxWidth(40),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor,
        ),
        child: Icon(
          FontAwesomeIcons.pen,
          size: ScreenSize.fontSize14,
          color: AppColors.orangeColor,
        ),
      ),
    );
  }

  Widget courseItemContent(BuildContext context, WidgetRef ref,
      StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>> courseListController,
      {required int dataIndex, required CourseModel data}) {
    return MainBtn(
      onPress: () {
        ref.read(choicedCourseProvider.notifier).update((state) => data);
        CourseDetailPage(courseListController: courseListController, data: data, dataIndex: dataIndex).show(context);
      },
      child: Container(
        width: ScreenSize.width,
        color: AppColors.black37,
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.fitPxHeight(8),
          horizontal: ScreenSize.fitPxHeight(15),
        ),
        margin: EdgeInsets.only(top: ScreenSize.fitPxHeight(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainBtn(
              onPress: () {
                ///ユーザー詳細ページに遷移
                UserProfileAllInfoBottomSheet(userData: data.courseCreateduserInfo).show(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  UserIcon(
                    iconSize: 24,
                    image: data.courseCreateduserInfo.image,
                  ),
                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                  Text(
                    data.courseCreateduserInfo.name ?? "用戶已不存在",
                    style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                  ),
                  const Expanded(child: SizedBox(width: 1)),

                  ///ellipsisボタン
                  GestureDetector(
                    onTap: () {
                      ref.read(choicedCourseProvider.notifier).update((state) => data);

                      data.courseCreateduserInfo.uid == ref.read(loginUserData).uid
                          ? CourseManagerBtmSheet(courseListController, dataIndex: dataIndex).show(context)
                          : MyCourseManagerBtmSheet(courseListController, dataIndex: dataIndex).show(context);
                    },
                    child: Container(
                      width: 30,
                      alignment: Alignment.centerRight,
                      color: AppColors.transparent,
                      child: Icon(
                        FontAwesomeIcons.ellipsis,
                        color: AppColors.greyColor130,
                        size: ScreenSize.fontSize16,
                      ),
                    ),
                  ),
                ],
              ),
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

            ///類別
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
                      formattedTag(data.type),
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
                            borderRadius: BorderRadius.circular(100),
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

            ///內容
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

            ///程度
            Row(
              children: [
                Text(
                  "程度 ",
                  style: TextStyle(
                    color: AppColors.greyColor130,
                    fontSize: ScreenSize.fontSize12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                levelWidget(data.needLevel),
              ],
            ),
            SizedBox(height: ScreenSize.fitPxHeight(5)),

            ///事先需求
            Visibility(
              visible: data.beforeNeed != "",
              child: Text(
                data.beforeNeed,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.greyColor130,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            Row(
              children: [
                Text(
                  "最終更新日: ${DateFormatUtilities().format(data.postTime)}",
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.6),
                    fontSize: ScreenSize.fontSize12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Expanded(child: SizedBox(width: 1)),
                Visibility(
                  visible: ref.watch(loginUserData).uid != data.courseCreateduserInfo.uid,
                  child: Builder(builder: (context) {
                    bool canPress = true;
                    return MainBtn(
                      onPress: () async {
                        if (canPress) {
                          canPress = false;

                          await likeStatusOnChange(
                            ref,
                            context,
                            courseListController: courseListController,
                            dataIndex: dataIndex,
                            data: data,
                          );

                          canPress = true;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: ScreenSize.fitPxWidth(12),
                        ),
                        color: Colors.transparent,
                        child: Icon(
                          data.isLike ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                          color: data.isLike ? AppColors.yellowColor : AppColors.greyColor,
                          size: ScreenSize.fontSize16,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget levelWidget(int level) {
    List<IconData> icons = [];

    for (int i = 0; i < level; i++) {
      icons.add(FontAwesomeIcons.splotch);
    }

    return Row(
      children: icons.map((e) {
        return Padding(
          padding: EdgeInsets.only(right: ScreenSize.fitPxWidth(5)),
          child: Icon(
            e,
            size: ScreenSize.fontSize12,
            color: AppColors.greyColor130,
          ),
        );
      }).toList(),
    );
  }

  Future<bool> likeStatusOnChange(
    WidgetRef ref,
    BuildContext context, {
    required StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>> courseListController,
    required int dataIndex,
    required CourseModel data,
  }) async {
    ProfileData userData = ref.watch(loginUserData);
    bool isSuccess = false;

    HomeGlobalViewModel().needLoginCheckFunc(func: () async {
      if (!data.isLike) {
        isSuccess = await CourseService().likeCourse(courseId: data.id, userUID: userData.uid);
      } else {
        isSuccess = await CourseService().deleteLikeCourse(courseId: data.id, userUID: userData.uid);
      }

      if (!isSuccess) {
        Toast().showCenter(msg: "請至列表  重新整理一次列表, 再按收藏");
        return isSuccess;
      }

      CourseModel editedData = data;
      editedData.isLike = !editedData.isLike;
      ref.read(courseListController.notifier).editData(dataIndex, editedData);
    });

    return isSuccess;
  }

  Future<void> shareCourse({required int courseId}) async {
    String sharePostUrl = "https://${APIHttpController.shareDomain}/course/$courseId";
    LoadingDialog().show();
    await Share.share(sharePostUrl);
    LoadingDialog().close();
  }

  String formattedTag(int type) {
    return SkillType.values.firstWhere((element) => element.type == type).value;
  }
}
