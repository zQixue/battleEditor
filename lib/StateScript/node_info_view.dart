//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/markdown_editor.dart';
import 'package:battlepus/common/text_editor.dart';

class NodeInfoView extends StatefulWidget {
  // final NodeStructData nodeType;
  // final StateScriptNode node;
  final double containerWidth;
  final double containerHeight;
  NodeInfoView({Key key , this.containerWidth , this.containerHeight}) : super(key: key);

  @override
  _NodeInfoViewState createState() => _NodeInfoViewState();
}

class _NodeInfoViewState extends State<NodeInfoView> {


  NodeStructData nodeType;
  StateScriptNode node;
  double width = 400;
  // double height = 00;
  StreamSubscription<NodeDescriptionEditorEvent> _lis;

  @override
  void initState() {
    _lis = EventCenter.eventBus.on<NodeDescriptionEditorEvent>().listen((event) {
      node = event.node;
      nodeType = node?.getNodeStructType();
      setState(() {

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

    if (node == null || nodeType == null) return Container(width: 0,height: 0,);

    var nt = node?.getNodeStructType();

    var height = widget.containerHeight *2 / 3;
    var con = MarkdownEditor(

      title: "${nt.getTypeShowString()} 结点类型介绍",
      // height: 260,
      bgColor : CommonUtil.alphaColor(Colors.blueAccent , 12),
      data: nodeType.description,
      onChanged: (v){
        nodeType.description = v;
        // print("change " +v);
      },
      onSubmitted: (v){
        nodeType.description = v;
      },
    );


    var right =  Container(
      width: width,
      height : height,
      padding: EdgeInsets.all(8),
      // height: 680.0 + 48,
      child: Column(
        children: [
          if (node != null)Expanded(child:ThemeCenter.block(
            // padding: EdgeInsets.all(8),
            // : "结点描述",
            headTitle: "${nt.getTypeShowString()} 结点描述",
            padding: EdgeInsets.all(8),
            // height: 200,
            child: TextEditor(
              initValue: node.description??"",
              maxLines: 8,
              onChanged: (v){
                node.description = v;
                EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
              },
            ),
            actions: [
              ThemeCenter.iconBtn(MaterialCommunityIcons.auto_fix,
                tooltip: "模板生成",
                onPressed: (){
                  setState(() {
                    node.description = node.getFullDesc(ScriptInfo.current.scriptData.collectInParamNameMaps());
                  });
                }
              ),

              ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
                  color: Colors.redAccent,
                  tooltip: "关闭",
                  onPressed: (){
                    EventCenter.eventBus.fire(NodeDescriptionEditorEvent()..node = null);
                  }
              ),
            ]
          )),
          if (node != null && nt != null)Expanded(child:ThemeCenter.block(
            // padding: EdgeInsets.all(8),
            // : "结点描述",
            headTitle: "${nt.getTypeShowString()} 结点描述模板",
            padding: EdgeInsets.all(8),
            // height: 200,
            child: TextEditor(
              initValue: nt.descriptionTemplate??"",
              maxLines: 8,
              onChanged: (v){
                nt.descriptionTemplate = v;
                EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
              },
            ),
          )),
          // Container(height: 8),
          // if (widget.node != null)LineContainer(
          //   // padding: EdgeInsets.all(8),
          //   title: "结点别名",
          //   height: 60,
          //   child: TextEditor(
          //     initValue: widget.node.nodeAlias??"",
          //     onChanged: (v){
          //       widget.node.nodeAlias = v;
          //       EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = widget.node);
          //     },
          //   ),
          // ),
          Expanded(child:ThemeCenter.area(child:con)),
        ],
      ),
    );


    return Positioned(
      left: (widget.containerWidth - width) - 8,
      top: (widget.containerHeight - height)/2,
      child: right,
    );
    // return Container(
    //   // color: CommonUtil.alphaColor(Colors.white, 0),
    //   child :Row(
    //     children: [
    //       Expanded(child : Container()),
    //       Expanded(child : right),
    //     ],
    //   )
    // );
  }
}