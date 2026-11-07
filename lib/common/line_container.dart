//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/common/ThemeCenter.dart';
class LineContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final Color separatorColor;
  final double height;
  final bool withLine;
  final TextStyle hintStyle;
  final EdgeInsetsGeometry padding;
  final bool noExpanded;

  LineContainer({Key key,this.hintStyle, this.noExpanded = false, this.padding , this.withLine = true, this.height , this.child , this.title = "" , this.separatorColor }) : super(key: key);

  @override
  _LineContainerState createState() => _LineContainerState();
}

class _LineContainerState extends State<LineContainer> {
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

          Row(children:[ Text(widget.title , maxLines: 1 , overflow:TextOverflow.clip, style: widget.hintStyle??ThemeCenter.mainTextStyle(step:5, fontSize: 13))]),
          widget.noExpanded? Container(
            padding: widget.padding?? EdgeInsets.all(0),
            child: widget.child,
          ):Expanded(child: Container(
            padding: widget.padding?? EdgeInsets.all(0),
            child: widget.child,
          )),
          // widget.child,
          if (widget.withLine) rowSeparatorWidget,
        ],
      ),
    );
  }
}