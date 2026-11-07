//@dart=2.11

import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';

class CBTypeNot extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    return "bool";
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
      return Material(
        color: bgcolor2,
        shadowColor: bgColor,
        shape: BeveledRectangleBorder(
            side: BorderSide(width: 0.5, color: bgColor),
            borderRadius: BorderRadius.circular(24)),
        // padding: CodeBlockyType.basePadding,
        // // width: 120,
        // decoration: dc,
        child :Container(
          padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
          child : Wrap(
            crossAxisAlignment: WrapCrossAlignment.center ,
            children: [
              Text("not " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),
              Container(
                // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
                height: CodeBlockyType.baseRowHeight,
                child:Material(
                  color: Colors.white,
                  shadowColor: bgColor,
                  shape: BeveledRectangleBorder(
                      side: BorderSide(width: 0.5, color: bgColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: 60,
                  ),
                ),
              ),
            ],
          ),
        ),

        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
    }
    // var blocky1 = blocky.getBlocky(0);

    var dtgt1 = BlockySlotEditor(targetType: "bool", blockFlag: BlockyTypes.BT_CONDITION,defaultWidgetBlockFlag: BlockyTypes.BT_CONDITION ,container: blocky,slot: "0",);
    // var dtgt2 = BlockySlotEditor(blockFlag: BlockyTypes.BT_CONDITION,defaultWidgetBlockFlag: BlockyTypes.BT_CONDITION ,container: blocky,slot: 1,);

    // var operate = blocky.values["operate"]??"and";
    // var op = CommonUtil.getStringDropdown("选择运算符",(itm){
    //   return operateIcons[itm];
    // }
    //     ,operateTypes
    //     ,operate, (v){
    //       // blocky.setBlocky(2, v);
    //       blocky.values["operate"] = v;
    //       EventCenter.eventBus.fire(BlockContainerRefresh());
    //     },menuIcon: operateIcons[operate]);

    var fColor = CodeBlockyType.isTypeError(blocky , targetType) ? Colors.redAccent : bgColor;
    var con = Material(
        color: bgcolor2,
        shadowColor: fColor,
        shape: BeveledRectangleBorder(
            side: BorderSide(width: 0.5, color: fColor),
            borderRadius: BorderRadius.circular(20)),
        // padding: CodeBlockyType.basePadding,
        // height: CodeBlockyType.baseRowHeight,
        child:Container(
          padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
          child : Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("not " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),
              dtgt1,
              // op,
              // dtgt2,
            ],
          ),
        )

      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeNot(){
    typeFlag = BlockyTypes.BT_CONDITION;
    // bgColor = Colors.lightBlue;
    setDefaultColor(Colors.lightBlue);
    name = "NotExpr";
    alias = "非";
  }

  // List<String> operateTypes =["and","or"];
  // Map<String,Widget> operateIcons ={
  //   "and" : Text(" and " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),//Icon(MaterialCommunityIcons.gate , color: Colors.indigo,size:24),
  //   "or" : Text(" or " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),//Icon(MaterialCommunityIcons.code_greater_than_or_equal , color: Colors.indigo,size:24),
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
    return "(not ${blk.getBlockyBehavicCode("0")})";
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }
    int iCount = CodeBlockyType.doCompile(blk0, "bool", bw, errLst, func);
    // int optextra = blk0.getOperateExtraType();
    // if (optextra == null){
    //   errLst.add("${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
    //   return ;
    // }
    bw.writeUint16(CodeBlockyType.OP_NOT , "取反");
    ++iCount;
    return iCount;
  }
}