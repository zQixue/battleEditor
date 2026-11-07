//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';

class ActionConnectionLine extends StatefulWidget {
  ActionConnectionLine({Key key}) : super(
      key: key);

  @override
  ActionConnectionLineState createState() =>
      ActionConnectionLineState(
      );
}

class ActionConnectionLineState extends State<ActionConnectionLine> {

  static Offset start = Offset.zero;
  static Offset end = Offset.zero;

  StreamSubscription<ConnectLineStartEvent> _lis1;
  StreamSubscription<ConnectLineMoveEvent> _lis2;
  StreamSubscription<ConnectLineEndEvent> _lis3;

  static ActionConnectionLineState current;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis1?.cancel();
    _lis2?.cancel();
    _lis3?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lis1 = EventCenter.eventBus.on<ConnectLineStartEvent>().listen((event) {
      setState(() {
        final RenderBox renderObject = context.findRenderObject() as RenderBox;
        start = renderObject.globalToLocal(event.start);
      });
    });
    _lis2 = EventCenter.eventBus.on<ConnectLineMoveEvent>().listen((event) {
      setState(() {
        final RenderBox renderObject = context.findRenderObject() as RenderBox;
        end = renderObject.globalToLocal(event.end);
      });
    });
    _lis3 = EventCenter.eventBus.on<ConnectLineEndEvent>().listen((event) {
      setState(() {
        start = null;
        end = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return IgnorePointer(
      child: CustomPaint(
        painter: _LinePainter(),
      )
    );
  }
}

class _LinePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = CommonUtil.alphaColor(Colors.indigo, 200);//Color.fromARGB(200, 255, 0, 0);
    if (ActionConnectionLineState.start == null || ActionConnectionLineState.end == null) return ;
    Path path = Path();
    var pout = ActionConnectionLineState.start;
    var pin = ActionConnectionLineState.end;
    if (pout.dx < pin.dx){
      path.moveTo(pout.dx, pout.dy);
//        canvas.drawLine(pout, pin, paint);
      var w = (pout.dx - pin.dx).abs();
      path.cubicTo(pout.dx+w/2, pout.dy, pin.dx -w/2 , pin.dy, pin.dx, pin.dy);
      canvas.drawPath(path, paint);
    }
    else{
      path.moveTo(pout.dx, pout.dy);
//        canvas.drawLine(pout, pin, paint);
      var w = (pout.dx - pin.dx).abs();
      path.cubicTo(pout.dx-w/2, pout.dy, pin.dx +w/2 , pin.dy, pin.dx, pin.dy);
      canvas.drawPath(path, paint);
    }
//    else{
//      path.moveTo(pout.dx, pout.dy);
////        canvas.drawLine(pout, pin, paint);
//      var w = (pout.dx - pin.dx).abs();
//      var h = (pout.dy - pin.dy).abs();
//      if (pout.dy > pin.dy){
//        path.cubicTo(pout.dx+w/2, pout.dy - h, pin.dx -w/2 , pin.dy + h, pin.dx, pin.dy);
//      }
//      else{
//        path.cubicTo(pout.dx+w/2, pout.dy + h, pin.dx -w/2 , pin.dy - h, pin.dx, pin.dy);
//      }
//      canvas.drawPath(path, paint);
//    }

//    canvas.drawLine(ActionConnectionLineState.start, ActionConnectionLineState.end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}