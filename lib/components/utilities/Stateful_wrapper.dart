import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Function? onDidChange;
  final Function? onDispose;
  final Widget child;

  const StatefulWrapper({required this.onInit, required this.child, this.onDidChange, this.onDispose});

  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.onDidChange != null) {
      widget.onDidChange!();
    }

    super.didChangeDependencies();
  }

  void onDispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
