import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavigationBarProvider = StateProvider<int>((ref) {
  return 0;
});

final bottomNavationBarPosProvider = StateProvider<double>((ref) {
  return Platform.isIOS ? 25 : 9;
});

class GlobalViewModel {
  final WidgetRef ref;
  final Function render;

  static GlobalViewModel? _instance;

  GlobalViewModel._internal(this.ref, this.render);

  static void init(WidgetRef ref, Function render) {
    _instance ??= GlobalViewModel._internal(ref, render);
  }

  factory GlobalViewModel() {
    if (_instance == null) {
      throw Exception("GlobalViewModel has not been initialized. Call GlobalViewModel.init(ref, render) first.");
    }
    return _instance!;
  }

  void changeMainPage(int page) {
    ref.read(bottomNavigationBarProvider.notifier).update((state) => page);
    render();
  }

  void bottomBarHideStateChage(bool hide) {
    if (hide) {
      ref.read(bottomNavationBarPosProvider.notifier).update((state) => -60);
    } else {
      ref.read(bottomNavationBarPosProvider.notifier).update((state) => Platform.isIOS ? 25 : 9);
    }

    render();
  }
}
