import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';
import 'package:social_mediam_match/states/user_state.dart';

import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/user_icon.dart';

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    LoginUser userData = ModalRoute.of(context)!.settings.arguments as LoginUser;
    UserState userState = context.read<UserState>();
    List<PostModel> myAllPosts = context.watch<UserState>().myAllPosts;
    return StatefulWrapper(
      onInit: () {
        userState.getPostDataByUID(userData);
      },
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    final before = scrollNotification.metrics.extentBefore;
                    final max = scrollNotification.metrics.maxScrollExtent;
                    if (before == max) {}
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: myAllPosts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 218, 219, 219),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  UserIcon(
                                    iconSize: 50,
                                    image: myAllPosts[index].postUserInfo.image,
                                  ),
                                  Text(myAllPosts[index].postUserInfo.email),
                                ],
                              ),
                              Text(myAllPosts[index].mainMessage),
                              Text("發文時間 : ${myAllPosts[index].postTime}"),
                              Text("有${myAllPosts[index].commentCount}則留言"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
