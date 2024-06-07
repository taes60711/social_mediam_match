import 'package:social_mediam_match/models/skill_model.dart';
import 'package:social_mediam_match/states/services/api_client.dart';

import '../../global.dart';

class SkillService extends ApiClient {
  SkillService() : super(overrideIp: "$ip:$port/skill");

  Future<List<RequestSkillListData>> requestSkillList() async {
    String responseData = await apiGet('/getList');

    List<RequestSkillListData> requestSkillListData = await handleResponse<RequestSkillListData>(
      responseData,
      model: RequestSkillListData.toModel,
      isList: true,
    );
    return requestSkillListData;
  }
}
