import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';

import '../../utilities/apiListView/api_list_view.dart';

import '../../utilities/loading.dart';

import '../postPage/post_utilities.dart';

class MyPostPage extends BaseFadeScalePage {
  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: () => render());
  }

  @override
  bool needWaitOpenPage() {
    return true;
  }

  @override
  Widget build(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Column(
      children: [
        BaseTopBar(
          title: "我的文章",
          leftWidget: Container(),
          rightWidget: MainBtn(
            onPress: () {
              closePage();
            },
            child: Icon(
              Icons.close,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        Expanded(
          child: APIListWidget(
              size: 6,
              apiFunc: (page, size) {
                return PostService().getPostDataByUID(page, size, userData);
              },
              listControllerProvider: myPostlistControllerProvider,
              noDataWidget: PostViewUtilities.noPostData(),
              loadingWidget: const PostLoading(),
              itemChild: (data, index) {
                return PostViewUtilities().postItemContent(viewModel, data: data, dataIndex: index);
              }),
        ),
      ],
    );
  }
}
