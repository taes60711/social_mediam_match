import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import '../../../provider/post/post_provider.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';

class PostPageByTextFilter extends BaseEndDrawer {
  final String searchText;

  PostPageByTextFilter({required this.searchText});
  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: () => render());
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          backFunc: () {
            closePage();
          },
        ),
        Expanded(
          child: APIListWidget(
              apiFunc: (page, size) {
                return PostService().getPostByTextFilter(page, size, searchText);
              },
              listControllerProvider: textFilterControllerProvider,
              noDataWidget: PostViewUtilities.noPostData(),
              customFloatBtn: PostViewUtilities.postCreateButton(context),
              loadingWidget: const PostLoading(),
              itemChild: (data, index) {
                return PostViewUtilities().postItemContent(viewModel, textFilterControllerProvider, data: data, dataIndex: index);
              }),
        ),
      ],
    );
  }
}
