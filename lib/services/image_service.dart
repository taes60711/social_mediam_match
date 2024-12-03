import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_mediam_match/services/api_client.dart';
import '../../global.dart';
import 'package:http/http.dart' as http;

import '../components/utilities/lodaing_dialog.dart';

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

  ///画像をスマホにダウンロードするとshareする
  Future<void> shareImage(String imgUrl) async {
    LoadingDialog().show();
    final response = await http.get(Uri.parse(imgUrl));

    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();

      final filePath = '${directory.path}/image.jpg';
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      LoadingDialog().close();
      XFile imageFile = XFile(filePath);
      await Share.shareXFiles([imageFile]);
    }
  }

  ///画像をスマホのアルバムに保存する
  Future<void> saveImageToLocal(String imgUrl) async {
    LoadingDialog().show();
    final response = await http.get(Uri.parse(imgUrl));

    final Uint8List imageBytes = response.bodyBytes;
    final result = await ImageGallerySaver.saveImage(imageBytes);
    LoadingDialog().close();
    print(result);
  }
}
