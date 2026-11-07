//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/StateScript/SSDefines.dart';

class GroupFlagNamesView extends StatefulWidget {
  final ScriptInfo script;
  final double scale;
  GroupFlagNamesView({Key key , this.script , this.scale = 1.0}) : super(key: key);

  @override
  _GroupFlagNamesViewState createState() => _GroupFlagNamesViewState();
}

class _GroupFlagNamesViewState extends State<GroupFlagNamesView> {

  StreamSubscription<LocationFlagEvent> _lis;

  static int _copiedColor = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  double scale ;
  @override
  void initState() {
    scale = widget.scale;
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<LocationFlagEvent>().listen((event) {
      if (scale != event.scale || event.bForce) {
        scale = event.scale;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (scale > 0.4 || SSDefines.isInDagging){
      return Container();
    }

    var nodes = List<Widget>();
    for(var g in widget.script.scriptData.nodeGroups){
      var rect = g.currentGroupRect;
      var nv = Positioned(
          left: rect.left - 50,
          top:rect.top - 200,
          child: Container(
            // padding: EdgeInsets.all(32),
            // decoration:_dc ,
            child:Wrap(
              crossAxisAlignment : WrapCrossAlignment.center,
              children: [
                Icon(MaterialCommunityIcons.flag_checkered ,size: 220, color: Colors.redAccent,),
                Text(g.getTypeShowString(),style: TextStyle(fontSize: 100, color: Colors.white, fontWeight: FontWeight.w600),),
              ],
            ),
          )
      );
      if (nv != null) {
        nodes.add(nv);
      }
    }
    // return nodes;
    return Stack(
      children: nodes,
    );
  }
}