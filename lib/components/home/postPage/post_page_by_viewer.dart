import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../global/home_global_view_model.dart';
import '../../../provider/post/post_provider.dart';
import '../../../services/post_service.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';
import 'post_utilities.dart';

class PostByView extends ConsumerStatefulWidget {
  const PostByView({super.key});

  @override
  ConsumerState<PostByView> createState() => _PostByViewState();
}

class _PostByViewState extends ConsumerState<PostByView> {
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
                return PostService().getPostDataByViewer(page, size);
              },
              listControllerProvider: listControllerProvider,
              haveBottomBar: true,
              noDataWidget: PostViewUtilities.noPostData(),
              customFloatBtn: PostViewUtilities.postCreateButton(context),
              loadingWidget: const PostLoading(),
              itemChild: (data, index) {
                return PostViewUtilities().postItemContent(ref, context, data: data);
              }),
        ),
      ],
    );
  }
}
