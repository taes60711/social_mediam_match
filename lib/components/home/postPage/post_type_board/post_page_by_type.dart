import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/models/post_model.dart';

import '../../../../provider/post/post_provider.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/post_service.dart';

import '../../../utilities/apiListView/api_list_view.dart';

import '../../../utilities/loading.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';

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
    String typeName = ref
        .read(allPostBoardListData)
        .firstWhere(
          (e) => e.id == boardData.type,
          orElse: () => PostBoard(name: '', id: 0),
        )
        .name;
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
                    Container(
                      width: ScreenSize.fitPxHeight(30),
                      height: ScreenSize.fitPxHeight(30),
                      color: const Color.fromARGB(96, 175, 170, 170),
                    ),
                    SizedBox(width: ScreenSize.fitPxHeight(10)),
                    Text(
                      typeName,
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
                      return PostService().getPostByType(page, size, boardData.type);
                    },
                    size: 7,
                    needReloadCheck: true,
                    listControllerProvider: typelistControllerProvider,
                    loadingWidget: const PostLoading(),
                    noDataWidget: PostViewUtilities.noPostData(),
                    customFloatBtn: PostViewUtilities.postCreateButton(context, postBoard: boardData),
                    itemChild: (data, index) {
                      return PostViewUtilities()
                          .postItemContent(viewModel, typelistControllerProvider, data: data, dataIndex: index);
                    }),
              ),
            ],
          );
  }
}
