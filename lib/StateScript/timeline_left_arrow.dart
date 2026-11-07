//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/ConnectPainter.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/EventCenter.dart';


class TimelineLeftArrow extends StatefulWidget {
  final StateScriptNode node;
  final SSCanvasViewState graph;
  TimelineLeftArrow({Key key,this.node , this.graph}) : super(key: key);

  @override
  _TimelineLeftArrowState createState() => _TimelineLeftArrowState();
}

class _TimelineLeftArrowState extends State<TimelineLeftArrow> {

  StreamSubscription<NodeRefreshWithTargetEvent> _lis4;

  @override
  void dispose() {
    _lis4.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _lis4 = EventCenter.eventBus.on<NodeRefreshWithTargetEvent>().listen((event) {
      // print("_lis4");
      if (event.exportId == widget.node.exportId){
        setState(() {

        });
        return;
      }

      // print("rebuild node ${widget.node.guid}");
      if (event.node == widget.node || event.nodeType == widget.node.getNodeStructType()) {
        setState(() {
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final minTLWidth = 0;
    var con = GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
        onPanStart: (e){
          widget.node.downPointer = e.globalPosition;
          widget.node.oriX = widget.node.x;
          widget.node.oriWidth = widget.node.tlWidth;
        },
        onPanUpdate: (e){

          setState(() {
            ConnectPainter.currentSelectTimelineClipNode = widget.node;
            var off = e.globalPosition - widget.node.downPointer;
            off = widget.graph.global2LocalDelta(off);
            var offX = off.dx;
            if (offX >= widget.node.oriWidth-minTLWidth){
              offX = widget.node.oriWidth-minTLWidth;
            }
            widget.node.x = (widget.node.oriX + offX).floorToDouble();
            widget.node.tlWidth = (widget.node.oriX + widget.node.oriWidth - widget.node.x).floorToDouble();

            // print(c.outOffX);
            EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());

          });
        },
        onPanEnd: (e){
          setState(() {
            EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          });
        },
        child: Icon(
          MaterialCommunityIcons.chevron_left_circle,
          size: 14,
          color:  Colors.cyanAccent,
        )
    );
    return Positioned(
      key: ValueKey(widget.node.guid),
      left: widget.node.x - 14 ,//- SSDefines.portOffX ,
      top: widget.node.y - 14,
      child: con,//RepaintBoundary(child:dnn2),
    );
  }
}