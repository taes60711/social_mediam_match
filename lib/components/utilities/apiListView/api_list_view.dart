import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../CustomBouncingScrollPhysics.dart';
import '../loading.dart';
import '../stateful_wrapper.dart';

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

class APIListController<R> {
  APIListController();
  List<R> listData = [];
  late Future<List<R>> Function(int page, int size) apiFunc;
  int page = 0;
  int size = 5;
}

final listControllerProvider = StateNotifierProvider<APILIstControllerNotifier, APIListController>(
  (ref) => APILIstControllerNotifier(APIListController()),
);

class APILIstControllerNotifier extends StateNotifier<APIListController> {
  APILIstControllerNotifier(APIListController state) : super(state);

  Future<void> init(Future<List> Function(int page, int size) initApiFunc) async {
    int page = state.page;
    int size = state.size;
    state.apiFunc = initApiFunc;
    state.listData = await state.apiFunc(page, size);
    state = state;
  }
}

class APIListWidget<R> extends ConsumerStatefulWidget {
  final Future<List<R>> Function(int page, int size) apiFunc;
  final StateNotifierProvider<APILIstControllerNotifier, APIListController<dynamic>> listControllerProvider;
  final Widget? upWidget;
  final Widget Function(R data, int index) itemChild;
  const APIListWidget({
    super.key,
    required this.apiFunc,
    required this.listControllerProvider,
    this.upWidget,
    required this.itemChild,
  });

  @override
  ConsumerState<APIListWidget<R>> createState() => _APIListWidgetState<R>();
}

class _APIListWidgetState<R> extends ConsumerState<APIListWidget<R>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });

    super.initState();
  }

  Future<void> init() async {
    await ref.read(widget.listControllerProvider.notifier).init(widget.apiFunc);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(widget.listControllerProvider).listData.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                widget.upWidget ?? Container(),
                Column(
                  children: ref.watch(widget.listControllerProvider).listData.asMap().entries.map((e) {
                    int index = e.key;
                    R data = e.value;
                    return widget.itemChild(data, index);
                  }).toList(),
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
