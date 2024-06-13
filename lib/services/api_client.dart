// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/route_options.dart';
import '../../global.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../components/utilities/custom_button.dart';
import '../components/utilities/style/style_config.dart';

class ApiClient {
  final String _ip;

  ApiClient({String? overrideIp}) : _ip = overrideIp ?? "$ip:$port";

  ///MARK: API Get Func
  Future<String> apiGet(
    String url, {
    Map<String, dynamic>? paramters,
  }) async {
    final uri = Uri.parse("http://$_ip$url").replace(queryParameters: paramters);
    print("Get API  Url : $url");
    Response response = await http.get(uri);

    try {
      if (response.statusCode != 200) {
        throw ArgumentError("${response.statusCode}");
      }
    } catch (e) {
      _onError(e);
      return "null";
    }

    return utf8.decode(response.bodyBytes);
  }

  ///MARK: API Push Func
  Future<String> apiPush(
    String url, {
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse("http://$_ip$url");
    Map<String, String> headers = {'content-type': 'application/json'};
    print("Push API Url : $url body : ${jsonEncode(body)}");
    Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode != 200) {
        throw ArgumentError("${response.statusCode}");
      }
    } catch (e) {
      _onError(e);
      return "null";
    }

    return "Success";
  }

  void _onError(dynamic errorMessage) {
    print("Error Message : $errorMessage");
  }

  //MARK: Response Handle
  ///APIclient取得したデータチェック：Get場合はデータモデルに加工する、Push場合は成功がどうか確認する
  Future<dynamic> handleResponse<T>(
    String responseData, {
    dynamic Function(Map<String, dynamic> json)? model,
    bool? isList,
  }) async {
    dynamic result;
    try {
      if (responseData == "null") {
        throw ArgumentError("service error");
      }
      if (model != null) {
        if (isList != null) {
          List<dynamic> listData = json.decode(responseData);
          result = <T>[];
          for (var e in listData) {
            result.add(model(e) as T);
          }
        } else {
          dynamic data = json.decode(responseData);
          result = model(data);
        }
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  void onRequestFailed({Function? onFailedFunc}) {
    showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            width: 180,
            height: 150,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Expanded(
                  child: Text('伺服器錯誤'),
                ),
                CustomButton(
                  title: '確認',
                  titleColor: normalTextColor,
                  backgroundColor: normalBgColor,
                  onPress: () {
                    onFailedFunc != null ? onFailedFunc() : RouteOptions.pagePop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
