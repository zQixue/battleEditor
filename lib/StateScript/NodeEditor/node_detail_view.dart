//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/NodeEditor/in_param_page.dart';
import 'package:battlepus/StateScript/NodeEditor/in_port_page.dart';
import 'package:battlepus/StateScript/NodeEditor/node_base_info_page.dart';
import 'package:battlepus/StateScript/NodeEditor/node_field_page.dart';
import 'package:battlepus/StateScript/NodeEditor/out_param_page.dart';
import 'package:battlepus/StateScript/NodeEditor/out_port_page.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class NodeDetailView extends StatefulWidget {
  NodeDetailView({Key key}) : super(
      key: key);

  @override
  _NodeDetailViewState createState() =>
      _NodeDetailViewState(
      );
}

class _NodeDetailViewState extends State<NodeDetailView> {
  StreamSubscription<NodeTypeSelectionChangeEvent> _lis;
  StreamSubscription<GlobalRefreshEvent> _lis1;
  NodeStructData crtNode;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
    _lis1?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<NodeTypeSelectionChangeEvent>().listen((event) {
      setState(() {
        crtNode = event.nodeType;
      });
    });

    _lis1 = EventCenter.eventBus.on<GlobalRefreshEvent>().listen((event) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (crtNode == null){
      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请在左侧选择一个结点"  , style: TextStyle(fontSize: 48 , color: Colors.grey),),
        ],
      ));

    };
    // var dc = new BoxDecoration(
    // boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    // );
    var bgClr = const Color.fromARGB(8, 0, 0, 0);
    // var padding = EdgeInsets.all(8);
    var padding =EdgeInsets.all(8);
    var tabViews = TabBarView(
      children: [
        Container(padding:padding,color : bgClr,child :NodeBaseInfoPage(nodeType : crtNode)),
        Container(padding:padding,color : bgClr,
          child : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return NodeFieldPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
            },
          ),
        ),
        Container(padding:padding,color : bgClr,
          child : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return InPortPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
            },
          ),
        ),
        Container(padding:padding,color : bgClr,
          child : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return OutPortPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
            },
          ),
        ),
        Container(padding:padding,color : bgClr,
          child : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return InParamPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
            },
          ),
        ),
        Container(padding:padding,color : bgClr,
          child : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return OutParamPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
            },
          ),
        ),
//        Container(padding: padding,color : bgClr,child :InPortPage(nodeType : crtNode)),
      ],
    );
    var textStyle = ThemeCenter.mainTextStyle(step: 8,fontSize: 14);
    var sb = const SizedBox(
        width: 20,
    );
    var tabBars = TabBar(
//      controller: TabController(),
      tabs: [
        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.credit_card_multiple,color:Colors.blue) ,sb, Expanded(child:Text("基本信息",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.focus_field,color:Colors.blue),sb,Expanded(child:Text("属性",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),

        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.arrow_collapse_right,color:Colors.blue),sb,Expanded(child:Text("输入",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.arrow_expand_right,color:Colors.blue),sb,Expanded(child:Text("输出",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),

        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.transfer_right,color:Colors.blue),sb,Expanded(child:Text("参数入口",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.function_variant,color:Colors.blue),sb,Expanded(child:Text("参数接口",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),

//        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.arrow_collapse_right,color:Colors.blue),sb,Text("输出",style: textStyle)])),
      ],
    );
//    bool inStore = NodeCamp.instance.nodeStructs.containsKey(crtNode.guid);
    var dtc = DefaultTabController(
      length: 6,
      child:Column(
        children: [
          Container(
            height: 52,
            child : Row(
              children: [
                Expanded(flex:3 , child : tabBars),
                Expanded(
                  flex:1 ,child :Container()
//                  child : Row(
//
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: [
//                      RaisedButton(
//                        child: Text(inStore?"更新库":"入库"),
//                        color: CommonUtil.scaleColor(inStore?Colors.redAccent:Colors.indigoAccent, 0.5),
//                        onPressed: (){
//                          bool exists = NodeCamp.instance.appendNodeType(crtNode);
//                          NodeCamp.instance.save();
//                          BotToast.showText(text: exists?"结点 ${crtNode.name} 已更新":"结点 ${crtNode.name} 已入库");
//                        },
//                      ),
//                      SizedBox(width: 12,)
//                    ],
//
//                  )
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
//                  color :Color.fromARGB(4, 0, 0, 0),
                  child: tabViews
              )
          ),
        ],
      )
    );
    return ThemeCenter.area(
      // decoration:dc,

      child: dtc,
    );
  }
}