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

  void create() {
    page = 0;
    state.loadDataStatus = LoadDataStatus.initial;
  }

  void onLoadStatusChange(LoadDataStatus status) {
    state.loadDataStatus = status;
  }

  Future<void> reload() async {
    page = 0;
    state.listData = await state.apiFunc(page, size);
    page++;
    await _preLoad();
    state.loadDataStatus = LoadDataStatus.loadingFinish;
  }

  Future<void> replaceApi(Future<List> Function(int page, int size) replaceApiFunc) async {
    create();
    state.apiFunc = replaceApiFunc;
    state.listData = await state.apiFunc(page, size);
    page++;
    await _preLoad();
    state.loadDataStatus = LoadDataStatus.loadingFinish;
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
    await _preLoad();
  }

  Future<void> _preLoad() async {
    preLoadData = await state.apiFunc(page, size);
    if (preLoadData.isEmpty) {
      state.loadDataStatus = LoadDataStatus.allDataLoaded;
    } else {
      state.loadDataStatus = LoadDataStatus.loadingFinish;
      page++;
    }
  }
}
