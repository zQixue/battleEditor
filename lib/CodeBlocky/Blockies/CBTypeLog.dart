//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';

import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';

class CBTypeLog extends CodeBlockyType{


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

    if (blocky == null) {
      return Container(
        height: CodeBlockyType.baseRowHeightAdd,
        padding: CodeBlockyType.basePadding,
        width: 100,
        decoration: dc,
        child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
      );
    }

    // String tgtType ;
    // var blocky0Type = blocky.getBlocky("0")?.getFullTypeWithExtra();
    // var blocky1Type = blocky.getBlocky("1")?.getFullTypeWithExtra();
    // if (blocky1Type != null) tgtType = blocky1Type;
    // if (blocky0Type != null) tgtType = blocky0Type;
    //
    // if (blocky.getBlocky("0") != null){
    //   blocky.getBlocky("0").readonlyFlag = true;
    // }
    // var dtgt1 = BlockySlotEditor(targetType: tgtType ,blockFlag: BlockyTypes.BT_VAR, defaultWidgetBlockFlag: BlockyTypes.BT_VAR , container: blocky, slot : "0");
    var dtgt1 = BlockySlotEditor(targetType: null ,blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_EXPR,
        container: blocky, slot : "0");

    var con = Container(
      key: ValueKey(blocky.guid),
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      // width: 120,

      decoration: dc,
      child: Row(
        children: [
          Text("打印",style: CodeBlockyType.baseTextStyle,),
          SizedBox(width: 8,),
          dtgt1,
          // SizedBox(width: 8,),
          // // Text("=",style: CodeBlockyType.baseTextStyle,),
          // Icon(MaterialCommunityIcons.equal_box,color: Colors.indigo,size: 20,),
          // SizedBox(width: 8,),
          // dtgt2,
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
  CBTypeLog(){
    typeFlag = BlockyTypes.BT_BLOCK;
    setDefaultColor(Colors.deepPurpleAccent);
    name = "Log";
    alias = "Log打印";
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    if (!StateScriptProject.instance.debugExport){
      // release 模式,log语句全部去除
      return 0;
    }
    // 表达式计算压栈
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 打印目标表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }

    // // 变量ID 压栈
    // var blk0 = blk.getBlocky("0");
    // if (blk0 == null){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 左侧变量未设置, ${func.getTypeShowString()}");
    //   return 0;
    // }


    // CodeBlockyType.doCompile(blk0, null, bw, errLst, func);
    int optextra = blk0.getOperateExtraType();
    if (optextra == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 获得类型失败, ${func.getTypeShowString()}");
      return 0;
    }
    // var optextra1 = blk1.getFullTypeWithExtra();
    // var optextra0 = blk0.getFullTypeWithExtra();
    // if (!CodeBlockyType.isObjectTypeValid(optextra1 , optextra0)){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 设置变量语句左右类型不一致, ${func.getTypeShowString()} $optextra1 != $optextra0");
    //   return 0;
    // }

    int iCount = CodeBlockyType.doCompile(blk0, null, bw, errLst, func);
    // var tp = CodeBlockyType.getType(blk0.blockyTypeId) as CBBehavicAgentVar;
    // String guid = blk0.values["guid"]??"";
    // var field = CBBehavicAgentVar.getField(guid);
    //
    // bool isScriptVar = false;
    // if (field == null){
    //   field = StateScriptProject.instance.globalScriptVars[guid];
    //   isScriptVar = true;
    // }
    // if (field == null){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , 无效的变量, ${func.getTypeShowString()}");
    //   return 0;
    // }
    // if (field.isReadOnly){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , 变量只读, ${func.getTypeShowString()}");
    //   return 0;
    // }
    //
    // if (!isScriptVar) {
    //   bw.writeUint16(CodeBlockyType.OP_ASSIGN_BAVAR + optextra, "设置BA变量");
    //   bw.writeUint32(field.exportId, "变量id");
    // }
    // else {
    //   bw.writeUint16(CodeBlockyType.OP_ASSIGN_SSVAR + optextra, "设置脚本变量");
    //   bw.writeUint32(field.exportId, "脚本变量id");
    // }

    bw.writeUint16(CodeBlockyType.OP_LOG + optextra, "打印");
    // bw.writeUint32(field.exportId, "脚本变量id");
    ++iCount;
    return iCount;
    // bw.writeUint16(CodeBlockyType.OP_EOF  , "代码终止");
  }


  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    // var varBlk = blk.getBlocky("0");
    // res["var"] = blk.getBlockyCode("0");//CodeBlockyType.getType("___var___").getExportFuncInfo(varBlk);
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();
    sb.write("print ");
    sb.write(blk.getBlockyBehavicCode("0"));
    // sb.write(" = ");
    // sb.write(blk.getBlockyBehavicCode("1"));
    return sb.toString();
  }
}