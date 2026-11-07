//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/common/Tagger/ATag.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/CommonUtil.dart';

class TagView extends StatefulWidget {
  final ATag tag;

  TagView({Key key,
    this.tag,

  }) : super(key: key);

  @override
  _TagViewState createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {

  static var tagColors = [Color(0xFFCC9999),  Color(0xFF666699),
    Color(0xFF0099CC),
    Color(0xFFCCCC99), Color(0xFFCC3399), Color(0xFF99CC00),
    Color(0xFFFF6666),  Color(0xFF3399CC),
    Color(0xFFCC6600), Color(0xFF999999),
    Color(0xFFFFFFCC), Color(0xFF009933),
    Color(0xFF0099CC), Color(0xFFCCCCCC), Color(0xFFFF6666),
    Color(0xFFFF6600), Color(0xFF009966),
    Color(0xFFCC6633), Color(0xFFCC6600),
    Color(0xFFCC0066), Color(0xFF009999),
    Color(0xFF6699CC), Color(0xFF663366), Color(0xFFCCCC99),
    Color(0xFF990033), Color(0xFFCCFF66), Color(0xFFFF9900),
    Color(0xFF666699), Color(0xFF660033), Color(0xFF99CC99),
    Color(0xFF663300),
    Color(0xFF990033), Color(0xFF006633),
    Color(0xFF660033), Color(0xFF999933), Color(0xFF660099),
    Color(0xFF993366), Color(0xFF666633),
    Color(0xFF996600), Color(0xFF666600),
    Color(0xFF009933), Color(0xFFCC9900), Color(0xFF666666),
    Color(0xFF666633),  Color(0xFFCC3366)];

  @override
  Widget build(BuildContext context) {
    var txt = widget.tag.getTypeShowString();
    var hash = txt.hashCode;

    return ThemeCenter.roundRect(
      // height: 32,
      radius: 4,
      padding: EdgeInsets.all(4),
      child: Row(
        children: [

          Text(txt , style: TextStyle(color:CommonUtil.changeColorLightness(tagColors[hash%tagColors.length],0.5)),),
        ],
      ),
      bgColor: Color(0),
      borderColor: CommonUtil.changeColorLightness(tagColors[hash%tagColors.length],0.3),
      borderWidth: 3
    );
  }
}