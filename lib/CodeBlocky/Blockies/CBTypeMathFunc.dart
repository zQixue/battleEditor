//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';


class CBTypeMathFunc extends CodeBlockyType{

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
              padding: CodeBlockyType.basePadding,
                decoration: dc,
                child:Text("abs" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo))
            ),
            Text(" of " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),
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

    var dtgt1 = BlockySlotEditor(blockFlag: BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    // var dtgt2 = BlockySlotEditor(blockFlag: BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: 1,);

    var operate = blocky.values["operate"]??"abs";
    var op = CommonUtil.getStringDropdown("选择运算符",(itm){
      return Container(
        decoration: dc,
          padding: CodeBlockyType.basePadding,
        child:Text(itm , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo))
      );//operateIcons[itm];
    }
        ,operateTypes
        ,operate, (v){
          HistoryManager.functionHistory?.appendHistory();
          blocky.values["operate"] = v;
          EventCenter.eventBus.fire(BlockContainerRefresh());
        },menuIcon: Icon(Entypo.chevron_down,color: Colors.indigoAccent,));

    var con = Container(
      decoration: dc,
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      child : Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: dc,
              padding: CodeBlockyType.basePadding,
              child:Row(
                children: [
                  Text(operate , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),
                  Container(
                    width: 24,
                    height: 24,
                    child:op,
                  )
                  // op
                ],
              )
          ),

          Text(" of " , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),
          dtgt1,
          // op,
        ],
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBTypeMathFunc(){
    typeFlag = BlockyTypes.BT_EXPR;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.lime);
    name = "MathFunc";
    alias = "数学函数";
  }

  List<String> operateTypes =["abs","floor","ceiling","sqrt","sin","cos","tan","asin","acos","atan","ln","log","e^","10^"];
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
    var operate = blk.values["operate"]??"abs";
    operate = ExportMappingConfig.instance.operates[operate]??operate;
    res["mathFunc"] = operate;
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }
}