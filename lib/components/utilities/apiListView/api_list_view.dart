import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../CustomBouncingScrollPhysics.dart';
import '../../../global/global_view_model.dart';
import '../loading.dart';
import '../stateful_wrapper.dart';
import 'api_list_controller.dart';

enum ListType {
  normal,
  grid,
}

class APIListView<R> extends StatelessWidget {
  final Widget Function(List<R> data, int index) itemChild;
  final Widget Function() loadingBuilder;
  final Widget? noDataBuilder;
  final Widget? noInitSearchBuilder;
  final Future<List<R>> Function(int page, int size) apiFunc;
  final List<R> providerList;
  final int size;
  final bool needToTopWidget;
  final Widget? customFloatbutton;
  final ListType listType;

  const APIListView({
    Key? key,
    required this.itemChild,
    required this.loadingBuilder,
    this.noDataBuilder,
    this.noInitSearchBuilder,
    required this.apiFunc,
    required this.providerList,
    this.size = 5,
    this.needToTopWidget = true,
    this.customFloatbutton,
    this.listType = ListType.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return StatefulWrapper(
      onInit: () async {
        if (noInitSearchBuilder == null) {
          context.read<BaseAPIListProvider<R>>().initApiFunc(initApiFunc: apiFunc);
          initLoadData(context, loadDataType: LoadDataType.initial);
        } else {
          context.read<BaseAPIListProvider<R>>().initNoSearch();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Builder(
          builder: (context) {
            bool isScrollUp = context.read<BaseAPIListProvider<R>>().isScrollUp;
            return AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset: isScrollUp ? const Offset(0, 1) : const Offset(0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: customFloatbutton != null,
                    child: customFloatbutton ?? Container(),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: needToTopWidget && !context.read<BaseAPIListProvider<R>>().isTop,
                    child: GestureDetector(
                      onTap: () {
                        scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: normalBgColor2,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          FontAwesomeIcons.angleUp,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        body: Builder(builder: (context) {
          LoadDataStatus nowLoadingStatus = context.select((BaseAPIListProvider<R> value) => value.loadStatus);

          Widget component = Container();

          if (nowLoadingStatus == LoadDataStatus.initial) {
            component = loadingBuilder();
          } else if (nowLoadingStatus == LoadDataStatus.initNoSearch) {
            component = noInitSearchBuilder ?? Container();
          } else {
            if (providerList.isEmpty) {
              component = noDataBuilder ?? Container();
            } else {
              component = listenListView(
                context,
                child: listType == ListType.normal
                    ? ListView.builder(
                        itemCount: providerList.length,
                        controller: scrollController,
                        physics: scrollPhysics(context),
                        itemBuilder: (context, index) {
                          if (providerList.length == 1) {
                            return Column(
                              children: [
                                ///再度読み込む時表示される
                                reloadWidget(),

                                this.itemChild(providerList, index),

                                ///すべでデータ読み込みたら表示される
                                allDataLoadedWidget(),
                              ],
                            );
                          } else if (index == 0) {
                            return Column(
                              children: [
                                ///再度読み込む時表示される
                                reloadWidget(),

                                this.itemChild(providerList, index),
                              ],
                            );
                          } else if (index == providerList.length - 1 && size > providerList.length) {
                            return Column(
                              children: [
                                this.itemChild(providerList, index),

                                ///すべでデータ読み込みたら表示される
                                allDataLoadedWidget(),
                              ],
                            );
                          } else if (index == providerList.length - 1) {
                            return Column(
                              children: [
                                this.itemChild(providerList, index),

                                ///データ読み込んてる場合表示される
                                loadingWidget(),

                                ///すべでデータ読み込みたら表示される
                                allDataLoadedWidget(),
                              ],
                            );
                          } else {
                            return this.itemChild(providerList, index);
                          }
                        },
                      )
                    : SingleChildScrollView(
                        physics: scrollPhysics(context),
                        controller: scrollController,
                        child: Column(
                          children: [
                            ///再度読み込む時表示される
                            reloadWidget(),

                            Wrap(
                              children: providerList.asMap().entries.map(
                                (e) {
                                  int index = e.key;
                                  double pad = 10;
                                  EdgeInsetsGeometry padding = EdgeInsets.only(left: pad / 2, right: pad);
                                  if (index % 2 == 0) {
                                    padding = EdgeInsets.only(left: pad, right: pad / 2);
                                  }
                                  return Container(
                                    padding: padding,
                                    width: ScreenSize.width / 2,
                                    child: this.itemChild(providerList, index),
                                  );
                                },
                              ).toList(),
                            ),

                            ///データ読み込んてる場合表示される
                            loadingWidget(),

                            ///すべでデータ読み込みたら表示される
                            allDataLoadedWidget(),
                          ],
                        ),
                      ),
              );
            }
          }

          return component;
        }),
      ),
    );
  }

  ///LisViewの状態をリスン
  Widget listenListView(BuildContext context, {required child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        /// only listen depth list == 0
        if (scrollNotification.depth != 0) {
          return false;
        }

        LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;

        if (scrollNotification is ScrollStartNotification) {
          context.read<BaseAPIListProvider<R>>().onScrollingPosChange(scrollNotification.metrics.pixels);
        }

        if (scrollNotification is ScrollUpdateNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          final max = scrollNotification.metrics.maxScrollExtent;

          /// スクロール箇所が最TOPチェック
          bool isTop = context.read<BaseAPIListProvider<R>>().isTop;
          bool isScrollUp = context.read<BaseAPIListProvider<R>>().isScrollUp;
          bool isScrollingUp = scrollPosition < context.read<BaseAPIListProvider<R>>().startScrollPos;
          if (needToTopWidget) {
            if (isScrollingUp) {
              if (!isScrollUp) {
                context.read<BaseAPIListProvider<R>>().onScrollUpOnChange(true);
              }
            } else {
              if (isScrollUp) {
                context.read<BaseAPIListProvider<R>>().onScrollUpOnChange(false);
              }
              if (isTop) {
                bool isPosNotInTop = scrollPosition >= 20;

                if (isPosNotInTop) {
                  context.read<BaseAPIListProvider<R>>().onIsTopChange(false);
                }
              }
            }
          }

          ///
          if (nowLoadDataStatus == LoadDataStatus.loadingFinish || nowLoadDataStatus == LoadDataStatus.allDataLoaded) {
            ///再度読み込む
            if (isTop) {
              if (scrollPosition <= 0) {
                context.read<BaseAPIListProvider<R>>().onLodaingStatusChange(LoadDataStatus.wantReload);
              }
            }

            ///全てデータ読み込みたら追加ロードできなくなる
            if (nowLoadDataStatus != LoadDataStatus.allDataLoaded) {
              if (scrollPosition >= max && max != 0) {
                context.read<BaseAPIListProvider<R>>().onLodaingStatusChange(LoadDataStatus.wantinSert);
              }
            }
          }
        }

        ///API読み込む
        if (scrollNotification is ScrollEndNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;

          /// スクロール箇所が最TOPチェック
          bool isTop = context.read<BaseAPIListProvider<R>>().isTop;
          if (!isTop && needToTopWidget) {
            if (scrollPosition < 10) {
              context.read<BaseAPIListProvider<R>>().onIsTopChange(true);
            }
          }

          ///追加データ
          if (nowLoadDataStatus == LoadDataStatus.wantinSert) {
            int loadPage = context.read<BaseAPIListProvider<R>>().page;
            context.read<BaseAPIListProvider<R>>().insertData(
                  apiFunc: () async => await apiFunc(loadPage, size),
                  size: size,
                  loadDataType: LoadDataType.insert,
                );

            ///リロードデータ
          } else if (nowLoadDataStatus == LoadDataStatus.wantReload) {
            initLoadData(context, loadDataType: LoadDataType.reload);
          }
        }
        return false;
      },
      child: child,
    );
  }

  /// スクロール制御方
  ScrollPhysics? scrollPhysics(BuildContext context) {
    LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;

    if (context.read<BaseAPIListProvider<R>>().listData.length < size) {
      return const AlwaysScrollableScrollPhysics();
    } else if (nowLoadDataStatus != LoadDataStatus.allDataLoaded) {
      return const BouncingScrollPhysics();
    } else {
      return const CustomBouncingScrollPhysics();
    }
  }

  /// はじめロード、プリロードデータ
  Future<void> initLoadData(BuildContext context, {required LoadDataType loadDataType}) async {
    int page = 0;

    await context
        .read<BaseAPIListProvider<R>>()
        .insertData(
          apiFunc: () async => await context.read<BaseAPIListProvider<R>>().apiFunc(page, size),
          size: size,
          loadDataType: loadDataType,
        )
        .then(
      (_) async {
        int preLoadPage = context.read<BaseAPIListProvider<R>>().page;

        print("initLoadData $preLoadPage");
        await context.read<BaseAPIListProvider<R>>().preLoad(
              apiFunc: () async => await context.read<BaseAPIListProvider<R>>().apiFunc(preLoadPage, size),
            );
      },
    );
  }

  /// データ読み込んてる場合表示される
  Widget loadingWidget() {
    return Builder(builder: (context) {
      LoadDataStatus nowLoadDataStatus = context.select((BaseAPIListProvider<R> value) => value.loadStatus);
      return Visibility(
        visible: nowLoadDataStatus != LoadDataStatus.allDataLoaded,
        child: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 50),
          child: Loading(),
        ),
      );
    });
  }

  /// すべでデータ読み込みたら表示される
  Widget allDataLoadedWidget() {
    return Builder(builder: (context) {
      LoadDataStatus nowLoadDataStatus = context.select((BaseAPIListProvider<R> value) => value.loadStatus);
      return Visibility(
        visible: nowLoadDataStatus == LoadDataStatus.allDataLoaded,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.commentSlash,
                color: normalBgColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  tr("NodataCanLoad"),
                  style: TextStyle(color: normalBgColor2, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 再度読み込む時表示される
  Widget reloadWidget() {
    return Builder(builder: (context) {
      LoadDataStatus nowLoadDataStatus = context.select((BaseAPIListProvider<R> value) => value.loadStatus);
      return Visibility(
        visible: nowLoadDataStatus == LoadDataStatus.wantReload,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Loading(),
        ),
      );
    });
  }
}

class APIListWidget<R> extends ConsumerStatefulWidget {
  final Future<List<R>> Function(int page, int size) apiFunc;
  final StateNotifierProvider<APIListControllerNotifier, APIListController<dynamic>> listControllerProvider;
  final Widget? upWidget;
  final Widget? loadingWidget;
  final Widget Function(R data, int index) itemChild;
  const APIListWidget({
    super.key,
    required this.apiFunc,
    required this.listControllerProvider,
    this.upWidget,
    this.loadingWidget,
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
    ref.read(widget.listControllerProvider.notifier).create();
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
                      Builder(builder: (context) {
                        return widget.upWidget ?? Container();
                      }),

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
                  if (ref.watch(bottomNavationBarPosProvider) == ScreenSize.fitPxHeight(-60)) {
                    flatButtonPos = ScreenSize.fitPxHeight(15);
                  }

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    right: ScreenSize.fitPxWidth(15),
                    bottom: flatButtonPos,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ///トップに移動ボタン
                        GestureDetector(
                          onTap: () {
                            ref.watch(widget.listControllerProvider).scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear,
                                );
                          },
                          child: Container(
                            width: ScreenSize.fitPxWidth(40),
                            height: ScreenSize.fitPxWidth(40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.greyColor98,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              FontAwesomeIcons.angleUp,
                              size: 16,
                              color: Colors.white,
                            ),
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
        // print(scrollNotification.runtimeType);

        /// only listen depth list == 0
        if (scrollNotification.depth != 0) {
          return false;
        }

        if (scrollNotification is ScrollStartNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          scrollStartPos = scrollPosition;
        }

        if (scrollNotification is ScrollUpdateNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          final max = scrollNotification.metrics.maxScrollExtent;

          bool isScrollingUp = scrollPosition < scrollStartPos;

          if (!isScrollUp) {
            if (isScrollingUp) {
              /// bottomBar表示される
              GlobalViewModel().bottomBarHideStateChage(false);
              isScrollUp = true;
            }
            if (ref.read(widget.listControllerProvider).loadDataStatus == LoadDataStatus.loadingFinish) {
              if (scrollPosition >= max - ScreenSize.fitPxHeight(10) && max != 0) {
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

              ///TOPでるし、アップに移動する（リロードしたい場合）
              if (scrollPosition <= 0) {
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
                GlobalViewModel().bottomBarHideStateChage(true);
                isScrollUp = false;
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
