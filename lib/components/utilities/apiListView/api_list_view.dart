import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../CustomBouncingScrollPhysics.dart';
import '../../../global/home_global_view_model.dart';
import '../custom_button.dart';
import '../loading.dart';
import 'api_list_controller.dart';

class APIListWidget<R> extends ConsumerStatefulWidget {
  final int size;
  final bool isNeedToTopBtn;
  final Future<List<R>> Function(int page, int size) apiFunc;
  final StateNotifierProvider<APIListControllerNotifier, APIListController<dynamic>> listControllerProvider;
  final Widget? loadingWidget;
  final Widget? noDataWidget;
  final Widget? customFloatBtn;
  final Widget Function(R data, int index) itemChild;
  const APIListWidget({
    super.key,
    this.size = 5,
    this.isNeedToTopBtn = true,
    required this.apiFunc,
    required this.listControllerProvider,
    this.loadingWidget,
    this.noDataWidget,
    this.customFloatBtn,
    required this.itemChild,
  });

  @override
  ConsumerState<APIListWidget<R>> createState() {
    return _APIListWidgetState<R>();
  }
}

class _APIListWidgetState<R> extends ConsumerState<APIListWidget<R>> {
  bool isScrollUp = true;
  bool isTop = true;
  double scrollStartPos = 0;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    ///init前に
    ref.read(widget.listControllerProvider.notifier).create(widget.size);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ///実際的init
      await ref.read(widget.listControllerProvider.notifier).init(widget.apiFunc);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    LoadDataStatus loadDataStatus = ref.read(widget.listControllerProvider).loadDataStatus;

    if (loadDataStatus != LoadDataStatus.initial) {
      if (ref.read(widget.listControllerProvider).listData.isEmpty) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: widget.noDataWidget ??
              Center(
                child: Text(
                  "NoData",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
        );
      }

      ///データロード終わり場合
      child = Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          ///データ不足場合は高さ画面合うよう
          height: ScreenSize.height,
          child: Stack(
            children: [
              SizedBox(
                ///データ不足場合は高さ画面合うよう
                height: ScreenSize.height,
                child: SingleChildScrollView(
                  physics: scrollPhysics(context),
                  controller: ref.watch(widget.listControllerProvider).scrollController,
                  child: Column(
                    children: [
                      ///データリロード
                      Visibility(
                        visible: ref.watch(widget.listControllerProvider).loadDataStatus == LoadDataStatus.wantReload,
                        child: const Loading(),
                      ),

                      ///項目リスト
                      Column(
                        children: ref.watch(widget.listControllerProvider).listData.asMap().entries.map((e) {
                          int index = e.key;
                          R data = e.value;
                          return widget.itemChild(data, index);
                        }).toList(),
                      ),

                      ///データインサート
                      Visibility(
                        visible: ref.watch(widget.listControllerProvider).loadDataStatus == LoadDataStatus.wantinSert,
                        child: const Loading(),
                      ),
                    ],
                  ),
                ),
              ),

              ///　FloatButton
              Builder(
                builder: (context) {
                  double flatButtonPos = ScreenSize.fitPxHeight(-60);

                  if (widget.customFloatBtn != null) {
                    flatButtonPos = ScreenSize.fitPxHeight(-100);
                  }
                  if (ref.watch(bottomNavationBarPosProvider) == ScreenSize.fitPxHeight(-60)) {
                    flatButtonPos = ScreenSize.fitPxHeight(15);
                  }

                  return !widget.isNeedToTopBtn
                      ? Container()
                      : AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          right: ScreenSize.fitPxWidth(15),
                          bottom: flatButtonPos,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /// カスタム FloatBtn
                              widget.customFloatBtn ?? Container(),

                              SizedBox(height: ScreenSize.fitPxHeight(10)),

                              ///トップに移動ボタン
                              MainBtn(
                                width: ScreenSize.fitPxWidth(40),
                                height: ScreenSize.fitPxWidth(40),
                                backgroundColor: AppColors.greyColor98,
                                borderRadius: 25,
                                onPress: () {
                                  ref.watch(widget.listControllerProvider).scrollController.animateTo(
                                        0,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      );
                                },
                                child: Icon(
                                  FontAwesomeIcons.angleUp,
                                  size: 16,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      );
    } else if (loadDataStatus == LoadDataStatus.initial) {
      ///ページに初めで遷移場合
      child = widget.loadingWidget ?? const Center(child: Loading());
    }
    return listenListView(context, child: child);
  }

  /// スクロール制御方
  ScrollPhysics? scrollPhysics(BuildContext context) {
    if (ref.watch(widget.listControllerProvider).listData.length < ref.read(widget.listControllerProvider.notifier).size) {
      ///データ不足場合
      return const AlwaysScrollableScrollPhysics();
    } else {
      ///普通場合
      return const NoBouncingScrollPhysics();
    }
  }

  ///LisViewの状態をリスン
  Widget listenListView(BuildContext context, {required child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        /// only listen depth list == 0
        if (scrollNotification.depth != 0) {
          return false;
        }

        if (scrollNotification is ScrollStartNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;

          ///最初スクロールところ取得
          scrollStartPos = scrollPosition;
        }

        if (scrollNotification is ScrollUpdateNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          final max = scrollNotification.metrics.maxScrollExtent;

          if (max != 0) {
            ///最上部場合bottomBar表示される
            if (scrollPosition == 0) {
              if (widget.isNeedToTopBtn) {
                HomeGlobalViewModel().bottomBarHideStateChage(false);
              }
              isScrollUp = true;
              return false;
            }

            bool isScrollingUp = scrollPosition < scrollStartPos;

            if (!isScrollUp) {
              if (isScrollingUp) {
                ///スクロール上に移動したら、bottomBar表示される
                if (widget.isNeedToTopBtn) {
                  HomeGlobalViewModel().bottomBarHideStateChage(false);
                }

                isScrollUp = true;
              }
              if (ref.read(widget.listControllerProvider).loadDataStatus == LoadDataStatus.loadingFinish) {
                ///画面最下部場合、プリデータロード
                if (scrollPosition >= max - ScreenSize.fitPxHeight(10)) {
                  ref.read(widget.listControllerProvider.notifier).onLoadStatusChange(LoadDataStatus.wantinSert);

                  ///プリロードデータインサート
                  ref.read(widget.listControllerProvider.notifier).insertData().then((_) {
                    ///プリロードデータない
                    if (ref.read(widget.listControllerProvider).loadDataStatus == LoadDataStatus.allDataLoaded) {
                      setState(() {});
                    }
                  });

                  ///プリロードデータある
                  if (ref.read(widget.listControllerProvider).loadDataStatus != LoadDataStatus.allDataLoaded) {
                    setState(() {});
                  }
                }
              }
            } else {
              ///TOPでいる
              if (isTop) {
                bool isPosNotInTop = scrollPosition >= 20;
                if (isPosNotInTop) {
                  ///TOPでないって設定する
                  isTop = false;
                }

                ///画面の最上部し、アップに移動する（リロードしたい場合）
                if (scrollPosition <= -ScreenSize.fitPxHeight(20)) {
                  ///ステータス：リロードに設定する
                  if (ref.read(widget.listControllerProvider).loadDataStatus != LoadDataStatus.wantReload) {
                    ref.read(widget.listControllerProvider.notifier).onLoadStatusChange(LoadDataStatus.wantReload);
                    setState(() {});
                  }
                }

                ///TOPでない
              } else {
                if (!isScrollingUp) {
                  /// bottomBar隠れる
                  if (widget.isNeedToTopBtn) {
                    HomeGlobalViewModel().bottomBarHideStateChage(true);
                  }
                  isScrollUp = false;
                }
              }
            }
          }
        }

        if (scrollNotification is ScrollEndNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;

          ///TOPでない
          if (!isTop) {
            bool isPosNotInTop = scrollPosition <= ScreenSize.fitPxHeight(10);
            if (isPosNotInTop) {
              ///TOPでるって設定する
              isTop = true;
            }

            ///TOPでいる
          } else {
            ///ステータス：リロードに設定すると、実際的API呼び
            if (ref.read(widget.listControllerProvider).loadDataStatus == LoadDataStatus.wantReload) {
              ref.read(widget.listControllerProvider.notifier).reload().then((value) => setState(() {}));
            }
          }
        }

        return false;
      },
      child: child,
    );
  }
}
