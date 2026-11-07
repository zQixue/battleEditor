//@dart=2.11

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/PortInfo.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutPort.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/StateScript/state_script_node_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';

import 'package:battlepus/common/drag_target_ex.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:theme_provider/theme_provider.dart';

class SOPortView extends StatefulWidget {
  final StateScriptNode node;
  final SSCanvasViewState graph;
  final SubstituteOutPort sop;
  SOPortView({Key key,this.node, this.graph, this.sop}) : super(key: key);

  @override
  _SOPortViewState createState() => _SOPortViewState();
}

class _SOPortViewState extends State<SOPortView> {


  StreamSubscription<SubstituteObjectRefreshEvent> _lis;
  final _posNotifier = ValueNotifier<Offset>(Offset(0,0));
  bool _storeHistory = false;
  // StreamSubscription<NodeRefreshWithTargetEvent> _lis4;
  // StreamSubscription<TransformUpdateEvent> _lis2;
  // StreamSubscription<FocusNodeUpdateEvent> _lis3;

  @override
  void dispose() {
    // TODO: implement dispose
    _lis?.cancel();
    _posNotifier?.dispose();
    // _lis2?.cancel();
    // _lis3?.cancel();
    // _lis4?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _posNotifier.value = Offset(widget.sop.x,widget.sop.y);
    _lis = EventCenter.eventBus.on<SubstituteObjectRefreshEvent>().listen((event) {
      // print("refresh port 1");
      if (event.object == widget.sop && (event.posChanged??false)){
        // print("sop pos changed");
        _posNotifier.value = Offset(widget.sop.x,widget.sop.y);
        return ;
      }
      if (event.object == widget.sop) {
        // print("refresh port 2");
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_controlKey.currentContext != null) {
                widget.sop.width = _controlKey.currentContext.size.width;
              }
            });
//
//     _lis4 = EventCenter.eventBus.on<NodeRefreshWithTargetEvent>().listen((event) {
//       if (event.node == widget.node) {
//         setState(() {});
//       }
//     });
//
//     _lis3 = EventCenter.eventBus.on<FocusNodeUpdateEvent>().listen((event) {
// //      print("focus");
//       if (event.guid == widget.node.guid) {
//         ZoomState.current.focusPosition(widget.node.x,widget.node.y);
//         EventCenter.eventBus.fire(GlobalRefreshEvent());
//       }
//     });
//
//     _lis2 = EventCenter.eventBus.on<TransformUpdateEvent>().listen((event) {
// //      print("focus");
//       if (event.guid == widget.node.guid) {
//         setState(() {});
//       }
//     });
    // TODO: implement initState
    super.initState();
  }
  var textStyle = const TextStyle(fontSize: 12 , color: Colors.black , fontWeight: FontWeight.w500 ,);
  var textStyle2 = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);

  void doSelect(SubstituteOutPort n){
    if (KeyEventCenter.isControlPressed()){
      setState(() {
        n.selected = !n.selected;
      });

      // EventCenter.eventBus.fire(FieldEditorRefreshEvent());
      return;
    }
    if (!n.selected) {
      ScriptInfo.current.unselectAll();
    }
    // widget.node.selected = true;
    if (!n.selected){
      setState(() {
        n.selected = true;
      });
    }

    // EventCenter.eventBus.fire(FieldEditorRefreshEvent());
  }
  final GlobalKey _controlKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
    var paramOutPort = getOutPortWidget(nodeType , widget.node , widget.sop);

    // if  (SSDefines.isInDagging && widget.node.selected){
    //   var n = widget.sop;
    //   return Positioned(
    //       left: n.x - SSDefines.sopWidth,//- SSDefines.portOffX ,
    //       top: n.y ,//- SSDefines.sopHeight / 2,
    //       child: Container(
    //         width: SSDefines.sopWidth,
    //         height: SSDefines.sopHeight,
    //         color:Colors.brown,
    //       )
    //   );
    // }


    var outPort = widget.node.getOutPort(widget.sop.outPortGuid);
    if (outPort == null){
      outPort = widget.node.dynamicInterfaces[widget.sop.outPortGuid];
    }
    if (outPort == null) return Container();
    var str = "${nodeType.getTypeShowString()}-${outPort.getTypeShowString()} ";
    // var txt = Text(str ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle);
    var hash = ("$str${outPort.guid}").hashCode;//outParam.guid.hashCode;//("$str").hashCode ;//+ outParam.guid.hashCode;
    var clr = Color(hash);
    var br = 4.0;
    if(widget.node.isModuleNode)widget.sop.selected=false;
    var _dcParam = new BoxDecoration(
      color: CommonUtil.scaleColor(clr, 80),

      // borderRadius: BorderRadius.only(
      //   topRight : Radius.circular(3.0),
      //   bottomRight : Radius.circular(3.0),
      // ),
      borderRadius: new BorderRadius.circular((2.0)),
      boxShadow: [ BoxShadow(color: widget.sop.selected? CommonUtil.alphaColor(Colors.greenAccent,180):CommonUtil.alphaColor(Colors.black,180), offset:Offset(0.0, 0.0),    blurRadius: br, spreadRadius: widget.sop.selected?4.0:0.0) , BoxShadow(color: Colors.white)],
    );

    var showName = DartCommon.isEmpty(widget.node.nodeAlias)?nodeType.getTypeShowString():widget.node.nodeAlias;
    if (!DartCommon.isEmpty(widget.sop.desc)) showName = widget.sop.desc;
    var normal = Container(
      key : _controlKey,
        padding: EdgeInsets.fromLTRB(4, 0, 2, 0),
        decoration: _dcParam,
        // width: SSDefines.sopWidth,
        height: SSDefines.sopHeight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Expanded(child:txt),
                Text("$showName" , maxLines: 1, overflow: TextOverflow.clip, style: textStyle2),
                if(!widget.node.isModuleNode)Container(
                  width: 20,
                  height: 18,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(MaterialCommunityIcons.square_edit_outline),
                    color: Colors.green,
                    iconSize: 18,
                    onPressed: (){

                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          var ch = ThemeCenter.block(
                            width: 600,
                            height: 400,
                            padding: EdgeInsets.all(8),
                            headTitle: "输入替身注释",
                            child: TextEditor(
                              initValue: widget.sop.desc??"",
                              maxLines: 3,
                              onChanged: (v){
                                widget.sop.desc = v;
                              },
                            ),

                          );
                          return ThemeConsumer(child :Dialog(child: ch));
                        },
                      ).then((value){
                        setState(() {

                        });
                      });

                    },
                  ),
                ),
                // SizedBox(width: 4,),
                // Expanded(child :txt),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(!widget.node.isModuleNode)Container(
                  width: 20,
                  height: 18,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(MaterialCommunityIcons.minus_box),
                    color: Colors.redAccent,
                    iconSize: 18,
                    onPressed: (){
                      widget.node.soports.remove(widget.sop);
                      EventCenter.eventBus.fire(GlobalRefreshEvent());
                    },
                  ),
                ),
                Container(
                  width: 20,
                  height: 18,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(MaterialCommunityIcons.link_box_variant_outline),
                    color: Colors.indigo,
                    iconSize: 18,
                    onPressed: (){
                      ScriptInfo.current.unselectAll();
                      ScriptInfo.current.currentPos = Offset(widget.sop.x,widget.sop.y);
                      var n = widget.node;
                      n.selected = true;
                      ZoomState.current.focusPosition(n.x,n.y);
                      EventCenter.eventBus.fire(GlobalRefreshEvent());
                    },
                  ),
                ),
                Text("${outPort.getTypeShowString()}" ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
                // paramOutPort,

                GestureDetector(
                  onTapUp: (e){
                    EventCenter.eventBus.fire(PortClickEvent()..node = widget.node..portGuid = outPort.guid);
                  },
                  child: paramOutPort,
                ),
              ],
            ),
          ],
        )

    );
    var n = widget.sop;
    var dnn2 = GestureDetector(
      dragStartBehavior : DragStartBehavior.down,
      child: normal,
      onPanStart: (e){
        // n.downPointer = e.globalPosition;
        // n.downStorePos = Offset(n.x , n.y);
        SSDefines.isInDagging = true;
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = 100);
        EventCenter.eventBus.fire(PortClickEvent()..node = null);
        doSelect(n);
        StateScriptNodeViewState.dragStorePos(e);
      },
      onTapDown: (e){
        doSelect(n);
      },
      onPanUpdate: (e){

        // setState(() {
          if (!_storeHistory) {
            HistoryManager.scriptHistory.appendHistory();
            _storeHistory = true;
          }
          SSDefines.isInDagging = true;
          StateScriptNodeViewState.dragUpdatePos(e , widget.graph);

          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=true);


          return;

          int count = StateScriptNodeViewState.dragUpdatePos(e, widget.graph);
          if (count < 8){
            StateScriptNodeViewState.sendDragUpdatePosEvent();
          }
          else{
            if (count < 32){
            if (StateScriptNodeViewState.darggingEventTimer == null){
                StateScriptNodeViewState.sendDragUpdatePosEvent();
                StateScriptNodeViewState.darggingEventTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
                  StateScriptNodeViewState.sendDragUpdatePosEvent();
                });
              }
            }
            else{
              EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=true);
            }
          }

        // });
      },
      onPanEnd: (e){
        SSDefines.isInDagging = false;
        if (StateScriptNodeViewState.darggingEventTimer != null){
          StateScriptNodeViewState.darggingEventTimer.cancel();
          StateScriptNodeViewState.darggingEventTimer = null;
        }
        // setState(() {
          StateScriptNodeViewState.dragEndPos(e , widget.graph);
          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        // });
        StateScriptNodeViewState.sendDragUpdatePosEvent();
        EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=false);
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = ZoomState.current.getScale()..bForce = true);
      },
    );

    // EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = widget.node);
    // var r = Positioned(
    //     //     left: n.x - SSDefines.sopWidth,//- SSDefines.portOffX ,
    //     //     top: n.y ,//- SSDefines.sopHeight / 2,
    //     //     child: Container(
    //     //       width: SSDefines.sopWidth,
    //     //       height: SSDefines.sopHeight,
    //     //       child: Row(
    //     //         mainAxisAlignment: MainAxisAlignment.end,
    //     //         children: [
    //     //           dnn2,
    //     //         ],
    //     //       ),
    //     //     )
    //     // );

    return ValueListenableBuilder(
        valueListenable: _posNotifier,
        builder: (_, value, __) => Positioned(
            left: n.x - SSDefines.sopWidth,//- SSDefines.portOffX ,
            top: n.y ,//- SSDefines.sopHeight / 2,
            child: RepaintBoundary(child:Container(
              width: SSDefines.sopWidth,
              height: SSDefines.sopHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  dnn2,
                ],
              ),
            ))
        )
    );
  }
  Widget getOutPortWidget(NodeStructData nodeType ,StateScriptNode node , SubstituteOutPort sop){
    var outPort = node.getOutPort(sop.outPortGuid);
    if (outPort == null){
      outPort = widget.node.dynamicInterfaces[sop.outPortGuid];
    }

    if (outPort == null) return null;

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutPortConnection(node , outPort);

    if (node.isModuleNode && !node.moduleInterfaces.containsKey(outPort.guid)){
      return Icon(
        MaterialCommunityIcons.alpha_f_circle,
        color: Colors.grey,
        size: SSDefines.portSize,
      );
    }

    var dn = DraggableEx(
      child:Icon(
              AntDesign.rightsquare,
              color: bWithConnection?Colors.red:Colors.grey,
              size: SSDefines.portSize,
            ),
      childWhenDragging: Container(
        child: Icon(
          AntDesign.rightsquare,
          color: Colors.red,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.portSize ,
        // height: SSDefines.portSize ,
      ),
      feedback:Container(
//          color: Colors.red,
//          width: SSDefines.portSize ,
//          height: SSDefines.portSize ,
      ),
      onDragStarted: (pos){
        EventCenter.eventBus.fire(ConnectLineStartEvent(pos));
      },
      onDragMove: (pos){
        EventCenter.eventBus.fire(ConnectLineMoveEvent(pos));

      },
      onDragEnd: (e){
        EventCenter.eventBus.fire(ConnectLineEndEvent());
      },

      onDraggableCanceled: (velocity, offset) {
        if (KeyEventCenter.isControlPressed()){
        var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
        SubstituteOutPort sop2 = SubstituteOutPort()..outPortGuid = sop.outPortGuid..x = off.dx..y = off.dy;
        node.soports.add(sop2);
        EventCenter.eventBus.fire(GlobalRefreshEvent());
      }
    },       
//        data:nodeType.outPorts[iIndex],
      data: OutPortInfo(widget.node, outPort , sop),
    );

    var dragTarget = DragTargetEx<InPortInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
//      onAccept: onAccept,
//      onDragMove: (off){
//
//      },
      onAcceptWithDetails: (DragTargetDetails<InPortInfo> details) {
        if (widget.node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }

        var con = PortConnection();
        con.outNodeGuid = widget.node.guid;
        con.outPortGuid = outPort.guid;
        con.inNodeGuid = details.data.node.guid;
        con.inPortGuid = details.data.port.guid;
        con.sopGuid = sop.guid;

        if (!ScriptInfo.current.scriptData.addPortConnection(con , sop : sop)){
//          BotToast.showSimpleNotification(title: "连接已经存在，忽略本次操作");
          BotToast.showText(text:"连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);
        }
        else{
          EventCenter.eventBus.fire(RefreshConnectCommandEvent());
        }
      },
      onWillAccept: (e){return true;},
//      onLeave: onOutPortLeave,
    );


    // return Container(
    //   // decoration: _dcPort,
    //  // color: Colors.green,
    //   width: SSDefines.portSize ,
    //   height: SSDefines.portSize ,
    //   child: dragTarget
    //
    // );
    return dragTarget;
  }

}