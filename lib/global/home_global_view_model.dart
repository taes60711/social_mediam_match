import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/utilities/style/screen_size.dart';
import '../global.dart';

final bottomNavigationBarProvider = StateProvider<int>((ref) {
  return 0;
});

final bottomNavationBarPosProvider = StateProvider<double>((ref) {
  return Platform.isIOS ? 25 : 9;
});

class HomeGlobalViewModel {
  static HomeGlobalViewModel? _instance;

  HomeGlobalViewModel._();

  factory HomeGlobalViewModel() {
    return _instance ??= HomeGlobalViewModel._();
  }

  late WidgetRef ref;
  late Function render;

  void init({required WidgetRef ref, required Function render}) {
    this.ref = ref;
    this.render = render;
  }

  bool keyboardIsFocus = false;

  void keyboardFocusOnChange(bool focus) {
    keyboardIsFocus = focus;
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

  static void pop() {
    Navigator.of(globalContext).pop();
  }
}
