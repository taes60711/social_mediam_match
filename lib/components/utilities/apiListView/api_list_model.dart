import 'package:flutter_riverpod/flutter_riverpod.dart';

class APIListModel<R> {
  APIListModel();
  List<R> listData = [];
  late Future<List<R>> Function(int page, int size) apiFunc;
  int page = 0;
  int size = 5;
}

class APIListModelNotifier extends StateNotifier<APIListModel> {
  APIListModelNotifier(APIListModel state) : super(state);

  Future<void> init(Future<List> Function(int page, int size) initApiFunc) async {
    int page = state.page;
    int size = state.size;
    state.apiFunc = initApiFunc;
    state.listData = await state.apiFunc(page, size);
    state = state;
  }
}
