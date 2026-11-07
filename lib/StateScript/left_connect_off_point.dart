//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/EventCenter.dart';

class LeftConnectOffPoint extends StatefulWidget {
  final dynamic connection;
  final SSCanvasViewState graph;
  LeftConnectOffPoint({Key key, this.connection , this.graph}) : super(key: key);

  @override
  _LeftConnectOffPointState createState() => _LeftConnectOffPointState();
}

class _LeftConnectOffPointState extends State<LeftConnectOffPoint> {
  bool isCommandOpen = false ;
  StreamSubscription<RefreshConnectCommandEvent> _lis;

  @override
  void dispose() {
    // TODO: implement dispose
    _lis?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState

    _lis = EventCenter.eventBus.on<RefreshConnectCommandEvent>().listen((event) {
      if (event.globalRefresh??false){
        setState(() {

        });
        return;
      }

      if (event.refreshConnection == widget.connection) {
        setState(() {
        });
      }
      if (event.targetNode != null) {
        var outNode = ScriptInfo.current.scriptData.nodeMap[widget.connection.outNodeGuid];
        var inNode = ScriptInfo.current.scriptData.nodeMap[widget.connection.inNodeGuid];
        if (outNode == event.targetNode || inNode == event.targetNode ){
          setState(() {
          });
        }
      }
      if (event.openChanged??false){
        var newState = event.openedPortConnection == widget.connection;
        if (newState != isCommandOpen){
          setState(() {
            isCommandOpen = newState;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (SSDefines.isInDagging){
    //   return Container();
    // }
    // if (!isCommandOpen) return Container();//Positioned(left: 0,top:0,child: Container());
    dynamic c;
    dynamic con;
    StateScriptNode outNode , inNode;
    Offset pout;
    Offset pin;
    Offset p;
    bool bNormal;
    if (widget.connection is PortConnection){
      c = widget.connection;
      con = widget.connection;
      outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];
      if (outNode == null || inNode == null) return Positioned(left: 0,top:0,child: Container());
      pout = outNode.getOutPortPosition(c.outPortGuid);
      pin = inNode.getInPortPosition(c.inPortGuid);
      if (c.sopGuid != null && c.sopGuid.trim() != ""){
        var sopout = outNode.getOutPortPositionBySOP(c.sopGuid);
        if (sopout != null){
          pout = sopout;
        }
      }
      if (pout == null || pin == null) return Positioned(left: 0,top:0,child: Container());

      pout = Offset(pout.dx + con.outOffX + SSDefines.draw_port_line_off ,pout.dy) ;
      pin = Offset(pin.dx + con.inOffX - SSDefines.draw_port_line_off ,pin.dy) ;

      p = (pout + pin)/2;
      bNormal = pout.dx <= pin.dx;
    }
    else {
      c = widget.connection;
      con = widget.connection;
      outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];
      if (outNode == null || inNode == null) Positioned(left: 0,top:0,child: Container());
      pout = outNode.getOutParamPosition(c.outParamGuid);

      if (c.sopGuid != null && c.sopGuid.trim() != "") {
        var sopout = outNode.getOutParamPositionBySOP(c.sopGuid);
        if (sopout != null) {
          pout = sopout;
        }
      }

      pin = inNode.getInParamPosition(c.inParamGuid);
      if (pout == null || pin == null) Positioned(left: 0,top:0,child: Container());
      pout = Offset(pout.dx + con.outOffX + SSDefines.draw_port_line_off ,pout.dy) ;
      pin = Offset(pin.dx + con.inOffX - SSDefines.draw_port_line_off ,pin.dy) ;
      p = (pout + pin) / 2;
      bNormal = pout.dx <= pin.dx;
    }

    var cSize = 16.0;
    var offStep = 8.0;
    var posLeft = Positioned(
      left: pout.dx -cSize/2,
      top: pout.dy -cSize/2 ,
      child: GestureDetector(

        onPanStart: (e){

          c.downPointer = e.globalPosition;
          c.downOffY = c.outOffX;
        },
        onPanUpdate: (e){

          setState(() {
            var off = e.globalPosition - c.downPointer;
            off = widget.graph.global2LocalDelta(off);

            c.outOffX = ((c.downOffY + off.dx)/SSDefines.connection_point_step).floorToDouble() *SSDefines.connection_point_step;

            // {
            //   var finalX = c.downOffY + c.outOffX;
            //   finalX = (finalX/offStep).floor() * offStep;
            //   c.offY = finalX - c.downOffY;
            // }

            if (c.outOffX<0.0)c.outOffX=0.0;
            // print(c.outOffX);
            EventCenter.eventBus.fire(RefreshConnectCommandEvent()..refreshConnection = widget.connection..openedPortConnection = widget.connection..openChanged = true);
            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());

          });
        },
        onPanEnd: (e){
          setState(() {
            EventCenter.eventBus.fire(RefreshConnectCommandEvent()..refreshConnection = widget.connection..openedPortConnection = widget.connection..openChanged = true);
            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          });
        },
        child: Container(
            width: cSize, height: cSize,
            child:Icon(
              MaterialCommunityIcons.circle,
              size: cSize,
              color:  Color(c.lineColor) //Colors.blue,
            )

        ) ,
      ) ,

    );

    return posLeft;
  }
}