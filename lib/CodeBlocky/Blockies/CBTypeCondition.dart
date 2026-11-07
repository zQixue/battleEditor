//@dart=2.11

import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';

import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';


class CBTypeCondition extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    return "bool";
  }

  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.2);
    // var dc = new BoxDecoration(
    //     border: new Border.all(color: bgColor, width: 0.5),
    //     color :bgcolor2,
    //     //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
    //     boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
    //     borderRadius: new BorderRadius.circular((90.0))
    // );
    var dc2 = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.4),
        color :Colors.white,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );
    if (blocky == null) {
      return Material(
        color: bgcolor2,
        shadowColor: bgColor,
        shape: BeveledRectangleBorder(
            side: BorderSide(width: 0.5, color: bgColor),
            borderRadius: BorderRadius.circular(20)),
        child :Container(
          padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
          child: Container(
            width: 60,
            decoration: dc2,
            height: CodeBlockyType.baseRowHeight,
            // child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
          ),
        ),


      );
    }

    var dtgt1 = BlockySlotEditor(targetType : "bool" , blockFlag: BlockyTypes.BT_EXPR|BlockyTypes.BT_METHOD|BlockyTypes.BT_VAR,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    var fColor = CodeBlockyType.isTypeError(blocky , targetType) ? Colors.redAccent : bgColor;
    return Material(
      color: bgcolor2,
      shadowColor: fColor,
      shape: BeveledRectangleBorder(
          side: BorderSide(width: 0.5, color: fColor),
          borderRadius: BorderRadius.circular(25)),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
        child: dtgt1
      )
    );

  }

  CBTypeCondition(){
    typeFlag = BlockyTypes.BT_CONDITION;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.lightBlue);
    name = "Condition";
    alias = "条件表达式";
  }
  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }
    return CodeBlockyType.doCompile(blk0, "bool", bw, errLst, func);
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();
    sb.write("(");
    sb.write(blk.getBlockyBehavicCode("0"));
    sb.write(")");
    return sb.toString();
  }

}