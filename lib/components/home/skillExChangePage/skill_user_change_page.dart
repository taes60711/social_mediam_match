import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_user_change_page_by_textfilter.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import '../../../global/home_global_view_model.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/user_service.dart';
import '../../strings/skillExChangePage/skill_change_page_string.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';

import '../../utilities/endDrawers/base_skill_filter_page.dart';
import '../../utilities/inputField/base_input.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/style_config.dart';
import 'skill_utilites.dart';

final filteredSkillList = StateProvider<List<RequestSkillListData>>((ref) {
  return [];
});

final userExChangelistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class SkillUserChangePage extends ConsumerStatefulWidget {
  const SkillUserChangePage({super.key});

  @override
  ConsumerState<SkillUserChangePage> createState() => _SkillUserChangePageState();
}

class _SkillUserChangePageState extends ConsumerState<SkillUserChangePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      ref.read(filteredSkillList.notifier).update((state) => []);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);
    return CommonScaffold(
      type: PageType.main,
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
                    return UserService().getAllUserData(page, size, userUid: userData.uid, filterSkill: []);
                  },
                  haveBottomBar: true,
                  listControllerProvider: userExChangelistControllerProvider,
                  loadingWidget: const SkillChangeLoading(),
                  itemChild: (data, index) {
                    return SkillUtilites().skillUserChangeContent(context, data: data);
                  },
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 3 : -45,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10)),
              child: _buildSearchBar(ref, () => setState(() {}), context),
            ),
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
              SkillUtilites().skillBar(skills: userData.mainSkills!),
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
              SkillUtilites().skillBar(skills: userData.wantSkills!),
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

  Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        borderRadius: BorderRadius.circular(5),
      ),
      width: ScreenSize.width,
      height: 36,
      child: Row(
        children: [
          MainBtn(
            onPress: () {
              if (searchController.text == "") {
                return;
              }
              SkillUserChangeByTextFilter(searchText: searchController.text).show(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search, color: AppColors.whiteColor),
            ),
          ),
          Expanded(
            child: BaseInputField(
              hintText: "搜尋",
              textInputAction: TextInputAction.search,
              controller: searchController,
              onFieldSubmitted: (value) {
                if (value == "") {
                  return;
                }
                SkillUserChangeByTextFilter(searchText: value).show(context);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              BaseSkillFilterPage(
                viewRender: () {
                  setState(() {});
                },
                filteredSkillList: filteredSkillList,
                searchFunc: (choicedFilterSkillList) async {
                  List<String> filteredSkillIdList = choicedFilterSkillList.map((e) => e.id.toString()).toList();
                  ProfileData userData = ref.watch(loginUserData);
                  await ref.read(userExChangelistControllerProvider.notifier).replaceApi((page, size) {
                    return UserService().getAllUserData(page, size, userUid: userData.uid, filterSkill: filteredSkillIdList);
                  });

                  ref.read(filteredSkillList.notifier).update((state) => choicedFilterSkillList);
                },
              ).show(context);
            },
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
    );
  }
}
