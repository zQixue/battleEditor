//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/common/CommonUtil.dart';


class CBTypeReturn extends CodeBlockyType{


  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 1),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((5.0))
    );
    var dc2 = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.4),
        color :Colors.white,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );
    if (blocky == null) {
      return Container(
        height: CodeBlockyType.baseRowHeight,
        padding: CodeBlockyType.basePadding,
        decoration: dc,
        child:Row(
         children: [
           SizedBox(width: 8,),
           Text("返回" , style: CodeBlockyType.baseTextStyle,),
           SizedBox(width: 8,),
           Container(
             height: CodeBlockyType.baseRowHeight,
             child:Container(
               width: 60,
               decoration: dc2,
             ),
           ),
         ],
        ),
      );
    }


    var dtgt1 = BlockySlotEditor(blockFlag: BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_EXPR,container: blocky, slot : "0");

    var con = Container(
      key: ValueKey(blocky.guid),
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      // width: 120,

      decoration: dc,
      child: Row(
        children: [
          Text("返回2 ",style: CodeBlockyType.baseTextStyle,),
          SizedBox(width: 8,),
          dtgt1,
        ],
      ),
    );
    return Column(
      children: [
        con,
        SizedBox(height: CodeBlockyType.baseInterval ,)
      ],
    );
  }
  CBTypeReturn(){
    typeFlag = BlockyTypes.BT_BLOCK;
    setDefaultColor(Colors.purpleAccent);
    name = "Return";
    alias = "返回2 ";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }
}