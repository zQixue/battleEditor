//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class ProgressDialog extends StatefulWidget {
  final double width ;
  final double height ;
  final double progressWidth ;
  final double progressHeight ;
  final String info ;
  final String title ;
  final TextStyle style ;
  final dynamic onCancel;
  ProgressDialog({Key key , this.onCancel, this.info , this.title = "请稍后...", this.style, this.width , this.height , this.progressWidth , this.progressHeight}) : super(key: key);

  @override
  _ProgressDialogState createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {

  String info ;
  StreamSubscription<ProgressEvent> _lis;

  @override
  void initState() {
    // TODO: implement initState
    info = widget.info;

    _lis = EventCenter.eventBus.on<ProgressEvent>().listen((event) {
      setState(() {
        info = event.info;
      });
    });

    super.initState();

  }


  @override
  void dispose() {
    _lis?.cancel();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    var con= Container(
      padding: EdgeInsets.all(8),
      width: widget.width??200,
      height: widget.height??200,
      child: Column(
        children: [
          Text(widget.title??"" , style: ThemeCenter.systemTheme.accentTextTheme.bodyText1),
          Expanded(child : Center(child: Container(width : widget.progressHeight??80 , height : widget.progressHeight??80 , child : CircularProgressIndicator()))),
          Text("${info??''}..."??"" , style: widget.style??ThemeCenter.systemTheme.accentTextTheme.bodyText1,),
        ],
      ) ,
    );

    return InkWell(
      child: con,
      onDoubleTap: (){
        widget.onCancel?.call();
      },
    );
  }
}