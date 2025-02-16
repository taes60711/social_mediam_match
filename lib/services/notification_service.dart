import 'package:social_mediam_match/models/notification_model.dart';
import 'package:social_mediam_match/services/api_client.dart';

class NotificationService extends ApiClient {
  NotificationService() : super(overrideBranch: "/notification");

  ///ログインユーザの通知リストデータ取得する
  Future<List<NotificationModel>> requestNotificationList(int page, int size, {required String userUId}) async {
    List<NotificationModel> requestNotificationListData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
      'userUid': userUId,
    };

    try {
      String responseData = await apiGet('/getNotification', paramters: paramters);

      requestNotificationListData = await handleResponse<NotificationModel>(
        responseData,
        model: NotificationModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestNotificationListData;
  }

  ///読んでいない通知数量取得する
  Future<String> requestNoReadNotificationAmount({required String userUId}) async {
    String count = "0";
    Map<String, dynamic> paramters = {
      'userUid': userUId,
    };

    try {
      count = await apiGet('/notReadCount', paramters: paramters);
    } catch (e) {
      onRequestFailed();
    }
    return count;
  }

  ///通知作成する
  Future<bool> createNotification({required NotificationModel notification}) async {
    Map<String, dynamic> createNotificationMap = {
      "userUid": notification.userUid,
      "otherUserUid": notification.otherUserUid,
      "type": notification.type,
      "title": notification.title,
      "message": "",
      "postId": notification.postId,
    };

    if (notification.postId != null) {
      createNotificationMap['postId'] = notification.postId ?? -1;
    }
    if (notification.courseId != null) {
      createNotificationMap['courseId'] = notification.courseId ?? -1;
    }

    String responseData = await apiPush("/createNotification", body: createNotificationMap);

    print("createNotification $responseData");

    return responseData != "null" ? true : false;
  }

  ///通知読み込み
  Future<bool> updateReadNotificationCount({int? id, String? userUid}) async {
    String responseData = "null";

    if (id != null) {
      responseData = await apiPush("/readNotification", body: {
        "id": id,
      });
    } else {
      responseData = await apiPush("/readAllNotification", body: {
        "userUid": userUid,
      });
    }

    print("updateReadNotificationCount $responseData");

    return responseData != "null" ? true : false;
  }

  ///通知削除する
  Future<bool> deleteNotification({required int id}) async {
    String responseData = await apiPush("/deleteNotification", body: {
      "id": id,
    });

    print("deleteNotification $responseData");

    return responseData != "null" ? true : false;
  }
}
