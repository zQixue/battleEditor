//@dart=2.11
import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/ConnectPainter.dart';
import 'package:battlepus/common/EventCenter.dart';

class ConnectLineView extends StatefulWidget {
  ConnectLineView({Key key}) : super(
      key: key);

  @override
  _ConnectLineViewState createState() =>
      _ConnectLineViewState(
      );
}

class _ConnectLineViewState extends State<ConnectLineView> {
  StreamSubscription<RefreshAllConnectLineEvent______> _lis;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lis = EventCenter.eventBus.on<RefreshAllConnectLineEvent______>().listen((event) {
      setState(() {
       // print("---- refresh connect lines");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return CustomPaint(painter: ConnectPainter());
    return RepaintBoundary(
        child: CustomPaint(painter: ConnectPainter())
    );

  }

}