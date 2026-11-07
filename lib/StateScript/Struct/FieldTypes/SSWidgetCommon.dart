//@dart=2.11

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/PortInfo.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutPort.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/drag_target_ex.dart';

class SSWidgetCommon {
  static Widget getOutPortWidget(NodeStructData nodeType ,StateScriptNode node , OutPort outPort , SSCanvasViewState graph , double fullHeight, FieldInfo fi){
    bool withOut = outPort != null;//iIndex <nodeType.outPorts.length;
    if (!withOut) return Container(width: SSDefines.portSize,);

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutPortConnection(node , outPort);

    if (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(outPort.guid))){
      return Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      );// dragTarget;
    }

    var dn = DraggableEx(

      child: Icon(
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
          if (node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许创建替身" , contentColor : Colors.redAccent);
            return;
          }
          var off = graph.fixPosition(graph.calcLocalPosition(offset));
          SubstituteOutPort sop = SubstituteOutPort()..outPortGuid = outPort.guid..x = off.dx..y = off.dy;
          node.soports.add(sop);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return;
        }
        if (KeyEventCenter.isShiftPressed()){

          if (node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
            return;
          }

          var off = graph.fixPosition(graph.calcLocalPosition(offset));
          var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = outPort.guid..x = off.dx..y = off.dy ..type = InterfaceType.OutPort;
          // ScriptInfo.current.scriptData.outPorts.add(mi);
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          // ScriptInfo.current.scriptData.registerOutPortInterface(mi);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          return ;
        }

        var tmpPos = offset;//Offset(pos.dx , pos.dy);
        tmpPos = graph.calcLocalPosition(tmpPos);
        tmpPos = graph.fixPosition(tmpPos);

        RenderBox getBox = graph.context.findRenderObject();
        var local = getBox.globalToLocal(offset);
        // print("aaaaaaaa");
        EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx ..showListY = local.dy ..srcNodeId = "${nodeType.guid}");

      },
//        data:nodeType.outPorts[iIndex],
      data: OutPortInfo(node, outPort , null),
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
        if (node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = PortConnection();
        con.outNodeGuid = node.guid;
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

    if (withOut){
      var key = "${node.guid}_${outPort.guid}";
      node.portYPos[key] = Offset(node.x + node.getWidth()- SSDefines.portSize/2 ,node.y +  node.totalLineHeight + SSDefines.nodeFieldRowHeight +  fullHeight +  SSDefines.nodePortHeight/2);

    }
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
        EventCenter.eventBus.fire(PortClickEvent()..node = node..portGuid = outPort.guid);
      },
      child: dragTarget,
    );// dragTarget;
  }

  static Widget getInParamWidget(NodeStructData nodeType, StateScriptNode node, InParam inParam,SSCanvasViewState graph , double fullHeight, FieldInfo fi) {
    // bool withIn = iIndex <nodeType.getNormalInParamsCount();
    if (inParam == null) return Container(width: SSDefines.portSize,);

    var inType = inParam.paramType;
    if (DartCommon.isEmpty(inType) && fi != null){
      inType = fi.extraParam;
    }

    bool bWithConnection = ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam);
    Color tpColor = CommonUtil.alphaColorD( Color(inType.hashCode) , 1.0);
    tpColor =CommonUtil.changeColorLightness(tpColor, 0.4);

    if (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(inParam.guid))){
      return Tooltip(
        child: Icon(
          MaterialCommunityIcons.record_circle,
          color: Colors.grey,
          size: SSDefines.portSize,
        ),
        message: inType,
      );// dragTarget;
    }

    var dn = DraggableEx(
      child: Container(
        // color: CommonUtil.alphaColor(Colors.green, 80) ,
        child: Icon(
          // AntDesign.rightsquare,
          MaterialCommunityIcons.record_circle,
          // color: bWithConnection?tpColor:CommonUtil.alphaColorD(tpColor, 0.5),
          color:tpColor,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
      ),
      childWhenDragging: Container(
        child: Icon(
          MaterialCommunityIcons.record_circle,
          color: Colors.green,//bWithConnection?Colors.red:Colors.grey,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
      ),
      feedback:Container(
//        color: Colors.red,
//        width: SSDefines.portSize ,
//        height: SSDefines.portSize ,

      ),

      data: InParamInfo(node, inParam),
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

          if (node.isModuleNode){
            BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
            return;
          }

          var off = graph.fixPosition(graph.calcLocalPosition(offset));
          var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = inParam.guid..x = off.dx..y = off.dy ..type = InterfaceType.InParam;
          // ScriptInfo.current.scriptData.inParams.add(mi);
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          // ScriptInfo.current.scriptData.registerInParamInterface(mi);
          EventCenter.eventBus.fire(GlobalRefreshEvent());

          return;
        }

        var tmpPos = offset;//Offset(pos.dx , pos.dy);
        tmpPos = graph.calcLocalPosition(tmpPos);
        tmpPos = graph.fixPosition(tmpPos);

        RenderBox getBox = graph.context.findRenderObject();
        var local = getBox.globalToLocal(offset);
        // print("aaaaaaaa");
        EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx ..showListY = local.dy..outParamFilter = inParam.paramType..srcNodeId = "ip_p_${nodeType.guid}");
      },
    );
    var dragTarget = DragTargetEx<OutParamInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
      onWillAccept:(OutParamInfo ii){
        // if (ii.port.paramType != inParam.paramType){
        if (!isTypeCanLink(inParam , ii.port , fi)){
          BotToast.showText(text:"参数类型不匹配" , contentColor : Colors.redAccent);
          return false;
        }
        BotToast.cleanAll();
        return true;
      },
//      onAccept: onAccept,
      onAcceptWithDetails: (DragTargetDetails<OutParamInfo> details) {
        if (node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = ParamConnection();
        con.inNodeGuid = node.guid;
        con.inParamGuid = inParam.guid;
        con.outNodeGuid = details.data.node.guid;
        con.outParamGuid = details.data.port.guid;
        con.sopGuid = details.data.sop?.guid;

        // if (details.data.port.paramType != inParam.paramType){
        if (!isTypeCanLink(inParam , details.data.port , fi)){
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

    {
      var key = "${node.guid}_${inParam.guid}";
      node.portYPos[key] = Offset(node.x+SSDefines.portSize/2 , node.y+node.totalLineHeight + SSDefines.nodeFieldRowHeight +  fullHeight + SSDefines.nodeParamHeight/2);
    }

    return Tooltip(
      child: GestureDetector(
        onTapUp: (e){
          EventCenter.eventBus.fire(PortClickEvent()..node = node..portGuid = inParam.guid);
        },
        child: dragTarget,
      ),
      message: inType,
    );// dragTarget;
  }

  static bool isTypeCanLink(InParam type1 , OutParam type2, FieldInfo fi){
    // print("$type1 $type2");
    var inType = type1.paramType;
    if (DartCommon.isEmpty(inType) && fi != null){
      inType = fi.extraParam;
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
}