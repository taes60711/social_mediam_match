import 'package:social_mediam_match/services/api_client.dart';

import '../global.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostService extends ApiClient {
  PostService() : super(overrideIp: "$ip:$port/posts");

  Future<List<PostModel>> getPostDataByUID(int page, int size, LoginUser userData) async {
    List<PostModel> requestPostDataByUID = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getPostsByUser/${userData.uid}', paramters: paramters);

      requestPostDataByUID = await handleResponse<PostModel>(
        responseData,
        model: PostModel.myPostToMap,
        isList: true,
      );

      requestPostDataByUID.map((e) => PostModel.noUserDataPostAddUserData(noUserDatPost: e, userData: userData)).toList();
    } catch (e) {
      onRequestFailed();
    }

    return requestPostDataByUID;
  }
}
