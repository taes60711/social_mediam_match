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
  final Future<List<R>> Function(int page, int size) apiFunc;
  final List<R> providerList;
  final int size;
  final bool needToTopWidget;
  final Widget? customFloatbutton;

  const APIListView({
    Key? key,
    required this.itemChild,
    required this.loadingBuilder,
    required this.apiFunc,
    required this.providerList,
    this.size = 5,
    this.needToTopWidget = true,
    this.customFloatbutton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    ///はじめロード、プリロードデータ
    Future<void> initLoadData({required LoadDataType loadDataType}) async {
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
          await context.read<BaseAPIListProvider<R>>().preLoad(apiFunc: () async => await apiFunc(preLoadPage, size));
        },
      );
    }

    return StatefulWrapper(
      onInit: () async {
        initLoadData(loadDataType: LoadDataType.initial);
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
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: normalBgColor2,
                    onPressed: () {
                      scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    child: const Icon(
                      FontAwesomeIcons.angleUp,
                      size: 16,
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
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollNotification) {
                    LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;
                    if (scrollNotification is ScrollUpdateNotification) {
                      final scrollPosition = scrollNotification.metrics.pixels;
                      final max = scrollNotification.metrics.maxScrollExtent;

                      /// スクロール箇所が最TOPチェック
                      bool isTop = context.read<BaseAPIListProvider<R>>().isTop;
                      if (isTop) {
                        if (scrollPosition >= 20) {
                          context.read<BaseAPIListProvider<R>>().onIsTopChange(false);
                        }
                      }

                      ///
                      if (nowLoadDataStatus == LoadDataStatus.loadingFinish ||
                          nowLoadDataStatus == LoadDataStatus.allDataLoaded) {
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
                      if (!isTop) {
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
                        initLoadData(loadDataType: LoadDataType.reload);
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: providerList.length,
                    controller: scrollController,
                    physics: nowLoadingStatus != LoadDataStatus.allDataLoaded
                        ? const BouncingScrollPhysics()
                        : const CustomBouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Builder(builder: (context) {
                              LoadDataStatus nowLoadDataStatus =
                                  context.select((BaseAPIListProvider<R> value) => value.loadStatus);
                              return Visibility(
                                visible: nowLoadDataStatus == LoadDataStatus.wantReload,
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Loading(),
                                ),
                              );
                            }),
                            this.itemChild(providerList, index),
                          ],
                        );
                      } else if (index == providerList.length - 1) {
                        return Column(
                          children: [
                            this.itemChild(providerList, index),
                            Builder(
                              builder: (context) {
                                LoadDataStatus nowLoadDataStatus =
                                    context.select((BaseAPIListProvider<R> value) => value.loadStatus);

                                return Column(
                                  children: [
                                    ///データ読み込んてる場合表示される
                                    Visibility(
                                      visible: nowLoadDataStatus != LoadDataStatus.allDataLoaded &&
                                          nowLoadDataStatus != LoadDataStatus.loadingFinish,
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 50),
                                        child: Loading(),
                                      ),
                                    ),

                                    ///すべでデータ読み込みたら表示される
                                    Visibility(
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
                                    ),
                                  ],
                                );
                              },
                            )
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
}
