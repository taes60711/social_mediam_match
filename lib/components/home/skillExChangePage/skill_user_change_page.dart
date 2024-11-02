import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../global/home_global_view_model.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../services/user_service.dart';
import '../../strings/skillExChangePage/skill_change_page_string.dart';
import '../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/style_config.dart';

class SkillUserChangePage extends ConsumerStatefulWidget {
  const SkillUserChangePage({super.key});

  @override
  ConsumerState<SkillUserChangePage> createState() => _SkillUserChangePageState();
}

final userExChangelistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class _SkillUserChangePageState extends ConsumerState<SkillUserChangePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 40 : 0,
              ),
              Expanded(
                child: APIListWidget<ProfileData>(
                  size: 6,
                  apiFunc: (page, size) {
                    return UserService().getAllUserData(page, size, userUid: "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2", filterSkill: []);
                  },
                  listControllerProvider: userExChangelistControllerProvider,
                  loadingWidget: SkillChangeLoading(),
                  itemChild: (data, index) {
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
                                  "${data.lastLogin}${SkillChangePageString.skExChpagebeforDays}",
                                  style: TextStyle(color: hintTextColor, fontSize: 12),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: ScreenSize.fitPxHeight(5),
                            ),

                            ///得意なスキル
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

                                ///スキル
                                skillBar(skills: data.mainSkills!),
                              ],
                            ),

                            SizedBox(height: ScreenSize.fitPxHeight(3)),

                            ///弱いスキル
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

                                ///スキル
                                skillBar(skills: data.wantSkills!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 3 : -45,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 100),
            child: _buildSearchBar(ref, () => setState(() {}), context),
          ),
        ],
      ),
    );
  }

  Widget userProfileView({required ProfileData userData}) {
    return Column(
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
                child: MainBtn(
                  onPress: () {},
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

  Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.greyColor57,
          borderRadius: BorderRadius.circular(5),
        ),
        width: ScreenSize.width,
        height: 36,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search, color: AppColors.whiteColor),
            ),
            Text(
              "搜尋",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 14,
              ),
            ),
            const Expanded(child: SizedBox(width: 1)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 50,
                height: 40,
                color: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.sliders,
                  size: ScreenSize.fontSize14,
                  color: AppColors.whiteColor.withOpacity(.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
