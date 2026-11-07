//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';


class CBTypeArithmetic extends CodeBlockyType{
  @override
  String getBlockyType(CodeBlocky blk){
    String tgtType ;
    var blocky0Type = blk.getBlocky("0")?.getFullTypeWithExtra();
    var blocky1Type = blk.getBlocky("1")?.getFullTypeWithExtra();
    if (blocky1Type != null) tgtType = blocky1Type;
    if (blocky0Type != null) tgtType = blocky0Type;

    var operate = blk.values["operate"]??"+";
    if (tgtType != null ){
      var rt = resultTypes["$tgtType$operate"];
      if (rt != null){
        return rt;
      }
    }

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

            Container(
              // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                width: 60,
                decoration: dc2,
              ),
            ),
            Icon(MaterialCommunityIcons.plus,color: Colors.indigo,size: 20,),
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
    // var blocky1 = blocky.getBlocky(0);
    String tgtType ;
    var blocky0Type = blocky.getBlocky("0")?.getFullTypeWithExtra();
    var blocky1Type = blocky.getBlocky("1")?.getFullTypeWithExtra();
    if (blocky1Type != null) tgtType = blocky1Type;
    if (blocky0Type != null) tgtType = blocky0Type;


    var canReceiveCallback = (blk){

      var finalBlkType = blocky.getFullTypeWithExtra();
      if (targetType != null && finalBlkType != null && finalBlkType != targetType){
        return "四则运算不支持 $targetType 返回";
      }

      var tp = (blk as CodeBlocky).getFullTypeWithExtra();
      if (tp != null && type2OperateTypes[tp] == null){
        return "四则运算不支持 $tp 运算";
      }
      return true;
    };

    if (targetType != null ){
      tgtType = targetType;
    }

    var dtgt1 = BlockySlotEditor(canReceiveCallback :canReceiveCallback ,targetType: tgtType , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    var dtgt2 = BlockySlotEditor(canReceiveCallback :canReceiveCallback ,targetType: tgtType , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "1",);

    // var operate = blocky.values["operate"]??"+";

    var operate = blocky.values["operate"]??"+";
    var ops = type2OperateTypes[tgtType??"int"];
    if (ops == null){
      var dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 1.2),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
      var con = Container(
        decoration: dc,
        padding: CodeBlockyType.basePadding,
        // height: CodeBlockyType.baseRowHeight,
        child : Center(
          child: Text("运算结果类型不支持"),
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
      return con;
    }
    if (ops == null || !ops.contains(operate)){
      operate = blocky.values["operate"] = "+";
    }

    var op = CommonUtil.getStringDropdown("选择运算符",(itm){
      return operateIcons[itm];
    }
    ,ops
    ,operate, (v){
      // blocky.setBlocky(2, v);
      blocky.values["operate"] = v;
      EventCenter.eventBus.fire(BlockContainerRefresh());
    },menuIcon: operateIcons[operate]);

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
          dtgt1,
          op,
          dtgt2,
        ],
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeArithmetic(){
    typeFlag = BlockyTypes.BT_EXPR;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.deepPurpleAccent);
    name = "Arithmetic";
    alias = "四则运算";
  }
  Map<String , String> resultTypes = {
    "short/" : "float",
    "int/" : "float",
    "ushort/" : "float",
    "uint/" : "float",
    "long/" : "double",
    "ulong/" : "double",
  };
  // List<String> operateTypes =["+","-","X","/","div","mod"];
  Map<String , List<String>> type2OperateTypes = {
    "short" : ["+","-","X","/","div","mod"],
    "int" : ["+","-","X","/","div","mod"],
    "float" : ["+","-","X","/"],
    "double" : ["+","-","X","/"],
    "long" : ["+","-","X","/","div","mod"],
    "ushort" : ["+","-","X","/","div","mod"],
    "uint" : ["+","-","X","/","div","mod"],
    "ulong" : ["+","-","X","/","div","mod"],
    "Vector2": ["+","-"],
    "Vector3": ["+","-"],
  };

  Map<String,Widget> operateIcons ={
    "+" : Icon(MaterialCommunityIcons.plus , color: Colors.blue,size:22),
    "-" : Icon(MaterialCommunityIcons.minus , color: Colors.blue,size:22),
    "X" : Icon(Entypo.cross , color: Colors.blue,size:22),
    "/" : Icon(MaterialCommunityIcons.division , color: Colors.blue,size:22),
    "div" : Text("整除" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.blue)),//Icon(MaterialCommunityIcons.div , color: Colors.indigo,size:22),
    "mod" : Text("取余" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.blue))//Icon(MaterialCommunityIcons. , color: Colors.indigo,size:22),
  };

  @override
  dynamic getExportFuncInfo(CodeBlocky blk , {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    var operate = blk.values["operate"]??"+";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    res["a"] = blk.getBlockyCode("0");
    res["b"] = blk.getBlockyCode("1");
    res["op"] = operate;
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();

    var operate = blk.values["operate"]??"+";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    if (operate == "X") operate = "*";
    sb.write("(");
    sb.write(blk.getBlockyBehavicCode("0"));
    sb.write(" $operate ");
    sb.write(blk.getBlockyBehavicCode("1"));
    sb.write(")");

    return sb.toString();
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    var checkType = blk.getFullTypeWithExtra();
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
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 左侧类型未指定, ${func.getTypeShowString()}");
      return 0;
    }

    var blocky1Type = blk1.getFullTypeWithExtra();
    if (blocky1Type == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 右侧类型未指定, ${func.getTypeShowString()}");
      return 0;
    }
    if (blocky1Type != blocky0Type) {
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 两侧表达式未类型不一致，无法运算, ${func.getTypeShowString()}");
      return 0;
    }
    int optextra = blk0.getOperateExtraType();
    if (optextra == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
      return 0;
    }
    int iCount = CodeBlockyType.doCompile(blk0, checkType, bw, errLst, func);
    iCount += CodeBlockyType.doCompile(blk1, checkType, bw, errLst, func);

    var operate = blk.values["operate"]??"+";


    switch(operate){
      case "+":
        bw.writeUint16(CodeBlockyType.OP_ADD + optextra , "+ 计算");
        break;
      case "-":
        bw.writeUint16(CodeBlockyType.OP_SUB + optextra , "- 计算");
        break;
      case "X":
        bw.writeUint16(CodeBlockyType.OP_MUL + optextra , "X 计算");
        break;
      case "/":
        bw.writeUint16(CodeBlockyType.OP_FDIV + optextra , "/ 计算");
        break;
      case "div":
        bw.writeUint16(CodeBlockyType.OP_DIV + optextra , "div 计算");
        break;
      case "mod":
        bw.writeUint16(CodeBlockyType.OP_MOD + optextra , "mod 计算");
        break;
    }
    ++iCount;
    return iCount;
  }
}