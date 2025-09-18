import 'package:social_mediam_match/services/api_client.dart';

class TokenService extends ApiClient {
  TokenService() : super(overrideBranch: "/token");

  ///MARK: Token取得
  Future<String> getToken({required String userId}) async {
    Map<String, dynamic> body = {
      "userId": userId,
    };

    String responseData = await apiPush("/getToken", body: body);

    ResponseData response = ResponseData.fromJson(responseData);

    return response.data['token'];
  }
}
