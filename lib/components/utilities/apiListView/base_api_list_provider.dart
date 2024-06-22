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
  List<R> posts = [];
  int size = 5;
  int page = 0;
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
      List<R> tempPostsData = await apiFunc();
      posts = tempPostsData;
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
    int beforegetDataSize = posts.length;
    List<R> tempPostsData = await apiFunc();
    posts.addAll(tempPostsData);
    if (beforegetDataSize >= posts.length) {
      loadStatus = LoadDataStatus.allDataLoaded;
    }
  }

  Future<void> render() async {
    await Future.delayed(Duration.zero);
    notifyListeners();
  }
}
