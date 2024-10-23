import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';

class APIListController<R> {
  APIListController();
  List<R> listData = [];
  late Future<List<R>> Function(int page, int size) apiFunc;
  LoadDataStatus loadDataStatus = LoadDataStatus.initial;
}

class APIListControllerNotifier extends StateNotifier<APIListController> {
  APIListControllerNotifier(APIListController state) : super(state);
  List preLoadData = [];
  int page = 0;
  int size = 5;

  void reLoad() {
    page = 0;
    state.loadDataStatus = LoadDataStatus.initial;
  }

  Future<void> init(Future<List> Function(int page, int size) initApiFunc) async {
    state.apiFunc = initApiFunc;
    state.listData = await state.apiFunc(page, size);
    page++;
    await _preLoad();
    state.loadDataStatus = LoadDataStatus.loadingFinish;
  }

  Future<void> insertData() async {
    state.listData.addAll(preLoadData);
    preLoadData.clear();
  }

  Future<void> _preLoad() async {
    preLoadData = await state.apiFunc(page, size);
    page++;
  }
}
