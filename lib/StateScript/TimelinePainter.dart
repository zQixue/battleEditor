//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/timeline_cursor.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:sprintf/sprintf.dart';
class TimelinePainter extends CustomPainter {

  Color _lineColor;
  Color _axisColor;
  double _width;
  double _height;
  TimelinePainter(double width ,double height){
    _width = width;
    _height = height;
    // _lineColor = lineColor;
    // _axisColor = axisColor;
    // _xStep = xStep;
    // _yStep = yStep;
  }

  final double timeline_width = 2048;
  static double step_1s = SSDefines.nodeWidth * 2;
  final double time_step_height = 8;
  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    var scale = ZoomState.current.scale;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5/scale
      ..color = Colors.white.withAlpha(180);

    final paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5/scale
      ..color = Colors.white.withAlpha(180);

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0/scale
      ..color = Colors.white.withAlpha(180);

    Offset center = ZoomState.current.currentDynamicCenterPosition();


    var lineLength = timeline_width/scale;
    var offY = (_height/2-80)/scale ;
    var p3 = center + Offset(-lineLength,- offY);
    var p4 = center + Offset(lineLength,- offY);
    canvas.drawLine(p3, p4, paint);

    var step = step_1s ;
    var height = time_step_height/scale;
    // print(height);
    for(double i = -lineLength ; i < lineLength ; i += step){
      var second =  ((center.dx + i)~/ step);
      double x = second * step ;
      var showSecond = ((center.dx + i - SSDefines.canvasZeroX)~/ step);
      if (center.dx + i - SSDefines.canvasZeroX <0) showSecond--;

      var p1 = Offset(x,center.dy-height - offY);
      var p2 = Offset(x,center.dy+height- offY);
      bool is5 = showSecond % 5==0;
      if (is5){
        p2 = Offset(x,center.dy+height*3- offY);
      }
      // var pText = Offset(x,center.dy+height);
      // print("---------------------- $p1 , $p2");
      canvas.drawLine(p1, p2, is5?paint2:paint);

      // var timeStr = formatTime(showSecond);
      // TextSpan span = new TextSpan(text:"$showSecond" , style:  TextStyle(fontSize: 16/scale , color: Colors.cyanAccent , background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
      TextSpan span = new TextSpan(text:"$showSecond", style:  TextStyle(fontSize: 14/scale , color: Colors.cyanAccent.withAlpha(180) ,fontWeight: FontWeight.w100));
      TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, p2);
    }

    if (scale >= 0.5){
      var step = SSDefines.fixPosX  ;
      for(double i = -lineLength ; i < lineLength ; i += step){
        var second =  ((center.dx + i)~/ step);
        double x = second * step ;
        var showSecond = ((center.dx + i - SSDefines.canvasZeroX)~/ step);
        if (center.dx + i - SSDefines.canvasZeroX <0) showSecond--;

        var p1 = Offset(x,center.dy - offY);
        var p2 = Offset(x,center.dy+height - offY);



        var _step40 = second %40;
        if(scale >= 1.0 && _step40 !=0 && _step40 %4 == 0){
          canvas.drawLine(p1, p2+ Offset(0,6), paint3);
          var str = sprintf("%0.1f",[1.0/ 40 * (showSecond)]);

          TextSpan span = new TextSpan(text:"${str}", style:  TextStyle(fontSize: 12/scale , color: Colors.white.withAlpha(200),fontWeight: FontWeight.w100 ));
          TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
          tp.layout();
          tp.paint(canvas, p2);
        }
        else{
          canvas.drawLine(p1, p2 , paint3);
        }
      }
    }

    var timelineCursorX = TimelineCursorInfo.posX + SSDefines.canvasZeroX;
    var pA = Offset(timelineCursorX,0);
    var pB = Offset(timelineCursorX,SSDefines.canvasHeight);
    paint.strokeWidth = 1 / scale ;
    paint.color = Colors.blue;
    canvas.drawLine(pA, pB, paint);
    {
      var step = SSDefines.fixPosX  ;
      var showSecond = (TimelineCursorInfo.posX ) ~/ step;
      if (TimelineCursorInfo.posX <0) showSecond--;
      var str = sprintf("%0.4fs", [1.0 / 40 * (showSecond)]);
      TextSpan span = new TextSpan(text: str, style: TextStyle(fontSize: 12 / scale, color: Colors.lightGreenAccent));
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      var p2 = Offset(timelineCursorX + 6,center.dy+height - offY + 40/scale);
      tp.paint(canvas, p2);
    }
    // for(double i = -step ; i > -lineLength ; i -= step){
    //   double x = ((center.dx + i)~/ step)  * step ;
    //   var p1 = Offset(x,center.dy-height);
    //   var p2 = Offset(x,center.dy+height);
    //   // print("---------------------- $p1 , $p2");
    //   canvas.drawLine(p1, p2, paint);
    //
    //   var showSecond = ((center.dx + i - SSDefines.canvasWidth/2)~/ step) - 1;
    //   TextSpan span = new TextSpan(text:"$showSecond" , style:  TextStyle(fontSize: 16/scale , color: Colors.cyanAccent , background: new Paint()..color=CommonUtil.alphaColorD(Colors.black,0.8),));
    //   TextPainter tp = new TextPainter(text: span,  textAlign: TextAlign.left ,textDirection: TextDirection.ltr);
    //   tp.layout();
    //   tp.paint(canvas, p2);
    // }


  }
  String formatTime(int sec){
    if (sec <= 60) return "$sec";
    if (sec <= 3600) return "${sec~/60}'${sec % 60}";
    return "$sec";
  }


  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => false;
}