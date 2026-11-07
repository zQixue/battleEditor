import 'package:flutter/material.dart';

class Monitor extends StatefulWidget {
  final Widget Function(_MonitorState ms , BuildContext context) builder;
  final dynamic value;
  Monitor({Key? key,
    required this.builder,
    this.value,
  }) : super(key: key);

  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  dynamic _crtValue;
  @override
  void initState() {
    _crtValue = widget.value;
    super.initState();
  }

  void setValue(dynamic value){
    if (_crtValue != value){
      setState(() {
        _crtValue = value;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var w = widget.builder.call(this , context);
    return w!;
  }
}