import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';

// App 主題樣式
class ThemeStyle {
  static ThemeStyle? _instance;

  // 私有構造函數
  ThemeStyle._();

  // 獲取單例實例
  factory ThemeStyle() {
    return _instance ??= ThemeStyle._();
  }

  late WidgetRef ref;

  // 初始化主題樣式
  Future<void> init(WidgetRef ref) async {
    this.ref = ref;

    /// 取得主題值
    _getStyles();
  }

  // 更改主題(呼叫)
  Future<void> onChangeTeme(AppThemeType newTheme) async {
    print("ThemeStyle OnChangeTheme ${newTheme.strName}");

    ///驅動Provider
    ref.read(appThemeControllerProvider.notifier).updateTheme(newTheme);

    /// 取得主題值
    _getStyles();
  }

  /// MARK: 主題顏色值 Start
  /// 樣式
  static late Color bgColor;
  // 更新顏色樣式
  void _getStyles() {
    bgColor = _colorManager(whiteColor: AppColors.whiteColor, blackColor: AppColors.black28);
  }

  /// MARK: 主題顏色值 End

  // 根據當前主題返回顏色
  dynamic _colorManager({required dynamic whiteColor, required dynamic blackColor}) {
    switch (ref.read(appThemeControllerProvider.notifier).currentTheme()) {
      case AppThemeType.black:
        return blackColor;
      case AppThemeType.white:
        return whiteColor;
    }
  }
}

// App 主題顏色類型
enum AppThemeType {
  white(strName: "white"),
  black(strName: "black");

  final String strName;

  const AppThemeType({
    required this.strName,
  });
}

// App 主題控制器 Provider
final appThemeControllerProvider = StateNotifierProvider<AppThemeSettingNotifier, AppThemeType>((ref) {
  return AppThemeSettingNotifier(AppThemeType.black);
});

// App 主題控制器
class AppThemeSettingNotifier extends StateNotifier<AppThemeType> {
  AppThemeSettingNotifier(AppThemeType state) : super(state);

  AppThemeType currentTheme() {
    return state;
  }

  void updateTheme(AppThemeType newTheme) {
    state = newTheme;
  }
}
