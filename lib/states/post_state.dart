import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/services/db_service.dart';
import '../models/user_model.dart';

class PostState extends ChangeNotifier {
  final DBService _dbService = DBService();
  final GlobalKey<ScaffoldState> forumGlobalKey = GlobalKey();
  bool floatButtonIsVisiable = false;

  bool isCanLoading = true;
  List<PostModel> postData = [];
  bool isGood = false;
  List<getPostCommentModel> postCommentData = [];
  List<TextEditingController> postCommentMessageController = [];
  TextEditingController postCommentInput = TextEditingController();
  bool isFirstLoading = true;
  bool isDataAddLoding = false;
  bool isReLoading = false;
  bool isPostCommentLoading = false;
  bool isPostCommentDataAddLoding = false;
  bool isPostCommentReLoading = false;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> globalCommentKey = GlobalKey();
  String endDrawerType = "";
  PostModel? choicedPostData;
  LoginUser? otherUser;

  List<PostModel> myAllPosts = [];
  PostModel? choicedPost;
  bool myPostsIsFirstLoading = false;
  GlobalKey<ScaffoldState> myPostsGlobalKey = GlobalKey();
  TextEditingController messageInput = TextEditingController();
  String myPostEndDrawerType = "";

  double startScrollPosition = -1;
  void getStartScrollPos(double pos) {
    startScrollPosition = pos;
    notifyListeners();
  }

  void floatButtonVisiableChange(double posheight) {
    if (posheight < 40) {
      if (floatButtonIsVisiable) {
        floatButtonIsVisiable = false;
        notifyListeners();
      }
    } else {
      if (!floatButtonIsVisiable) {
        floatButtonIsVisiable = true;
        notifyListeners();
      }
    }
  }

  int selectedboardIndex = 0;
  void boardOnChange(int type) {
    selectedboardIndex = type;
    forumGlobalKey.currentState!.openEndDrawer();
    notifyListeners();
  }

  Future<void> postOnChange(PostModel choicedPost, String endDrawerType) async {
    myPostEndDrawerType = endDrawerType;
    this.choicedPost = choicedPost;
    await Future.delayed(Duration.zero).then((value) => notifyListeners());
  }

  Future<void> getPostDataByUID(LoginUser userData, {required bool isFirstSearch}) async {
    try {
      List<PostModel> tempPostsData = [];
      if (isFirstSearch) {
        tempPostsData = await _dbService.getPostDataByUID(userData, isFirst: isFirstSearch);
      } else {
        tempPostsData = await _dbService.getPostDataByUID(userData);
      }
      tempPostsData.forEach((e) {
        myAllPosts = [...myAllPosts, e];
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostData(int postId) async {
    await _dbService.deletePost(postId);
    myAllPosts.remove(myAllPosts.where((element) => element.id == postId).first);
    notifyListeners();
  }

  Future<void> updatePostData(int postId, String updateMessage) async {
    await _dbService.updatePost(postId, updateMessage);
    int postIndex = myAllPosts.indexWhere((element) => element.id == postId);
    myAllPosts[postIndex].mainMessage = updateMessage;
    notifyListeners();
  }

  Future<void> updatePostGood(int postId, {String? userUID}) async {
    if (userUID != null) {
      await _dbService.updatePostGood(postId, userUID: userUID);
    } else {
      await _dbService.updatePostGood(postId);
    }
    isGood = !isGood;
    notifyListeners();
  }

  void changeChoicedPostGoodCount({required PostModel choicedPost, required isGood}) {
    if (isGood) {
      choicedPost.good -= 1;
    } else {
      choicedPost.good += 1;
    }
    notifyListeners();
  }

  Future<void> getPostData({required String searchType}) async {
    try {
      List<PostModel> tempPostData = [];
      if (searchType == "AddData") {
        tempPostData = await _dbService.getPostData();
        tempPostData.forEach((e) {
          postData = [...postData, e];
        });
        isDataAddLoding = false;
      } else {
        if (searchType == "First") {
          isFirstLoading = true;
          Future.delayed(Duration.zero).then((value) => notifyListeners());
        }
        tempPostData = await _dbService.getPostData(isFirst: true);
        postData = tempPostData;
        isFirstLoading = false;
        isReLoading = false;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void canLoadingChange(bool loading) {
    isCanLoading = loading;
    notifyListeners();
  }

  void addData() {
    isDataAddLoding = true;
    notifyListeners();
  }

  void reLoadingPage() {
    isReLoading = true;
    notifyListeners();
  }

  Future<void> getNewsPostData({required String searchType}) async {
    try {
      List<PostModel> tempPostData = [];
      if (searchType == "AddData") {
        tempPostData = await _dbService.getNewPosts();
        tempPostData.forEach((e) {
          postData = [...postData, e];
        });
        isDataAddLoding = false;
      } else {
        if (searchType == "First") {
          isFirstLoading = true;
          Future.delayed(Duration.zero).then((value) => notifyListeners());
        }
        tempPostData = await _dbService.getNewPosts(isFirst: true);
        postData = tempPostData;
        isFirstLoading = false;
        isReLoading = false;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPostDataByType(int type, {required String searchType}) async {
    try {
      List<PostModel> tempPostData = [];
      if (searchType == "AddData") {
        tempPostData = await _dbService.getPostsByType(type);
        tempPostData.forEach((e) {
          postData = [...postData, e];
        });
        isDataAddLoding = false;
      } else {
        if (searchType == "First") {
          isFirstLoading = true;
          Future.delayed(Duration.zero).then((value) => notifyListeners());
        }
        tempPostData = await _dbService.getPostsByType(type, isFirst: true);
        postData = tempPostData;
        isFirstLoading = false;
        isReLoading = false;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createPost(String userUid, String title, String message, int type) async {
    try {
      await _dbService.createPost(userUid, title, message, type);

      List<PostModel> tempPostData = await _dbService.getPostsByType(type, isFirst: true);
      postData = [];
      tempPostData.forEach((e) {
        postData = [...postData, e];
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

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
        isGood = await _dbService.checkIsPostGood(postId, loginUserUID!);
        print(postId);
        print(isGood);
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
      this.otherUser = otherUser;
      globalKey?.currentState!.openEndDrawer();
    } else {
      this.choicedPostData = choicedPostData;
      if (loginUserData!.uid != choicedPostData!.createdBy) {
        print("moveToPost");
        await _dbService.moveToPost(choicedPostData.id);
      }
    }
    notifyListeners();
  }
}
