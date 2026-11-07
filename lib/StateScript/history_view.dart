//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/common/EventCenter.dart';

class HistoryView extends StatefulWidget {
  final HistoryManager manager;
  HistoryView({Key key , this.manager}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  StreamSubscription<HistoryRefreshEvent> _lis2;

  @override
  void dispose() {
    // TODO: implement dispose
    _lis2?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _lis2 = EventCenter.eventBus.on<HistoryRefreshEvent>().listen((event) {
      if (widget.manager == event.manager) {
        setState(() {

        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var manager = widget.manager;
    if (manager == null) return Container();
    bool withUndo = manager.undoList.length > 0;
    bool withRedo = manager.redoList.length > 0;
    var size = 36.0;
    var fontSize = 18.0;
    TextStyle st = TextStyle(fontWeight: FontWeight.w600 , fontSize : 12, color: Colors.white);
    var dc = new BoxDecoration(
        // border: new Border.all(color: bgColor, width: 0.5),
        color : Colors.red,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        // boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            // color: Colors.blueGrey,
            width: size,
            height: size,
            child: Stack(
              children: [
                Positioned(
                  left:2,
                  top:-6,
                  child: Icon(MaterialCommunityIcons.undo , size: 32, color:withUndo?Colors.indigo:Colors.grey),
                ),

                withUndo?Positioned(
                  left:0,
                  top:18,
                  child: Container(
                    decoration: dc,
                      padding: EdgeInsets.all(0),
                    width: size,
                    height :fontSize,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${manager.undoList.length}",style: st)
                        ],
                      ),
                  ),
                ):Container()
              ],
            ),

          ),
          SizedBox(width: 2,),
          Container(
            padding: EdgeInsets.all(0),
            width: size,
            height: size,
            child: Stack(
              children: [
                Positioned(
                  left:2,
                  top:-6,
                  child: Icon(MaterialCommunityIcons.redo , size: 32, color:withRedo?Colors.indigo:Colors.grey),
                ),

                withRedo?Positioned(
                  left:0,
                  top:18,
                  child: Container(
                    padding: EdgeInsets.all(0),
                      decoration: dc,
                      width: size,
                      height :fontSize,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${manager.redoList.length}",style: st)
                        ],
                      ),
                  ),
                ):Container()
              ],
            ),
          ),
          (withRedo||withUndo)?IconButton(
            icon: Icon(MaterialCommunityIcons.close_box_outline),
            onPressed: (){
              setState(() {
                widget.manager.clear();
              });

            },
          ) :Container()
        ],
      ),
    );


  }
}