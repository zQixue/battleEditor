//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
class LineFieldContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final Color separatorColor;
  final double height;
  final bool singleLine;
  final bool withLine;
  final TextStyle hintStyle;
  final bool noExpanded;
  LineFieldContainer({Key key ,this.hintStyle,this.noExpanded=false, this.withLine = true, this.height , this.child , this.title = "" , this.separatorColor  ,this.singleLine = true}) : super(
      key: key);

  @override
  _LineFieldContainerState createState() =>
      _LineFieldContainerState(
      );
}

class _LineFieldContainerState extends State<LineFieldContainer> {
  @override
  Widget build(BuildContext context) {
    var rowSeparatorWidget = Divider(
      color: widget.separatorColor??ThemeCenter.mainTextStepColor(3),
      height: 0.3,
      thickness: 0.9,
    );

    return Container(
      padding: EdgeInsets.all(0),
      height: widget.height??null,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4,),
//          SingleChildScrollView(
//            scrollDirection: Axis.horizontal,
//            child: Row(children:[ SizedBox(width: 2,), Text(widget.title , maxLines: 1 , overflow:TextOverflow.clip, style: TextStyle(color: Colors.black45 ,fontSize: 14),)]),
//          ),

          if (!DartCommon.isEmpty( widget.title))Row(children:[ Text(widget.title , maxLines: 1 , overflow:TextOverflow.clip, style: widget.hintStyle??ThemeCenter.mainTextStyle(step:5, fontSize: 13))]),
          widget.noExpanded?Expanded(child:widget.child):Expanded(
            child: widget.singleLine? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children:[ SizedBox(width: 4,),widget.child]),
            ):SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: widget.child),
            ),
          // widget.child,
          if (widget.withLine) rowSeparatorWidget,
        ],
      ),
    );
  }
}