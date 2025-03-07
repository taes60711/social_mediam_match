import '../models/app_info_model.dart';
import 'api_client.dart';

class AppInfoService extends ApiClient {
  AppInfoService() : super(overrideBranch: "/appInfo");

  Future<AppInfoModel> getAppInfo() async {
    AppInfoModel requestAppInfoData = AppInfoModel();
    try {
      String responseData = await apiGet('/getInfo');

      requestAppInfoData = await handleResponse<AppInfoModel>(
        responseData,
        model: AppInfoModel.toMap,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestAppInfoData;
  }
}
