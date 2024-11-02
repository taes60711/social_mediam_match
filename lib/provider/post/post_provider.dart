import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/utilities/apiListView/api_list_controller.dart';
import '../../models/post_model.dart';

final listControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final newlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final topPostProvider = StateProvider<List<PostModel>>((ref) {
  return [];
});

final choicedPostProvider = StateProvider<PostModel>((ref) {
  return PostModel();
});
