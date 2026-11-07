//@dart=2.11
import 'dart:async';
import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:battlepus/StateScript/AutoFill/AutoFiller.dart';
import 'package:battlepus/StateScript/FieldVisibleController.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/BreakPointType.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/PortInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutParam.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutPort.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';

import 'package:battlepus/common/drag_target_ex.dart';
import 'package:battlepus/common/tree_selector.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';

class StateScriptNodeView extends StatefulWidget {
  final StateScriptNode node;
  final SSCanvasViewState graph;

  StateScriptNodeView({Key key,this.node, this.graph}) : super(
      key: key);

  @override
  StateScriptNodeViewState createState() =>
      StateScriptNodeViewState(
      );
}

class StateScriptNodeViewState extends State<StateScriptNodeView> {




  static double _padding = 4;

  DateTime _lastPressedAdt;

  StreamSubscription<NodeRefreshEvent> _lis;
  StreamSubscription<NodeRefreshWithTargetEvent> _lis4;
  StreamSubscription<TransformUpdateEvent> _lis2;
  StreamSubscription<FocusNodeUpdateEvent> _lis3;

  bool _storeHistory = false;


  double getHeightAboveFields(){
    var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
    return SSDefines.nodeHeaderHeight + nodeType.getAllPortsHeight() + nodeType.getAllParamsHeight();
  }

  var _dcPort = new BoxDecoration(
//    shape:BoxShape.circle,
    boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
  );

  Widget getInPortWidget(NodeStructData nodeType , StateScriptNode node , InPort inPort){
//    var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
    bool withIn = inPort != null;//iIndex <nodeType.inPorts.length;
    if (!withIn) return const SizedBox(width: SSDefines.portSize,);
    //Entypo EvilIcons Feather
    // exit enter in out
    bool bWithConnection = ScriptInfo.current.getScriptData().hasInPortConnection(node , inPort);

    if (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(inPort.guid))){
      return const Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      );// dragTarget;
    }

    var dn = DraggableEx(
      child: bWithConnection?const Icon(
        AntDesign.rightsquare,
        color: Colors.green ,
        size: SSDefines.portSize,
      ):const Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      ),

      childWhenDragging:  const Icon(
          AntDesign.rightsquare,
          color: Colors.green,
          size: SSDefines.portSize,
        ),
      feedback:const SizedBox(
        width: 1,
       // color: Colors.red,
       // width: SSDefines.portSize ,
       // height: SSDefines.portSize ,
      ),

      data: InPortInfo(widget.node, inPort),
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
        if (KeyEventCenter.isShiftPressed()){
          if (widget.node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
            return;
          }
          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = inPort.guid..x = off.dx..y = off.dy ..type = InterfaceType.InPort;
          // ScriptInfo.current.scriptData.inPorts.add(mi);
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          // ScriptInfo.current.scriptData.registerInPortInterface(mi);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return;
        }

        var tmpPos = offset;//Offset(pos.dx , pos.dy);
        tmpPos = widget.graph.calcLocalPosition(tmpPos);
        tmpPos = widget.graph.fixPosition(tmpPos);

        RenderBox getBox = widget.graph.context.findRenderObject();
        var local = getBox.globalToLocal(offset);
        // print("aaaaaaaa");
        EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx ..showListY = local.dy ..srcNodeId = "p_${nodeType.guid}");
      },
    );
    var dragTarget = DragTargetEx<OutPortInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
//      onAccept: onAccept,
      onAcceptWithDetails: (DragTargetDetails<OutPortInfo> details) {
        if (widget.node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = PortConnection();
        con.inNodeGuid = widget.node.guid;
        con.inPortGuid = inPort.guid;
        con.outNodeGuid = details.data.node.guid;
        con.outPortGuid = details.data.port.guid;
        con.sopGuid = details.data.sop?.guid??"";
        if (!ScriptInfo.current.scriptData.addPortConnection(con , sop:details.data.sop)){
          BotToast.showText(text:"连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);
        }
        else{
          EventCenter.eventBus.fire(RefreshConnectCommandEvent());
        }
//    con.
      },


      onWillAccept: (e){return true;},
//      onWillAccept: onInPortWillAccept,
//      onLeave: onInPortLeave,
    );
//     return Container(
//       // color:Colors.red,
//       // decoration: _dcPort,
// //      color: Colors.indigo,
//       width: SSDefines.portSize ,
//       height: SSDefines.portSize ,
//       child: dragTarget,
//     );
    return Wrap(
      children: [
        GestureDetector(
          onTapUp: (e){
            EventCenter.eventBus.fire(PortClickEvent()..node = widget.node..portGuid = inPort.guid);
          },
          child: dragTarget,
        ),
        // InkWell(
        //
        //   child: Icon(
        //     MaterialCommunityIcons.link_box_variant,
        //     color: nodeType.inPorts[iIndex].isInterface ?Colors.indigo :Colors.grey,
        //     size: SSDefines.portSize,
        //   ),
        // )
      ],
    );
  }



  Widget getOutPortWidget(NodeStructData nodeType ,StateScriptNode node , OutPort outPort){
    bool withOut = outPort != null;//iIndex <nodeType.outPorts.length;
    if (!withOut) return const SizedBox(width: SSDefines.portSize,);

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutPortConnection(node , outPort);

    if (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(outPort.guid))){
      return const Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      );// dragTarget;
    }

    var dn = DraggableEx(

      child: bWithConnection?const Icon(
              AntDesign.rightsquare,
              color: Colors.red,
              size: SSDefines.portSize,
            ):const Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      ),
      childWhenDragging:const Icon(
          AntDesign.rightsquare,
          color: Colors.red,
          size: SSDefines.portSize,
        ),
        feedback:const SizedBox(
          width:1,
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
          if (widget.node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许创建替身" , contentColor : Colors.redAccent);
            return;
          }
          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          SubstituteOutPort sop = SubstituteOutPort()..outPortGuid = outPort.guid..x = off.dx..y = off.dy;
          widget.node.soports.add(sop);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return;
        }
        if (KeyEventCenter.isShiftPressed()){

          if (widget.node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
            return;
          }

          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = outPort.guid..x = off.dx..y = off.dy ..type = InterfaceType.OutPort;
          // ScriptInfo.current.scriptData.outPorts.add(mi);
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          // ScriptInfo.current.scriptData.registerOutPortInterface(mi);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return ;
        }

        var tmpPos = offset;//Offset(pos.dx , pos.dy);
        tmpPos = widget.graph.calcLocalPosition(tmpPos);
        tmpPos = widget.graph.fixPosition(tmpPos);

        RenderBox getBox = widget.graph.context.findRenderObject();
        var local = getBox.globalToLocal(offset);
        // print("aaaaaaaa");
        EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx ..showListY = local.dy ..srcNodeId = "${nodeType.guid}");

      },
//        data:nodeType.outPorts[iIndex],
      data: OutPortInfo(widget.node, outPort , null),
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

        if (!ScriptInfo.current.scriptData.addPortConnection(con)){
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
    return GestureDetector(
      onTapUp: (e){
        EventCenter.eventBus.fire(PortClickEvent()..node = widget.node..portGuid = outPort.guid);
      },
      child: dragTarget,
    );// dragTarget;
  }

  var textStyle = const TextStyle(fontSize: 12 , color:Color.fromARGB(255, 228, 223, 223) , fontWeight: FontWeight.w500 ,);
  var nodeHeaderStyle = const TextStyle(fontSize: 14 , color: Color.fromARGB(255, 228, 223, 223) , fontWeight: FontWeight.w800 ,);
  var paramHeaderStyle = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);
  var fieldHeaderStyle = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);

  // void getModulePortsWidget(NodeStructData nodeType , StateScriptNode node , List<Widget> lines){
  //   if (nodeType.fields.length<=0) return ;
  //   var scriptFieldId = nodeType.fields[0].guid;
  //   var fvh = node.fieldValues[scriptFieldId];
  //   if (fvh== null) return ;
  //   var scriptId = node.fieldValues[scriptFieldId].value as String;
  //   ScriptInfo si ;
  //   if (scriptId != null) {
  //     si = StateScriptProject.instance.getScriptByGuid(scriptId);
  //     if (si == null){
  //       return ;
  //     }
  //   }
  //
  //   //加载脚本
  //   if (si.scriptData == null) si.loadScript();
  //   var _sb4 = const SizedBox(width: 2,);
  //   var ssd = si.scriptData;
  //   if (ssd == null) return ;
  //   // var inCount = ssd.inPorts.length;
  //   // var outCount = ssd.outPorts.length;
  //   var fullPortLineCount = max(inCount,outCount);
  //
  //   for(int fi = 0 ; fi < fullPortLineCount;++fi){
  //     var withIn = fi < inCount;
  //     var withOut = fi < outCount;
  //     var iIn = ssd.getInPortInterfaceTarget(fi);//withIn?ssd.validInPorts[fi]:1024;
  //     if (iIn != null){iIn = ssd.getRealInPortInterface(fi);widget.node.dynamicInterfaces[iIn.guid] = iIn;}
  //     var iOut = ssd.getOutPortInterfaceTarget(fi);//withOut?ssd.validOutPorts[fi]:1024;
  //     if (iOut != null){iOut = ssd.getRealOutPortInterface(fi);widget.node.dynamicInterfaces[iOut.guid] = iOut;}
  //     // continue;
  //     var rowLine = Container(
  //       // color: Colors.indigo,
  //       padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding, 0),
  //       height: SSDefines.nodePortHeight,
  //       child: Row (
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           // crossAxisAlignment: CrossAxisAlignment.end,
  //           children:[
  //             getInPortWidget(nodeType ,node , iIn),
  //             _sb4,
  //             !withIn?SizedBox(width:0):Text(ssd.getInPortInterfaceName(fi),maxLines: 1, overflow: TextOverflow.clip,  style: textStyle),
  //             Expanded(child:Container()),
  //             !withOut?SizedBox(width:0):Text(ssd.getOutPortInterfaceName(fi) ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
  //
  //             if (node.soports == null || node.soports.length==0) _sb4,
  //             getOutPortWidget(nodeType ,node , iOut),
  //           ]
  //       ),
  //     );
  //     lines.add(rowLine);
  //     if (withIn){
  //       var key = "${node.guid}_${iIn.guid}";
  //       node.portYPos[key] = Offset(node.x+SSDefines.portSize/2 , node.y+node.totalLineHeight + SSDefines.nodePortHeight/2);
  //     }
  //     if (withOut){
  //       var key = "${node.guid}_${iOut.guid}";
  //       node.portYPos[key] = Offset( node.x+nodeType.width- SSDefines.portSize/2, node.y+node.totalLineHeight + SSDefines.nodePortHeight/2);
  //     }
  //     node.totalLineHeight += SSDefines.nodePortHeight;
  //   }
  // }
  void getPortsWidget(NodeStructData nodeType , StateScriptNode node , List<Widget> lines){

    // if (nodeType.name == "Module"){
    //   getModulePortsWidget(nodeType,node,lines);
    //   // return;
    // }

    var parent = StateScriptProject.instance.structMap[nodeType.baseType];
    if (parent != null){
      getPortsWidget(parent , node , lines);
    }

    var _sb4 = const SizedBox(width: 2,);
    var fullPortLineCount = max(nodeType.inPorts.length,nodeType.outPorts.length);
    for(int i = 0 ; i < fullPortLineCount;++i){
      var withIn = i<nodeType.inPorts.length;
      var withOut = i<nodeType.outPorts.length;

      var inport = withIn?nodeType.inPorts[i]:null;
      var outport = withOut?nodeType.outPorts[i]:null;


      bool withSubPort = withOut && node.getSubPortsByPortGuid(nodeType.outPorts[i].guid).length>0;
      var rowLine = SizedBox(
        // 端口行不再包一层无色容器，直接由高度约束承载，端口图标与节点边缘对齐
        height: SSDefines.nodePortHeight,
        child: Row (
            crossAxisAlignment: CrossAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              getInPortWidget(nodeType ,node , inport),
              _sb4,
              !withIn?const SizedBox(width:0):Text(nodeType.inPorts[i].getTypeShowString(),maxLines: 1, overflow: TextOverflow.clip,  style: textStyle),
              const Expanded(child:const SizedBox(width: 1,)),
              !withOut?const SizedBox(width:0):Text(nodeType.outPorts[i].getTypeShowString() ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
              _sb4,
              if (withSubPort)              Container(
                 width: 18,
                  height: 18,
                  child:   PopupMenuButton<SubstituteOutPort>(
                padding:EdgeInsets.zero ,
                itemBuilder: (context) {
                  var sops =  node.getSubPortsByPortGuid(nodeType.outPorts[i].guid);
                  var  selfNodeType = StateScriptProject.instance.structMap[node.nodeTypeGuid];
                  var showName = DartCommon.isEmpty(node.nodeAlias)?selfNodeType.getTypeShowString():node.nodeAlias;
                  List<PopupMenuEntry<SubstituteOutPort>> items = [];
                  for (var sop in sops) {
                    if (!DartCommon.isEmpty(sop.desc)) showName = sop.desc;
                    items.add(PopupMenuItem(child: Text(showName),value: sop));
                  }  
                 return  items;
                },
                  onSelected: (n) {
                    ScriptInfo.current.unselectAll();
                    n.selected = true;
                    ZoomState.current.focusPosition(n.x,n.y);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  },
                icon: Icon(MaterialCommunityIcons.link_box_variant , size: 14, color: Colors.indigo,),
            ),

          ),
              getOutPortWidget(nodeType ,node , outport),
            ]
        ),
      );
      lines.add(rowLine);
      if (withIn){
        var key = "${node.guid}_${nodeType.inPorts[i].guid}";
        node.portYPos[key] = Offset(node.x + SSDefines.portSize/2 , node.y + node.totalLineHeight + SSDefines.nodePortHeight/2);
      }
      if (withOut){
        var key = "${node.guid}_${nodeType.outPorts[i].guid}";
        node.portYPos[key] = Offset(node.x + node.getWidth()- SSDefines.portSize/2 ,node.y +  node.totalLineHeight + SSDefines.nodePortHeight/2);
      }
      node.totalLineHeight += SSDefines.nodePortHeight;
    }
  }

  var _dcParam = new BoxDecoration(
//    shape:BoxShape.circle,

    boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
  );


  static bool isTypeCanLink(StateScriptNode inNode , InParam type1 , OutParam type2){
    // print("$type1 $type2");
    var inType = type1.paramType;
    if (DartCommon.isEmpty(inType) ){
      var guid = type1.fieldId;
      if (!DartCommon.isEmpty(guid)){
        var fi = inNode.getNodeStructType().getAllFieldMap()[guid];
        if (fi != null){
          inType = fi.extraParam;
        }
      }
    }
    if (inType == type2.paramType){
      return true;
    }

    if (inType.trim() == "Union" && InParam.ignoreTypes.containsKey(type2.paramType.trim())){
      return true;
    }
    if (type2.paramType.trim() == "Union" && InParam.ignoreTypes.containsKey(inType.trim())){
      return true;
    }

    return false;
  }

  // IconData getParamIcon(String prmType){
  //   if (DartCommon.isEmpty(prmType)){
  //     return MaterialCommunityIcons.record_circle;
  //   }
  //   var ch = prmType.codeUnitAt(0);
  //
  // }
  Widget getInParamWidget(NodeStructData nodeType, StateScriptNode node, InParam inParam) {
    // bool withIn = iIndex <nodeType.getNormalInParamsCount();
    if (inParam == null) return const SizedBox(width: SSDefines.portSize,);
    bool bWithConnection = ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam);
    Color tpColor = CommonUtil.alphaColorD( Color(inParam.paramType.hashCode) , 1.0);
    tpColor = CommonUtil.changeColorLightness(tpColor, 0.4);

    if (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(inParam.guid))){
      return Tooltip(
        child: const Icon(
          MaterialCommunityIcons.record_circle,
          color: Colors.grey,
          size: SSDefines.portSize,
        ),
        message: inParam.paramType,
      );// dragTarget;
    }

    var dn = DraggableEx(
      child:  Icon(
          // AntDesign.rightsquare,
          MaterialCommunityIcons.record_circle,
          // color: bWithConnection?tpColor:CommonUtil.alphaColorD(tpColor, 0.5),
          color:tpColor,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
      childWhenDragging: const Icon(
          MaterialCommunityIcons.record_circle,
          color: Colors.green,//bWithConnection?Colors.red:Colors.grey,
          size: SSDefines.portSize,
        ),
      feedback:const SizedBox(
        width: 1,
//        color: Colors.red,
//        width: SSDefines.portSize ,
//        height: SSDefines.portSize ,

      ),

      data: InParamInfo(widget.node, inParam),
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
        if (KeyEventCenter.isShiftPressed()){

          if (widget.node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
            return;
          }

          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = inParam.guid..x = off.dx..y = off.dy ..type = InterfaceType.InParam;
          // ScriptInfo.current.scriptData.inParams.add(mi);
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          // ScriptInfo.current.scriptData.registerInParamInterface(mi);
          EventCenter.eventBus.fire(GlobalRefreshEvent());

          return;
        }

        var tmpPos = offset;//Offset(pos.dx , pos.dy);
        tmpPos = widget.graph.calcLocalPosition(tmpPos);
        tmpPos = widget.graph.fixPosition(tmpPos);

        RenderBox getBox = widget.graph.context.findRenderObject();
        var local = getBox.globalToLocal(offset);
        // print("aaaaaaaa");
        EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx
          ..showListY = local.dy..outParamFilter = inParam.paramType..srcNodeId = "ip_p_${nodeType.guid}"
            ..srcNodeGuid = widget.node.guid..srcParamGuid = inParam.guid..paramName
        );
      },
    );
    var dragTarget = DragTargetEx<OutParamInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
      onWillAccept:(OutParamInfo ii){
        // if (ii.port.paramType != inParam.paramType){
        if (!isTypeCanLink(widget.node, inParam , ii.port)){
          BotToast.showText(text:"参数类型不匹配" , contentColor : Colors.redAccent);
          return false;
        }
        BotToast.cleanAll();
        return true;
      },
//      onAccept: onAccept,
      onAcceptWithDetails: (DragTargetDetails<OutParamInfo> details) {
        if (widget.node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = ParamConnection();
        con.inNodeGuid = widget.node.guid;
        con.inParamGuid = inParam.guid;
        con.outNodeGuid = details.data.node.guid;
        con.outParamGuid = details.data.port.guid;
        con.sopGuid = details.data.sop?.guid;

        // if (details.data.port.paramType != inParam.paramType){
        if (!isTypeCanLink(widget.node , inParam , details.data.port)){
          BotToast.showText(text:"参数类型不匹配，忽略本次操作" , contentColor : Colors.redAccent);
          return;
        }

        if (!ScriptInfo.current.scriptData.addParamConnection(con , sop:details.data.sop)){
          BotToast.showText(text:"参数连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);
        }
        else{

          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        }
      },
    );
    return Tooltip(
      child: GestureDetector(
        onTapUp: (e){
          EventCenter.eventBus.fire(PortClickEvent()..node = widget.node..portGuid = inParam.guid);
        },
        child: dragTarget,
      ),
      message: inParam.paramType,
    );// dragTarget;
  }

  Widget getOutParamWidget(NodeStructData nodeType, StateScriptNode node, OutParam outParam) {
    bool withOut = outParam != null;//iIndex <nodeType.outParams.length;
    if (!withOut) return const SizedBox(width: SSDefines.paramSize,);

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutParamConnection(node , outParam);
    Color tpColor =CommonUtil.alphaColorD( Color(outParam.paramType.hashCode) , 1.0);
    tpColor =CommonUtil.changeColorLightness(tpColor, 0.4);

    if (node.isModuleNode && (!node.isRootModuleNode || !node.moduleInterfaces.containsKey(outParam.guid))){
      return Tooltip(
        child: const Icon(
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
              color:tpColor,
              size: SSDefines.portSize,
            ),
      childWhenDragging: const Icon(
          MaterialCommunityIcons.alpha_f_circle,
          // AntDesign.rightsquare,
          // AntDesign.rightsquare,
          color: Colors.red,//bWithConnection?Colors.red:Colors.grey,
          size: SSDefines.portSize,
        ),
      feedback:const SizedBox(
        width: 1,
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
          if (widget.node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许创建替身" , contentColor : Colors.redAccent);
            return;
          }
          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          SubstituteOutParam sop = SubstituteOutParam()..outParamGuid = outParam.guid..x = off.dx..y = off.dy;
          widget.node.sops.add(sop);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return;
        }

        if (KeyEventCenter.isShiftPressed()){

          if (widget.node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
            return;
          }
          var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
          var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = outParam.guid..x = off.dx..y = off.dy ..type = InterfaceType.OutParam;
          // ScriptInfo.current.scriptData.outParams.add(mi);
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          // ScriptInfo.current.scriptData.registerOutParamInterface(mi);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return;
        }


        var tmpPos = offset;//Offset(pos.dx , pos.dy);
        tmpPos = widget.graph.calcLocalPosition(tmpPos);
        tmpPos = widget.graph.fixPosition(tmpPos);

        RenderBox getBox = widget.graph.context.findRenderObject();
        var local = getBox.globalToLocal(offset);
        // print("aaaaaaaa");
        EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx
          ..showListY = local.dy..inParamFilter = outParam.paramType..srcNodeId = "op_${nodeType.guid}"
          ..srcNodeGuid = widget.node.guid..srcParamGuid = outParam.guid
        );
      },
//        data:nodeType.outPorts[iIndex],
      data: OutParamInfo(node, outParam , null),
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
        if (!isTypeCanLink(ii.node,ii.port , outParam)){
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
        // if (details.data.port.paramType != nodeType.outParams[iIndex].paramType){
        if (!isTypeCanLink(details.data.node , details.data.port, outParam)){
          BotToast.showText(text:"参数类型不匹配，忽略本次操作" , contentColor : Colors.redAccent);
          return;
        }

        if (!ScriptInfo.current.scriptData.addParamConnection(con)){
//          BotToast.showSimpleNotification(title: "连接已经存在，忽略本次操作");
          BotToast.showText(text:"参数连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);

        }
        else{
          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        }
      },
      // onWillAccept: (e){return true;},
//      onLeave: onOutPortLeave,
    );


    // return dragTarget;
    return Tooltip(
        child: GestureDetector(
          onTapUp: (e){
            EventCenter.eventBus.fire(PortClickEvent()..node = widget.node..portGuid = outParam.guid);
          },
          child: dragTarget,
        ),
        message: outParam.paramType
    );// dragTarget;
  }

  // void getModuleParamsWidget(NodeStructData nodeType, StateScriptNode node, List<Widget> lines , {bool hideNoConnection = false}) {
  //   if (nodeType.fields.length<=0) return ;
  //   var scriptFieldId = nodeType.fields[0].guid;
  //   var fvh = node.fieldValues[scriptFieldId];
  //   if (fvh== null) return ;
  //   var scriptId = node.fieldValues[scriptFieldId].value as String;
  //   ScriptInfo si ;
  //   if (scriptId != null) {
  //     si = StateScriptProject.instance.getScriptByGuid(scriptId);
  //     if (si == null){
  //       return ;
  //     }
  //   }
  //
  //   //加载脚本
  //   if (si.scriptData == null) si.loadScript();
  //   var _sb4 = const SizedBox(width: 2,);
  //   var ssd = si.scriptData;
  //   if (ssd == null) return ;
  //   var inCount = ssd.inParams.length;
  //   var outCount = ssd.outParams.length;
  //   var fullPortLineCount = max(inCount,outCount);
  //
  //   for(int fi = 0 ; fi < fullPortLineCount;++fi){
  //     var withIn = fi < inCount;
  //     var withOut = fi < outCount;
  //     var iIn = ssd.getInParamInterfaceTarget(fi);//withIn?ssd.validInParams[fi]:1024;
  //     if (iIn != null) {iIn = ssd.getRealInParamInterface(fi); widget.node.dynamicInterfaces[iIn.guid] = iIn; }
  //     var iOut =  ssd.getOutParamInterfaceTarget(fi);//withOut?ssd.validOutParams[fi]:1024;
  //     if (iOut != null){iOut = ssd.getRealOutParamInterface(fi);widget.node.dynamicInterfaces[iOut.guid] = iOut;}
  //
  //     // var inParam = nodeType.getNormalInParam(iIn);
  //     // if (inParam != null) inParam.target = ssd.getInParamInterfaceTarget(iIn);
  //     // var outParam = nodeType.outParams[iOut];
  //     // if (outParam != null) outParam.target = ssd.getOutParamInterfaceTarget(iOut);
  //
  //
  //     // if (hideNoConnection){
  //     //   bool bInWithConnection = withIn && ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam);
  //     //   bool bOutWithConnection = withOut && ScriptInfo.current.getScriptData().hasOutParamConnection(node , nodeType.outParams[iOut]);
  //     //   withIn &= bInWithConnection;
  //     //   withOut &= bOutWithConnection;
  //     // }
  //
  //     // continue;
  //     var rowLine = Container(
  //       // color: Colors.indigo,
  //       padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding, 0),
  //       height: SSDefines.nodePortHeight,
  //       child: Row (
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           // crossAxisAlignment: CrossAxisAlignment.end,
  //           children:[
  //             getInParamWidget(nodeType ,node , iIn),
  //             _sb4,
  //             !withIn?SizedBox(width:0):Text(ssd.getInParamInterfaceName(fi),maxLines: 1, overflow: TextOverflow.clip,  style: textStyle),
  //             Expanded(child:Container()),
  //             !withOut?const SizedBox(width:0):Text(ssd.getOutParamInterfaceName(fi) ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
  //             _sb4,
  //             getOutParamWidget(nodeType ,node , iOut),
  //           ]
  //       ),
  //     );
  //     lines.add(rowLine);
  //     if (withIn){
  //       var key = "${node.guid}_${iIn.guid}";
  //       node.portYPos[key] = Offset(node.x+SSDefines.portSize/2 , node.y+node.totalLineHeight + SSDefines.nodePortHeight/2);
  //     }
  //     if (withOut){
  //       var key = "${node.guid}_${iOut.guid}";
  //       node.portYPos[key] = Offset(node.x+nodeType.width - SSDefines.portSize/2 , node.y+node.totalLineHeight + SSDefines.nodePortHeight/2);
  //     }
  //     node.totalLineHeight += SSDefines.nodePortHeight;
  //   }
  // }
//  bool flipParam = false;
  void getParamsWidget(NodeStructData nodeType, StateScriptNode node, List<Widget> lines , {bool hideNoConnection = false, Map visibleMap = const{} }) {

    // if (nodeType.name == "Module"){
    //   getModuleParamsWidget(nodeType,node,lines,hideNoConnection:hideNoConnection);
    //   // return;
    // }

    // //参数端口类型 可以由字段控制显隐
    //   Map visibleMap = {};
    // //运行 lua 脚本显隐
    // if (StateScriptProject.instance.useLuaForFieldVisible){
    //   var code = FieldVisibleController.instance.fieldVisibleCodeForStruct[nodeType.guid];
    //   if (code != null){
    //     visibleMap = FieldVisibleController.instance.getFieldVisibleMap(node);
    //   }
    // }

    var parent = StateScriptProject.instance.structMap[nodeType.baseType];
    if (parent != null){
      getParamsWidget(parent , node , lines , hideNoConnection: hideNoConnection);
    }

    var _sb4 = const SizedBox(width: 2,);
    var fullParamLineCount = max(nodeType.getNormalInParamsCount(),nodeType.outParams.length);
    for(int i = 0 ; i < fullParamLineCount;++i){
      var withIn = i<nodeType.getNormalInParamsCount();
      var withOut = i<nodeType.outParams.length;
      Widget rowLine ;
      var inParam = nodeType.getNormalInParam(i);
      var outParam = withOut?nodeType.outParams[i]:null;
      
      if (hideNoConnection){
        bool bInWithConnection = withIn && ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam);
        bool bOutWithConnection = withOut && ScriptInfo.current.getScriptData().hasOutParamConnection(node , nodeType.outParams[i]);
        withIn &= bInWithConnection;
        withOut &= bOutWithConnection;
      }
      bool inParamVisible = true;
      if(inParam != null)
      {
          inParamVisible = (visibleMap[inParam.name]??true);
          paramConnectionverify( node.guid, inParam.guid,inParamVisible,true);
      }

      bool outParamVisible = true;
      if(outParam != null)
      {
          outParamVisible = (visibleMap[outParam.name]??true);
          paramConnectionverify(node.guid, outParam.guid,outParamVisible,false);
      }

      if (!withIn && !withOut) continue;
      if (!nodeType.getIsFlipParam()){
        bool withSubParams = withOut && node.getSubParamsByParamGuid(nodeType.outParams[i].guid).length>0;
        rowLine = SizedBox(
          // 参数行与端口行保持一致，不额外包无色容器，连接点贴齐节点边缘
          height: SSDefines.nodeParamHeight,
          child: Row (
            crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                (!withIn || !inParamVisible)?const SizedBox(width:0):getInParamWidget(nodeType , node , inParam),
                _sb4,
                (!withIn|| !inParamVisible)?const SizedBox(width:0):Text(inParam.getTypeShowString(), maxLines: 1, overflow: TextOverflow.clip , style: textStyle),
                const Expanded(child:const SizedBox(width: 1,)),
                  (!withOut || !outParamVisible) ?const SizedBox(width:0):Text(nodeType.outParams[i].getTypeShowString() ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
                _sb4,
                if (withSubParams && outParamVisible)    
                Container(
                  width: 18,
                  height: 18,
                  child: PopupMenuButton<SubstituteOutParam>(
                  padding:EdgeInsets.zero ,
                  itemBuilder: (context) {
                    var sops =  node.getSubParamsByParamGuid(nodeType.outParams[i].guid);
                    var selfNodeType = StateScriptProject.instance.structMap[node.nodeTypeGuid];
                    var showName = DartCommon.isEmpty(node.nodeAlias)?selfNodeType.getTypeShowString():node.nodeAlias;
                    List<PopupMenuEntry<SubstituteOutParam>> items = [];
                    for (var sop in sops) {
                      if (!DartCommon.isEmpty(sop.desc)) showName = sop.desc;
                      items.add(PopupMenuItem(child: Text(showName),value: sop));
                    }  
                    return  items;
                  },
                  onSelected: (n) {
                    ScriptInfo.current.unselectAll();
                    n.selected = true;
                    ZoomState.current.focusPosition(n.x,n.y);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  },
                  icon: Icon(MaterialCommunityIcons.link_box_variant , size: 14, color: Colors.indigo,),
                ),

              ),
                (!withOut || !outParamVisible) ?const SizedBox(width:0):getOutParamWidget(nodeType , node , outParam),
            ]
          ),
        );
      }
      else{
        // // var inParam = nodeType.getNormalInParam(i);
        // rowLine = Container(
        //   padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding, 0),
        //   //        padding: _portPadding,
        //   height: SSDefines.nodeParamHeight,
        //   child: Row (
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children:[
        //         !withOut?SizedBox(width:0):getOutParamWidget(nodeType , node ,i),
        //         _sb4,
        //         !withOut?SizedBox(width:0):Text(nodeType.outParams[i].getTypeShowString() , style: textStyle),
        //         Expanded(child:Container()),
        //         !withIn?SizedBox(width:0):Text(inParam.getTypeShowString(),  style: textStyle),
        //         _sb4,
        //         !withIn?SizedBox(width:0):getInParamWidget(nodeType , node , inParam),
        //       ]
        //   ),
        // );
      }
      lines.add(rowLine);
      if (withIn){
        var key = "${node.guid}_${inParam.guid}";
        node.portYPos[key] = Offset(node.x+SSDefines.portSize/2 , node.y+node.totalLineHeight + SSDefines.nodeParamHeight/2);
      }
      if (withOut){
        var key = "${node.guid}_${nodeType.outParams[i].guid}";
        node.portYPos[key] =  Offset(node.x+node.getWidth() - SSDefines.portSize/2 , node.y+node.totalLineHeight + SSDefines.nodeParamHeight/2);
      }
      node.totalLineHeight += SSDefines.nodeParamHeight;
    }
  }

  
  //给Unity发通信,通知节点端口数据刷新
  void NoticeLogPortData(bool isLog)
  {
      RunSession.instance.sendRuntimeLogNodePortData( widget.node.scriptId, widget.node.exportId, isLog);
  }

  bool isFocus()
  {
      return RunSession.instance.isFocusStateMode;
  }

  void paramConnectionverify( String nodeGUID, String portGuid, bool visible, bool isInParam)
  {
    if(visible) return;
      var connections = ScriptInfo.current.scriptData.paramConnections;
      if(connections.length >0)
      {
        ParamConnection co = null;
        for (var element in connections) 
        {
          String comparePortGuid = isInParam?element.inParamGuid :element.outParamGuid;
          String compareNodeGUID = isInParam?element.inNodeGuid :element.outNodeGuid;
          if(comparePortGuid == portGuid && compareNodeGUID == nodeGUID )
          {
              co = element;
              break;
          }
        }
        if(co!= null && !visible)
        {
        ScriptInfo.current.scriptData.removeParamConnection(co);
        }
      }
  }


  bool getNodePortDataDebugState()
  {
     if( RunSession.instance.isRunning){
       return widget.node.inLogPortData;
     }
     else
     {
        if( widget.node.inLogPortData)
          {
            widget.node.inLogPortData = false;
            //做一次协议同步
            RunSession.instance.sendRuntimeLogNodePortData( widget.node.scriptId, widget.node.exportId, false);
          }
        return  widget.node.inLogPortData;
     }
  }

  Color getNodeColor(){
//    print(widget.node.scriptName);
//    print(RunSession.instance.activeScriptName);
    if (!RunSession.instance.isRunning || RunSession.instance.activeScriptId != widget.node.scriptId){
      // widget.node.getNodeStructType().bgColor = Colors.grey.value;
      // StateScriptProject.instance.nodeStructs.forEach((element) {element.bgColor = Colors.grey.value;});
      return Color(widget.node.getNodeStructType().bgColor);
    }

    if (RunSession.instance.isActive(widget.node.exportId)){
      return CommonUtil.scaleColor(Colors.yellow, 0.5);
    }

    if (!widget.node.getNodeStructType().withUpdateLogic)
    {
      if(RunSession.instance.isFlashing(widget.node.exportId))
      {
       
        if(!RunSession.instance.isEndNode(widget.node.exportId))
              return CommonUtil.scaleColor(Colors.blue, 0.5);

        return Color.fromARGB(255, 183, 0, 255);
      }

      if(RunSession.instance.isEndNode(widget.node.exportId))
      {
          return Color.fromARGB(255, 183, 0, 255);
      }
    }

    return CommonUtil.scaleColor(Colors.brown, 0.2);

  }

  void onHeadTapDown({bool noEditing = false}){
    EventCenter.eventBus.fire(FocusCanvasEvent());
    if (!noEditing){
      if (!KeyEventCenter.isControlPressed() && _lastPressedAdt != null && DateTime.now().difference(_lastPressedAdt) < Duration(milliseconds: 400)) {

        // if (widget.node.isModuleNode) return ;
        setState(() {
          // EventCenter.eventBus.fire(FieldEditorRefreshEvent());
          widget.node.inEditting = !widget.node.inEditting;


          if (widget.node.inEditting){
            if (KeyEventCenter.isShiftPressed()){
              EventCenter.eventBus.fire(GlobalRefreshEvent());
            }
            // EventCenter.eventBus.fire(GlobalRefreshEvent());

            // for(var n in ScriptInfo.current.scriptData.nodes){
            //   EventCenter.eventBus.fire(NodeSelectStatusChangedEvent()..targetNode = n);
            // }
            // EventCenter.eventBus.fire(NodeSelectStatusChangedEvent()..targetNode = widget.node);

          }
          // EventCenter.eventBus.fire(GlobalRefreshEvent());
          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());

          EventCenter.eventBus.fire(NodeRefreshDragOrderEvent());
          // EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = widget.node);
        });
      }
    }
    _lastPressedAdt = DateTime.now();
    if (KeyEventCenter.isControlPressed()){
      if (widget.node.isModuleNode) return ;
      setState(() {
        // EventCenter.eventBus.fire(FieldEditorRefreshEvent());
        widget.node.selected = !widget.node.selected;
        // EventCenter.eventBus.fire(NodeSelectStatusChangedEvent()..targetNode = widget.node);
      });
    }
    else{
      if (widget.node.isModuleNode) return ;
      if (widget.node.selected == false) {
        ScriptInfo.current.unselectAll();
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
      }
      if (widget.node.selected == false) {
        setState(() {
          widget.node.selected = true;

          SimpleNode info = SimpleNode();
          info.guid = widget.node.guid;
          Transport.instance.sendUdpData(OPackType.O2U_MAP_FocusNode, info);

          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        });
      }
    }
  }

  var _headerPadding = EdgeInsets.fromLTRB(4,0,0,0);

  Widget getNodeWidget(){

    widget.node.totalLineHeight = 0;
    widget.node.initPortYPos();
    bool inDebug = false;

    var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
    if (nodeType == null) return Container(child : const Text("类型错误"));

    bool isModule = nodeType.name == "Module";
    String moduleName ;
    if (isModule){
      var scriptFieldId = nodeType.fields[0].guid;
      var fvh = widget.node.fieldValues[scriptFieldId];
      if (fvh != null) {
        var scriptId = widget.node.fieldValues[scriptFieldId].value as String;
        ScriptInfo si;
        if (scriptId != null) {
          si = StateScriptProject.instance.getScriptByGuid(scriptId);
          if (si != null) {
            moduleName = si.getTypeShowString();
          }
        }
      }
    }
    // var ntname = "${widget.node.exportId??"?(导出时指定)"}";
    var ntname = nodeType.getTypeShowString();
    if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == widget.node.scriptId){
      // ntname = ntname + " |" +widget.node.exportId.toString() + "|" + RunSession.instance.getTriggerCount(widget.node.exportId).toString();
      // ntname = ntname + "|" +RunSession.instance.getTriggerCount(widget.node.exportId).toString();
      inDebug = true;
    }


    // if (!DartCommon.isEmpty(widget.node.description)){
    //   ntname = widget.node.description;
    // }
    if (!DartCommon.isEmpty(ntname) && ntname[0] == "#"){
      var newName = ntname.substring(1).replaceAllMapped(RegExp(r'\{\s*(\w+)\s*\}'), (match){
        var fieldName = match.group(1);
        var fi = nodeType.getFieldByName(fieldName); //widget.node.fie
        if (fi != null){
          // print(fi.guid);
          var val = widget.node.fieldValues[fi.guid]?.value;
          if (val != null) {
            var ed = SSFieldType.getFieldType(fi.typeGuid, fieldInfo: fi);
            if (ed != null) {
              return ed.parseShortShowName(val);
            }
          }
          // return val;
        }
        return "";
      });

      ntname = newName;
    }

    // var br = 6.0;
    //
    // if (!DartCommon.isEmpty(widget.node.description)){
    //
    // }

    var mainColor = getNodeColor();
    if (mainColor == Colors.white ){
      mainColor = Colors.grey;//CommonUtil.scaleColor(Colors.grey,0.3);
    }
    bool bInLogPortData  = getNodePortDataDebugState();

    var nodeOutDec = new BoxDecoration(
        // color:Colors.white,
        border: new Border.all(color: CommonUtil.scaleColor(mainColor, 0.8), width: 2),
        color : inDebug?mainColor:Color.fromARGB(160,30, 30, 30),
        boxShadow: [ 
          BoxShadow(color: (widget.node.selected??false)?  CommonUtil.alphaColor(Colors.lightGreen,140):Color.fromARGB(mainColor.alpha > 200 ? 200:mainColor.alpha, mainColor.red, mainColor.green, mainColor.blue),   
           blurRadius:  widget.node.selected??false?6.0:0.0, 
           spreadRadius: widget.node.selected??false?8.0:0.0) , 
          // BoxShadow(color: Colors.white)
           ],
        // // shape: BoxShape.rectangle, // 默认值也是矩形
        borderRadius: new BorderRadius.circular(((nodeType.getIsTimelineNode()??false)?1.0:5.0))
    );

    bool bEditField =  widget.node.inEditting;

    var innerWidth = widget.node.getWidth();//SSDefines.nodeWidth ;//* (bEditField ? SSDefines.editFactor:1);
    var width = innerWidth ;//+ SSDefines.innerHPadding * 2 ;// + SSDefines.portOffX *2;

    // 标题栏独立背景已移除，名称与按钮和 In/Out 端口行共用节点外层容器背景
    // var dcHeader = new BoxDecoration(
    //
    //     // border: new Border.all(color: CommonUtil.scaleColor(mainColor , 0.5), width: 1.5),
    //     // color: CommonUtil.scaleColor(Colors.grey , 0.5),//Color(widget.node.getNodeStructType().bgColor),
    //     color: CommonUtil.scaleColor(mainColor, 0.8),
    //     // gradient: LinearGradient( colors: [CommonUtil.scaleColor(mainColor , 0.8), CommonUtil.scaleColor(mainColor , 0.5) ],),
    //     borderRadius: BorderRadius.only(topLeft: Radius.circular(1.5) , topRight: Radius.circular(1.5)),
    //     // borderRadius: new BorderRadius.circular(((nodeType.getIsTimelineNode()??false)?0.5:3.7)),
    //
    // );
    final minTLWidth = 1;
    var finalName =  isModule?"$ntname - ${moduleName??"未指定"}":"$ntname";


    var headerCon = Container(
      // width: innerWidth+9,
      // 标题栏不再使用独立背景，名称与按钮直接落在节点外层容器上，与 In/Out 端口行同框、同透明度
      // decoration: dcHeader,
      // color :Colors.greenAccent,
      padding: _headerPadding,
      height: SSDefines.nodeHeaderHeight,
      child: Row(
        children: [
          // if (nodeType.isTimelineNode) GestureDetector(
          //   onPanStart: (e){
          //     widget.node.downPointer = e.globalPosition;
          //     widget.node.oriX = widget.node.x;
          //     widget.node.oriWidth = widget.node.tlWidth;
          //   },
          //   onPanUpdate: (e){
          //
          //     setState(() {
          //       var off = e.globalPosition - widget.node.downPointer;
          //       off = widget.graph.global2LocalDelta(off);
          //       var offX = off.dx;
          //       if (offX >= widget.node.oriWidth-minTLWidth){
          //         offX = widget.node.oriWidth-minTLWidth;
          //       }
          //       widget.node.x = (widget.node.oriX + offX).floorToDouble();
          //       widget.node.tlWidth = (widget.node.oriX + widget.node.oriWidth - widget.node.x).floorToDouble();
          //
          //       // print(c.outOffX);
          //       EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
          //       EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          //
          //     });
          //   },
          //   onPanEnd: (e){
          //     setState(() {
          //       EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
          //       EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          //     });
          //   },
          //   child: Icon(
          //     MaterialCommunityIcons.chevron_left_circle,
          //     size: 14,
          //     color:  Colors.brown,
          //   )
          // ),
          Expanded(child : Text(finalName, maxLines: 1, overflow: TextOverflow.clip, style: nodeHeaderStyle)),
          // nodeType.syncTransform?Container(
          //   width: 22,
          //   child:IconButton(padding:EdgeInsets.all(0),icon: Icon(MaterialCommunityIcons.unity,), color: Colors.indigo, tooltip:"unity中定位",iconSize: 20,
          //     onPressed: (){
          //       // ObjInfo info = widget.node.getTransformInfo(null);
          //       // PackSolver.registerTransitionObject(widget.node);
          //       // Transport.instance.sendUdpData(OPackType.O2U_SigleObject, info);
          //       BotToast.showText(text: "已发送");
          //     },
          //   ),
          // ):Container(width: 0,),
          if(isFocus())
             SizedBox(
            // Container(
            width: 22,
            child:IconButton(padding:EdgeInsets.all(0),icon: Icon(bInLogPortData ? Icons.radio_button_on : Icons.radio_button_off,), iconSize: 20,color: bInLogPortData ? Colors.red: Colors.blue, tooltip: bInLogPortData?"取消输出端口信息":"输出端口信息",
              onPressed: (){
                NoticeLogPortData(!widget.node.inLogPortData);

                setState(() {
                    widget.node.inLogPortData = !widget.node.inLogPortData;
                   EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                });

              },
            ),
          ),

          SizedBox(
            // Container(
            width: 22,
            child:IconButton(padding:EdgeInsets.all(0),icon: const Icon(MaterialCommunityIcons.alpha_d_box_outline,), iconSize: 20,color: Colors.blue, tooltip:"节点定义",
              onPressed: (){
                SSDefines.focusNodeType = nodeType.guid;
                Navigator.pushNamed(context, "/NodeDefinePage").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));

              },
            ),
          ),
          SizedBox(
             width: 22,
             child:IconButton(padding:EdgeInsets.all(0),icon: Icon(bEditField ? MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.alpha_m_box_outline,), iconSize: 20,color: bEditField?Colors.red:Colors.blue, tooltip:bEditField?"退出编辑":"编辑",
               onPressed: (){
                 // EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = widget.node);
                 setState(() {
                   widget.node.inEditting = !widget.node.inEditting;
                   EventCenter.eventBus.fire(NodeRefreshDragOrderEvent());
                   EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                 });
               },
             ),
           ),
          // if (nodeType.isTimelineNode) GestureDetector(
          //     onPanStart: (e){
          //       widget.node.downPointer = e.globalPosition;
          //       // widget.node.oriX = widget.node.x;
          //       widget.node.oriWidth = widget.node.tlWidth;
          //     },
          //     onPanUpdate: (e){
          //
          //       setState(() {
          //         var off = e.globalPosition - widget.node.downPointer;
          //         off = widget.graph.global2LocalDelta(off);
          //
          //         var offX = off.dx;
          //         if (offX <= minTLWidth - widget.node.oriWidth){
          //           offX = minTLWidth - widget.node.oriWidth;
          //         }
          //
          //         // widget.node.x = (widget.node.oriX + off.dx).floorToDouble();
          //         widget.node.tlWidth = (widget.node.oriWidth + offX).floorToDouble();
          //
          //         // print(c.outOffX);
          //         EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
          //         EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          //
          //       });
          //     },
          //     onPanEnd: (e){
          //       setState(() {
          //         EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
          //         EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          //       });
          //     },
          //     child: Icon(
          //       MaterialCommunityIcons.chevron_right_circle,
          //       size: 14,
          //       color:  Colors.brown,
          //     )
          // ),
        ],
      ),
    );

    var lines = List<Widget>();
    widget.node.totalLineHeight += SSDefines.nodeHeaderHeight;


    // Widget timelineCon ;
    // if (nodeType.isTimelineNode){
    //   timelineCon = Container(
    //     // width: innerWidth+9,
    //     decoration: dcHeader,
    //     padding: _headerPadding,
    //     height: SSDefines.nodeHeaderHeight,
    //     child: Row(
    //       children: [
    //         GestureDetector(
    //             onPanStart: (e){
    //               widget.node.downPointer = e.globalPosition;
    //               widget.node.oriX = widget.node.x;
    //               widget.node.oriWidth = widget.node.tlWidth;
    //             },
    //             onPanUpdate: (e){
    //
    //               setState(() {
    //                 var off = e.globalPosition - widget.node.downPointer;
    //                 off = widget.graph.global2LocalDelta(off);
    //                 var offX = off.dx;
    //                 if (offX >= widget.node.oriWidth-minTLWidth){
    //                   offX = widget.node.oriWidth-minTLWidth;
    //                 }
    //                 widget.node.x = (widget.node.oriX + offX).floorToDouble();
    //                 widget.node.tlWidth = (widget.node.oriX + widget.node.oriWidth - widget.node.x).floorToDouble();
    //
    //                 // print(c.outOffX);
    //                 EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
    //                 EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    //
    //               });
    //             },
    //             onPanEnd: (e){
    //               setState(() {
    //                 EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
    //                 EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    //               });
    //             },
    //             child: Icon(
    //               MaterialCommunityIcons.chevron_left_circle,
    //               size: 14,
    //               color:  Colors.brown,
    //             )
    //         ),
    //         Expanded(child : Container()),
    //         GestureDetector(
    //             onPanStart: (e){
    //               widget.node.downPointer = e.globalPosition;
    //               // widget.node.oriX = widget.node.x;
    //               widget.node.oriWidth = widget.node.tlWidth;
    //             },
    //             onPanUpdate: (e){
    //
    //               setState(() {
    //                 var off = e.globalPosition - widget.node.downPointer;
    //                 off = widget.graph.global2LocalDelta(off);
    //
    //                 var offX = off.dx;
    //                 if (offX <= minTLWidth - widget.node.oriWidth){
    //                   offX = minTLWidth - widget.node.oriWidth;
    //                 }
    //
    //                 // widget.node.x = (widget.node.oriX + off.dx).floorToDouble();
    //                 widget.node.tlWidth = (widget.node.oriWidth + offX).floorToDouble();
    //
    //                 // print(c.outOffX);
    //                 EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
    //                 EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    //
    //               });
    //             },
    //             onPanEnd: (e){
    //               setState(() {
    //                 EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
    //                 EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    //               });
    //             },
    //             child: Icon(
    //               MaterialCommunityIcons.chevron_right_circle,
    //               size: 14,
    //               color:  Colors.brown,
    //             )
    //         ),
    //       ],
    //     ),
    //   );
    //
    //   widget.node.totalLineHeight += SSDefines.nodeHeaderHeight;
    // }

    // totalHeight += SSDefines.nodeHeaderHeight;
    ///header
//    lines.add(header);
//     bool bHideEdt = !node.inEditting || bWithConnection;
    if (widget.node.inEditting) createBaseStringFieldEditor(lines);

    if (bEditField){
      var bp = Box(
        padding: EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0),
        height: SSDefines.nodeFieldRowHeight,
        child: Row(
          children: [
            Expanded(child : const SizedBox(width: 1,)),
            ThemeCenter.iconBtn(MaterialCommunityIcons.alpha_p_circle,
                tooltip: "Port完成断点",
                color: (widget.node.enablePortDoneBreakPoint??false)?const Color(0xFF8B0000):Colors.blue,
                onPressed: (){
                  widget.node.enablePortDoneBreakPoint = !(widget.node.enablePortDoneBreakPoint??false);
                  EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
                  EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());

                  if (RunSession.instance.remoteIsPlaying){
                    //通知unity
                    var script = ScriptInfo.current.scriptData;

                    if (script!=null) {
                      var bpKey = "${script.exportId}_${BreakPointType.BPT_PORT_DONE}_${widget.node.exportId}";
                      if (widget.node.enablePortDoneBreakPoint) {
                        RunSession.instance.sendAddBreakPoint(bpKey);
                      }
                      else{
                        RunSession.instance.sendRemoveBreakPoint(bpKey);
                      }
                    }
                  }
                }
            ),
            Expanded(child:const SizedBox(width: 1,)),
            ThemeCenter.iconBtn(MaterialCommunityIcons.alpha_p_circle,
                tooltip: "Param完成断点",
                color: (widget.node.enableParamDoneBreakPoint??false)?const Color(0xFF8B0000):Colors.blue,
                onPressed: (){
                  widget.node.enableParamDoneBreakPoint = !(widget.node.enableParamDoneBreakPoint??false);
                  EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
                  EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());

                  if (RunSession.instance.remoteIsPlaying){
                    //通知unity
                    var script = ScriptInfo.current.scriptData;

                    if (script!=null) {
                      var bpKey = "${script.exportId}_${BreakPointType.BPT_PARAM_DONE}_${widget.node.exportId}";
                      if (widget.node.enablePortDoneBreakPoint) {
                        RunSession.instance.sendAddBreakPoint(bpKey);
                      }
                      else{
                        RunSession.instance.sendRemoveBreakPoint(bpKey);
                      }
                    }
                  }

                }
            ),
            Expanded(child:const SizedBox(width: 1,)),
          ],
        ),
      );
      lines.add(bp);
      widget.node.totalLineHeight += SSDefines.nodeFieldRowHeight;
    }

    //参数端口类型 可以由字段控制显隐
    Map visibleMap = {};
    //运行 lua 脚本显隐
    if (StateScriptProject.instance.useLuaForFieldVisible){
      var code = FieldVisibleController.instance.fieldVisibleCodeForStruct[nodeType.guid];
      if (code != null){
        visibleMap = FieldVisibleController.instance.getFieldVisibleMap(widget.node);
      }
    }

    ///port text
    getPortsWidget(nodeType, widget.node ,lines);

    ///param
    getParamsWidget(nodeType , widget.node , lines,  visibleMap: visibleMap, hideNoConnection: !bEditField && (StateScriptProject.instance.hidePort??false));

    //字段
    int iFieldGroupId = widget.node.getCurrentFieldGroupId();
    // print("iFieldGroupId = $iFieldGroupId");
    getFieldWidgets(widget.node , nodeType , lines , widget.node.fieldValues , isModule , groupId: iFieldGroupId, visibleMap: visibleMap);




    var c = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0),
      child: headerCon,
    );

    lines.insert(0, c);
    // if (timelineCon!= null){
    //   lines.insert(0, Container(
    //     padding: EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0),
    //     child: timelineCon,
    //   ));
    // }

    // var bp = Container(
    //   padding: EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0),
    //   height: SSDefines.nodeFieldRowHeight,
    //   child: Row(
    //     children: [
    //       ThemeCenter.iconBtn(MaterialCommunityIcons.circle,
    //         tooltip: "Port完成断点",
    //         color: Colors.brown,
    //       )
    //     ],
    //   ),
    // );
    // lines.add(bp);

    var con = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
      decoration: nodeOutDec,
      width: width,
      // height: height,
      child: Column(
        children: lines,
      ),
    );
    // if (StateScriptNode.staticSelectedNodesMap.length <=0 || widget.node.selected){
    //   return con;
    // }
    // else{
    //   return Opacity(
    //     opacity: 0.4,
    //     child: con,
    //   );
    // }
    return con;

  }

  // void getFieldWidgets(StateScriptNode node ,  NodeStructData nodeType , List<Widget> lines){
  //
  // }

  double getFieldWidgets(StateScriptNode node , NodeStructData nodeType ,List<Widget> lines , Map<String,dynamic> values , bool isModule , {int groupId,Map visibleMap = const{} } ){

    bool flip = false;//bFlip || nodeType.getIsFlipParam();
    double finalHeight = 0;
    var parent = StateScriptProject.instance.structMap[nodeType.baseType];
    if (parent != null) finalHeight += getFieldWidgets(node , parent , lines , values , flip);

    var extraPadding = 20.0;

    var lastVarTypeGuid = "";

   // Map visibleMap = {};
    Map fieldShowNameMap = visibleMap["FiledShowName"]??{};
    //运行 lua 脚本显隐
    // if (StateScriptProject.instance.useLuaForFieldVisible){
    //   var code = FieldVisibleController.instance.fieldVisibleCodeForStruct[nodeType.guid];
    //   if (code != null){
    //     visibleMap = FieldVisibleController.instance.getFieldVisibleMap(node);
    //     fieldShowNameMap = visibleMap["FiledShowName"]??{};
    //   }
    // }
    for(var f in nodeType.fields){
      if (groupId != null && f.groupIds != null && f.groupIds.length>=1){
        if (!f.groupIds.contains(groupId)){
          continue;
        }
      }
      //为false时跳出循环 也就是不可见 不绘制控件
      if (!(visibleMap[f.name]??true)){
        continue;
      }
      if (f.haveDynamicInParam){
        extraPadding = 0.0;
      }
      else{
        extraPadding = 20.0;
      }

      EditorLevelInfo ei = EditorLevelInfo()..fontSize = 12..lastVarTypeGuid = lastVarTypeGuid;
      // print("set 3 : $lastVarTypeGuid");
      lastVarTypeGuid = "";
      var fguid = f.guid;

      var inParam = nodeType.getBindInParam(fguid);

      bool isLock =  (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(inParam?.guid)));
      if (isLock && inParam == null) {
        var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);

        if (ft.guid == "___agentvar___"){
          var crtV = values[fguid];
          var guid = ft.parseValue(crtV.value);
          var fields = StateScriptProject.instance.getAgentFieldInfos();
          var field = CommonUtil.getItemByGuid(fields, guid);
          if (field != null){
            lastVarTypeGuid = field.typeGuid;
            // print("set 1 : $lastVarTypeGuid");
          }
        }
        if (ft.guid == "___scriptvar___"){
          var crtV = values[fguid];
          var guid = ft.parseValue(crtV.value);
          // var fields = ScriptInfo.current.scriptData.scriptFields;
          var field = ScriptInfo.current.scriptData.fullScriptsFields[guid];//CommonUtil.getItemByGuid(fields, guid);
          if (field != null){
            lastVarTypeGuid = field.typeGuid;
            // print("set 2 : $lastVarTypeGuid");
          }
        }
        SSDefines.lastEnumValue = -1;
        continue;
      }
      // bool bWithConnection = inParam != null ? ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam) : false;
      var templateVal = values[fguid];
      bool bOverrided = false;
      var crtVal = templateVal;
      if (node.isModuleNode && !isLock){
        //模块结点
        fguid = "${node.guid}-$fguid";
        values = ScriptInfo.current.scriptData.overrideFieldValues;
        // if (templateVal != null && values[fguid] == null) values[fguid] =
        if (values[fguid] == null) {
          var fvh = FieldValueHolder();
          fvh.name = f.getTypeShowString();
          fvh.value = templateVal?.value;
          values[fguid] = fvh;
        }
        bOverrided = values[fguid] != null && templateVal?.value != values[fguid]?.value;
        print("override value : ${values[fguid]?.value}");
        crtVal = values[fguid];
      }
      bool withDynamicTrigger = f.haveDynamicInParam || f.haveDynamicOutPort;
      bool bForceShow = (node.fieldForceShow[fguid]??false) == true || withDynamicTrigger;
      bool bForceShowFlag = node.fieldForceShow[fguid]??false;
      bool bHideEdt = !(StateScriptProject.instance.showAllFields??false) && !node.inEditting && (!bForceShow);//|| bWithConnection;
      var _sb4 = const SizedBox(width: 2,);
      var header = Box(
        // decoration: _dcPort,
        padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding, 0),
        height: SSDefines.nodeFieldRowHeight,
        // width : SSDefines.nodeFieldNameWidth,
        child : Row(
          children: [
            // if (bOverrided) Icon(MaterialCommunityIcons.alpha_o_box , color: Colors.redAccent,size:14),
            getInParamWidget(nodeType, node, inParam),
            if (!((StateScriptProject.instance.showAllFields??false)||withDynamicTrigger)) ThemeCenter.iconBtn((bForceShowFlag)?MaterialCommunityIcons.check_circle_outline:MaterialCommunityIcons
                .circle_outline,
                width: 16,height: 16,
                color: (bForceShowFlag)?Colors.green:Colors.grey,
                tooltip: "强制显示",
                onPressed: (){
                  var v = (node.fieldForceShow[fguid]??false);
                  setState(() {
                    node.fieldForceShow[fguid] = !v;
                  });
                }
            ),
              _sb4,

             Text(fieldShowNameMap[f.name]??f.getTypeShowString(),

              overflow: TextOverflow.clip,
              style: textStyle,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),

            // Checkbox(
            //   value: node.fieldForceShow[fguid]??false,
            //
            //   onChanged: (v){
            //     setState(() {
            //       node.fieldForceShow[fguid] = v;
            //     });
            //   },
            // ),
            // flip?_sb4:SizedBox(width: 0,),
            // flip?getInParamWidget(nodeType, node, inParam):SizedBox(width: 0,),
          ],
        ),
      );

      // print("node type : ${nodeType.name}");
      var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      // print("ft : $ft");
      // var crtV = values[fguid];
      if (crtVal == null) {
        var fvh = FieldValueHolder();
        fvh.name = f.getTypeShowString();
        fvh.value = ft.parseValue(f.defaultValue);
        crtVal = fvh;
        values[fguid] = fvh;
      }

      var oldV = crtVal.value;
      var edt = ft?.getThinEditWidget(
        // ft.parseValue(crtV.value),
        crtVal.value,
        (v){
          var old = crtVal.value;
          var nodeId = widget.node.guid;
          HistoryManager.scriptHistory.appendCallbackHistory("${widget.node.guid}-${fguid}",
                  (){
                    // setState(() {
                      if (ScriptInfo.current!=null && ScriptInfo.current.scriptData!= null){
                        var node = ScriptInfo.current.scriptData.nodeMap[nodeId];
                        if (node != null) {
                          node.fieldValues[fguid].value = old;
                          node.inEditting = true;
                          EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
                        }
                      }
                    // });
                  },
                  (){
                    // setState(() {
                      if (ScriptInfo.current!=null && ScriptInfo.current.scriptData!= null){
                        var node = ScriptInfo.current.scriptData.nodeMap[nodeId];
                        if (node != null) {
                          node.inEditting = true;
                          node.fieldValues[fguid].value = v;
                          EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
                        }
                      }
                    // });
                  });
          values[fguid].value = v;
          // if (widget.node.getNodeStructType().syncTransform ) {
          //   //
          //   if ((f.name == "position" || f.name == "rotation") && ft.guid == "___vector3___") {
          //     // print("0000000000000000");
          //     ObjInfo info = widget.node.getTransformInfo(null);
          //     PackSolver.registerTransitionObject(widget.node);
          //     Transport.instance.sendUdpData(OPackType.O2U_SigleObject, info);
          //   }
          // }



          //battlepus runtime 实时更新
          // print(RunSession.instance.remoteIsPlaying);
          // if (RunSession.instance.remoteIsPlaying){
          //   if (ScriptInfo.current != null){
          //     var scriptHashCode = ScriptInfo.current.guid.hashCode;
          //     var nodeId = widget.node.exportId;
          //     RunSession.instance.sendRuntimeRefreshNodeData(scriptHashCode,nodeId,widget.node);
          //   }
          // }
        },
        (v){
          // print("auto fill $v != ${values[fguid].value}");
          if ((f.autoFillTrigger??false)){
            //调用自动填充脚本
            if (oldV != v) {
              print("auto fill ${f.name}");
              AutoFiller.fill(node, f.name, v);
            }
          }
          EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
          setState(() {
            values[fguid].value = v;
            // print("111111 ${RunSession.instance.remoteIsPlaying} ${ScriptInfo.current}");

            //往unity同步
            SyncNodeData info = widget.node.getSyncData();
            Transport.instance.sendUdpData(OPackType.O2U_MAP_SyncObject, info);

            //battlepus runtime 实时更新
            // print(RunSession.instance.remoteIsPlaying);
            if (RunSession.instance.remoteIsPlaying ){
              if (ScriptInfo.current != null){
                var scriptHashCode = ScriptInfo.current.guid.hashCode;
                var nodeId = widget.node.exportId;
                RunSession.instance.sendRuntimeRefreshNodeData(ScriptInfo.current.exportId,nodeId,widget.node);
              }
            }
          });

          // print("field changed");
        },
        SSDefines.nodeFieldRowHeight,
        levelInfo:  ei..node = widget.node ..fi = f ..lineCount = f.lineCount..graph = widget.graph .. isModule = isModule..fieldValueHolder = values[fguid]..onFocus=(){
          if (!node.selected && !node.isModuleNode){
            ScriptInfo.current.unselectAll();
            node.selected = true;
          }
        },
        bOpen: true,
        context: context,
      );//??EditorHolder()..widget=Container(height: SSDefines.nodeFieldRowHeight, color:Colors.redAccent);
      if (edt == null){
        edt = EditorHolder()..widget=const Box(height: SSDefines.nodeFieldRowHeight, color:Colors.redAccent);
      }
      if (ft?.guid == "___agentvar___"){
        var guid = ft.parseValue(crtVal.value);
        var fields = StateScriptProject.instance.getAgentFieldInfos();
        var field = CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
          // print("set 7 : $lastVarTypeGuid");
        }
      }
      if (ft?.guid == "___scriptvar___"){
        var guid = ft.parseValue(crtVal.value);
        // var fields = ScriptInfo.current.scriptData.scriptFields;
        var field = ScriptInfo.current.scriptData.fullScriptsFields[guid];//CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
          // print("set 8 : $lastVarTypeGuid");
        }
      }

      if (f.disabled??false){
        edt.widget = IgnorePointer(
          child: edt.widget,
        );
      }
      Widget resourceSelector;
      Widget refreshResourceSelector;
      if (!DartCommon.isEmpty(f.resourceListGuid)){
        var resourceList = StateScriptProject.instance.resourceLists[f.resourceListGuid];
        if (resourceList != null){
          if (resourceList.name2Paths.isEmpty){
            resourceList.collect();
          }
          resourceSelector = TreeSelector(
            size: 18,
            datas: resourceList.name2Paths.keys.toList(),
            onCheckSelected: (v){
              return crtVal.value == ft.parseValue(v);
            },
            onItemBuilder: (item){
              return Text(item , style: TextStyle(color: Colors.white),);
            },
            onGetFilter: (item){
              try{
                return "$item ${PinyinHelper.getPinyin(item , separator: "", format: PinyinFormat.WITHOUT_TONE)} ${PinyinHelper.getShortPinyin(item)}";
              }
              catch(e){
                return "$item";
              }

            },
            // field: focusItem,
            onChanged: (v){

              setState(() {
                crtVal.value = ft.parseValue(v);

                if ((f.autoFillTrigger??false)){
                  //调用自动填充脚本
                  if (oldV != crtVal.value) {
                    print("auto fill ${f.name}");
                    AutoFiller.fill(node, f.name, v);
                  }
                }
              });

              // state.setValue(v.guid);
            },
            onClear: (){
              setState(() {
                crtVal.value = ft.parseValue("");
                if ((f.autoFillTrigger??false)){
                  //调用自动填充脚本
                  if (oldV != crtVal.value) {
                    print("auto fill ${f.name}");
                    AutoFiller.fill(node, f.name, "");
                  }
                }
              });

              // state.setValue("");
            },
            actions: [

              ElevatedButton(onPressed: (){
                  resourceList.collect();
                  setState(() {

                  });
                  BotToast.showText(text: "搜集完毕",contentColor: Colors.lightGreen);
                },
                child: Text("刷新")
              ),
              const SizedBox(width: 4,),
            ],
          );
          if (!DartCommon.isEmpty(crtVal.value)) {
            refreshResourceSelector = ThemeCenter.iconBtn(MaterialCommunityIcons.refresh,
                width: 18,
                height: 18,
                onPressed: () {
                  setState(() {
                    // crtVal.value = ft.parseValue(f.resourceListGuid);

                    if ((f.autoFillTrigger ?? false)) {
                      //调用自动填充脚本
                      print("auto fill ${f.name}");
                      AutoFiller.fill(node, f.name, crtVal.value);
                    }
                  });
                }
            );
          }

        }

      }
      if (bOverrided){
        var row = Column(
            children: [
              // if(!bHideEdt || bWithConnection) header,
              if (inParam != null || !bHideEdt) header,
              if (!bHideEdt) Box(
                height: edt.height,
                color: bOverrided?Colors.amber:null,
                child:Padding(
                  padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding + extraPadding, 0, SSDefines.innerHPadding, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: edt.widget
                      ),

                      if (refreshResourceSelector != null) refreshResourceSelector,
                      if (resourceSelector != null) resourceSelector,

                      if (bOverrided) ThemeCenter.iconBtn(MaterialCommunityIcons.alpha_o_box,
                        color: Colors.redAccent,
                        tooltip: "清理重载",
                        onPressed: (){
                          setState(() {
                            ScriptInfo.current.scriptData.overrideFieldValues[fguid] = null;

                            if (RunSession.instance.remoteIsPlaying ){
                              if (ScriptInfo.current != null){
                                var scriptHashCode = ScriptInfo.current.guid.hashCode;
                                var nodeId = node.exportId;
                                RunSession.instance.sendRuntimeRefreshNodeData(ScriptInfo.current.exportId,nodeId,node);
                              }
                            }

                          });
                        },)
                      ],
                  )
                ) ,
              )
            ],
          );
        // );

        lines.add(row);
      }
      else{
        if (resourceSelector == null) {
          var row = Column(
            children: [
              if (inParam != null || !bHideEdt) header,
              if (!bHideEdt && !isLock) Box(
                  height: edt.height,
                  color: bOverrided ? Colors.amber : null,
                  padding: flip ? EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding + extraPadding, 0) :
                  EdgeInsets.fromLTRB(SSDefines.innerHPadding + extraPadding, 0, SSDefines.innerHPadding, 0),
                  child: Row(
                    children: [
                      Expanded(child:edt.widget),
                      // 「点击开启标记」按钮已按要求去除

                  ],)
              ),

            ],
          );

          lines.add(row);
        }
        else{
          var row = Column(
            children: [
              // if(!bHideEdt || bWithConnection) header,
              if (inParam != null || !bHideEdt) header,

              if (!bHideEdt && !isLock) Box(
                height: edt.height,
                color: bOverrided ? Colors.amber : null,
                // padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding , 0, SSDefines.innerHPadding + extraPadding, 0),
                padding: flip ? EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding + extraPadding, 0) :
                EdgeInsets.fromLTRB(SSDefines.innerHPadding + extraPadding, 0, SSDefines.innerHPadding, 0),
                child: Row(
                  children: [
                    Expanded(child: edt.widget),
                    if (refreshResourceSelector != null) refreshResourceSelector,
                    resourceSelector,
                  ],
                ) ,
              ),

            ],
          );

          lines.add(row);
        }
      }

      if (inParam != null){
        var key = "${node.guid}_${inParam.guid}";
        node.portYPos[key] = Offset(node.x+SSDefines.portSize/2 , node.y + node.totalLineHeight + SSDefines.nodeFieldRowHeight/2 );//+ SSDefines.nodeParamHeight/2;
        node.totalLineHeight += ((!bHideEdt && !isLock))?edt.height:0.0;//(bHideEdt?SSDefines.nodeFieldRowHeight:SSDefines.nodeFieldRowHeight + edt.height);// + SSDefines.nodeParamHeight;
        // if (bWithConnection) node.totalLineHeight += SSDefines.nodeFieldRowHeight;
        node.totalLineHeight += SSDefines.nodeFieldRowHeight;
      }
      else{
        // node.totalLineHeight += (bHideEdt?0.0:SSDefines.nodeFieldRowHeight + edt.height);// + SSDefines.nodeParamHeight;
        node.totalLineHeight += (((bHideEdt || isLock))?0.0: edt.height + SSDefines.nodeFieldRowHeight);
      }
    }
    SSDefines.lastEnumValue = -1;
    return finalHeight;
  }

//   Widget getNodeWidget2(){
//     var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
//     if (nodeType == null) return Container(child : Text("类型错误"));
//
//     var dc = new BoxDecoration(
//       // border: new Border.all(color: Color(0xFFFF0000), width: 0.5),
//       color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
//       boxShadow: [ BoxShadow(color: widget.node.selected? CommonUtil.alphaColor(Colors.indigo,180):Colors.grey, offset:widget.node.selected?Offset(0.0, 0.0):Offset(1.0, 1.0),    blurRadius: 3.0, spreadRadius: widget.node.selected?4.0:1.0) , BoxShadow(color: Colors.white)],
//
//         // shape: BoxShape.rectangle, // 默认值也是矩形
//         borderRadius: new BorderRadius.circular((5.0))
//     );
//     bool bEditField = widget.node.inEditting;
//     if (bEditField){
//
//     }
//     var _headerPadding = EdgeInsets.fromLTRB(4,0,0,0);
// //    var _portPadding = EdgeInsets.fromLTRB(8,0,8,0);
//     var innerWidth = SSDefines.nodeWidth;
//     var width = innerWidth + SSDefines.portOffX *2;
//     var height = getHeightAboveFields();
//     var ntname = nodeType.getTypeShowString();
//     if (RunSession.instance.isRunning && RunSession.instance.activeScriptName == widget.node.scriptName){
//       ntname = ntname + " |" +widget.node.exportId.toString() + "|" + RunSession.instance.getTriggerCount(widget.node.exportId).toString();
//     }
//
//     var dcHeader = new BoxDecoration(
//       border: new Border.all(color: CommonUtil.scaleColor(Colors.black , 0.5), width: 0.1),
//         color: CommonUtil.scaleColor(Colors.grey , 0.5),//Color(widget.node.getNodeStructType().bgColor),
//         // boxShadow: [ BoxShadow(color: widget.node.selected? CommonUtil.alphaColor(Colors.indigo,180):Colors.grey, offset:widget.node.selected?Offset(0.0, 0.0):Offset(1.0, 1.0),    blurRadius: 3.0, spreadRadius: widget.node.selected?4.0:1.0) , BoxShadow(color: Colors.white)],
//
//         // shape: BoxShape.rectangle, // 默认值也是矩形
//         borderRadius: new BorderRadius.circular((5.0))
//     );
//     var headerCon = Container(
//       decoration: dcHeader,
//       padding: _headerPadding,
// //      color: widget.node.selected? CommonUtil.alphaColor(Colors.indigo,100):CommonUtil.alphaColor(Colors.grey , 164),
// //       color: CommonUtil.scaleColor(Colors.grey , 0.5),
//       height: SSDefines.nodeHeaderHeight,
//       child: Row(
//         children: [
//           Expanded(child : Text( ntname, style: TextStyle(fontWeight: FontWeight.w500))),
//
//           Container(
//             width: 28,
//             child:bEditField?SizedBox(width: 0,)
//                 :IconButton(padding:EdgeInsets.all(0),icon: Icon(MaterialCommunityIcons.circle_edit_outline,), color: Colors.indigo, tooltip:"编辑",
//               onPressed: (){
//                 EventCenter.eventBus.fire(NodeDescRefreshEvent());
//                 setState(() {
//                   widget.node.inEditting = true;
//
//                 });
//               },
//             ),
//           ),
//
//         ],
//       ),
//     );
//
//     var header = GestureDetector(
//       onTapDown: (e) {
//         if (!KeyEventCenter.isControlPressed() && _lastPressedAdt != null && DateTime.now().difference(_lastPressedAdt) < Duration(milliseconds: 400)) {
//           setState(() {
//             EventCenter.eventBus.fire(NodeDescRefreshEvent());
//             widget.node.inEditting = !widget.node.inEditting;
//             // if (widget.node.inEditting){
//             //   EventCenter.eventBus.fire(GlobalRefreshEvent());
//             // }
//           });
//         }
//         _lastPressedAdt = DateTime.now();
//         if (KeyEventCenter.isControlPressed()){
//           setState(() {
//             EventCenter.eventBus.fire(NodeDescRefreshEvent());
//             widget.node.selected = !widget.node.selected;
//
//           });
//         }
//         else{
// //          if (!widget.node.selected) {
//             setState(() {
//
//               ScriptInfo.current.unselectAll();
//               widget.node.selected = true;
//               EventCenter.eventBus.fire(NodeDescRefreshEvent());
//             });
// //          }
//
//         }
//
//
//       },
//       child: headerCon,
//     );
//     var lines = List<Widget>();
//     ///header
// //    lines.add(header);
//     ///port text
//     getPortsWidget(nodeType, widget.node, lines);
//     ///param
//     getParamsWidget(nodeType ,widget.node , lines);
//     var aboveLines = Container(
//       width: width ,
//       child:Column(
//         children: lines,
//       ),
//     );
//
//
//     var c = Container(
// //      padding: EdgeInsets.all(_padding),
//       width: innerWidth ,
//       decoration: dc,
//
//       child: Column(
//         children: [header],
//       ),
//     );
//
//     return Container(
// //      color: Colors.grey,
//
//       width: width,
//       height: height,
//       child:Stack(
//         children: [
//           Center(child:c),
//           Positioned(
//             top:SSDefines.nodeHeaderHeight,
//             child: aboveLines
//           ),
//         ],
//       ),
//
//     );
//   }

  void createBaseStringFieldEditor(List<Widget> rows){//FunctionStringCallback onChanged ) {
    // EditorLevelInfo ei = EditorLevelInfo()..fontSize = 16;
    // var lineHeight = 42.0;
    // var ft = SSFieldType.getFieldType("___string___");
    // var edt = ft.getThinEditWidget(
    //   widget.node.group,
    //   (v){
    //     widget.node.group = v;
    //   },
    //   (v){
    //     setState(() {
    //       widget.node.group = v;
    //     });
    //
    //   },
    //   SSDefines.nodeFieldRowHeight,
    //   levelInfo: ei..lineCount = 1,
    //   bOpen: true,
    //   context: context,
    // );
    //
    // var row = Container(
    //   // color: rows.length%2==1?Colors.white:CommonUtil.alphaColor(Colors.grey, 48),
    //   // padding: EdgeInsets.fromLTRB(8, 4, 4, 4),
    //   // width: SSDefines.nodeFieldPanelWidth,
    //   padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding + SSDefines.paramSize , 0),
    //   height: lineHeight,
    //   child: Row(
    //     children: [
    //       Icon(MaterialCommunityIcons.group ,size: 20 ,color: Colors.grey,),
    //             SizedBox(width: 10,),
    //             Text("分组",
    //               overflow: TextOverflow.clip,
    //               style: paramHeaderStyle,
    //               maxLines: 1,
    //               textAlign: TextAlign.start,
    //             ),
    //       SizedBox(width: 2,),
    //       Expanded(child:edt.widget),
    //       SizedBox(width: 10,),
    //     ],
    //   ),
    // );
    //
    // rows.add(row);
    // widget.node.totalLineHeight += lineHeight;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _lis?.cancel();
    _lis2?.cancel();
    _lis3?.cancel();
    _lis4?.cancel();
    _posNotifier?.dispose();
    super.dispose();
  }

  final _posNotifier = ValueNotifier<Offset>(Offset(0,0));

  @override
  void initState() {
    _posNotifier.value = Offset(widget.node.x,widget.node.y);
    _lis = EventCenter.eventBus.on<NodeRefreshEvent>().listen((event) {
      // print("_lis");
      setState(() {
      });
    });

    _lis4 = EventCenter.eventBus.on<NodeRefreshWithTargetEvent>().listen((event) {
      // print("_lis4");
      if (event.exportId == widget.node.exportId){
        setState(() {

        });
        return;
      }

      // print("rebuild node ${widget.node.guid}");
      if (event.node == widget.node || event.nodeType == widget.node.getNodeStructType()) {
        if (event.posChanged??false){
          _posNotifier.value = Offset(widget.node.x,widget.node.y);

          EventCenter.eventBus.fire(NodeRefreshDragOrderEvent());
          // return ;
        }

        setState(() {
          // for(var mi in ScriptInfo.current.scriptData.inPorts){
          //   if (mi == null) continue;
          //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
          //   if (node != null) {
          //     var pos = node.getInPortPosition(mi.interfaceGuid);
          //     if (pos != null){
          //       EventCenter.eventBus.fire(ModuleInterfaceRefreshEvent()..mi = mi );
          //     }
          //   }
          // }
          // for(var mi in ScriptInfo.current.scriptData.outPorts){
          //   if (mi == null) continue;
          //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
          //   if (node != null) {
          //     var pos = node.getOutPortPosition(mi.interfaceGuid);
          //     if (pos != null){
          //       EventCenter.eventBus.fire(ModuleInterfaceRefreshEvent()..mi = mi );
          //     }
          //   }
          // }
          // for(var mi in ScriptInfo.current.scriptData.inParams){
          //   if (mi == null) continue;
          //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
          //   if (node != null) {
          //     var pos = node.getInParamPosition(mi.interfaceGuid);
          //     if (pos != null){
          //       EventCenter.eventBus.fire(ModuleInterfaceRefreshEvent()..mi = mi );
          //     }
          //   }
          // }

          // for(var mi in ScriptInfo.current.scriptData.outParams){
          //   if (mi == null) continue;
          //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
          //   if (node != null) {
          //     var pos = node.getOutParamPosition(mi.interfaceGuid);
          //     if (pos != null){
          //       EventCenter.eventBus.fire(ModuleInterfaceRefreshEvent()..mi = mi );
          //     }
          //   }
          // }
        });
      }
    });

    _lis3 = EventCenter.eventBus.on<FocusNodeUpdateEvent>().listen((event) {
//      print("focus");
//       print("_lis3");
      if (event.guid == widget.node.guid) {
        ZoomState.current.focusPosition(widget.node.x,widget.node.y);
        widget.node.selected = true;
        EventCenter.eventBus.fire(GlobalRefreshEvent());
      }
    });

    _lis2 = EventCenter.eventBus.on<TransformUpdateEvent>().listen((event) {
      // print("_lis2");
//      print("focus");
      if (event.guid == widget.node.guid) {
        setState(() {});
      }
    });
    // TODO: implement initState
    super.initState();
  }

  static Offset _downPointer = Offset.zero;
  static void dragStorePos(DragStartDetails e){
    _downPointer = e.globalPosition;
    var nodes = ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){
      if (n.selected){
        n.downPointer = e.globalPosition;
        n.downStorePos = Offset(n.x , n.y);
      }
      for(var sop in n.soports){
        if (sop.selected){
          // sop.downPointer = e.globalPosition;
          sop.downStorePos = Offset(sop.x , sop.y);
        }
      }
      for(var sop in n.sops){
        if (sop.selected){
          // sop.downPointer = e.globalPosition;
          sop.downStorePos = Offset(sop.x , sop.y);
        }
      }
    }
  }


  static int dragUpdatePos(DragUpdateDetails e , SSCanvasViewState graph){
    var off = e.globalPosition - _downPointer??Offset.zero;
    off = graph.global2LocalDelta(off);
    int res = 0;
    var nodes = ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){
      // bool bingo = false;
      if (n.selected){
        n.x = n.downStorePos.dx + off.dx;
        n.y = n.downStorePos.dy + off.dy;
        res+=1;
        // EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n..posChanged = true);
        // EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);

        // bingo = true;
      }

      for(var sop in n.soports){
        if (sop.selected){
          sop.x = sop.downStorePos.dx + off.dx;
          sop.y = sop.downStorePos.dy + off.dy;
          res+=1;
          // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
          // bingo = true;
        }
      }
      for(var sop in n.sops){
        if (sop.selected){
          sop.x = sop.downStorePos.dx + off.dx;
          sop.y = sop.downStorePos.dy + off.dy;
          res+=1;
          // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
          // bingo = true;
        }
      }
      // if (bingo){
      //   // EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = n);
      //   if (n.group != null && n.group.trim() != "") {
      //     EventCenter.eventBus.fire(GroupRefreshEvent()..guid = n.group);
      //   }
      // }
    }

    return res;
  }

  static void sendDragUpdatePosEvent(){
    // var off = e.globalPosition - _downPointer??Offset.zero;
    // off = graph.global2LocalDelta(off);

    var nodes = ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){
      bool bingo = false;
      if (n.selected){
        // n.x = n.downStorePos.dx + off.dx;
        // n.y = n.downStorePos.dy + off.dy;
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n..posChanged = true);
        EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);
        bingo = true;
      }

      for(var sop in n.soports){
        if (sop.selected){
          // sop.x = sop.downStorePos.dx + off.dx;
          // sop.y = sop.downStorePos.dy + off.dy;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
          bingo = true;
        }
      }
      for(var sop in n.sops){
        if (sop.selected){
          // sop.x = sop.downStorePos.dx + off.dx;
          // sop.y = sop.downStorePos.dy + off.dy;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
          bingo = true;
        }
      }
      if (bingo){
        // EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = n);
        if (n.group != null && n.group.trim() != "") {
          EventCenter.eventBus.fire(GroupRefreshEvent()..guid = n.group);
        }
      }
    }
  }


  static void dragEndPos(DragEndDetails e , SSCanvasViewState graph){
    // var off = e.globalPosition - _downPointer??Offset.zero;
    // off = graph.global2LocalDelta(off);

    var nodes = ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){
      bool bingo = false;
      if (n.selected){
        var pos = Offset(n.x,n.y);
        pos = graph.fixPosition(pos);
        n.x = pos.dx;
        n.y = pos.dy;
        bingo = true;
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n..posChanged = true);
        EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);
      }

      for(var sop in n.soports){
        if (sop.selected){
          var pos = Offset(sop.x,sop.y);
          pos = graph.fixPosition(pos);
          sop.x = pos.dx;
          sop.y = pos.dy;
          bingo = true;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
        }
      }
      for(var sop in n.sops){
        if (sop.selected){
          var pos = Offset(sop.x,sop.y);
          pos = graph.fixPosition(pos);
          sop.x = pos.dx;
          sop.y = pos.dy;
          bingo = true;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
        }
      }

      if (bingo) EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = n);
    }
  }

  static Timer darggingEventTimer;
  @override
  Widget build(BuildContext context) {
//    var dc = new BoxDecoration(
//      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
//    );
//    var dc2 = new BoxDecoration(
//      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.red)],
//    );

    // print("rebuild node");
    // var normal = RepaintBoundary(
    //   child: getNodeWidget(),
    // ); // (SSDefines.isInDagging && widget.node.selected)? Container(width: widget.node.getNodeStructType().width,height: widget.node.totalLineHeight ,color :Colors.blue) : getNodeWidget();
    if (widget.node.getNodeStructType() == null) return const SizedBox(width: 1,);
    var normal = getNodeWidget();

    if (widget.node.isModuleNode){
      return ValueListenableBuilder(
        key: ValueKey("${widget.node.guid}_vlb"),
        valueListenable: _posNotifier,
        builder: (_, value, __) => Positioned(
          left: widget.node.x ,//- SSDefines.portOffX ,
          top: widget.node.y,
          child: normal,//RepaintBoundary(child:dnn2),
        ),
      );
    }
    // var normal = Container(width: widget.node.getNodeStructType().width,height: widget.node.totalLineHeight ,color :Colors.blue);
    var dnn2 = GestureDetector(
      dragStartBehavior : DragStartBehavior.down,
      child: normal,
        onTapDown: (e) {
        // print("onTapDown");
          onHeadTapDown();
          _storeHistory = false;
        },
      onPanStart: (e){
        // print("onPanStart");
        SSDefines.isInDagging = true;
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());//RefreshConnectCommandEvent().globalRefresh = true);
        EventCenter.eventBus.fire(PortClickEvent()..node = null);
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = 100);
        onHeadTapDown(noEditing : true);
        dragStorePos(e);

      },
      onPanUpdate: (e){
        // print("pan update");
        SSDefines.isInDagging = true;

          if (!_storeHistory) {
            HistoryManager.scriptHistory.appendHistory();
            _storeHistory = true;
          }

          int count = dragUpdatePos(e, widget.graph);
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=true);


        return;
        // EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          if (count < 8){
            sendDragUpdatePosEvent();
          }
          else{
            if (count < 32){
              if (darggingEventTimer == null){
                sendDragUpdatePosEvent();
                darggingEventTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
                  sendDragUpdatePosEvent();
                });
              }
            }
            else{
              EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=true);
            }
          }
      },
      onPanEnd: (e){
        SSDefines.isInDagging = false;
        // setState(() {
          if (darggingEventTimer != null){
            darggingEventTimer.cancel();
            darggingEventTimer = null;
          }
          dragEndPos(e, widget.graph);

          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());//RefreshConnectCommandEvent().globalRefresh = true);
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = ZoomState.current.getScale()..bForce = true);
          sendDragUpdatePosEvent();
          EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=false);

        EventCenter.eventBus.fire(TimelineCursorInit());
      },
    );

    // return ValueListenableBuilder(
    //   key: ValueKey(widget.node.guid),
    //   valueListenable: _posNotifier,
    //   builder: (_, value, __) => Positioned(
    //     left: widget.node.x ,//- SSDefines.portOffX ,
    //     top: widget.node.y,
    //     child: dnn2,//RepaintBoundary(child:dnn2),
    //   ),
    // );

    return Positioned(
      key: ValueKey("${widget.node.guid}_positioned"),
      left: widget.node.x ,//- SSDefines.portOffX ,
      top: widget.node.y,
      child: dnn2,//RepaintBoundary(child:dnn2),
    );

  }



  static Widget getTypeNormal(){
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    var normal = Box(
        padding: EdgeInsets.all(_padding),
      width: SSDefines.nodeWidth,
      height: SSDefines.nodeHeight,
      child:Container(
        decoration: dc,
      )
    );

    return normal;
  }

  void onDragCompleted() {
//    print("---- onDragCompleted");
  }

  void onDragEnd(DraggableDetails details) {
//    print("---- onDragEnd ${details.offset}");



    var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(details.offset));// + Offset(BTDefines.nodeTypeWidth/2 , BTDefines.nodeTypeHeight/2));
    widget.node.x = off.dx;
    widget.node.y = off.dy;

    widget.graph.refresh();

  }

  void onDragStarted() {
//    print("---- onDragStarted");
  }

  void onDraggableCanceled(Velocity velocity, Offset offset) {
//    print("---- onDraggableCanceled $offset ");
  }


}