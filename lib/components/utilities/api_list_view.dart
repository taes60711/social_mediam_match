import 'package:flutter/material.dart';

import 'stateful_wrapper.dart';

class APIListView<R> extends StatelessWidget {
  final Widget Function(List<R> data, int index) child;
  final Future<void> Function(int page, int size) apiFunc;
  final List<R> providerList;

  const APIListView({
    Key? key,
    required this.child,
    required this.apiFunc,
    required this.providerList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () async {
        await apiFunc(0, 5);
      },
      child: Scaffold(
        body: ListView.builder(
          itemCount: providerList.length,
          itemBuilder: (context, index) {
            return this.child(providerList, index);
          },
        ),
      ),
    );
  }
}
