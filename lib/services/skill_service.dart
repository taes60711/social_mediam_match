import 'package:social_mediam_match/models/skill_model.dart';

import 'api_client.dart';

class SkillService extends ApiClient {
  SkillService() : super(overrideBranch: "/skill");

  ///MARK:  App全てのスキル種類
  Future<List<RequestSkillListData>> requestSkillList() async {
    List<RequestSkillListData> requestSkillListData = [];
    try {
      String responseData = await apiGet('/getList');

      requestSkillListData = await handleResponse<RequestSkillListData>(
        responseData,
        model: RequestSkillListData.toModel,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestSkillListData;
  }
}
