import 'package:flutter/material.dart';

import '../../enum/user_detail_end_drawer_type.dart';

class FriendProivder extends ChangeNotifier {
  UserDetailEndDrawerType endDrawerOpenInfo = UserDetailEndDrawerType.close;
  void changeEndDrawerStatus(UserDetailEndDrawerType status) {
    endDrawerOpenInfo = status;
    notifyListeners();
  }
}
