import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';

import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';

import '../../../services/user_service.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/inputField/base_input.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

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
      bgColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10)),
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
                  initWidget: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: Text(
                        "first Search",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                  itemChild: (data, index) {
                    return MainBtn(
                      onPress: () {
                        UserProfileAllInfoBottomSheet(userData: data).show(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor98,
                          borderRadius: BorderRadius.circular(
                            ScreenSize.fitPxWidth(5),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10), vertical: ScreenSize.fitPxWidth(5)),
                        margin: EdgeInsets.only(top: ScreenSize.fitPxWidth(10)),
                        child: Row(
                          children: [
                            UserIcon(
                              iconSize: ScreenSize.fitPxWidth(50),
                              image: data.image,
                            ),
                            SizedBox(width: ScreenSize.fitPxWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.email,
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                                Text(
                                  data.name ?? "",
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
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
      height: 36,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search, color: AppColors.whiteColor),
          ),
          Expanded(
            child: BaseInputField(
              hintText: "搜尋",
              autoFocus: true,
              controller: controller,
              onFieldSubmitted: (value) async {
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
