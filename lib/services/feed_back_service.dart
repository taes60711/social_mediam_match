import '../models/feed_back_model.dart';
import 'api_client.dart';

class UserFeedBackService extends ApiClient {
  UserFeedBackService() : super(overrideBranch: "/feedback");

  ///フィードバック作成
  Future<bool> createFeedBack(FeedBackModel feedBack) async {
    Map<String, dynamic> body = feedBack.toJson();

    String responseData = await apiPush('/create', body: body);

    print("createFeedBack : $responseData");

    return responseData != "null" ? true : false;
  }
}
