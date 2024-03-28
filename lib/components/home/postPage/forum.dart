import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import 'post_page.dart';

class Forum extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  const Forum({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    int formIndex = context.select((PostState value) => value.formIndex);

    Widget component;
    if (formIndex == -1) {
      component = Column(
        children: [
          GestureDetector(
            onTap: () {
              postState.forumPageChange(0);
            },
            child: Container(
              color: const Color.fromARGB(255, 162, 182, 192),
              width: ScreenSize().width,
              height: 200,
              child: Center(child: Text("協槓")),
            ),
          ),
          GestureDetector(
            onTap: () {
              postState.forumPageChange(1);
            },
            child: Container(
              color: Colors.blueGrey,
              width: ScreenSize().width,
              height: 200,
              child: Center(child: Text("留言")),
            ),
          ),
        ],
      );
    } else if (formIndex == 0) {
      component = ChangeNotifierProvider(
        create: (_) => PostState(),
        child: PostPage(
          userData: userData,
          gotoFriendPage: gotoFriendPage,
          formPageChange: () {
            postState.forumPageChange(-1);
          },
        ),
      );
    } else {
      component = Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  postState.forumPageChange(-1);
                },
                icon: Icon(Icons.arrow_back_ios),
              )),
        ],
      );
    }

    return component;
  }
}
