//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class AObjectTag extends StatefulWidget {
  final AObject obj;
  final String highlightPattern;
  AObjectTag({Key key,
    this.highlightPattern,
    this.obj,
  }) : super(key: key);

  @override
  _AObjectTagState createState() => _AObjectTagState();
}

class _AObjectTagState extends State<AObjectTag> {

  StreamSubscription<AObjectChanged> _lis;

  @override
  void dispose() {
    _lis?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _lis = EventCenter.eventBus.on<AObjectChanged>().listen((event) {
      if (event.obj == widget.obj)
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var txtMsg = widget.obj.getTag();
    if (widget.obj.isComment){
      txtMsg = widget.obj.comment??"";
    }
    var txt = Text(txtMsg, overflow: TextOverflow.ellipsis, maxLines: 1 , style: widget.obj.isComment?TextStyle(fontSize: 14, color: Colors.green): ThemeCenter.mainTextStyle(step: 8,fontSize: 14));
    var res = widget.highlightPattern == null?Expanded(child : txt):
    Expanded(child : ParsedText(
      text: txtMsg,
      style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12),
      parse: <MatchText>[
        MatchText(
          pattern: widget.highlightPattern, // a custom pattern to match
          regexOptions: RegexOptions(
              multiLine : true,
              caseSensitive : false,
              unicode : true,
              dotAll : true
          ),
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 12,
          ), // custom style to be applied to this matched text
        )
      ],
    ));
    return res;
  }
}