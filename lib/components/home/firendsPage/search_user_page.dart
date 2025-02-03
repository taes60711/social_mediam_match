import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';

import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';

import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../enum/date_format_utilities.dart';
import '../../../services/user_service.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/inputField/base_input.dart';
import '../../utilities/main_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/app_colors.dart';

final searchedUserControllerProvider =
    StateNotifierProvider<APIListControllerNotifier<ProfileData>, APIListController<ProfileData>>(
  (ref) => APIListControllerNotifier(APIListController<ProfileData>()),
);

class SearchUserPage extends BaseBottomSheet {
  bool firstSearch = true;

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.window,
      bgColor: AppColors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
        child: Column(
          children: [
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            _buildSearchBar(ref, () => render(), context),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            Expanded(
              child: APIListWidget(
                apiFunc: (page, size) {
                  return UserService().requestUserDataByNamePart(page, size, userName: "");
                },
                listControllerProvider: searchedUserControllerProvider,
                initWidget: _buildInit(),
                noDataWidget: _buildNoData(),
                itemChild: (data, index) {
                  return MainBtn(
                    onPress: () {
                      UserProfileAllInfoBottomSheet(userData: data).show(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.greyColor57,
                        borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(8)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.fitPxWidth(10),
                        vertical: ScreenSize.fitPxWidth(5),
                      ),
                      margin: EdgeInsets.only(top: ScreenSize.fitPxWidth(10)),
                      child: SizedBox(
                        width: ScreenSize.width,
                        child: Row(
                          children: [
                            UserIcon(
                              iconSize: ScreenSize.fitPxWidth(50),
                              image: data.image,
                            ),
                            SizedBox(width: ScreenSize.fitPxWidth(10)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.name ?? "",
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: ScreenSize.fontSize16,
                                        ),
                                      ),
                                      Text(
                                        DateFormatUtilities().format(data.lastLogin),
                                        style: TextStyle(
                                          color: AppColors.whiteColor.withOpacity(.5),
                                          fontSize: ScreenSize.fontSize12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data.email,
                                    style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.greyColor130),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SizedBox(
        width: ScreenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(20)),
              child: Icon(
                FontAwesomeIcons.usersSlash,
                color: AppColors.whiteColor,
                size: ScreenSize.fitPxWidth(80),
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            Text(
              "搜尋無結果",
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInit() {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SizedBox(
        width: ScreenSize.width,
        child: Column(
          children: [
            SizedBox(height: ScreenSize.fitPxHeight(120)),
            Icon(
              Icons.search,
              color: AppColors.whiteColor,
              size: ScreenSize.fitPxWidth(80),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(8)),
            Text(
              "請用名稱搜尋",
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        borderRadius: BorderRadius.circular(5),
      ),
      height: ScreenSize.fitPxWidth(36),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.search,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize16,
            ),
          ),
          Expanded(
            child: BaseInputField(
              hintText: "搜尋",
              autoFocus: true,
              controller: controller,
              onFieldSubmitted: (value) async {
                if (value.replaceAll(" ", "") == "") {
                  return;
                }
                if (firstSearch) {
                  await ref.read(searchedUserControllerProvider.notifier).init((page, size) {
                    return UserService().requestUserDataByNamePart(page, size, userName: value);
                  });
                  firstSearch = false;
                  render();
                } else {
                  await ref.read(searchedUserControllerProvider.notifier).replaceApi((page, size) {
                    return UserService().requestUserDataByNamePart(page, size, userName: value);
                  });
                  render();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
