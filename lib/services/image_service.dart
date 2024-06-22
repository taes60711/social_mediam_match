import 'package:social_mediam_match/services/api_client.dart';
import '../../global.dart';

class ImageService extends ApiClient {
  ImageService() : super(overrideIp: "$ip:$port/images");

  ///base64画像string取得する
  Future<String> getBase64Img(String image) async {
    String uid = "-1";
    try {
      uid = await apiGet64Img("/$image");
    } catch (e) {
      onRequestFailed();
    }

    return uid;
  }

  ///画像がデータベースに存在チェック
  Future<String> imageIsExist(String image) async {
    Map<String, dynamic> body = {
      "image": image,
    };

    String responseData = await apiPush('/checkImage', body: body);

    print("imageIsExist : $responseData");

    return responseData != "null" ? responseData : "Failed";
  }

  ///画像がデータベースに保存
  Future<bool> saveImg(String id, String image) async {
    Map<String, dynamic> body = {
      "id": id,
      "image": image,
    };

    String responseData = await apiPush('/saveImg', body: body);

    print("imageIsExist : $responseData");

    return responseData != "null" ? true : false;
  }
}
