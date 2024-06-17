import 'package:social_mediam_match/services/api_client.dart';
import '../../global.dart';

class ImageService extends ApiClient {
  ImageService() : super(overrideIp: "$ip:$port/images");
  String url = "http://$ip:$port/images";

  Future<String> getBase64Img(String image) async {
    String uid = "-1";
    try {
      uid = await apiGet64Img("/$image");
    } catch (e) {
      onRequestFailed();
    }

    return uid;
  }

  Future<String> imageIsExist(String image) async {
    Map<String, dynamic> body = {
      "image": image,
    };

    String responseData = await apiPush('/checkImage', body: body);

    print("imageIsExist : $responseData");

    return responseData != "null" ? responseData : "Failed";
  }

  Future<bool> saveImg(String id, String image) async {
    Map<String, dynamic> body = {
      "id": id,
      "image": image,
    };

    String responseData = await apiPush('/saveImg', body: body);

    print("imageIsExist : $responseData");

    return responseData != "null" ? true : false;
  }

  // Future<String> imageIsExist(String image) async {
  //   String uid = "-1";
  //   String searchUrl = '$url/checkImage';
  //   Map<String, String> headers = {'content-type': 'application/json'};
  //   final uri = Uri.parse(searchUrl);

  //   try {
  //     String body = jsonEncode({"image": image});

  //     var response = await http.put(uri, headers: headers, body: body);
  //     if (response.statusCode != 404) {
  //       print(response.body);
  //       uid = response.body;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

  //   return uid;
  // }

  // Future<bool> saveImage(String id, String image) async {
  //   bool isSucess = false;
  //   String searchUrl = '$url/saveImg';
  //   Map<String, String> headers = {'content-type': 'application/json'};

  //   final uri = Uri.parse(searchUrl);
  //   try {
  //     String body = jsonEncode({"id": id, "image": image});

  //     var response = await http.put(uri, headers: headers, body: body);
  //     if (response.statusCode != 404) {
  //       isSucess = true;
  //       print("saveImage sucess");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return isSucess;
  // }
}
