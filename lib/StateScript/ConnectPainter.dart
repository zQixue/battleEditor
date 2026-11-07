//@dart=2.11

import 'dart:core';
import 'dart:math';
 
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/BreakPointType.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/connect_line_commands.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syntax_highlighter/syntax_highlighter.dart';
typedef LineCallback = void Function(List<Widget> lineCmds);
class ConnectPainter extends CustomPainter {
  static RegExp lineChecker = new RegExp(r"\n");
  static StateScriptNode currentSelectTimelineClipNode;
  // List<PortConnection> portConnections = List<PortConnection>();
  // List<ParamConnection> paramConnections = List<ParamConnection>();
  // List<StateScriptNode> allNodes = List<StateScriptNode>();
  @override
  void paint(Canvas canvas, Size size) {

    // print("paint lines");
    // Define a paint object
    final paintBP = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 12.0
      ..color = SSDefines.breakPointColor;// CommonUtil.changeColorLightness(Colors.brown, 0.6); //Colors.brown;
    final paintActiveBP = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 12.0
      ..color = SSDefines.breakPointActiveColor;// CommonUtil.changeColorLightness(Colors.brown, 0.6); //Colors.brown;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      // ..filterQuality = FilterQuality.high
      ..color = Color.fromARGB(200, 255, 0, 0);
    if (ScriptInfo.current == null) return;
    // portConnections.clear();
    // paramConnections.clear();
    // portConnections.addAll(ScriptInfo.current.scriptData.portConnections);
    // paramConnections.addAll(ScriptInfo.current.scriptData.paramConnections);

    // var connections = ScriptInfo.current.scriptData.portConnections;
    // for(var sbs in ScriptInfo.current.scriptData.subScripts){
    //   if (!sbs.isExpanded) continue;
    //   if (sbs.subPortConnections != null) portConnections.addAll(sbs.subPortConnections);
    //   if (sbs.subParamConnections != null)paramConnections.addAll(sbs.subParamConnections);
    // }



    paint.strokeWidth = 1.5;
    for(var sbs in ScriptInfo.current.scriptData.subScripts){
      if (sbs.subNodes == null || sbs.subNodes.length<=0)continue;
      if (!sbs.isExpanded) continue;
      paint.color = Colors.lightGreenAccent;
      canvas.drawRect(Rect.fromLTWH(sbs.x + 1 , sbs.y + 28 , max(sbs.fullWidth+ SSDefines.moduleOffX,318.3)   ,sbs.fullHeight  + SSDefines.moduleOffY ), paint);
    }
    drawTimeline(ScriptInfo.current.scriptData.nodes , canvas,paintActiveBP , paintBP);

    for(var sbs in ScriptInfo.current.scriptData.subScripts){
      if (!sbs.isExpanded) continue;
      drawTimeline(sbs.subNodes , canvas,paintActiveBP , paintBP);
    }


    paint.strokeWidth = 3.0;
    drawPortConnections(ScriptInfo.current.scriptData.portConnections , canvas , paint , paintActiveBP , paintBP);
    drawParamConnections(ScriptInfo.current.scriptData.paramConnections , canvas , paint , paintActiveBP , paintBP);
    for(var sbs in ScriptInfo.current.scriptData.subScripts){
      if (!sbs.isExpanded) continue;
      if (sbs.subPortConnections != null) drawPortConnections(sbs.subPortConnections , canvas , paint , paintActiveBP , paintBP);
      if (sbs.subParamConnections != null) drawParamConnections(sbs.subParamConnections, canvas , paint , paintActiveBP , paintBP);
    }
    paint.strokeWidth = 1.5;

    if (SSDefines.isInDagging){
      return;
    }
    var outNameMap = ScriptInfo.current.scriptData.collectInParamNameMaps();
    drawNodeInfo(ScriptInfo.current.scriptData.nodes , canvas,paintActiveBP , paintBP , outNameMap);
    for(var sbs in ScriptInfo.current.scriptData.subScripts){
      if (!sbs.isExpanded) continue;
      drawNodeInfo(sbs.subNodes , canvas,paintActiveBP , paintBP , outNameMap);
    }

    {
      Path path = Path();
      paint.color = Colors.green ;

      for (var mi in StateScriptNode.allModuleInterfaces) {
        if (mi == null) continue;
        var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
        if (node != null&& mi.x != null && mi.y != null) {
          var pos1 = node.getInPortPosition(mi.interfaceGuid);
          if (pos1 != null) {
            print("pos1 : $pos1");
            path.moveTo(pos1.dx, pos1.dy);
            path.lineTo(mi.x + 12, mi.y + 16);
          }
        }
      }

      // for (var mi in ScriptInfo.current.scriptData.inPorts) {
      //   if (mi == null) continue;
      //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
      //   if (node != null&& mi.x != null && mi.y != null) {
      //     var pos1 = node.getInPortPosition(mi.interfaceGuid);
      //     path.moveTo(pos1.dx , pos1.dy);
      //     path.lineTo(mi.x + 12, mi.y + 16);
      //   }
      // }
      // for(var mi in ScriptInfo.current.scriptData.outPorts){
      //   if (mi == null) continue;
      //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
      //   if (node != null && mi.x != null && mi.y != null) {
      //     var pos1 = node.getOutPortPosition(mi.interfaceGuid);
      //     path.moveTo(pos1.dx , pos1.dy);
      //     path.lineTo(mi.x + 12, mi.y + 16);
      //
      //   }
      // }
      // for(var mi in ScriptInfo.current.scriptData.inParams){
      //   if (mi == null) continue;
      //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
      //   if (node != null&& mi.x != null && mi.y != null) {
      //
      //     var pos1 = node.getInParamPosition(mi.interfaceGuid);
      //     path.moveTo(pos1.dx , pos1.dy);
      //     path.lineTo(mi.x + 12, mi.y + 16);
      //
      //   }
      // }
      //
      // for(var mi in ScriptInfo.current.scriptData.outParams){
      //   if (mi == null) continue;
      //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
      //   if (node != null&& mi.x != null && mi.y != null) {
      //
      //     var pos1 = node.getOutParamPosition(mi.interfaceGuid);
      //     path.moveTo(pos1.dx , pos1.dy);
      //     path.lineTo(mi.x + 12, mi.y + 16);
      //
      //   }
      // }
      canvas.drawPath(path, paint);
    }
  }

  void drawParamConnections(List<ParamConnection> paramConnections , canvas , paint , paintActiveBP , paintBP){
    bool bCubic = StateScriptProject.instance.cubicLine;
    bool bTimelineMode = StateScriptNode.withTimelineNode;
    if (bTimelineMode){
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = CommonUtil.changeColorLightness(Colors.lightBlueAccent,0.4);//Color.fromARGB(200, 255, 0, 0);
    }

    for(var c in paramConnections){
      var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      var inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];
      if (outNode == null || inNode == null) continue;
      if (outNode.getNodeStructType() == null || inNode.getNodeStructType()==null) continue;


      if (outNode.isModuleNode && !inNode.isModuleNode && (!outNode.isRootModuleNode ||!outNode.moduleInterfaces.containsKey(c.outParamGuid))){
        continue;
      }
      if (inNode.isModuleNode && !outNode.isModuleNode && (!inNode.isRootModuleNode ||!inNode.moduleInterfaces.containsKey(c.inParamGuid))){
        continue;
      }

      var pout = outNode.getOutParamPosition(c.outParamGuid);
      if (c.sopGuid != null && c.sopGuid.trim() != ""){
        var sopout = outNode.getOutParamPositionBySOP(c.sopGuid);
        if (sopout != null){
          pout = sopout;
        }
      }
      var pin = inNode.getInParamPosition(c.inParamGuid);
      if (pout == null || pin == null) {
        print("--------------------------------------------- no $pout $pin");
        continue;
      }

      var connectionId = c.getConnectionId(ScriptInfo.current.scriptData);
      Path path = Path();
//      pout.dy+= SSDefines.nodeHeaderHeight;
//      pout.dy+= SSDefines.nodeHeaderHeight;
//      print(c.lineColor);
      var nodeType = StateScriptProject.instance.structMap[inNode.nodeTypeGuid];
      var inParam = inNode.getInParam(c.inParamGuid);
      paint.strokeWidth = 2.0;
      // paint.strokeCap = StrokeCap.butt;
      Color tpColor = inParam != null? CommonUtil.alphaColorD( Color(inParam.paramType.hashCode) , 1.0) : Colors.lightBlue;
      tpColor =CommonUtil.changeColorLightness(tpColor, 0.4);
      if (outNode.selected || inNode.selected || !StateScriptNode.alphaParamLineColor ||ConnectLineCommandsState.opendGuid == c.guid) {
        paint.color = CommonUtil.changeColorLightness(Colors.yellow, 0.7);// Colors.yellow;//CommonUtil.changeColorLightness(tpColor, 0.6)  ;//Color(c.lineColor);
        paint.strokeWidth = 2.0;
        // paint.strokeCap = StrokeCap.square;
      }
      else {

        // var hash = outNode.exportId + c.outParamGuid.hashCode ;//+ inNode.exportId + c.inPortGuid.hashCode;//c.inNodeGuid.hashCode;
        if (!bTimelineMode) {
          paint.color = CommonUtil.changeColorLightness(Color(c.lineColor), 0.7); //Colors.indigo;line_colors
        }

        // if (StateScriptNode.alphaParamLineColor){
        //   // var clr = Color(c.lineColor);
        //   paint.color = CommonUtil.changeColorLightness(tpColor, 0.5);//tpColor;//CommonUtil.alphaColor(Color(c.lineColor), (clr.alpha * 65 / 255).floor());
        // }
      }

      if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == inNode.scriptId){
        var flashing = RunSession.instance.prmFlashing[connectionId??-1]??false; //RunSession.instance.isFlashing(inNode.exportId);
        paint.color = flashing ? Colors.green : CommonUtil.scaleColor(Colors.lightBlue , 0.3);
      }

      bool bFlip = false;//outNode.getNodeStructType().getIsFlipParam() || inNode.getNodeStructType().getIsFlipParam();
      // if (bFlip){
      //   var temp = pout;
      //   pout = pin;
      //   pin = temp;
      // }
      var opOff = Offset(pout.dx + SSDefines.draw_port_line_off + (c.outOffX??0) ,pout.dy) ;
      var ipOff = Offset(pin.dx - SSDefines.draw_port_line_off + (c.inOffX ??0) ,pin.dy) ;
      var triggerCountCenter = (opOff + ipOff) / 2;

      if (bCubic){
        var crt = pout;
        path.moveTo(crt.dx, crt.dy); //out 原点

        path.lineTo(opOff.dx, opOff.dy); //out 偏移点

        var offY = c.offY ?? 0;
        if (opOff.dx < ipOff.dx && offY == 0){
          path.moveTo(opOff.dx, opOff.dy);
          var w = (opOff.dx - ipOff.dx).abs();
          path.cubicTo(opOff.dx+w/2, opOff.dy , ipOff.dx -w/2 , ipOff.dy , ipOff.dx, ipOff.dy);
        }
        else{

          path.moveTo(opOff.dx, opOff.dy);
          var w = 200;//(opOff.dx - ipOff.dx).abs();
          var center = (opOff + ipOff) / 2;
          var offY = c.offY??0;
          center = Offset(center.dx , center.dy + offY);
          triggerCountCenter = center;
          if (opOff.dy > ipOff.dy){
            path.cubicTo(opOff.dx+w/2 , opOff.dy , opOff.dx+w/2, center.dy, center.dx , center.dy);//ipOff.dx -w/2 , ipOff.dy + h+ offY, ipOff.dx, ipOff.dy);
            path.cubicTo(ipOff.dx -w/2 , center.dy , ipOff.dx - w/2, ipOff.dy , ipOff.dx, ipOff.dy);
          }
          else{
            path.cubicTo(opOff.dx+w/2 , opOff.dy , opOff.dx+w/2, center.dy, center.dx , center.dy);//ipOff.dx -w/2 , ipOff.dy - h + offY, ipOff.dx, ipOff.dy);
            path.cubicTo(ipOff.dx -w/2 , center.dy, ipOff.dx -w/2 , ipOff.dy, ipOff.dx, ipOff.dy);
          }
        }


        path.lineTo(ipOff.dx, ipOff.dy); //in 偏移点
        path.lineTo(pin.dx, pin.dy); //in 原点
        canvas.drawPath(path, paint);
      }
      else {
        var crt = pout;
        path.moveTo(crt.dx, crt.dy); //out 原点

        path.lineTo(opOff.dx, opOff.dy); //out 偏移点

        var offY = c.offY ?? 0;
        if (offY != 0 || opOff.dx > ipOff.dx || bTimelineMode) {
          triggerCountCenter = Offset(triggerCountCenter.dx, triggerCountCenter.dy + offY);
          var opCenter = Offset(opOff.dx, triggerCountCenter.dy);
          path.lineTo(opCenter.dx, opCenter.dy); //out 垂直线
          // path.arcToPoint(opCenter, radius: Radius.circular(1),
          //   largeArc: false,);
          var ipCenter = Offset(ipOff.dx, triggerCountCenter.dy);
          path.lineTo(ipCenter.dx, ipCenter.dy); //in 垂直线
        }


        path.lineTo(ipOff.dx, ipOff.dy); //in 偏移点
        path.lineTo(pin.dx, pin.dy); //in 原点
        canvas.drawPath(path, paint);
      }

      if (c.enableBreakPoint){
        //画断点
        var bpKey = "${ScriptInfo.current.scriptData?.exportId}_${BreakPointType.BPT_PARAM_CONNECTION}_${connectionId}";
        bool activeBp = RunSession.instance.currentBreakPoint == bpKey;
        canvas.drawCircle(triggerCountCenter, SSDefines.breakPointSize , activeBp?paintActiveBP : paintBP);
        // canvas.drawCircle(triggerCountCenter, SSDefines.breakPointSize, paintBP);
      }
      if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == inNode.scriptId){

        var count = RunSession.instance.prmTriggerCount[connectionId??0]??0;
        TextSpan span = new TextSpan(text:"$count" , style:  TextStyle(fontSize: 14 , color: Colors.yellowAccent,background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
        TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(triggerCountCenter.dx, triggerCountCenter.dy-20));
      }

    }
  }
  // static var line_colors = [Color(0xFFCC9999),  Color(0xFF666699),
  //    Color(0xFF0099CC),
  //   Color(0xFFCCCC99), Color(0xFFCC3399), Color(0xFF99CC00),
  //   Color(0xFFFF6666),  Color(0xFF3399CC),
  //   Color(0xFFCC6600), Color(0xFF999999),
  //    Color(0xFFFFFFCC), Color(0xFF009933),
  //   Color(0xFF0099CC), Color(0xFFCCCCCC), Color(0xFFFF6666),
  //   Color(0xFFFF6600), Color(0xFF009966),
  //   Color(0xFFCC6633), Color(0xFFCC6600),
  //   Color(0xFFCC0066), Color(0xFF009999),
  //   Color(0xFF6699CC), Color(0xFF663366), Color(0xFFCCCC99),
  //   Color(0xFF990033), Color(0xFFCCFF66), Color(0xFFFF9900),
  //   Color(0xFF666699), Color(0xFF660033), Color(0xFF99CC99),
  //   Color(0xFF663300),
  //   Color(0xFF990033), Color(0xFF006633),
  //   Color(0xFF660033), Color(0xFF999933), Color(0xFF660099),
  //   Color(0xFF993366), Color(0xFF666633),
  //   Color(0xFF996600), Color(0xFF666600),
  //   Color(0xFF009933), Color(0xFFCC9900), Color(0xFF666666),
  //   Color(0xFF666633),  Color(0xFFCC3366)];

  void drawPortConnections(List<PortConnection> portConnections , canvas , paint , paintActiveBP , paintBP){
    bool bCubic = StateScriptProject.instance.cubicLine;
    bool bTimelineMode = StateScriptNode.withTimelineNode;
    if (bTimelineMode){
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.blueGrey;//Color.fromARGB(200, 255, 0, 0);
    }

    for(var c in portConnections){
      var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      var inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];


      if (outNode.getNodeStructType() == null || inNode.getNodeStructType()==null) continue;

      if (outNode == null || inNode == null) continue;

      if (outNode.isModuleNode && !inNode.isModuleNode && (!outNode.isRootModuleNode ||!outNode.moduleInterfaces.containsKey(c.outPortGuid))){
        continue;
      }
      if (inNode.isModuleNode && !outNode.isModuleNode && (!inNode.isRootModuleNode ||!inNode.moduleInterfaces.containsKey(c.inPortGuid))){
        continue;
      }

      var pout = outNode.getOutPortPosition(c.outPortGuid);
      var pin = inNode.getInPortPosition(c.inPortGuid);
      if (c.sopGuid != null && c.sopGuid.trim() != ""){
        var sopout = outNode.getOutPortPositionBySOP(c.sopGuid);
        if (sopout != null){
          pout = sopout;
        }
      }
      if (pout == null || pin == null) continue;

      var connectionId = c.getConnectionId(ScriptInfo.current.scriptData);
      // if (connectionId == null){
      //   var outPort = outNode.getNodeStructType().getOutPort(c.outPortGuid);
      //   var inPort = inNode.getNodeStructType().getInPort(c.inPortGuid);
      //   connectionId = "${outNode.exportId}_${outPort.exportId}_${inNode.exportId}_${inPort.exportId}";
      // }

      Path path = Path();
//      pout.dy+= SSDefines.nodeHeaderHeight;
//      pout.dy+= SSDefines.nodeHeaderHeight;
//      print(c.lineColor);
//       paint.color = Color(c.lineColor);

      if (outNode.selected || inNode.selected ){//|| !StateScriptNode.alphaParamLineColor ||ConnectLineCommandsState.opendGuid == c.guid) {
        paint.color = CommonUtil.changeColorLightness(Colors.yellow, 0.7);// Colors.yellow;//CommonUtil.changeColorLightness(Colors.indigo, 0.6)  ;//Color(c.lineColor);
      }
      else {
        // var hash = outNode.exportId + c.outPortGuid.hashCode + inNode.exportId + c.inPortGuid.hashCode;//c.inNodeGuid.hashCode;
        if (!bTimelineMode) {
          paint.color = CommonUtil.changeColorLightness(Color(c.lineColor), 0.6); //Colors.indigo;line_colors
        }
      }

      if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == inNode.scriptId){
        // var flashing = RunSession.instance.isFlashing(inNode.exportId) && !inNode.getNodeStructType().getWithUpdateLogic();
        // var outflashing = RunSession.instance.isOutFlashing(outNode.exportId);
        var flashing = RunSession.instance.prtFlashing[connectionId??-1]??false;
        paint.color = (flashing) ? Colors.redAccent : CommonUtil.scaleColor(Colors.indigoAccent , 0.3);
      }

      // var pOutOri = pout;
      // var pInOri = pin;
      // paint.color = CommonUtil.changeColorLightness(paint.color, 0.8);

      // pout = Offset(pout.dx + c.outOffX ,pout.dy) ;
      // pin = Offset(pin.dx + c.inOffX ,pin.dy) ;
      var opOff = Offset(pout.dx + SSDefines.draw_port_line_off + (c.outOffX??0) ,pout.dy) ;
      var ipOff = Offset(pin.dx - SSDefines.draw_port_line_off + (c.inOffX ??0) ,pin.dy) ;
      var triggerCountCenter = (opOff + ipOff) / 2;

      if (bCubic){
        var crt = pout;
        path.moveTo(crt.dx, crt.dy); //out 原点
        path.lineTo(opOff.dx, opOff.dy); //out 偏移点

        var offY = c.offY ?? 0;

        var triggerCountCenter = (pout + pin) / 2;
        if (opOff.dx < ipOff.dx && offY == 0){
          path.moveTo(opOff.dx, opOff.dy);
          var w = (opOff.dx - ipOff.dx).abs();
          path.cubicTo(opOff.dx+w/2, opOff.dy , ipOff.dx -w/2 , ipOff.dy , ipOff.dx, ipOff.dy);
        }
        else{

          path.moveTo(opOff.dx, opOff.dy);
          var w = 200;//(opOff.dx - ipOff.dx).abs();
          var center = (opOff + ipOff) / 2;
          var offY = c.offY??0;
          center = Offset(center.dx , center.dy + offY);
          triggerCountCenter = center;
          if (opOff.dy > ipOff.dy){
            path.cubicTo(opOff.dx+w/2 , opOff.dy , opOff.dx+w/2, center.dy, center.dx , center.dy);//ipOff.dx -w/2 , ipOff.dy + h+ offY, ipOff.dx, ipOff.dy);
            path.cubicTo(ipOff.dx -w/2 , center.dy , ipOff.dx - w/2, ipOff.dy , ipOff.dx, ipOff.dy);
          }
          else{
            path.cubicTo(opOff.dx+w/2 , opOff.dy , opOff.dx+w/2, center.dy, center.dx , center.dy);//ipOff.dx -w/2 , ipOff.dy - h + offY, ipOff.dx, ipOff.dy);
            path.cubicTo(ipOff.dx -w/2 , center.dy, ipOff.dx -w/2 , ipOff.dy, ipOff.dx, ipOff.dy);
          }
        }
        path.lineTo(pin.dx, pin.dy); //in 原点
        canvas.drawPath(path, paint);
      }
      else {
        var crt = pout;
        path.moveTo(crt.dx, crt.dy); //out 原点
        path.lineTo(opOff.dx, opOff.dy); //out 偏移点

        var offY = c.offY ?? 0;
        bool bFlipOutIn = opOff.dx > ipOff.dx;
        if (offY != 0 || bFlipOutIn || bTimelineMode) {
          var offY = c.offY ?? 0;
          triggerCountCenter = Offset(triggerCountCenter.dx, triggerCountCenter.dy + offY);

          var opCenter = Offset(opOff.dx, triggerCountCenter.dy);
          path.lineTo(opCenter.dx, opCenter.dy); //out 垂直线
          var ipCenter = Offset(ipOff.dx, triggerCountCenter.dy);
          path.lineTo(ipCenter.dx, ipCenter.dy); //in 垂直线
        }
        path.lineTo(ipOff.dx, ipOff.dy); //in 偏移点
        path.lineTo(pin.dx, pin.dy); //in 原点
        canvas.drawPath(path, paint);
      }

//       if (c.outOffX!= 0){
//         path.moveTo(pOutOri.dx, pOutOri.dy);
//         path.lineTo(pout.dx, pout.dy);
//       }
//
//       if (c.inOffX!= 0){
//         path.moveTo(pInOri.dx, pInOri.dy);
//         path.lineTo(pin.dx, pin.dy);
//       }
//       var triggerCountCenter = (pout + pin) / 2;
//
//       var opc = Offset(pout.dx  ,triggerCountCenter.dy) ;
//       var ipc = Offset(pin.dx  ,triggerCountCenter.dy) ;
//
//       path.moveTo(opc.dx, opc.dy);
//       path.lineTo(pout.dx, pout.dy);
//
//
//       if (pout.dx < pin.dx){
//         path.moveTo(pout.dx, pout.dy);
// //        canvas.drawLine(pout, pin, paint);
//         var w = (pout.dx - pin.dx).abs();
//         path.cubicTo(pout.dx+w/2, pout.dy, pin.dx -w/2 , pin.dy, pin.dx, pin.dy);
//         canvas.drawPath(path, paint);
//       }
//       else{
//         path.moveTo(pout.dx, pout.dy);
//         var w = 100;//(pout.dx - pin.dx).abs();
// //        var h = (pout.dy - pin.dy).abs();
//         var center = (pout + pin) / 2;
//         var offY = c.offY??0;
//         center = Offset(center.dx , center.dy + offY);
//         triggerCountCenter = center;
//         if (pout.dy > pin.dy){
//           path.cubicTo(pout.dx+w/2 , pout.dy , pout.dx+w/2, center.dy, center.dx , center.dy);//pin.dx -w/2 , pin.dy + h+ offY, pin.dx, pin.dy);
//           path.cubicTo(pin.dx -w/2 , center.dy , pin.dx - w/2, pin.dy , pin.dx, pin.dy);
//         }
//         else{
//           path.cubicTo(pout.dx+w/2 , pout.dy , pout.dx+w/2, center.dy, center.dx , center.dy);//pin.dx -w/2 , pin.dy - h + offY, pin.dx, pin.dy);
//           path.cubicTo(pin.dx -w/2 , center.dy, pin.dx -w/2 , pin.dy, pin.dx, pin.dy);
//         }
//         canvas.drawPath(path, paint);
//       }
      if (c.enableBreakPoint){
        //画断点
        var bpKey = "${ScriptInfo.current.scriptData?.exportId}_${BreakPointType.BPT_PORT_CONNECTION}_${connectionId}";
        bool activeBp = RunSession.instance.currentBreakPoint == bpKey;
        canvas.drawCircle(triggerCountCenter, SSDefines.breakPointSize , activeBp?paintActiveBP : paintBP);
      }
      if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == inNode.scriptId){

        var count = RunSession.instance.prtTriggerCount[connectionId??0]??0;
        TextSpan span = new TextSpan(text:"$count" , style:  TextStyle(fontSize: 14 , color: Colors.cyanAccent , background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
        TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(triggerCountCenter.dx, triggerCountCenter.dy-20));

        // {
        //   TextSpan span = new TextSpan(text:"${c.exportId}" , style:  TextStyle(fontSize: 14 , color: Colors.cyanAccent , background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
        //   TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
        //   tp.layout();
        //   tp.paint(canvas, new Offset(triggerCountCenter.dx-32, triggerCountCenter.dy-20));
        // }
      }

    }
  }
  void drawPortConnectionsOld(List<PortConnection> portConnections , canvas , paint , paintActiveBP , paintBP){
    for(var c in portConnections){
      var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      var inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];

      if (outNode.getNodeStructType() == null || inNode.getNodeStructType()==null) continue;

      if (outNode == null || inNode == null) continue;

      var pout = outNode.getOutPortPosition(c.outPortGuid);
      var pin = inNode.getInPortPosition(c.inPortGuid);
      if (c.sopGuid != null && c.sopGuid.trim() != ""){
        var sopout = outNode.getOutPortPositionBySOP(c.sopGuid);
        if (sopout != null){
          pout = sopout;
        }
      }
      if (pout == null || pin == null) continue;

      var connectionId = c.getConnectionId(ScriptInfo.current.scriptData);
      // if (connectionId == null){
      //   var outPort = outNode.getNodeStructType().getOutPort(c.outPortGuid);
      //   var inPort = inNode.getNodeStructType().getInPort(c.inPortGuid);
      //   connectionId = "${outNode.exportId}_${outPort.exportId}_${inNode.exportId}_${inPort.exportId}";
      // }

      Path path = Path();
//      pout.dy+= SSDefines.nodeHeaderHeight;
//      pout.dy+= SSDefines.nodeHeaderHeight;
//      print(c.lineColor);
//       paint.color = Color(c.lineColor);

      if (outNode.selected || inNode.selected ){//|| !StateScriptNode.alphaParamLineColor ||ConnectLineCommandsState.opendGuid == c.guid) {
        paint.color = CommonUtil.changeColorLightness(Colors.yellow, 0.7);// Colors.yellow;//CommonUtil.changeColorLightness(Colors.indigo, 0.6)  ;//Color(c.lineColor);
      }
      else {
        paint.color = CommonUtil.changeColorLightness(Colors.indigo, 0.5);//Colors.indigo;
      }

      if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == inNode.scriptId){
        // var flashing = RunSession.instance.isFlashing(inNode.exportId) && !inNode.getNodeStructType().getWithUpdateLogic();
        // var outflashing = RunSession.instance.isOutFlashing(outNode.exportId);
        var flashing = RunSession.instance.prtFlashing[connectionId??-1]??false;
        paint.color = (flashing) ? Colors.redAccent : CommonUtil.scaleColor(Colors.indigoAccent , 0.3);
      }

      var pOutOri = pout;
      var pInOri = pin;
      // paint.color = CommonUtil.changeColorLightness(paint.color, 0.8);

      pout = Offset(pout.dx + c.outOffX ,pout.dy) ;
      pin = Offset(pin.dx + c.inOffX ,pin.dy) ;

      if (c.outOffX!= 0){
        path.moveTo(pOutOri.dx, pOutOri.dy);
        path.lineTo(pout.dx, pout.dy);
      }

      if (c.inOffX!= 0){
        path.moveTo(pInOri.dx, pInOri.dy);
        path.lineTo(pin.dx, pin.dy);
      }
      var triggerCountCenter = (pout + pin) / 2;
      if (pout.dx < pin.dx){
        path.moveTo(pout.dx, pout.dy);
//        canvas.drawLine(pout, pin, paint);
        var w = (pout.dx - pin.dx).abs();
        path.cubicTo(pout.dx+w/2, pout.dy, pin.dx -w/2 , pin.dy, pin.dx, pin.dy);
        canvas.drawPath(path, paint);
      }
      else{
        path.moveTo(pout.dx, pout.dy);
        var w = 100;//(pout.dx - pin.dx).abs();
//        var h = (pout.dy - pin.dy).abs();
        var center = (pout + pin) / 2;
        var offY = c.offY??0;
        center = Offset(center.dx , center.dy + offY);
        triggerCountCenter = center;
        if (pout.dy > pin.dy){
          path.cubicTo(pout.dx+w/2 , pout.dy , pout.dx+w/2, center.dy, center.dx , center.dy);//pin.dx -w/2 , pin.dy + h+ offY, pin.dx, pin.dy);
          path.cubicTo(pin.dx -w/2 , center.dy , pin.dx - w/2, pin.dy , pin.dx, pin.dy);
        }
        else{
          path.cubicTo(pout.dx+w/2 , pout.dy , pout.dx+w/2, center.dy, center.dx , center.dy);//pin.dx -w/2 , pin.dy - h + offY, pin.dx, pin.dy);
          path.cubicTo(pin.dx -w/2 , center.dy, pin.dx -w/2 , pin.dy, pin.dx, pin.dy);
        }
        canvas.drawPath(path, paint);
      }
      if (c.enableBreakPoint){
        //画断点
        var bpKey = "${ScriptInfo.current.scriptData?.exportId}_${BreakPointType.BPT_PORT_CONNECTION}_${connectionId}";
        bool activeBp = RunSession.instance.currentBreakPoint == bpKey;
        canvas.drawCircle(triggerCountCenter, SSDefines.breakPointSize , activeBp?paintActiveBP : paintBP);
      }
      if (RunSession.instance.isRunning && RunSession.instance.activeScriptId == inNode.scriptId){

        var count = RunSession.instance.prtTriggerCount[connectionId??0]??0;
        TextSpan span = new TextSpan(text:"$count" , style:  TextStyle(fontSize: 14 , color: Colors.cyanAccent , background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
        TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(triggerCountCenter.dx, triggerCountCenter.dy-20));

        // {
        //   TextSpan span = new TextSpan(text:"${c.exportId}" , style:  TextStyle(fontSize: 14 , color: Colors.cyanAccent , background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
        //   TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
        //   tp.layout();
        //   tp.paint(canvas, new Offset(triggerCountCenter.dx-32, triggerCountCenter.dy-20));
        // }
      }

    }
  }

  void drawTimeline(List<StateScriptNode> nodes , canvas , paintActiveBP , paintBP){
    // if (RunSession.instance.isRunning && RunSession.instance.activeScriptName == ScriptInfo.current.name){
    //   var nodes = ScriptInfo.current.scriptData.nodes;
    //   allNodes.clear();
    //   var nodes = ScriptInfo.current.scriptData.nodes;
    if (nodes == null) return ;
    for(var n in nodes){
      var nType = n.getNodeStructType();
      if (nType == null){
        continue;
      }

      if (nType.getIsTimelineNode()){
        final double tw = 64;
        final double offX = 16;
        final double offY = 16;

        var nx = n.x;
        if (SSDefines.isInDagging){
          nx = (nx / SSDefines.fixPosX).floor()*SSDefines.fixPosX;
        }

        var ny = n.y;
        if (SSDefines.isInDagging){
          ny = (ny / SSDefines.fixPosY).floor()*SSDefines.fixPosY;
        }
        if (currentSelectTimelineClipNode == n) {
          var startTime = n.getStartTime(v:nx);
          var str = sprintf("%0.2f", [startTime]);
          TextSpan span = new TextSpan(text: str, style: TextStyle(fontSize: 12, color: Colors.lightGreenAccent , backgroundColor: Colors.black54));
          TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.right, textDirection: TextDirection.ltr );
          tp.layout(minWidth: tw);
          tp.paint(canvas, new Offset(nx - tw - offX, ny - offY));
          var endTime = n.getEndTime(v:nx);
          str = sprintf("%0.2f [%0.2fs]", [endTime, endTime - startTime]);
          span = new TextSpan(text: str, style: TextStyle(fontSize: 12, color: Colors.lightGreenAccent, backgroundColor: Colors.black54));
          tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          tp.layout(minWidth: tw);
          tp.paint(canvas, new Offset(nx + n.tlWidth + offX, ny - offY));
        }

        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.0
          ..color = Colors.lightGreen;//.withAlpha(200);//CommonUtil.al(Colors.lightGreen, 0.6); //Colors.brown;
        Path path2 = Path();
        final tlY = ny-7.0;
        path2.moveTo(nx,tlY);
        path2.lineTo(nx + n.tlWidth,tlY);


        canvas.drawPath(path2, paint);
        paint.strokeWidth = 1;
        final tlSOff = 8;
        path2.moveTo(nx,tlY - tlSOff);
        path2.lineTo(nx,tlY + tlSOff);
        path2.moveTo(nx+ n.tlWidth,tlY - tlSOff);
        path2.lineTo(nx+ n.tlWidth,tlY + tlSOff);
        canvas.drawPath(path2, paint);


      }
    }
  }

  void drawNodeInfo(List<StateScriptNode> nodes , Canvas canvas , paintActiveBP , paintBP, Map<String, Map<String, String>> outNameMap){
    // if (RunSession.instance.isRunning && RunSession.instance.activeScriptName == ScriptInfo.current.name){
    //   var nodes = ScriptInfo.current.scriptData.nodes;
    //   allNodes.clear();
    //   var nodes = ScriptInfo.current.scriptData.nodes;
    final paintBP1 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 12.0
      ..color = Colors.lightGreenAccent;// CommonUtil.changeColorLightness(Colors.brown, 0.6); //Colors.brown;
    final paintBP2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 12.0
      ..color = Colors.amberAccent;// CommonUtil.changeColorLightness(Colors.brown, 0.6); //Colors.brown;
    if (nodes == null) return ;
    for(var n in nodes){
      var nType = n.getNodeStructType();
      if (nType == null){
        continue;
      }
      // var tc = RunSession.instance.getTriggerCount(n.exportId).toString();
      // bool isRunning = RunSession.instance.isRunning && RunSession.instance.activeScriptName == ScriptInfo.current.name;


      //var centerX = n.x + nType.width/2 ;
      var centerX = n.x + n.getWidth()/2 ;


      if (n.enablePortDoneBreakPoint){
        //画断点
        var bpKey = "${ScriptInfo.current.scriptData?.exportId}_${BreakPointType.BPT_PORT_DONE}_${n.exportId}";
        bool activeBp = RunSession.instance.currentBreakPoint == bpKey;
        canvas.drawCircle(new Offset(centerX - 48, n.y-16), SSDefines.breakPointSize , activeBp?paintActiveBP : paintBP);
      }

      if (n.enableParamDoneBreakPoint){
        //画断点
        var bpKey = "${ScriptInfo.current.scriptData?.exportId}_${BreakPointType.BPT_PARAM_DONE}_${n.exportId}";
        bool activeBp = RunSession.instance.currentBreakPoint == bpKey;
        canvas.drawCircle(new Offset(centerX + 48, n.y-16), SSDefines.breakPointSize , activeBp?paintActiveBP : paintBP);
      }
      var desc = n.getFullDesc(outNameMap);
      // TextSpan span = new TextSpan(text:"${n.exportId}" , style:  TextStyle(fontSize: 14 , color: Colors.white));
      TextSpan span = new TextSpan(text:"$desc" , style:  TextStyle(fontSize: 14 , color: Colors.white));
      TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
      tp.layout(maxWidth: n.getWidth());
      var lineCount = tp.computeLineMetrics().length - 1;
      // var lineCount = lineChecker.allMatches(desc).length;
      // print("$desc $lineCount");
      // tp.paint(canvas, new Offset(n.x + nType.width/2 - 8, n.y-20));
      tp.paint(canvas, new Offset(n.x , n.y - (nType.getIsTimelineNode()?9:0)-20 - 20* lineCount));

      if (RunSession.instance.isRunning){
        // var inPrms = nType.inParams;
        for(var inParam in nType.inParams){
          var pin = n.getInParamPosition(inParam.guid);
          var val = RunSession.instance.getInParamRealTimeValue(n.exportId,inParam.exportId);
          if (pin == null || val == null) continue;
          TextSpan span = new TextSpan( text: val , style:  TextStyle(color: Colors.greenAccent, fontSize: 14,background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),
          ),);
          TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.right ,textDirection: TextDirection.ltr);
          tp.layout(minWidth: 512);
          tp.paint(canvas, new Offset(pin.dx -SSDefines.portSize -512, pin.dy-SSDefines.portSize/2));
        }
        var di = RunSession.instance.getNodeDebugString(n.exportId);
        if (!DartCommon.isEmpty(di)) {
          TextSpan span = new TextSpan( text: di , style:  TextStyle(color: Colors.greenAccent, fontSize: 14,background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),
          ),);
          TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.right ,textDirection: TextDirection.ltr);
          tp.layout(minWidth: 512);
          tp.paint(canvas, new Offset(n.x-512, n.y));
        }
      }

      var funcFields = nType.getFieldsByTypeGuid("___agentfunction___");
      if (funcFields != null){
        // print("bbb");
        int iCount = 0;
        for(var funcField in funcFields) {
          var afi = n.fieldValues[funcField.guid];
          if (afi == null) continue;
          var fv = afi?.value;
          // print(afi.value);
          var clr = funcField.extraParam =="bool" ?Color(0xFF666699) :Colors.black;
          if (fv != null) {
            // n.fieldValues[funcField.guid].value = "";
            var func = StateScriptProject.instance.getFunction(fv);
            if (func != null) {
              var code = func.getBlockBehavicCode();
              // code = code.length>256?"${code.substring(0,256)} ......":code;

              // final spans = SpanBuilder(code)
              //               //     .apply(TextSpan(text: "if", style: TextStyle(color : Colors.amberAccent)))
              //               //     .apply(TextSpan(text: "else", style: TextStyle(color : Colors.amberAccent)))
              //               //     .apply(TextSpan(text: "==", style: TextStyle(color : Colors.cyanAccent)))
              //               //     .apply(TextSpan(text: "<>", style: TextStyle(color : Colors.cyanAccent)))
              //               //     // .apply(TextSpan(text: "> ", style: TextStyle(color : Colors.cyanAccent)))
              //               //     .build();
              const fSize = 14.0;
              final SyntaxHighlighterStyle style = SyntaxHighlighterStyle(
                baseStyle: const TextStyle(color: Color(0xFFFFFFFF) , fontSize: fSize),
                numberStyle: const TextStyle(color: Colors.amber,fontSize: fSize, fontWeight: FontWeight.w800),
                commentStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: fSize),
                keywordStyle: const TextStyle(color: Colors.redAccent, fontSize: fSize ),
                stringStyle: const TextStyle(color: Colors.cyanAccent, fontSize: fSize),
                punctuationStyle: const TextStyle(color: Color(0xFFFFFFFF), fontSize: fSize),
                classStyle: const TextStyle(color: Colors.cyanAccent, fontSize: fSize),
                constantStyle: const TextStyle(color: Color(0xFF795548), fontSize: fSize),
              );
              final spans = DartSyntaxHighlighter(style).format(code);

              // var result = highlight.parse(code, language: 'dart');
              // print("------------------------------------------------ code : $code");
              // result.printMe();
              // var spans2 = result.getSpans(<String ,TextStyle>{
              //   "keyword":TextStyle(color: Colors.redAccent),
              //   "number":TextStyle(color: Colors.cyanAccent),
              // });
              TextSpan span = new TextSpan( children: [spans], style:  TextStyle(color: Colors.white, fontSize: 13, //background: new Paint()..color=CommonUtil.alphaColorD(Colors.green,0.4),
              ),);
              TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
              tp.layout(minWidth: 1);
              var off = new Offset(n.x + n.getWidth() + 4 , n.y +iCount*20);
              tp.paint(canvas, off + Offset(16,0));
              canvas.drawCircle(off+ Offset(6,10), 4, funcField.extraParam =="bool"?paintBP1:paintBP2);
              var lineCount = tp.computeLineMetrics().length;
              iCount += lineCount-1;
            }

          }
        }
      }
    }
  }

  // List<Widget> getAllModuleInterfaces(){
  //   var nodes = List<Widget>();
  //   for(var mi in ScriptInfo.current.scriptData.inPorts){
  //     if (mi == null) continue;
  //     var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
  //     if (node != null) {
  //       // var pos = node.getInPortPosition(mi.interfaceGuid);
  //       // if (pos != null){
  //       var nv = ModuleInterfaceView(node  : node , onGetPosition: ()=>node.getInPortPosition(mi.interfaceGuid), isRight: false, graph: this , interface: mi, onDelete: (mi){
  //         setState(() {
  //         });
  //       },);
  //       nodes.add(nv);
  //       // }
  //     }
  //   }
  //   for(var mi in ScriptInfo.current.scriptData.outPorts){
  //     if (mi == null) continue;
  //     var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
  //     if (node != null) {
  //       // var pos = node.getOutPortPosition(mi.interfaceGuid);
  //       // if (pos != null){
  //       var nv = ModuleInterfaceView(node  : node ,onGetPosition: ()=>node.getOutPortPosition(mi.interfaceGuid), isRight: true, graph: this , interface: mi, onDelete: (mi){
  //         setState(() {
  //         });
  //       },);
  //       nodes.add(nv);
  //       // }
  //     }
  //   }
  //   for(var mi in ScriptInfo.current.scriptData.inParams){
  //     if (mi == null) continue;
  //     var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
  //     if (node != null) {
  //       // var pos = node.getInParamPosition(mi.interfaceGuid);
  //       // if (pos != null){
  //       var nv = ModuleInterfaceView(node  : node ,onGetPosition: ()=>node.getInParamPosition(mi.interfaceGuid), isRight: false, graph: this , interface: mi, onDelete: (mi){
  //         setState(() {
  //         });
  //       },);
  //       nodes.add(nv);
  //       // }
  //     }
  //   }
  //
  //   for(var mi in ScriptInfo.current.scriptData.outParams){
  //     if (mi == null) continue;
  //     var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
  //     if (node != null) {
  //       // var pos = node.getOutParamPosition(mi.interfaceGuid);
  //       // if (pos != null){
  //       var nv = ModuleInterfaceView(node  : node ,onGetPosition: ()=>node.getOutParamPosition(mi.interfaceGuid), isRight: true, graph: this , interface: mi, onDelete: (mi){
  //         setState(() {
  //         });
  //       },);
  //       nodes.add(nv);
  //       // }
  //     }
  //   }
  //   return nodes;
  // }


  @override
  bool shouldRepaint(ConnectPainter oldDelegate) => this != oldDelegate;
  // @override
  // bool hitTest(Offset position) {
  //   return false;
  // }
}