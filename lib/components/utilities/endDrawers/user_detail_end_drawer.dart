import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../provider/friend_provider.dart';
import '../../user_detail_page.dart';
import 'custom_end_drawer.dart';

enum UserDetailEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create FriendProvider

///MARK: void ユーザ詳細ページ開くように
void openUserDetailEndDrawer({required BuildContext context, required LoginUser otherUserData}) {
  context.read<FriendProvider>().changeEndDrawerStatus(UserDetailEndDrawerType.open, otherUserData);
}

///MARK: void ユーザ詳細ページ開くように
void closeUserDetailEndDrawer({required BuildContext context}) {
  context.read<FriendProvider>().changeEndDrawerStatus(UserDetailEndDrawerType.close, LoginUser());
}

///MARK: Widget ユーザ詳細ページ用EndDrawer
Widget userDetailEndDrawer() {
  return Builder(
    builder: (context) {
      print("userDetailEndDrawer");
      UserDetailEndDrawerType endDrawer = context.select((FriendProvider value) => value.endDrawerOpenInfo);

      Widget endDrawerWidget = Container();

      if (endDrawer == UserDetailEndDrawerType.open) {
        endDrawerWidget = EndDrawer(
          onDismissed: () {
            closeUserDetailEndDrawer(context: context);
          },

          /// ユーザ詳細ページ
          child: UserDetailPage(
            otherUser: context.read<FriendProvider>().ohterUserData,
            toChatRoom: () {
              closeUserDetailEndDrawer(context: context);
            },
          ),
        );
      }

      return endDrawerWidget;
    },
  );
}
