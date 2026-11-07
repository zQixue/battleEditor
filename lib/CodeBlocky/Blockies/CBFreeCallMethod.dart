//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';


class CBFreeCallMethod extends CodeBlockyType{


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
            Text("调用函数" , style: CodeBlockyType.baseTextStyle,),
            // SizedBox(width: 8,),
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

    if (blocky.getBlocky("0") != null){
      blocky.getBlocky("0").freeFunctionFlag = true;
    }
    var dtgt1 = BlockySlotEditor(func: func , blockFlag: BlockyTypes.BT_METHOD,defaultWidgetBlockFlag: BlockyTypes.BT_METHOD,container: blocky, slot : "0");

    var con = Container(
      key: ValueKey(blocky.guid),
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      // width: 120,

      decoration: dc,
      child: Row(
        children: [
          Text("调用函数",style: CodeBlockyType.baseTextStyle,),
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
  CBFreeCallMethod(){
    typeFlag = BlockyTypes.BT_BLOCK;
    setDefaultColor(Colors.blue);
    name = "method";
    alias = "调用函数";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["call"] = blk.getBlockyCode("0");
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){

    return blk.getBlockyBehavicCode("0");
  }

  int getOperateExtraType(String tp){
    var eid = CodeBlocky.operateExtras[tp];
    if (eid != null) return eid;
    if (tp.startsWith("Enum.")){
      return CodeBlocky.operateExtras["enum"];
    }
    if (tp.startsWith("BObj.")){
      return CodeBlocky.operateExtras["obj"];
    }
    return -1;
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , 函数未设置");
      return 0;
    }
    var fullTp = blk0.getFullTypeWithExtra();
    if (fullTp != null) {
      var tp = getOperateExtraType(fullTp);
      if (tp >= 0) {
        //带返回
        if (CodeBlocky.operateExtras["struct"] == tp){
          BehavicAgentClass clz = blk0.getStructType();
          if (clz == null){
            errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , POP struct 结构类型不存在");
            return 0;
          }
        }
      }
    }
    blk0.freeFunctionFlag = true;
    int iCount = CodeBlockyType.doCompile(blk0, null, bw, errLst, func);
    //自由调用
    // var fullTp = blk0.getFullTypeWithExtra();
    if (fullTp != null) {
      var tp = getOperateExtraType(fullTp);
      if (tp >= 0) {
        //带返回
        bw.writeUint16(CodeBlockyType.OP_POP + tp , "自由调用函数出栈");
        if (CodeBlocky.operateExtras["struct"] == tp){
          BehavicAgentClass clz = blk0.getStructType();
          bw.writeUint32(clz.exportId , "struct 类型 id");
        }
        ++iCount;
      }
    }
    return iCount;
  }
}