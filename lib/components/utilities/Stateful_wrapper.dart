import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Function? onDispose;
  final Widget child;

  const StatefulWrapper({required this.onInit, required this.child, this.onDispose});

  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  void onDispose() {
    widget.onDispose!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
