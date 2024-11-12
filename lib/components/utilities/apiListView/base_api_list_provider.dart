import 'dart:developer';

import 'package:flutter/material.dart';

enum LoadDataType {
  initial,
  insert,
  reload,
  finish,
}

enum LoadDataStatus {
  initNoSearch,
  initial,
  loading,
  loadingFinish,
  wantinSert,
  wantReload,
  allDataLoaded,
  allDataLoadingFinish,
}

class BaseAPIListProvider<R> extends ChangeNotifier {
  List<R> _preLoadData = [];
  List<R> listData = [];
  R? choiceData;
  int size = 5;
  int page = 0;
  bool isTop = true;
  double startScrollPos = 0.0;
  bool isScrollUp = true;
  LoadDataStatus loadStatus = LoadDataStatus.loadingFinish;
  late Future<List<R>> Function(int page, int size) apiFunc;

  void initApiFunc({required Future<List<R>> Function(int page, int size) initApiFunc}) {
    apiFunc = initApiFunc;
    render();
  }

  Future<void> replaceApiFunc(int size, {required Future<List<R>> Function(int page, int size) replaceApiFunc}) async {
    apiFunc = replaceApiFunc;
    await reloadData(apiFunc: () => apiFunc(0, size));
    await preLoad(apiFunc: () => apiFunc(1, size));
    render();
  }

  void initNoSearch() {
    loadStatus = LoadDataStatus.initNoSearch;
    render();
  }

  Future<void> reloadData({required Future<List<R>> Function() apiFunc}) async {
    loadStatus = LoadDataStatus.loading;
    List<R> tempReloadData = await apiFunc();
    listData = tempReloadData;
    page = 1;
    render();
  }

  void onChoiceData({required R choicedData}) {
    choiceData = choicedData;
    render();
  }

  void editData({int? dataIndex, required R updatedData}) {
    int wantUpdateDataIndex = -1;
    if (dataIndex != null) {
      wantUpdateDataIndex = dataIndex;
    } else {
      wantUpdateDataIndex = listData.indexWhere((element) => element == choiceData);
    }

    listData[wantUpdateDataIndex] = updatedData;
    render();
  }

  void deleteData({required R choiceData}) {
    listData.remove(choiceData);
    render();
  }

  void createData({required R createdData}) {
    listData.insert(0, createdData);
    render();
  }

  Future<void> insertData({
    required Future<List<R>> Function() apiFunc,
    required int size,
    required LoadDataType loadDataType,
  }) async {
    loadStatus = LoadDataStatus.loading;
    if (loadDataType == LoadDataType.insert) {
      listData.addAll(_preLoadData);
      render();
      await preLoad(apiFunc: apiFunc);
    } else {
      if (loadDataType == LoadDataType.initial) {
        loadStatus = LoadDataStatus.initial;
      }
      size = size;
      render();

      List<R> tempData = await apiFunc();
      listData = tempData;
      inspect(listData);
      page = 1;
    }
  }

  Future<void> preLoad({required Future<List<R>> Function() apiFunc}) async {
    print("preloadPage $page");
    List<R> tempPreLoadData = await apiFunc();
    _preLoadData = tempPreLoadData;
    inspect(_preLoadData);
    if (tempPreLoadData.isEmpty) {
      loadStatus = LoadDataStatus.allDataLoaded;
    } else if (tempPreLoadData.length < size) {
      listData.addAll(_preLoadData);
      loadStatus = LoadDataStatus.allDataLoaded;
    } else {
      if (loadStatus != LoadDataStatus.allDataLoaded) {
        loadStatus = LoadDataStatus.loadingFinish;
      }
    }
    page++;
    render();
  }

  void onLodaingStatusChange(LoadDataStatus loadDataStatus) {
    loadStatus = loadDataStatus;
    render();
  }

  void onIsTopChange(bool isTopStatus) {
    isTop = isTopStatus;
    render();
  }

  void onScrollingPosChange(double isScrollingUpStatus) {
    startScrollPos = isScrollingUpStatus;
    render();
  }

  void onScrollUpOnChange(bool isScrollUpStatus) {
    isScrollUp = isScrollUpStatus;
    render();
  }

  Future<void> render() async {
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
