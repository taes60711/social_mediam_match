import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../loading.dart';
import '../stateful_wrapper.dart';

class APIListView<R> extends StatelessWidget {
  final Widget Function(List<R> data, int index) itemChild;
  final Future<List<R>> Function(int page, int size) apiFunc;
  final List<R> providerList;
  final int size;

  const APIListView({
    Key? key,
    required this.itemChild,
    required this.apiFunc,
    required this.providerList,
    this.size = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () async {
        int page = context.read<BaseAPIListProvider<R>>().page;

        await context.read<BaseAPIListProvider<R>>().insertData(
              apiFunc: () async => await apiFunc(page, size),
              size: size,
              loadDataType: LoadDataType.initial,
            );
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotification) {
            LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;
            if (scrollNotification is ScrollUpdateNotification) {
              final scrollPosition = scrollNotification.metrics.pixels;
              final max = scrollNotification.metrics.maxScrollExtent;

              if (nowLoadDataStatus == LoadDataStatus.loadingFinish || nowLoadDataStatus == LoadDataStatus.allDataLoaded) {
                ///再度読み込み
                if (scrollPosition < 0) {
                  context.read<BaseAPIListProvider<R>>().onLodaingStatusChange(LoadDataStatus.wantReload);
                }

                ///全てデータ読み込みたら追加ロードできなくなる
                if (nowLoadDataStatus != LoadDataStatus.allDataLoaded) {
                  if (scrollPosition >= max && max != 0) {
                    context.read<BaseAPIListProvider<R>>().onLodaingStatusChange(LoadDataStatus.wantinSert);
                  }
                }
              }
            }
            if (scrollNotification is ScrollEndNotification) {
              if (nowLoadDataStatus == LoadDataStatus.wantinSert || nowLoadDataStatus == LoadDataStatus.wantReload) {
                int loadPage = 0;
                LoadDataType loadDataType = LoadDataType.reload;
                if (nowLoadDataStatus == LoadDataStatus.wantinSert) {
                  loadPage = context.read<BaseAPIListProvider<R>>().page;
                  loadDataType = LoadDataType.insert;
                }

                context.read<BaseAPIListProvider<R>>().insertData(
                      apiFunc: () async => await apiFunc(loadPage, size),
                      size: size,
                      loadDataType: loadDataType,
                    );
              }
            }
            return false;
          },
          child: ListView.builder(
            itemCount: providerList.length,
            itemBuilder: (context, index) {
              LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;
              if (index == 0) {
                return Column(
                  children: [
                    Visibility(
                      visible: nowLoadDataStatus == LoadDataStatus.wantReload,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Loading(),
                      ),
                    ),
                    this.itemChild(providerList, index),
                  ],
                );
              } else if (index == providerList.length - 1) {
                return Column(
                  children: [
                    this.itemChild(providerList, index),

                    ///追加データしてる場合表示される
                    Visibility(
                      visible: nowLoadDataStatus == LoadDataStatus.wantinSert,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
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
              } else {
                return this.itemChild(providerList, index);
              }
            },
          ),
        ),
      ),
    );
  }
}
