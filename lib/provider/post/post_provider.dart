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

  bool isPostCommentLoading = false;
  bool isPostCommentDataAddLoding = false;
  bool isPostCommentReLoading = false;

  final GlobalKey<ScaffoldState> globalCommentKey = GlobalKey();
  String endDrawerType = "";
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

  Future<void> getPostCommentData(int postId, {String? loginUserUID, required String searchType}) async {
    try {
      List<PostCommentModel> tempPostCommentData = [];
      if (searchType == "AddData") {
        isPostCommentDataAddLoding = true;
        tempPostCommentData = await _dbService.getPostCommentData(postId);
        notifyListeners();

        tempPostCommentData.forEach((e) {
          postCommentData.add(
            getPostCommentModel(
                uid: e.uid,
                postId: postId,
                userUid: e.userUid,
                message: e.message,
                isEditor: false,
                postTime: e.postTime,
                commentUserInfo: e.commentUserInfo),
          );
          postCommentMessageController.add(TextEditingController());
        });
      } else {
        if (searchType == "First") {
          isPostCommentLoading = true;
        } else if (searchType == "Reload") {
          isPostCommentReLoading = true;
        }
        // isGood = await _dbService.checkIsPostGood(postId, loginUserUID!);
        Future.delayed(Duration.zero).then((value) => notifyListeners());
        tempPostCommentData = await _dbService.getPostCommentData(postId, isFirst: true);
        List<getPostCommentModel> tempGetPostCommentData = [];
        postCommentMessageController.clear();
        tempPostCommentData.forEach((e) {
          tempGetPostCommentData.add(
            getPostCommentModel(
                uid: e.uid,
                postId: postId,
                userUid: e.userUid,
                message: e.message,
                isEditor: false,
                postTime: e.postTime,
                commentUserInfo: e.commentUserInfo),
          );
          postCommentMessageController.add(TextEditingController());
        });
        postCommentData = tempGetPostCommentData;
      }

      isPostCommentDataAddLoding = false;
      isPostCommentReLoading = false;
      isPostCommentLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void postAddData() {
    isPostCommentDataAddLoding = true;
    notifyListeners();
  }

  void postReLoadingPage() {
    isPostCommentReLoading = true;
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

  Future<void> openDrawer(String endDrawerType,
      {GlobalKey<ScaffoldState>? globalKey, LoginUser? otherUser, LoginUser? loginUserData, PostModel? choicedPostData}) async {
    this.endDrawerType = endDrawerType;
    if (this.endDrawerType == "userDetail") {
      this.otherUser = otherUser ?? LoginUser();
      globalKey?.currentState!.openEndDrawer();
    } else {
      this.choicedPostData = choicedPostData;
      if (loginUserData!.uid != choicedPostData!.createdBy) {
        print("moveToPost");
        // await _dbService.moveToPost(choicedPostData.id);
      }
    }
    notifyListeners();
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
