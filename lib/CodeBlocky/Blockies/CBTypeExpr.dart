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
import 'package:battlepus/common/DartCommon.dart';


class CBTypeExpr extends CodeBlockyType{


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
        // height: CodeBlockyType.baseRowHeight,
        padding: CodeBlockyType.basePadding,
        decoration: dc,
        child:Wrap(
          crossAxisAlignment: WrapCrossAlignment.center ,
          children: [
            // SizedBox(width: 8,),
            Text("返回" , style: CodeBlockyType.baseTextStyle,),
            SizedBox(width: 4,),
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
    bool isError = false;

    if (func != null && !DartCommon.isEmpty(func.extraParam)){
      isError = blocky.getBlocky("0") != null && CodeBlockyType.isTypeError(blocky.getBlocky("0") , func.extraParam);
    }
    // else{
    //   isError = blocky.getBlocky("0") != null && CodeBlockyType.isTypeError(blocky.getBlocky("0") , "Enum.EBTStatus") && CodeBlockyType.isTypeError(blocky.getBlocky("0") , "bool");
    // }
      // print("func.extraParam = ${func.extraParam}");
    if (isError){
      // if (blocky.getBlocky("0") != null && CodeBlockyType.isTypeError(blocky.getBlocky("0") , "Enum.EBTStatus") && CodeBlockyType.isTypeError(blocky.getBlocky("0") , "bool")){
      // if (blocky.getBlocky("0") != null && CodeBlockyType.isTypeError(blocky.getBlocky("0") , func.extraParam)){
        dc = new BoxDecoration(
            border: new Border.all(color: bgColor, width: 1),
            color : Colors.redAccent,
            //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
            boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
            borderRadius: new BorderRadius.circular((5.0))
        );
      }
    // }

    var dtgt1 = BlockySlotEditor(func: func , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_EXPR,container: blocky, slot : "0");

    var con = Container(
      key: ValueKey(blocky.guid),
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      // width: 120,

      decoration: dc,
      child: Row(
        children: [
          Text("返回",style: CodeBlockyType.baseTextStyle,),
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
  CBTypeExpr(){
    typeFlag = BlockyTypes.BT_BLOCK;
    setDefaultColor(Colors.purpleAccent);
    name = "expr";
    alias = "返回";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    // StringBuffer sb = StringBuffer();

    return "return ${blk.getBlockyBehavicCode("0")}";
    // return sb.toString();
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , 表达式未设置");
      return 0;
    }

    bool isError = false;
    String errStr = "";
    if (func != null && !DartCommon.isEmpty(func.extraParam)){
      isError = blk0 != null && CodeBlockyType.isTypeError(blk0 , func.extraParam);
      errStr = "结点 ${StateScriptNode.crtExportNode.exportId} , 返回类型错误，期待 ${func.extraParam}";
    }
    // else{
    //   isError = blk0 != null && CodeBlockyType.isTypeError(blk0, "Enum.EBTStatus") && CodeBlockyType.isTypeError(blk0 , "bool");
    //   errStr = "结点 ${StateScriptNode.crtExportNode.exportId} , 返回类型错误，期待 Enum.EBTStatus 或者 bool";
    // }

    // if (func != null && !DartCommon.isEmpty(func.extraParam)){
    if (isError){
      // if (CodeBlockyType.isTypeError(blk0, func.extraParam)){
        errLst.add(errStr);
        // print("errLst == $errLst");
        return 0;
      }
    // }

    int iCount = CodeBlockyType.doCompile(blk0, null, bw, errLst, func);
    bw.writeUint16(CodeBlockyType.OP_RETURN, "return");
    return iCount+1;
    // bw.writeUint16(CodeBlockyType.OP_EOF  , "代码终止");
  }
}