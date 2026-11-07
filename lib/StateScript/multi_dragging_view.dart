//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/DraggingFramesPainter.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/common/EventCenter.dart';

class MultiDraggingView extends StatefulWidget {
  MultiDraggingView({Key key}) : super(key: key);

  @override
  _MultiDraggingViewState createState() => _MultiDraggingViewState();
}

class _MultiDraggingViewState extends State<MultiDraggingView> {

  StreamSubscription<RefreshMultiDraggingEvent> _lis;


  bool bShow = false;
  @override
  void dispose() {
    _lis?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _lis = EventCenter.eventBus.on<RefreshMultiDraggingEvent>().listen((event) {
      setState(() {
        bShow = event.bShow??false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (!SSDefines.isInDagging || !bShow){
    //   return Container();
    // }
    // return RepaintBoundary(child:CustomPaint(painter: DraggingFramesPainter()));
    // return CustomPaint(painter: DraggingFramesPainter());
    return Visibility(visible: SSDefines.isInDagging && bShow, child: CustomPaint(painter: DraggingFramesPainter()));
  }
}