import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/models/post_model.dart';

import '../../../../provider/account/user_provider.dart';
import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/post_service.dart';

import '../../../utilities/apiListView/api_list_view.dart';

import '../../../utilities/loading.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';

import '../post_utilities.dart';

class PostPageByType extends BaseEndDrawer {
  late PostViewModel viewModel;
  bool isInit = true;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: () => render());
    isInit = false;
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    PostBoard boardData = ref.read(choicedPostBoardProvider);

    PostBoard typeData = ref.read(allPostBoardListData).firstWhere(
          (e) => e.id == boardData.type,
          orElse: () => PostBoard(),
        );
    return isInit
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.fitPxHeight(10),
                  vertical: ScreenSize.fitPxHeight(10),
                ),
                child: Row(
                  children: [
                    MainBtn(
                      onPress: () {
                        closePage();
                      },
                      child: Container(
                        width: ScreenSize.fitPxWidth(40),
                        height: ScreenSize.fitPxWidth(40),
                        color: AppColors.transparent,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: ScreenSize.fontSize14,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenSize.fitPxHeight(30),
                      height: ScreenSize.fitPxHeight(30),
                      child: Icon(
                        typeData.iconData,
                        color: AppColors.whiteColor.withOpacity(0.8),
                        size: ScreenSize.fitPxHeight(25),
                      ),
                    ),
                    SizedBox(width: ScreenSize.fitPxHeight(10)),
                    Text(
                      typeData.chineseName,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.8),
                        fontSize: ScreenSize.fontSize18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: APIListWidget(
                    apiFunc: (page, size) {
                      return PostService().getPostByType(page, size, boardData.type, userId: ref.read(loginUserData).uid);
                    },
                    size: 7,
                    needReloadCheck: true,
                    listControllerProvider: typelistControllerProvider,
                    loadingWidget: const PostLoading(),
                    noDataWidget: PostViewUtilities.noPostData(),
                    customFloatBtn: PostViewUtilities.postCreateButton(context, ref, postBoard: boardData),
                    itemChild: (data, index) {
                      return PostViewUtilities()
                          .postItemContent(viewModel, typelistControllerProvider, data: data, dataIndex: index);
                    }),
              ),
            ],
          );
  }
}
