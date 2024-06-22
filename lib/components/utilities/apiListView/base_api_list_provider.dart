import 'package:flutter/material.dart';

enum LoadDataType {
  initial,
  insert,
  reload,
}

enum LoadDataStatus {
  initial,
  loading,
  loadingFinish,
  wantinSert,
  wantReload,
  allDataLoaded,
}

class BaseAPIListProvider<R> extends ChangeNotifier {
  List<R> listData = [];
  int size = 5;
  int page = 0;
  bool isTop = true;
  LoadDataStatus loadStatus = LoadDataStatus.loadingFinish;

  Future<void> insertData({
    required Future<List<R>> Function() apiFunc,
    required int size,
    required LoadDataType loadDataType,
  }) async {
    loadStatus = LoadDataStatus.loading;

    if (loadDataType == LoadDataType.insert) {
      size = size;
      await _loadData(apiFunc: apiFunc);
      page++;
    } else {
      List<R> tempData = await apiFunc();
      listData = tempData;
      page = 1;
    }

    if (loadStatus != LoadDataStatus.allDataLoaded) {
      loadStatus = LoadDataStatus.loadingFinish;
    }
    render();
  }

  void onLodaingStatusChange(LoadDataStatus loadDataStatus) {
    loadStatus = loadDataStatus;
    render();
  }

  Future<void> _loadData({required Future<List<R>> Function() apiFunc}) async {
    int beforegetDataSize = listData.length;
    List<R> tempData = await apiFunc();
    listData.addAll(tempData);
    if (beforegetDataSize >= listData.length) {
      loadStatus = LoadDataStatus.allDataLoaded;
    }
  }

  void onIsTopChange(bool isTopStatus) {
    isTop = isTopStatus;
    render();
  }

  Future<void> render() async {
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
