//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:battlepus/StateScript/SSDefines.dart';

class GridPainter extends CustomPainter {

  Color _lineColor;
  Color _axisColor;
  double _xStep;
  double _yStep;
  GridPainter(Color lineColor , Color axisColor , double xStep , double yStep){
    _lineColor = lineColor;
    _axisColor = axisColor;
    _xStep = xStep;
    _yStep = yStep;
  }
  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8
      ..color = _axisColor;

    var p1 = Offset(SSDefines.canvasZeroX ,0);
    var p2 = Offset(SSDefines.canvasZeroX ,size.height);
    canvas.drawLine(p1, p2, paint);

    var p3 = Offset(0 ,size.height/2);
    var p4 = Offset(size.width ,size.height/2);
    canvas.drawLine(p3, p4, paint);

//    // Left eye
//    canvas.drawRRect(
//      RRect.fromRectAndRadius(Rect.fromLTWH(20, 40, 100, 100), Radius.circular(20)),
//      paint,
//    );
//    // Right eye
//    canvas.drawOval(
//      Rect.fromLTWH(size.width - 120, 40, 100, 100),
//      paint,
//    );
//    // Mouth
//    final mouth = Path();
//    mouth.moveTo(size.width * 0.8, size.height * 0.6);
//    mouth.arcToPoint(
//      Offset(size.width * 0.2, size.height * 0.6),
//      radius: Radius.circular(150),
//    );
//    mouth.arcToPoint(
//      Offset(size.width * 0.8, size.height * 0.6),
//      radius: Radius.circular(200),
//      clockwise: false,
//    );
//
//    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}