//@dart=2.11

import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_editor.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/common/CommonUtil.dart';


class CBTypeWhile extends CodeBlockyType{

  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.5),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((5.0))
    );

    var dc2 = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.5),
        color :Colors.white,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((5.0))
    );


    if (blocky == null) {
      return Container(
        // height: 28,
        width: 120,
        decoration: dc,
        child : Column(
          children: [
            Container(
              height: CodeBlockyType.baseRowHeight,
              child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, CodeBlockyType.baseSplitWidth/2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                decoration: dc2,
              ),
            ),
            Container(
              height: CodeBlockyType.baseRowHeight,
            )
          ],
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
    }

    var dtgt1 = BlockySlotEditor(blockFlag: BlockyTypes.BT_CONDITION, defaultWidgetBlockFlag: BlockyTypes.BT_CONDITION , container: blocky, slot : "0");
    var body = blocky.getCreateBody();
    var bodyWidget = BlockyEditor(blockiesContainer: body, expanded: false,owner: blocky,);

    var head = Container(
      key: ValueKey(blocky.guid),
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      // width: 120,

//      decoration: dc,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 8,),
          Text("当",style: CodeBlockyType.baseTextStyle,),
          SizedBox(width: 8,),
          dtgt1,
          SizedBox(width: 8,),
          Text("执行",style: CodeBlockyType.baseTextStyle,),
          // Text("=",style: CodeBlockyType.baseTextStyle,),
          // Icon(MaterialCommunityIcons.,color: Colors.indigo,size: 20,),

        ],
      ),
    );
    var con = Container(
      decoration: dc,
      child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          head,
          Container(

            padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, CodeBlockyType.baseSplitWidth, 0),
            child:Container(
              decoration: dc2,
              child: bodyWidget,
            ),
          ),
          Container(
            height: CodeBlockyType.baseRowHeight/2,
          ),
        ],
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return Column(
      children: [
        con,
        SizedBox(height: CodeBlockyType.baseInterval ,)
      ],
    );
  }

  CBTypeWhile(){
    typeFlag = BlockyTypes.BT_BLOCK;
    // bgColor = Colors.brown;
    setDefaultColor(Colors.brown);
    name = "While";
    alias = "循环 While";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["expr"] = blk.getBlockyCode("0");
    res["block"] = blk.getCreateBody().getExportCode();

    return res;
  }

}