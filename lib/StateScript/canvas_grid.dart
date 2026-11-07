//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/GridPainter.dart';


class CanvasGrid extends StatefulWidget {
  final Color lineColor ;
  final Color axisColor ;
  final double xStep ;
  final double yStep ;
  CanvasGrid({Key key , this.lineColor = const Color.fromARGB(20, 0, 0, 0) , this.axisColor = const Color.fromARGB(20, 255, 0, 0) ,this.xStep = 64 , this.yStep = 64 }) : super(
      key: key);

  @override
  _CanvasGridState createState() =>
      _CanvasGridState(
      );
}

class _CanvasGridState extends State<CanvasGrid> {
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.widthConstraints().maxWidth,
            height: constraints.heightConstraints().maxHeight,
//            color: Colors.yellow,
            color: Color.fromARGB(0, 0, 0, 0),
            // child: ClipRect(
            //   // clipper: _MyClipper(),
            //   child: CustomPaint(painter: GridPainter(widget.lineColor ,widget.axisColor , widget.xStep,widget.yStep)),
            // ),
            child : CustomPaint(painter: GridPainter(widget.lineColor ,widget.axisColor , widget.xStep,widget.yStep)),
          );
        }
    );
  }
}

class _MyClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(1000.0, 1000.0, size.width - 1000.0,  size.height- 1000.0);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

