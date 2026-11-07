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
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortInfo.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutParam.dart';
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

class SOParamView extends StatefulWidget {
  final StateScriptNode node;
  final SSCanvasViewState graph;
  final SubstituteOutParam sop;
  SOParamView({Key key,this.node, this.graph, this.sop}) : super(key: key);

  @override
  _SOParamViewState createState() => _SOParamViewState();
}

class _SOParamViewState extends State<SOParamView> {


  StreamSubscription<SubstituteObjectRefreshEvent> _lis;
  final _posNotifier = ValueNotifier<Offset>(Offset(0,0));
  bool _storeHistory = false;
  // StreamSubscription<SubstitudeRefreshEvent> _lis4;
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
  void didUpdateWidget(SOParamView oldWidget) {
    // TODO: implement didUpdateWidget
    // RenderBox getBox = context.findRenderObject();
    // widget.sop.width = getBox.size.width;
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    _posNotifier.value = Offset(widget.sop.x,widget.sop.y);
    _lis = EventCenter.eventBus.on<SubstituteObjectRefreshEvent>().listen((event) {
      // print("refresh param 1");
      if (event.object == widget.sop && (event.posChanged??false)){
        _posNotifier.value = Offset(widget.sop.x,widget.sop.y);
        return ;
      }

      if (event.object == widget.sop) {
        // print("refresh param 2 ");
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(
            (_){
              if(_controlKey.currentContext != null) {
                widget.sop.width = _controlKey.currentContext.size.width;
              }
              // print("widget.sop.width = ${widget.sop.width}");
            });
//
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

  void doSelect(SubstituteOutParam n){
    if (KeyEventCenter.isControlPressed()){
      n.selected = !n.selected;
      // EventCenter.eventBus.fire(FieldEditorRefreshEvent());
      return;
    }
    if (!n.selected) {
      ScriptInfo.current.unselectAll();
    }

    n.selected = true;
    // EventCenter.eventBus.fire(FieldEditorRefreshEvent());
  }

  final GlobalKey _controlKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
    var paramOutPort = getOutParamWidget(nodeType , widget.node , widget.sop);

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


    var outParam = nodeType.getOutParam(widget.sop.outParamGuid);
    if (outParam == null){
      outParam = widget.node.dynamicInterfaces[widget.sop.outParamGuid];
    }

    if (outParam == null) {
      // return Container(width: 100,height: 30,color: Colors.red,);
      return emptySOP;
    }
    var str = "${nodeType.getTypeShowString()}-${outParam.getTypeShowString()} ";
    // var txt = Text(str ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle);
    var hash = ("$str${outParam.guid}").hashCode;//outParam.guid.hashCode;//("$str").hashCode ;//+ outParam.guid.hashCode;
    var clr = Color(hash);
    var br = 4.0;
    if(widget.node.isModuleNode)widget.sop.selected=false;
    var _dcParam = new BoxDecoration(
      color: CommonUtil.scaleColor(clr, 80),
        // borderRadius: BorderRadius.only(
        //   topRight : Radius.circular(18.0),
        //   bottomRight : Radius.circular(18.0),
        // ),
        borderRadius: new BorderRadius.circular((8.0)),
      boxShadow: [ BoxShadow(color: widget.sop.selected? CommonUtil.alphaColor(Colors.greenAccent,180):CommonUtil.alphaColor(Colors.black,180), offset:Offset(0.0, 0.0),    blurRadius: br, spreadRadius: widget.sop.selected?4.0:0.0) , BoxShadow(color: Colors.white)],
    );
    var showName = DartCommon.isEmpty(widget.node.nodeAlias)?nodeType.getTypeShowString():widget.node.nodeAlias;
    if (!DartCommon.isEmpty(widget.sop.desc)) showName = widget.sop.desc;
    var normal = Container(
      key:_controlKey,
      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
      decoration: _dcParam,
      // alignment: Alignment.centerRight,
      // width: SSDefines.sopWidth
      height: SSDefines.sopHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
                    widget.node.sops.remove(widget.sop);
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
              Text( "${outParam.getTypeShowString()}" ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
              // paramOutPort,

              GestureDetector(
                onTapUp: (e){
                  EventCenter.eventBus.fire(PortClickEvent()..node = widget.node..portGuid = outParam.guid);
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
        SSDefines.isInDagging = true;
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = 100);
        EventCenter.eventBus.fire(PortClickEvent()..node = null);
        doSelect(n);
        // n.downPointer = e.globalPosition;
        // n.downStorePos = Offset(n.x , n.y);

        StateScriptNodeViewState.dragStorePos(e);
      },
      onTapDown: (e){
        doSelect(n);
        _storeHistory = false;
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
        StateScriptNodeViewState.sendDragUpdatePosEvent();
        EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=false);
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = ZoomState.current.getScale()..bForce = true);
        // });
      },
    );
    // EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = widget.node);
    // var r = Positioned(
    //   left: n.x - SSDefines.sopWidth,//- SSDefines.portOffX ,
    //   top: n.y ,//- SSDefines.sopHeight / 2,
    //   child: Container(
    //     width: SSDefines.sopWidth,
    //     height: SSDefines.sopHeight,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         dnn2,
    //       ],
    //     ),
    //   )
    // );

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

  Widget getOutParamWidget(NodeStructData nodeType, StateScriptNode node, SubstituteOutParam sop) {
    // bool withOut = iIndex <nodeType.outParams.length;
    // if (!withOut) return Container(width: SSDefines.paramSize,);

    var outParam = nodeType.getOutParam(sop.outParamGuid);
    if (outParam == null){
      outParam = node.dynamicInterfaces[sop.outParamGuid];
    }
    if (outParam == null) return null;

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutParamConnection(node , outParam);
    Color tpColor =CommonUtil.alphaColorD( Color(outParam.paramType.hashCode) , 1.0);
    tpColor =CommonUtil.changeColorLightness(tpColor, 0.4);

    if (node.isModuleNode && !node.moduleInterfaces.containsKey(outParam.guid)){
      return Tooltip(
        child: Icon(
          MaterialCommunityIcons.alpha_f_circle,
          color: Colors.grey,
          size: SSDefines.portSize,
        ),
        message: outParam.paramType,
      );// dragTarget;
    }

    var dn = DraggableEx(

      child:Icon(
              MaterialCommunityIcons.alpha_f_circle,
              color: tpColor,//bWithConnection?Colors.brown:CommonUtil.scaleColor(Colors.brown, 0.26),
              size: SSDefines.portSize,
            ),
      childWhenDragging: Container(
        child: Icon(
          MaterialCommunityIcons.alpha_f_circle,
          // AntDesign.rightsquare,
          // AntDesign.rightsquare,
          color: Colors.red,//bWithConnection?Colors.red:Colors.grey,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
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
      onDraggableCanceled:(Velocity velocity, Offset offset){
        if (KeyEventCenter.isControlPressed()){
          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          SubstituteOutParam sop2 = SubstituteOutParam()..outParamGuid = sop.outParamGuid..x = off.dx..y = off.dy;
          node.sops.add(sop2);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
      },
//        data:nodeType.outPorts[iIndex],
      data: OutParamInfo(node, outParam , sop),
    );

    var dragTarget = DragTargetEx<InParamInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
//      onAccept: onAccept,
//      onDragMove: (off){
//
//      },
      onWillAccept:(InParamInfo ii){
        // if (ii.port.paramType != nodeType.outParams[iIndex].paramType){
        if (!StateScriptNodeViewState.isTypeCanLink(ii.node , ii.port , outParam)){
          BotToast.showText(text:"参数类型不匹配" , contentColor : Colors.redAccent);
          return false;
        }
        BotToast.cleanAll();
        return true;
      },
      onAcceptWithDetails: (DragTargetDetails<InParamInfo> details) {
        if (widget.node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = ParamConnection();
        con.outNodeGuid = widget.node.guid;
        con.outParamGuid = outParam.guid;
        con.inNodeGuid = details.data.node.guid;
        con.inParamGuid = details.data.port.guid;
        con.sopGuid = sop.guid;
        // if (details.data.port.paramType != nodeType.outParams[iIndex].paramType){
        if (!StateScriptNodeViewState.isTypeCanLink(details.data.node , details.data.port, outParam)){
          BotToast.showText(text:"参数类型不匹配，忽略本次操作" , contentColor : Colors.redAccent);
          return;
        }

        if (!ScriptInfo.current.scriptData.addParamConnection(con , sop : sop)){
//          BotToast.showSimpleNotification(title: "连接已经存在，忽略本次操作");
          BotToast.showText(text:"参数连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);

        }
        else{
          EventCenter.eventBus.fire(RefreshConnectCommandEvent());
          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());

        }
      },
      // onWillAccept: (e){return true;},
//      onLeave: onOutPortLeave,
    );


    // return dragTarget;
    return Tooltip(
        child:dragTarget ,
        message: outParam.paramType
    );// dragTarget;


  }
}