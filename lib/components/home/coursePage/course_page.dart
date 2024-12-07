import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page_by_skillfilter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page_by_textfilter.dart';
import 'package:social_mediam_match/components/home/coursePage/course_utilites.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_skill_filter_page.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/services/course_service.dart';
import '../../../global/home_global_view_model.dart';

import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/course/course_provider.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/common_scaffold.dart';
import '../../utilities/main_button.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/screen_size.dart';

class CourseMainPage extends ConsumerStatefulWidget {
  const CourseMainPage({super.key});

  @override
  ConsumerState<CourseMainPage> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends ConsumerState<CourseMainPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      ref.read(couseFilteredSkillList.notifier).update((state) => []);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileData userData = ref.watch(loginUserData);
    return CommonScaffold(
      type: PageType.main,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? ScreenSize.fitPxWidth(40) : 0,
              ),
              Expanded(
                child: APIListWidget(
                  apiFunc: (int page, int size) {
                    return CourseService().getAllCourses(userData.uid, page, size);
                  },
                  listControllerProvider: courseMainPageListPorver,
                  haveBottomBar: true,
                  needReloadCheck: true,
                  customFloatBtn: CourseUtilites.courseCreateButton(context),
                  loadingWidget: const CourseLoading(),
                  noDataWidget: CourseUtilites.noCourseData(),
                  itemChild: (data, index) {
                    return CourseUtilites()
                        .courseItemContent(context, ref, courseMainPageListPorver, data: data, dataIndex: index);
                  },
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60)
                ? ScreenSize.fitPxHeight(5)
                : ScreenSize.fitPxHeight(-50),
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 300),
            child: _buildSearchBar(ref, () => setState(() {}), context),
          ),
        ],
      ),
    );
  }
}

Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
  TextEditingController searchController = TextEditingController();
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: ScreenSize.fitPxWidth(10),
    ),
    decoration: BoxDecoration(
      color: AppColors.greyColor57,
      borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(5)),
    ),
    width: ScreenSize.width,
    height: ScreenSize.fitPxWidth(36),
    child: Row(
      children: [
        MainBtn(
          onPress: () {
            if (searchController.text == "") {
              return;
            }
            CoursePageByTextFilter(searchText: searchController.text).show(context);
          },
          child: Container(
            width: ScreenSize.fitPxWidth(30),
            height: ScreenSize.fitPxWidth(36),
            color: Colors.transparent,
            child: Icon(
              Icons.search,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize16,
            ),
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
              CoursePageByTextFilter(searchText: value).show(context);
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            BaseSkillFilterPage(
              viewRender: render,
              filteredSkillList: couseFilteredSkillList,
              searchFunc: (choicedFilterSkillList) async {
                List<String> filteredSkillIdList = choicedFilterSkillList.map((e) => e.id.toString()).toList();
                CoursePageBySkillFilter(filterSkill: filteredSkillIdList).show(context);

                ref.read(couseFilteredSkillList.notifier).update((state) => choicedFilterSkillList);
              },
            ).show(context);
          },
          child: Container(
            width: ScreenSize.fitPxWidth(30),
            height: ScreenSize.fitPxWidth(40),
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
