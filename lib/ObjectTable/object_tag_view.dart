//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/common/EventCenter.dart';

class ObjectTagView extends StatefulWidget {
  final AObject object;
  final Color color;
  ObjectTagView({Key key,
    this.object,
    this.color,
  }) : super(key: key);

  @override
  _ObjectTagViewState createState() => _ObjectTagViewState();
}

class _ObjectTagViewState extends State<ObjectTagView> {
  StreamSubscription<AObjectChanged> _lis;

  StreamSubscription<AObjectShowDetail> _lis2;
  bool isDetailShow = false ;
  @override
  void dispose() {
    _lis?.cancel();
    _lis2?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _lis = EventCenter.eventBus.on<AObjectChanged>().listen((event) {
      if (event.obj == widget.object)
        setState(() {
        });
    });

    _lis2 = EventCenter.eventBus.on<AObjectShowDetail>().listen((event) {
      bool bShow = event.obj == widget.object;
      if(bShow != isDetailShow) {
        setState(() {
          isDetailShow = bShow ;
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.object == null){
      return const Text("[ 空 ]" , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 12, fontWeight: FontWeight.w500 , color: Colors.redAccent));
    }
    var clr = widget.color??Colors.lightBlueAccent;
    if (isDetailShow){
      clr = Colors.yellow;
    }

    if (widget.object.isComment){
      var txt = Text(widget.object.comment??"" , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 12, fontWeight: FontWeight.w500 , color: Colors.green));
      return Tooltip(
        message:widget.object.comment??"" ,
        child: txt,
      );
    }

    var txt = Text(widget.object.getTag() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 12, fontWeight: FontWeight.w500 , color: clr));
    return txt;
    // return Row(
    //   children: [
    //     Expanded(child: txt,),
    //     Tooltip(
    //       child: Icon(MaterialCommunityIcons.comment, size: 20,
    //         color: DartCommon.isEmpty(widget.object.comment)?Colors.grey:Colors.green,
    //       ),
    //       message: widget.object.comment??"",
    //     ),
    //   ],
    // );
  }
}