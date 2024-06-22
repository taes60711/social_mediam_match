import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/base_api_list_provider.dart';

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
        body: Column(
          children: [
            context.read<BaseAPIListProvider<R>>().loadStatus == LoadDataStatus.wantReload
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: Loading(),
                  )
                : Container(),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollNotification) {
                  LoadDataStatus nowLoadDataStatus = context.read<BaseAPIListProvider<R>>().loadStatus;
                  if (scrollNotification is ScrollUpdateNotification) {
                    final scrollPosition = scrollNotification.metrics.pixels;
                    final max = scrollNotification.metrics.maxScrollExtent;

                    if (nowLoadDataStatus == LoadDataStatus.loadingFinish) {
                      if (scrollPosition >= max && max != 0) {
                        context.read<BaseAPIListProvider<R>>().onLodaingStatusChange(LoadDataStatus.wantinSert);
                      }
                      if (scrollPosition < 0) {
                        context.read<BaseAPIListProvider<R>>().onLodaingStatusChange(LoadDataStatus.wantReload);
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
                    if (index == providerList.length - 1) {
                      return Column(
                        children: [
                          this.itemChild(providerList, index),
                          Visibility(
                            visible: context.read<BaseAPIListProvider<R>>().loadStatus == LoadDataStatus.wantinSert,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Loading(),
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
          ],
        ),
      ),
    );
  }
}
