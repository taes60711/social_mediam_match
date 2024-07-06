import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../CustomBouncingScrollPhysics.dart';
import '../loading.dart';
import '../stateful_wrapper.dart';

class APIListView<R> extends StatelessWidget {
  final Widget Function(List<R> data, int index) itemChild;
  final Widget Function() loadingBuilder;
  final Widget? noDataBuilder;
  final Future<List<R>> Function(int page, int size) apiFunc;
  final List<R> providerList;
  final int size;
  final bool needToTopWidget;
  final Widget? customFloatbutton;

  const APIListView({
    Key? key,
    required this.itemChild,
    required this.loadingBuilder,
    this.noDataBuilder,
    required this.apiFunc,
    required this.providerList,
    this.size = 5,
    this.needToTopWidget = true,
    this.customFloatbutton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return StatefulWrapper(
      onInit: () async {
        initLoadData(context, loadDataType: LoadDataType.initial);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Builder(
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: customFloatbutton != null,
                  child: customFloatbutton ?? Container(),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: needToTopWidget && !context.select((BaseAPIListProvider<R> value) => value.isTop),
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
            );
          },
        ),
        body: Builder(builder: (context) {
          LoadDataStatus nowLoadingStatus = context.select((BaseAPIListProvider<R> value) => value.loadStatus);
          return nowLoadingStatus == LoadDataStatus.initial
              ? loadingBuilder()
              : providerList.isEmpty
                  ? noDataBuilder ?? Container()
                  : listenListView(
                      context,
                      child: ListView.builder(
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
                      ),
                    );
        }),
      ),
    );
  }

  ///LisViewの状態をリスン
  Widget listenListView(BuildContext context, {required child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;
        if (scrollNotification is ScrollUpdateNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          final max = scrollNotification.metrics.maxScrollExtent;

          /// スクロール箇所が最TOPチェック
          bool isTop = context.read<BaseAPIListProvider<R>>().isTop;
          if (isTop && needToTopWidget) {
            bool isPosNotInTop = scrollPosition >= 20;

            if (isPosNotInTop) {
              context.read<BaseAPIListProvider<R>>().onIsTopChange(false);
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
          apiFunc: () async => await apiFunc(page, size),
          size: size,
          loadDataType: loadDataType,
        )
        .then(
      (_) async {
        int preLoadPage = context.read<BaseAPIListProvider<R>>().page;
        print("initLoadData $preLoadPage");
        await context.read<BaseAPIListProvider<R>>().preLoad(apiFunc: () async => await apiFunc(preLoadPage, size));
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
