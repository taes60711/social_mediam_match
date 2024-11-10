import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/utilities/apiListView/api_list_controller.dart';
import '../../models/post_model.dart';

final myPostlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final listControllerProvider = StateNotifierProvider<APIListControllerNotifier<PostModel>, APIListController<PostModel>>(
  (ref) => APIListControllerNotifier(APIListController<PostModel>()),
);

final newlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final textFilterControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final topPostProvider = StateProvider<List<PostModel>>((ref) {
  return [];
});

final allPostBoardListData = StateProvider<List<PostBoard>>((ref) {
  return [];
});

final choicedPostBoardProvider = StateProvider<PostBoard>((ref) {
  return PostBoard();
});

final choicedPostProvider = StateProvider<PostModel>((ref) {
  return PostModel();
});

final postCommentListControllerProvider =
    StateNotifierProvider<APIListControllerNotifier<PostCommentTextEditorModel>, APIListController<PostCommentTextEditorModel>>(
  (ref) => APIListControllerNotifier(APIListController<PostCommentTextEditorModel>()),
);

final postCreateChoiceBoard = StateProvider<PostBoard>((ref) {
  return PostBoard();
});
