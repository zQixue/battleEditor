//@dart=2.11

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/int_editor.dart';


class CBTypeConstUInt extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    return "uint";
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

    var dc3 = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.4),
        color : Colors.brown,
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
        child : Container(
          height: CodeBlockyType.baseRowHeight,
          child:Container(
            width: 60,
            decoration: dc2,
            child: Center(child: Text("8" , style: CodeBlockyType.baseTextStyle,)),
          ),
        ),
      );
    }
    var val = blocky.values["value"]??0;
    var con = Container(
      decoration: dc,
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      child : Container(
        width: max(60,val.toString().length * 14.0),
          decoration: dc3,
          padding: CodeBlockyType.basePadding,
          child: IntEditor(
            forceBuild: false,
            initValue: val,
            onSubmitted: (v){
              blocky.values["value"] = v;
              EventCenter.eventBus.fire(BlockContainerRefresh());
            },
            onChanged: (v){
              // var old = blocky.values["value"];
              // HistoryManager.functionHistory?.appendCallbackHistory(blocky.guid,
              //         (){
              //
              //       // print("undo set : $old ${blocky.}");
              //       blocky.values["value"] = old;
              //     },
              //         (){
              //           // print("undo set : $v $blocky");
              //       blocky.values["value"] = v;
              //     });
              HistoryManager.functionHistory?.appendHistory(guid : "${blocky.guid}");
              blocky.values["value"] = v;
              EventCenter.eventBus.fire(BlockContainerRefresh());
            },
            // onSubmitted: (v){
            //   blocky.values["value"] = v;
            //   EventCenter.eventBus.fire(BlockContainerRefresh());
            // },
          ),
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeConstUInt(){
    typeFlag = BlockyTypes.BT_CONST;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.lightGreen);
    name = "ConstUInt";
    alias = "正整数常量";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    var val = (blk.values["value"]??0) as int;
    res["val"] = val;
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    // StringBuffer sb = StringBuffer();
    var val = (blk.values["value"]??0) as int;
    return "$val";
    // return sb.toString();
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var val = (blk.values["value"]??0) as int;
    bw.writeUint16(CodeBlockyType.OP_PUSH + CodeBlocky.operateExtras["uint"] , "uint 压栈");
    bw.writeInt32(val , "uint 值");
    return 1;
  }
}