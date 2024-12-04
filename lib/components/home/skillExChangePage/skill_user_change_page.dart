import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_user_change_page_by_skill_filter.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_user_change_page_by_textfilter.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';

import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../global/home_global_view_model.dart';
import '../../../models/skill_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/user_service.dart';

import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';

import '../../utilities/endDrawers/base_skill_filter_page.dart';
import '../../utilities/inputField/base_input.dart';
import '../../utilities/loading.dart';
import '../../utilities/main_button.dart';
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
                height: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? ScreenSize.fitPxWidth(40) : 0,
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
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60)
                ? ScreenSize.fitPxHeight(5)
                : ScreenSize.fitPxHeight(-50),
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

  Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenSize.fitPxWidth(5)),
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
              SkillUserChangeByTextFilter(searchText: searchController.text).show(context);
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
                  SkillUserChangeBySkillFilter(filterSkill: filteredSkillIdList).show(context);
                  ref.read(filteredSkillList.notifier).update((state) => choicedFilterSkillList);
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
}
