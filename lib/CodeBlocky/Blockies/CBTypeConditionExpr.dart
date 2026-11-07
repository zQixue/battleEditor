//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';


class CBTypeConditionExpr extends CodeBlockyType{
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
                child:Container(
                  width: 60,
                  decoration: dc2,
                ),
              ),
              Icon(MaterialCommunityIcons.code_equal,color: Colors.indigo,size: 24,),
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
        ),

        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
    }

    String tgtType ;
    var blocky0Type = blocky.getBlocky("0")?.getFullTypeWithExtra();
    var blocky1Type = blocky.getBlocky("1")?.getFullTypeWithExtra();
    if (blocky1Type != null) tgtType = blocky1Type;
    if (blocky0Type != null) tgtType = blocky0Type;


    var canReceiveCallback = (blk){
      var tp = getOperateExtraType((blk as CodeBlocky).getFullTypeWithExtra()??"int");
      if (tp != null && type2OperateTypes[tp] == null){
        // print(type2OperateTypes);
        return "比较运算不支持2 $tp";
      }
      return true;
    };

    var dtgt1 = BlockySlotEditor(canReceiveCallback :canReceiveCallback ,targetType: tgtType , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    var dtgt2 = BlockySlotEditor(canReceiveCallback :canReceiveCallback ,targetType: tgtType , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "1",);

    var rtp = getOperateExtraType(tgtType??"int");
    // print("rtp = $rtp");
    var operate = blocky.values["operate"]??"==";
    var ops = type2OperateTypes[rtp??"int"];
    if (ops == null){
      //检查是不是枚举
      ops = ["==","<>"];
    }
    if (!ops.contains(operate)){
      operate = blocky.values["operate"] = "==";
    }
    var op = CommonUtil.getStringDropdown("选择运算符",(itm){
      return operateIcons[itm];
    }
        ,ops
        ,operate, (v){
          // blocky.setBlocky(2, v);
          HistoryManager.functionHistory?.appendHistory();
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
  CBTypeConditionExpr(){
    typeFlag = BlockyTypes.BT_CONDITION;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.lightBlue);
    name = "ConditionExpr";
    alias = "条件判断表达式";
  }

  // List<String> operateTypes =[">",">=","<","<=","==","<>"];
  Map<String , List<String>> type2OperateTypes = {
    "short" : [">",">=","<","<=","==","<>"],
    "int" : [">",">=","<","<=","==","<>"],
    "float" : [">",">=","<","<=","==","<>"],
    "double" : [">",">=","<","<=","==","<>"],
    "long" : [">",">=","<","<=","==","<>"],
    "ushort" : [">",">=","<","<=","==","<>"],
    "uint" : [">",">=","<","<=","==","<>"],
    "ulong" : [">",">=","<","<=","==","<>"],
    "boolean": ["==","<>"],
    "bool": ["==","<>"],
    "Vector2": ["==","<>"],
    "Vector3": ["==","<>"],
    "enum": ["==","<>"],
    "obj": ["==","<>"],
    "object": ["==","<>"],
    "struct": ["==","<>"],
  };
  Map<String,Icon> operateIcons ={
    ">" : Icon(MaterialCommunityIcons.code_greater_than , color: Colors.blue,size:24),
    ">=" : Icon(MaterialCommunityIcons.code_greater_than_or_equal , color: Colors.blue,size:24),
    "<" : Icon(MaterialCommunityIcons.code_less_than , color: Colors.blue,size:24),
    "<=" : Icon(MaterialCommunityIcons.code_less_than_or_equal , color: Colors.blue,size:24),
    "==" : Icon(MaterialCommunityIcons.code_equal , color: Colors.blue,size:24),
    "<>" : Icon(MaterialCommunityIcons.code_not_equal_variant , color: Colors.blue,size:24),
  };

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    var operate = blk.values["operate"]??"==";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    res["a"] = blk.getBlockyCode("0");
    res["b"] = blk.getBlockyCode("1");
    res["op"] = operate;
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();
    var operate = blk.values["operate"]??"==";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    sb.write("(");
    sb.write(blk.getBlockyBehavicCode("0"));
    sb.write(" $operate ");
    sb.write(blk.getBlockyBehavicCode("1"));
    sb.write(")");
    return sb.toString();
  }

  String getOperateExtraType(String tp){

    if (tp.startsWith("Enum.")){
      return "enum";
    }
    if (tp.startsWith("BObj.")){
      return "obj";
    }
    if (tp.startsWith("BStruct.")){
      return "struct";
    }
    return tp;
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

    var blocky0Type = blk0.getFullTypeWithExtra();

    if (blocky0Type == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 左侧类型未确定, ${func.getTypeShowString()}");
      return 0;
    }

    var blocky1Type = blk1.getFullTypeWithExtra();

    if (blocky1Type == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 右侧类型未确定, ${func.getTypeShowString()}");
      return 0;
    }

    // if (blocky1Type != blocky0Type && (blocky0Type != "object" && blocky1Type != "object")) {
    if (!CodeBlockyType.isObjectTypeValid(blocky1Type , blocky0Type)) {
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 两侧表达式未类型不一致 $blocky0Type $blocky1Type，无法比较, ${func.getTypeShowString()}");
      return 0;
    }

    var tp = getOperateExtraType(blocky0Type??"int");
    if (tp != null && type2OperateTypes[tp] == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 不支持的类型比较 $blocky0Type $blocky1Type, ${func.getTypeShowString()}");
      return 0;
    }
    var operate = blk.values["operate"]??"==";
    var supportOps = type2OperateTypes[tp];
    if (!supportOps.contains(operate)){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , $blocky0Type 不支持 $operate 比较, ${func.getTypeShowString()}");
      return 0;
    }
    int optextra = blk0.getOperateExtraType();
    if (CodeBlocky.operateExtras["struct"] == optextra){
      BehavicAgentClass clz = blk0.getStructType();
      if (clz == null){
        errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , condition expr struct 结构类型不存在");
        return 0;
      }
    }

    int iCount = CodeBlockyType.doCompile(blk0, blocky0Type, bw, errLst, func);

    iCount += CodeBlockyType.doCompile(blk1, blocky0Type, bw, errLst, func);


    //CodeBlocky.operateExtras["boolean"];//blk0.getOperateExtraType();
    // if (optextra == null){
    //   errLst.add("${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
    //   return ;
    // }
    switch(operate){
      case ">":
        bw.writeUint16(CodeBlockyType.OP_GREATER + optextra , "> 比较");
        break;
      case ">=":
        bw.writeUint16(CodeBlockyType.OP_GE + optextra , ">= 比较");
        break;
      case "<":
        bw.writeUint16(CodeBlockyType.OP_LESS + optextra , "< 比较");
        break;
      case "<=":
        bw.writeUint16(CodeBlockyType.OP_LE + optextra , "<= 比较");
        break;
      case "==":
        bw.writeUint16(CodeBlockyType.OP_EQUAL + optextra , "== 比较");
        if (CodeBlocky.operateExtras["struct"] == optextra){
          BehavicAgentClass clz = blk0.getStructType();
          bw.writeUint32(clz.exportId , "struct 类型 id");
        }
        break;
      case "<>":
        bw.writeUint16(CodeBlockyType.OP_NOT_EQUAL + optextra , "!= 比较");
        if (CodeBlocky.operateExtras["struct"] == optextra){
          BehavicAgentClass clz = blk0.getStructType();
          bw.writeUint32(clz.exportId , "struct 类型 id");
        }
        break;
    }
    ++iCount;
    return iCount;

  }
}