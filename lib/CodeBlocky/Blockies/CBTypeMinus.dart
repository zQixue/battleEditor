//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';


class CBTypeMinus extends CodeBlockyType{
  @override
  String getBlockyType(CodeBlocky blk){
    String tgtType ;
    var blocky0Type = blk.getBlocky("0")?.getFullTypeWithExtra();
    if (blocky0Type != null) tgtType = blocky0Type;

    return tgtType;
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


    if (blocky == null) {
      return Container(
        // height: 28,\
        padding: CodeBlockyType.basePadding,
        // width: 120,
        decoration: dc,
        child : Wrap(
          crossAxisAlignment: WrapCrossAlignment.center ,
          children: [
            Icon(MaterialCommunityIcons.minus,color: Colors.indigo,size: 20,),
            Container(
              // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                width: 60,
                decoration: dc2,
              ),
            ),
          ],
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
    }

    var dtgt1 = BlockySlotEditor(targetType : targetType, blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    if (CodeBlockyType.isTypeError(blocky , targetType)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 0.5),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
    }
    var con = Container(
      decoration: dc,
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      child : Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(MaterialCommunityIcons.minus,color: Colors.indigo,size: 20,),
          dtgt1,
        ],
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeMinus(){
    typeFlag = BlockyTypes.BT_EXPR;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.deepPurpleAccent);
    name = "Minus";
    alias = "相反数";
  }
  //
  // List<String> operateTypes =["+","-","X","/"];
  // Map<String,Icon> operateIcons ={
  //   "+" : Icon(MaterialCommunityIcons.plus , color: Colors.indigo,size:22),
  //   "-" : Icon(MaterialCommunityIcons.minus , color: Colors.indigo,size:22),
  //   "X" : Icon(Entypo.cross , color: Colors.indigo,size:22),
  //   "/" : Icon(MaterialCommunityIcons.division , color: Colors.indigo,size:22),
  // };

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    // var res = Map<String , dynamic>();
    // res["expr"] = blk.getBlockyCode("0");
    return "(- ${blk.getBlockyBehavicCode("0")})";
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }

    int optextra = blk0.getOperateExtraType();
    if (optextra == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
      return 0;
    }
    int iCount = CodeBlockyType.doCompile(blk0, targetType, bw, errLst, func);
    bw.writeUint16(CodeBlockyType.OP_MINUS + optextra  , "取相反数");
    ++iCount;
    return iCount;
  }
}