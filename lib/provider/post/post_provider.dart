import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/utilities/apiListView/api_list_controller.dart';

final listControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

final newlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);
