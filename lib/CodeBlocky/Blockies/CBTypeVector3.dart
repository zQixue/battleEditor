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

class CBTypeVector3 extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    return "Vector3";
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
            Icon(MaterialCommunityIcons.alpha_x_box_outline , color:Colors.redAccent),
            Container(
              // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                width: 40,
                decoration: dc2,
              ),
            ),
            Icon(MaterialCommunityIcons.alpha_y_box_outline , color:Colors.green),
            Container(
              // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                width: 40,
                decoration: dc2,
              ),
            ),
            Icon(MaterialCommunityIcons.alpha_z_box_outline , color:Colors.blueAccent),
            Container(
              // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                width: 40,
                decoration: dc2,
              ),
            ),
          ],
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
    }
    // var blocky1 = blocky.getBlocky(0);

    var dtgt1 = BlockySlotEditor(targetType : "float" , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    var dtgt2 = BlockySlotEditor(targetType : "float" , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "1",);
    var dtgt3 = BlockySlotEditor(targetType : "float" , blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "2",);

    if (CodeBlockyType.isTypeError(blocky , targetType)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 1.2),
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
          Icon(MaterialCommunityIcons.alpha_x_box_outline , color:Colors.redAccent),
          dtgt1,
          Icon(MaterialCommunityIcons.alpha_y_box_outline , color:Colors.green),
          dtgt2,
          Icon(MaterialCommunityIcons.alpha_z_box_outline , color:Colors.blueAccent),
          dtgt3
        ],
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeVector3(){
    typeFlag = BlockyTypes.BT_EXPR;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.deepPurpleAccent);
    name = "Vector3";
    alias = "3D向量";
  }

  // List<String> operateTypes =["+","-","X","/","div","mod"];
  // Map<String,Widget> operateIcons ={
  //   "+" : Icon(MaterialCommunityIcons.plus , color: Colors.indigo,size:22),
  //   "-" : Icon(MaterialCommunityIcons.minus , color: Colors.indigo,size:22),
  //   "X" : Icon(Entypo.cross , color: Colors.indigo,size:22),
  //   "/" : Icon(MaterialCommunityIcons.division , color: Colors.indigo,size:22),
  //   "div" : Text("整除" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),//Icon(MaterialCommunityIcons.div , color: Colors.indigo,size:22),
  //   "mod" : Text("取余" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo))//Icon(MaterialCommunityIcons. , color: Colors.indigo,size:22),
  // };
  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    res["x"] = blk.getBlockyCode("0");
    res["y"] = blk.getBlockyCode("1");
    res["z"] = blk.getBlockyCode("2");
//    print(res);
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    // var res = Map<String , dynamic>();
    // res["expr"] = blk.getBlockyCode("0");
    return "v3(${blk.getBlockyBehavicCode("0")},${blk.getBlockyBehavicCode("1")},${blk.getBlockyBehavicCode("2")})";
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    // var checkType = blk.getFullTypeWithExtra();
    var blk0 = blk.getBlocky("0");
    if (blk0 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} Vector2 X 未设置, ${func.getTypeShowString()}");
      return 0;
    }


    var blk1 = blk.getBlocky("1");
    if (blk1 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} Vector2 Y 未设置, ${func.getTypeShowString()}");
      return 0;
    }


    var blk2 = blk.getBlocky("2");
    if (blk2 == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} Vector2 Z 未设置, ${func.getTypeShowString()}");
      return 0;
    }
    int iCount = CodeBlockyType.doCompile(blk0, "float" , bw, errLst, func);
    iCount += CodeBlockyType.doCompile(blk1, "float", bw, errLst, func);
    iCount += CodeBlockyType.doCompile(blk2, "float", bw, errLst, func);

    bw.writeUint16(CodeBlockyType.OP_PUSH + CodeBlocky.operateExtras["Vector3"] , "v3 压栈");
    ++iCount;
    return iCount;
  }

}