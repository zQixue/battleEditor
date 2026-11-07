//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';

class TooltipHelper extends StatefulWidget {
  final String value;
  final dynamic onSubmitted;
  final double width ;
  final double height ;
  final Color iconColor ;
  TooltipHelper({Key key , this.value , this.onSubmitted ,  this.width , this.height , this.iconColor = Colors.greenAccent}) : super(key: key);

  @override
  _TooltipHelperState createState() => _TooltipHelperState();
}

class _TooltipHelperState extends State<TooltipHelper> {

  String value ;
  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeCenter.iconBtn(MaterialCommunityIcons.help_box , color: Colors.greenAccent,
        width: widget.width , height : widget.height,
        tooltip: DartCommon.isEmpty(value)?"没有注释":value,
        onPressed: (){
          var con = ThemeCenter.block(
            padding: EdgeInsets.all(4),
            headTitle: "编辑帮助",
            child: TextEditor(
              initValue: value,
              maxLines: 30,
              onChanged: (v){
                setState(() {
                  value = v;
                  widget.onSubmitted?.call(value);
                });

              },
            ),
          );
          showDialog<String>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              var child = Container(
                padding: EdgeInsets.all(8),
                width: 600,
                height: 600,
                child: con,
              );
              return Dialog(child: child);
            },
          ).then((value){
            // if (value != null) {
            //   widget.onSubmitted?.call(value);
            // }
          });
        }
    );
  }
}