import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/utilities/style/screen_size.dart';

final bottomNavigationBarProvider = StateProvider<int>((ref) {
  return 0;
});

final bottomNavationBarPosProvider = StateProvider<double>((ref) {
  return Platform.isIOS ? 25 : 9;
});

class GlobalViewModel {
  static GlobalViewModel? _instance;

  GlobalViewModel._();

  factory GlobalViewModel() {
    return _instance ??= GlobalViewModel._();
  }

  late WidgetRef ref;
  late Function render;

  void init(WidgetRef ref, Function render) {
    this.ref = ref;
    this.render = render;
  }

  ///BottomNavigiatonbarのページコントローラー
  void changeMainPage(int page) {
    ref.read(bottomNavigationBarProvider.notifier).update((state) => page);
    render();
  }

  ///BottomNavigiatonbar隠れ/表示する
  void bottomBarHideStateChage(bool hide) {
    if (hide) {
      ref.read(bottomNavationBarPosProvider.notifier).update((state) => ScreenSize.fitPxHeight(-60));
    } else {
      ref.read(bottomNavationBarPosProvider.notifier).update((state) => Platform.isIOS ? 25 : 9);
    }
    render();
  }
}
