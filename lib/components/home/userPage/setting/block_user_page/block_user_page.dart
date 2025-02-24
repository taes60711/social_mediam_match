import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/models/BlockUser_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/services/black_list_service.dart';

import '../../../../../enum/date_format_utilities.dart';
import '../../../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../../../utilities/apiListView/api_list_controller.dart';
import '../../../../utilities/main_button.dart';
import '../../../../utilities/style/app_colors.dart';
import '../../../../utilities/style/screen_size.dart';
import '../../../../utilities/user_icon.dart';
import 'block_user_manager.dart';

final blocklistControllerProvider = StateNotifierProvider<APIListControllerNotifier<BlockUser>, APIListController<BlockUser>>(
  (ref) => APIListControllerNotifier(APIListController<BlockUser>()),
);

class BlockUserPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      child: Column(
        children: [
          const BaseTopBar(
            title: "黑名單",
          ),
          Expanded(
            child: APIListWidget<BlockUser>(
              apiFunc: (page, size) async {
                return await BlackListService().getBlockUserList(page, size, userUID: ref.read(loginUserData).uid);
              },
              listControllerProvider: blocklistControllerProvider,
              needReloadCheck: true,
              itemChild: (data, index) {
                return MainBtn(
                  onPress: () {
                    BlockUserManagerBtmSheet(blocklistControllerProvider, dataIndex: index).show(context);
                  },
                  child: Container(
                    width: ScreenSize.width,
                    decoration: BoxDecoration(
                      color: AppColors.black37,
                      borderRadius: BorderRadius.circular(
                        ScreenSize.fitPxWidth(15),
                      ),
                    ),
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
                            MainBtn(
                              onPress: () {
                                UserProfileAllInfoBottomSheet(userData: data.userInfo).show(context);
                              },
                              child: UserIcon(
                                iconSize: ScreenSize.fitPxWidth(55),
                                image: data.userInfo.image,
                                borderRadius: 15,
                              ),
                            ),
                            SizedBox(width: ScreenSize.fitPxWidth(10)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data.userInfo.name ?? "用戶已不存在",
                                        style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                                      Visibility(
                                        visible: data.userInfo.job != null,
                                        child: Icon(
                                          FontAwesomeIcons.briefcase,
                                          color: AppColors.greyColor130,
                                          size: ScreenSize.fontSize12,
                                        ),
                                      ),
                                      SizedBox(width: ScreenSize.fitPxWidth(2)),
                                      Text(
                                        data.userInfo.job ?? "",
                                        style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data.userInfo.introduction ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              DateFormatUtilities().format(data.userInfo.lastLogin),
                              style: TextStyle(color: AppColors.greyColor176, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenSize.fitPxHeight(5)),
                      ],
                    ),
                  ),
                );
              },
              noDataWidget: SizedBox(
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
                          FontAwesomeIcons.userLargeSlash,
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
