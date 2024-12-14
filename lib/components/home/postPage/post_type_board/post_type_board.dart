import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';

import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';

import '../../../../global/home_global_view_model.dart';
import '../../../../models/post_model.dart';
import '../../../utilities/common_scaffold.dart';
import '../../../utilities/main_button.dart';
import 'post_page_by_type.dart';

class PostTypeBoard extends ConsumerStatefulWidget {
  const PostTypeBoard({super.key});

  @override
  ConsumerState<PostTypeBoard> createState() => _PostTypeBoardState();
}

class _PostTypeBoardState extends ConsumerState<PostTypeBoard> {
  @override
  Widget build(BuildContext context) {
    List<PostBoard> allBoard = ref.read(allPostBoardListData);
    return CommonScaffold(
      child: Column(
        children: [
          PostViewUtilities().topPadding(
            ref.watch(bottomNavationBarPosProvider),
            ref.watch(topPostProvider).isNotEmpty,
          ),
          Expanded(
            child: Column(
              children: allBoard
                  .map(
                    (e) => MainBtn(
                      onPress: () {
                        ref.read(choicedPostBoardProvider.notifier).update((state) => e);
                        PostPageByType().show(context);
                      },
                      child: Container(
                        color: AppColors.black37,
                        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(5)),
                        margin: EdgeInsets.only(bottom: ScreenSize.fitPxHeight(13)),
                        width: ScreenSize.width,
                        child: Row(
                          children: [
                            SizedBox(width: ScreenSize.fitPxHeight(20)),
                            Container(
                              width: ScreenSize.fitPxHeight(25),
                              height: ScreenSize.fitPxHeight(25),
                              color: const Color.fromARGB(96, 175, 170, 170),
                            ),
                            SizedBox(width: ScreenSize.fitPxHeight(10)),
                            Text(
                              e.chineseName,
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.8),
                                fontSize: ScreenSize.fontSize16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
