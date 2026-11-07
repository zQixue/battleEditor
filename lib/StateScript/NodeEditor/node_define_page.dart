//@dart=2.11
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/NodeEditor/node_define_list_view.dart';
import 'package:battlepus/StateScript/NodeEditor/node_detail_view.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/EventCenter.dart';

class NodeDefinePage extends StatefulWidget {
  NodeDefinePage({Key key}) : super(
      key: key);

  @override
  _NodeDefinePageState createState() =>
      _NodeDefinePageState(
      );
}

class _NodeDefinePageState extends State<NodeDefinePage> {
  StreamSubscription<NodeTypeChangeEvent> _lis;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lis = EventCenter.eventBus.on<NodeTypeChangeEvent>().listen((event) {
      setState(() {

      });
    });
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
//    StateScriptProject.instance.save();
  }

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context).settings.arguments as Map;
    // if (args != null){
    //   select
    // }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("结点定义"),
        actions: [
          IconButton(icon: Icon(MaterialCommunityIcons.collage),iconSize: 36, color: Colors.white, tooltip:"搜集结点联想库",
            onPressed: (){
              StateScriptProject.instance.collectConnectAssist();
              BotToast.showText(text: "搜集完毕");
            },
          ),
          IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 36, color: Colors.white, tooltip:"保存",
            onPressed: (){
              StateScriptProject.instance.save();
              BotToast.showText(text: "保存完毕");
            },
          ),
        ],
      ),
      body:Container(
        // padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(flex : 2 , child: NodeDefineListView()),
            // SizedBox(width: 8,),
            Expanded(flex : 6 , child:NodeDetailView()),
          ],
        ),
      ),
    );
  }
}