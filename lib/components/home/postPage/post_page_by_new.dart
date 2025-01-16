import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import '../../../global/home_global_view_model.dart';
import '../../../provider/post/post_provider.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';

// new
class PostByNew extends ConsumerStatefulWidget {
  const PostByNew({super.key});

  @override
  ConsumerState<PostByNew> createState() => _PostByViewState();
}

class _PostByViewState extends ConsumerState<PostByNew> {
  late PostViewModel viewModel;
  @override
  void initState() {
    viewModel = PostViewModel(ref: ref, context: context, render: () => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostViewUtilities().topPadding(
          ref.watch(bottomNavationBarPosProvider),
          ref.watch(topPostProvider).isNotEmpty,
        ),
        Expanded(
          child: APIListWidget(
              apiFunc: (page, size) {
                return PostService().getNewPosts(page, size);
              },
              listControllerProvider: newlistControllerProvider,
              haveBottomBar: true,
              needReloadCheck: true,
              loadingWidget: const PostLoading(),
              noDataWidget: PostViewUtilities.noPostData(),
              customFloatBtn: PostViewUtilities.postCreateButton(context, ref),
              itemChild: (data, index) {
                return PostViewUtilities().postItemContent(viewModel, newlistControllerProvider, data: data, dataIndex: index);
              }),
        ),
      ],
    );
  }
}
