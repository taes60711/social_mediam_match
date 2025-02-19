import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';

enum ApiStatus {
  loading,
  nodata,
  finish,
}

class APIPage<R> extends StatefulWidget {
  final Widget Function(R data) child;
  final Widget? loadingWidget;
  final Widget? nodataWidget;
  final Future<R> Function() apiFunc;
  final Future Function(R data)? initFunc;
  final bool Function(R data)? noDataCondition;

  const APIPage({
    required this.child,
    this.loadingWidget,
    this.nodataWidget,
    required this.apiFunc,
    this.initFunc,
    this.noDataCondition,
    super.key,
  });

  @override
  State<APIPage<R>> createState() => _APIPageState<R>();
}

class _APIPageState<R> extends State<APIPage<R>> {
  ApiStatus apiStatus = ApiStatus.loading;
  late R data;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      data = await widget.apiFunc();
      if (widget.initFunc != null) {
        await widget.initFunc!(data);
      }
      apiStatus = ApiStatus.finish;

      if (widget.noDataCondition != null && widget.noDataCondition!(data) == true) {
        throw ();
      }
    } catch (e) {
      apiStatus = ApiStatus.nodata;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (apiStatus == ApiStatus.loading) {
      return widget.loadingWidget ?? const Loading();
    }

    if (apiStatus == ApiStatus.finish) {
      try {
        return widget.child(data);
      } catch (e) {
        return widget.nodataWidget ??
            const Center(
              child: Text("No Data"),
            );
      }
    }

    return widget.nodataWidget ??
        const Center(
          child: Text("No Data"),
        );
  }
}
