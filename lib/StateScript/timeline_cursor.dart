//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/TimelinePainter.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/protos/transition.pb.dart';

class TimelineCursor extends StatefulWidget {
  final double height;
  final SSCanvasViewState graph;
  TimelineCursor({Key key , this.height , this.graph}) : super(key: key);

  @override
  TimelineCursorState createState() => TimelineCursorState();
}

class TimelineCursorInfo{
  static double _posX = 0;

  // ignore: unnecessary_getters_setters
  static set posX(double val){
    _posX = val;
    EventCenter.eventBus.fire(TimelineCursorRefresh());

  }

  // ignore: unnecessary_getters_setters
  static double get posX{
    return _posX;
  }
}

class TimelineCursorState extends State<TimelineCursor> {
  Offset downPointer;
  double oldX;
  bool isUserDragging = false;
  StreamSubscription<TimelineCursorRefresh> _lis4;
  StreamSubscription<TimelineCursorInit> _lis5;
  @override
  void dispose() {
    _lis4.cancel();
    _lis5.cancel();
    super.dispose();
  }

  double getPosFromTime(double time){
    var s = TimelinePainter.step_1s;
    return (time) * s;
  }

  @override
  void initState() {
    _lis4 = EventCenter.eventBus.on<TimelineCursorRefresh>().listen((event) {
      setState(() {
        if (event.time != null){
          if (!(RunSession.instance.isFocusFrameMode && RunSession.instance.remoteIsPlaying) || event.isUnityResponce){
            TimelineCursorInfo.posX = getPosFromTime(event.time).floorToDouble();
          }
        }

        if (RunSession.instance.remoteIsPlaying && ! RunSession.instance.isFocusFrameMode){
          //unity 运行状态
          var canvasPos = ZoomState.current.currentCenterPosition();
          ZoomState.current.focusPosition(TimelineCursorInfo.posX + SSDefines.canvasZeroX, canvasPos.dy);
          // EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
      });
    });
    _lis5 = EventCenter.eventBus.on<TimelineCursorInit>().listen((event) {
      setState(() {
        send2Unity(TimelineCursorInfo.posX);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curW = 16;
    var scale = ZoomState.current.scale;
    var con = GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onTapDown: (e){
          isUserDragging = true;
        },
        onPanStart: (e) {
          if (RunSession.instance.remoteIsPlaying && ! RunSession.instance.isFocusFrameMode) return;
          isUserDragging = true;
          downPointer = e.globalPosition;
          oldX = TimelineCursorInfo.posX;
        },
        onPanUpdate: (e) {

          if (RunSession.instance.remoteIsPlaying&& ! RunSession.instance.isFocusFrameMode) return;
          setState(() {
            var off = e.globalPosition - downPointer;
            off = widget.graph.global2LocalDelta(off);

            var offX = off.dx;
            TimelineCursorInfo.posX = (oldX + offX).floorToDouble();

            if (!RunSession.instance.remoteIsPlaying) {
              send2Unity(TimelineCursorInfo.posX);
            }
            else{
              //运行时，拖动
            }
          });
        },
        onPanEnd: (e) {
          if (RunSession.instance.remoteIsPlaying&& ! RunSession.instance.isFocusFrameMode) return;
          isUserDragging = false;

          if (RunSession.instance.isFocusFrameMode){
            var bp = TimelineTime();
            bp.time = getTime(TimelineCursorInfo.posX);
            Transport.instance.sendUdpData(OPackType.O2U_RuntimeSetTime, bp);
          }
          setState(() {
            //
          });
        },
        child: Container(
          color: CommonUtil.alphaColor(Colors.lightGreen, 90),
          width: curW / scale,
          height: SSDefines.canvasHeight,
        )
    );

    Offset center = ZoomState.current.currentDynamicCenterPosition();
    // var offY = (widget.height/2-80)/scale ;
    return Positioned(
      key: ValueKey("timeline_cursor"),
      left: TimelineCursorInfo.posX + SSDefines.canvasZeroX - curW / scale / 2,//- SSDefines.portOffX ,
      top: 0,
      child: con,//RepaintBoundary(child:dnn2),
    );
  }

  static double getTime(double v){
    var s = TimelinePainter.step_1s;
    return (v)/s;
  }

  static void send2Unity(double pos){
    var nodes = ScriptInfo.current?.scriptData?.nodeMap?.values?.toList();
    if (nodes == null) return ;

    var bp = TimelineSyncData();
    bp.time = getTime(pos);
    // print("send2Unity ${bp.time}");
    for(var n in nodes){
      var nd = n.getSyncData();
      if (nd != null) {
        bp.nodeValues.add(nd);
      }
    }
    Transport.instance.sendUdpData(OPackType.O2U_MAP_SyncTimeline, bp);
  }
}