//@dart=2.11


import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';


class CBTypeNull extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    return "obj";
  }

  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 1.2),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );

    var dc2 = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.4),
        color :Colors.white,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );


    return Container(
      // height: 28,\
      padding: CodeBlockyType.basePadding,
      // width: 120,
      decoration: dc,
      child : Container(
        height: CodeBlockyType.baseRowHeight,
        child:Container(
            width: 60,
            decoration: dc2,
            child: Center(child: Text("空" , style: TextStyle(color: Colors.grey ,fontWeight: FontWeight.w800),)),
        ),
      ),
    );
  }
  CBTypeNull(){
    typeFlag = BlockyTypes.BT_CONST;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.lime);
    name = "ConstNUll";
    alias = "空引用";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    // var val = blk.values["value"] == true;
    res["val"] = "null";
    return res;
  }


  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    return "NULL";
  }
  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    bw.writeUint16(CodeBlockyType.OP_PUSH_NULL , "空引用压栈");
    return 1;
  }
}