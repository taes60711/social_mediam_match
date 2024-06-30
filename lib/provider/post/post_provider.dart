import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/post_model.dart';
import '../../components/utilities/endDrawers/post_board_end_drawer.dart';
import '../../components/utilities/endDrawers/post_page_by_text_filter_end_drawer.dart';
import '../../models/user_model.dart';
import '../../services/db_service.dart';

class PostProvider extends ChangeNotifier {
  final DBService _dbService = DBService();

  bool isGood = false;
  List<getPostCommentModel> postCommentData = [];
  List<TextEditingController> postCommentMessageController = [];
  TextEditingController postCommentInput = TextEditingController();

  PostModel? choicedPostData;
  LoginUser otherUser = LoginUser();
  TextEditingController messageInput = TextEditingController();
  TextEditingController textFilterInput = TextEditingController();

  void changeIsGoodStatus(bool changedGood) {
    isGood = changedGood;
    notifyListeners();
  }

  // Future<void> createPost(String userUid, String title, String message, int type) async {
  //   try {
  //     String fomattedContent = await RichTextFormat(htmlString: message).sendPostImgFormat();
  //     await _dbService.createPost(userUid, title, fomattedContent, type);

  //     List<PostModel> tempPostData = await _dbService.getPostsByType(type, isFirst: true);
  //     postData = [];
  //     tempPostData.forEach((e) {
  //       postData = [...postData, e];
  //     });
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> changePostComment(int uid, int index, String updatedMessage) async {
    await _dbService.updatePostComment(uid, updatedMessage);
    postCommentData[index].isEditor = false;
    postCommentData[index].message = updatedMessage;
    notifyListeners();
  }

  Future<void> editPostComment(int index) async {
    postCommentData[index].isEditor = !postCommentData[index].isEditor;
    notifyListeners();
  }

  Future<void> deletePostComment(int uId) async {
    await _dbService.deletePostComment(uId);
    int index = postCommentData.indexWhere((element) => element.uid == uId);
    postCommentData.remove(postCommentData[index]);
    postCommentMessageController.remove(postCommentMessageController[index]);
    notifyListeners();
  }

  Future<void> createPostComment(int postId, String message, LoginUser commentUser) async {
    try {
      int lastIndex = await _dbService.createPostComment(postId, commentUser.uid, message);

      DateTime dateUtc = DateTime.now().toUtc();
      DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc.toString(), true);
      String formattedTime = DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal());

      getPostCommentModel tempPostCommentData = getPostCommentModel(
          uid: lastIndex,
          postId: postId,
          userUid: commentUser.uid,
          message: message,
          postTime: formattedTime,
          commentUserInfo: commentUser,
          isEditor: false);
      postCommentMessageController.insert(0, TextEditingController());
      postCommentData.insert(0, tempPostCommentData);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  PostBoardEndDrawerType endDrawerOpenInfo = PostBoardEndDrawerType.close;
  int selectedboardIndex = 0;
  void changeEndDrawerStatus(PostBoardEndDrawerType status, int boardType) {
    endDrawerOpenInfo = status;
    selectedboardIndex = boardType;
    notifyListeners();
  }

  PostPageBytextFilterEndDrawerType postPageBytextFilterEndDrawerOpenInfo = PostPageBytextFilterEndDrawerType.close;
  void changePostPageBytextFilterEndDrawerStatus(PostPageBytextFilterEndDrawerType status) {
    postPageBytextFilterEndDrawerOpenInfo = status;
    notifyListeners();
  }
}
