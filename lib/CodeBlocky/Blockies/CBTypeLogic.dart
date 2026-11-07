//@dart=2.11

import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';


class CBTypeLogic extends CodeBlockyType{

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
              // Icon(MaterialCommunityIcons.code_equal,color: Colors.indigo,size: 24,),
              operateIcons["and"],
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

    var dtgt1 = BlockySlotEditor(targetType : "bool" , blockFlag: BlockyTypes.BT_CONDITION,defaultWidgetBlockFlag: BlockyTypes.BT_CONDITION ,container: blocky,slot: "0",);
    var dtgt2 = BlockySlotEditor(targetType : "bool" , blockFlag: BlockyTypes.BT_CONDITION,defaultWidgetBlockFlag: BlockyTypes.BT_CONDITION ,container: blocky,slot: "1",);

    var operate = blocky.values["operate"]??"and";
    var op = CommonUtil.getStringDropdown("选择运算符",(itm){
      return operateIcons[itm];
    }
        ,operateTypes
        ,operate, (v){
          HistoryManager.functionHistory?.appendHistory();
          // blocky.setBlocky(2, v);
          blocky.values["operate"] = v;
          EventCenter.eventBus.fire(BlockContainerRefresh());
        },menuIcon: operateIcons[operate]);

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
              dtgt1,
              op,
              dtgt2,
            ],
          ),
        )

      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeLogic(){
    typeFlag = BlockyTypes.BT_CONDITION;
    // bgColor = Colors.lightBlue;
    setDefaultColor(Colors.lightBlue);
    name = "LogicExpr";
    alias = "逻辑表达式";
  }

  List<String> operateTypes =["and","or"];
  Map<String,Widget> operateIcons ={
    "and" : Text(" and " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),//Icon(MaterialCommunityIcons.gate , color: Colors.indigo,size:24),
    "or" : Text(" or " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),//Icon(MaterialCommunityIcons.code_greater_than_or_equal , color: Colors.indigo,size:24),
  };

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    var operate = blk.values["operate"]??"and";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    res["a"] = blk.getBlockyCode("0");
    res["b"] = blk.getBlockyCode("1");
    res["op"] = operate;
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();
    var operate = blk.values["operate"]??"and";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    sb.write("(");
    sb.write(blk.getBlockyBehavicCode("0"));
    sb.write(" $operate ");
    sb.write(blk.getBlockyBehavicCode("1"));
    sb.write(")");
    return sb.toString();
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    // var checkType = blk.getFullTypeWithExtra();
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 左侧表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }


    var blk1 = blk.getBlocky("1");
    if (blk1 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 右侧表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }
    int iCount = CodeBlockyType.doCompile(blk0, "bool", bw, errLst, func);

    ByteDataWriter bw2 = ByteDataWriter();
    int iCount2 = CodeBlockyType.doCompile(blk1, "bool", bw2, errLst, func);

    var operate = blk.values["operate"]??"and";
    //----------------
    //追加 skip 命令
    switch(operate){
      case "and":
        bw.writeUint16(CodeBlockyType.OP_AND_SKIP  , "与运算");
        bw.writeInt32( iCount2, "Skip跳转距离");
        break;
      case "or":
        bw.writeUint16(CodeBlockyType.OP_OR_SKIP  , "或运算");
        bw.writeInt32( iCount2, "Skip跳转距离");
        break;
    }
    ++ iCount;
    //----------------
    bw.writeBuffer(bw2);
    iCount += iCount2;
    // int optextra = CodeBlocky.operateExtras["bool"];//blk0.getOperateExtraType();
    // // if (optextra == null){
    // //   errLst.add("${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
    // //   return ;
    // // }
    switch(operate){
      case "and":
        bw.writeUint16(CodeBlockyType.OP_AND  , "与运算");
        break;
      case "or":
        bw.writeUint16(CodeBlockyType.OP_OR  , "或运算");
        break;
    }
    ++ iCount;
    return iCount;

  }

}