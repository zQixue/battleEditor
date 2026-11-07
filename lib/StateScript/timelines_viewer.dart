//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/TimelinePainter.dart';

class TimelinesViewer extends StatefulWidget {
  final double width;
  final double height;
  TimelinesViewer({Key key, this.width, this.height}) : super(key: key);

  @override
  _TimelinesViewerState createState() => _TimelinesViewerState();
}

class _TimelinesViewerState extends State<TimelinesViewer> {
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.widthConstraints().maxWidth,
            height: constraints.heightConstraints().maxHeight,
//            color: Colors.yellow,
            color: Color.fromARGB(0, 0, 0, 0),
            child: CustomPaint(painter: TimelinePainter(widget.width,widget.height)),
          );
        }
    );
  }
}