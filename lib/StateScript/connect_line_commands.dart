//@dart=2.11
import 'dart:async';

// import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/left_connect_off_point.dart';
import 'package:battlepus/StateScript/port_connect_command.dart';
import 'package:battlepus/StateScript/right_connect_off_point.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/EventCenter.dart';

class ConnectLineCommands extends StatefulWidget {
  final SSCanvasViewState graph;
  ConnectLineCommands({Key key , this.graph}) : super(
      key: key);

  @override
  ConnectLineCommandsState createState() =>
      ConnectLineCommandsState(
      );
}

class ConnectLineCommandsState extends State<ConnectLineCommands> {
  StreamSubscription<PortClickEvent> _lis;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  PortClickEvent _crtEvent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<PortClickEvent>().listen((event) {
      if (_crtEvent == null || _crtEvent.node != event.node || _crtEvent.portGuid != event.portGuid) {
        setState(() {
          _crtEvent = event;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (RunSession.instance.isRunning && !RunSession.instance.isEditorMode) {
    //   return Container();
    // }
    return getLinePanel();
//    return new LayoutBuilder(
//        builder: (BuildContext context, BoxConstraints constraints) {
//          return getLinePanel();
//        }
//    );
  }

  static String opendGuid ;
  Widget getLinePanel(){
    // if (SSDefines.isInDagging){
    //   return Container();
    // }
    if(_crtEvent == null){
      return Container();
    }
    List<Widget> cmds = new List<Widget>();

    var connections = ScriptInfo.current.scriptData.portConnections;
    var btnSize = 18.0;
    for(var con in connections){
      var b1 = con.inPortGuid == _crtEvent.portGuid && con.inNodeGuid == _crtEvent.node.guid;
      var b2 = con.outPortGuid == _crtEvent.portGuid && con.outNodeGuid == _crtEvent.node.guid;
        if (!b1 && !b2){
          continue;
        }

        var pos = PortConnectCommand(connection: con, graph: widget.graph,);
        cmds.add(pos);
        // print("?????????????????????????");
        var leftPos = LeftConnectOffPoint(connection: con,graph: widget.graph,);
        cmds.add(leftPos);
        var rightPos = RightConnectOffPoint(connection: con,graph: widget.graph,);
        cmds.add(rightPos);
    }
    var paramConnections = ScriptInfo.current.scriptData.paramConnections;
    for(var con in paramConnections){
      var b1 = con.inParamGuid == _crtEvent.portGuid && con.inNodeGuid == _crtEvent.node.guid;
      var b2 = con.outParamGuid == _crtEvent.portGuid && con.outNodeGuid == _crtEvent.node.guid;
      if (!b1 && !b2){
        continue;
      }

      var pos = PortConnectCommand(connection: con, graph: widget.graph,);
      cmds.add(pos);
      var leftPos = LeftConnectOffPoint(connection: con,graph: widget.graph,);
      cmds.add(leftPos);
      var rightPos = RightConnectOffPoint(connection: con,graph: widget.graph,);
      cmds.add(rightPos);
    }
    // var pos = ConnectCommandPannel();
    // cmds.add(pos);

    return RepaintBoundary(child:Stack(
      children: cmds,
    ));
  }
}