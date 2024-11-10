import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';

class APIListController<R> {
  APIListController();

  ScrollController scrollController = ScrollController();
  List<R> listData = [];
  late Future<List<R>> Function(int page, int size) apiFunc;
  LoadDataStatus loadDataStatus = LoadDataStatus.initial;
  APIListController<R> copyWith({
    List<R>? listData,
    LoadDataStatus? loadDataStatus,
    Future<List<R>> Function(int page, int size)? apiFunc,
  }) {
    return APIListController<R>()
      ..listData = listData ?? this.listData
      ..loadDataStatus = loadDataStatus ?? this.loadDataStatus
      ..apiFunc = apiFunc ?? this.apiFunc;
  }
}

class APIListControllerNotifier<R> extends StateNotifier<APIListController<R>> {
  APIListControllerNotifier(APIListController<R> state) : super(state);
  List<R> preLoadData = [];
  int page = 0;
  int size = 0;

  void create(int initSize) {
    page = 0;
    size = initSize;
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

  Future<void> replaceApi(Future<List<R>> Function(int page, int size) replaceApiFunc) async {
    bool needJumpToTop = false;
    if (state.listData.isNotEmpty) {
      needJumpToTop = true;
    }
    create(size);
    state.apiFunc = replaceApiFunc;
    state.listData = await state.apiFunc(page, size);
    page++;
    await _preLoad();
    state.loadDataStatus = LoadDataStatus.loadingFinish;
    if (needJumpToTop) {
      state.scrollController.jumpTo(0);
    }
  }

  Future<void> init(Future<List<R>> Function(int page, int size) initApiFunc) async {
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

  void addDataTofirst(R editedData) {
    List<R> nowStateList = state.listData;
    nowStateList.insert(0, editedData);

    state = state.copyWith(listData: nowStateList);
  }

  void addDataToLast(R editedData) {
    List<R> nowStateList = state.listData;
    nowStateList = [...nowStateList, editedData];

    state = state.copyWith(listData: nowStateList);
  }

  void removeData(int index) {
    List<R> nowStateList = state.listData;
    nowStateList.removeAt(index);

    state = state.copyWith(listData: nowStateList);
  }

  void editData(int index, R editedData) {
    List<R> nowStateList = state.listData;
    nowStateList[index] = editedData;

    state = state.copyWith(listData: nowStateList);
  }
}
