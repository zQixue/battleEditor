//@dart=2.11

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
typedef LineCallback = void Function(List<Widget> lineCmds);
class DraggingFramesPainter extends CustomPainter {

  Offset fixPosition(Offset off) {
    var x = ((off.dx - SSDefines.canvasZeroX) / SSDefines.fixPosX).floor() * SSDefines.fixPosX + SSDefines.canvasZeroX;//- BTDefines.nodeWidth/2 * viewZoom;
    var y  = ((off.dy - SSDefines.canvasZeroY)/ SSDefines.fixPosY ).floor()* SSDefines.fixPosY + SSDefines.canvasZeroY;//- BTDefines.nodeHeight/2 * viewZoom;
    return Offset(x,y);
  }
  @override
  void paint(Canvas canvas, Size size) {

    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Color.fromARGB(200, 255, 0, 0);

    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color.fromARGB(200, 255, 255, 0);

    if (ScriptInfo.current == null) return;


    for(var n in ScriptInfo.current.scriptData.nodes){
      if (n.selected) {
        var pos = Offset(n.x,n.y);
        pos = fixPosition(pos);
        var rect = Rect.fromLTWH(pos.dx,pos.dy,n.getWidth() , n.totalLineHeight + 6);
        canvas.drawRect(rect, paint);



        // canvas.drawLine(Offset(pos.dx-20,pos.dy), Offset(pos.dx+20,pos.dy), paint1);
        // canvas.drawLine(Offset(pos.dx,pos.dy - 20), Offset(pos.dx,pos.dy+20), paint1);
      }

      for(var sop in n.soports){
        if (sop.selected){
          var rect = Rect.fromLTWH(sop.x- 100,sop.y,100 , SSDefines.sopHeight);
          canvas.drawRect(rect, paint);
        }
      }

      for(var sop in n.sops){
        if (sop.selected){
          var rect = Rect.fromLTWH(sop.x- 100,sop.y,100 , SSDefines.sopHeight);
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DraggingFramesPainter oldDelegate) => oldDelegate != this;
}