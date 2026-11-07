//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';

class CBTypeParam extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    if (blk == null) return null;
    String guid = blk.values["guid"]??"";
    var field = getParam(guid);
    if (field == null) return null;
    return field.getFullTypeWithExtra();
  }

  static FieldInfo getParam(String guid){

    for(var i in CodeBlocky.curentFunction.params){
      if (i.guid == guid){
        i.extraType = 0;
        return i;
      }
    }

    return null;
  }

  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.5),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );
    if (blocky == null) {
      return Container(
        height: CodeBlockyType.baseRowHeight,
        width: 120,
        decoration: dc,
        child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
      );
    }

    String v = blocky.values["guid"]??"";
    Map<String,FieldInfo> allFields =  Map<String,FieldInfo>();
    FieldInfo crt = null;
    List<FieldInfo> fields = List<FieldInfo>();
    for(var i in CodeBlocky.curentFunction.params){
      if (i.guid == v){
        crt = i;
      }
      i.extraType = 0;
      fields.add(i);
      allFields[i.guid] = i;
    }

    if (crt == null && v != ""){
      var temp = FieldInfo()..guid = v;
      temp.name = "INVALID";
      temp.alias = "无效";
      temp.extraType = blocky.values["type"]??1;
      crt = temp;
      fields.add(temp);
    }
    if (targetType != null){
      fields = fields.where((element) => element.getFullTypeWithExtra() == targetType || crt == element).toList();
    }
    var res = CommonUtil.getStringSearchableDropdown("选择参数", (field){
      return CommonUtil.getSearchKey(field);
    }, (i){
      if (i.extraType == 0){
        var text = "${(i as FieldInfo).getTypeShowString()}";
        var txt = Text(text , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle( fontSize: 14, fontWeight: FontWeight.w600 , color: Colors.black));
        return Row(
          children: [
            Icon(MaterialCommunityIcons.alpha_p_box_outline,color: Colors.black , size: 20,),
            txt,
          ],
        );
        // return txt;
      }
    }, fields, crt, (v){
      HistoryManager.functionHistory?.appendHistory();
      blocky.values["guid"] = v;
      blocky.values["type"] = allFields[v]?.extraType??1;
      blocky.values["fieldTypeGuid"] = allFields[v]?.guid??"";
      EventCenter.eventBus.fire(BlockContainerRefresh());
    },expanded: false, color: Colors.black);


    if (CodeBlockyType.isTypeError(blocky , targetType)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 0.5),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      key: ValueKey(blocky.guid),
      height: CodeBlockyType.baseRowHeight ,
      child:Row(
        children: [
          res,
        ],
      ),
      decoration: dc,
    );
  }

  CBTypeParam(){
    typeFlag = BlockyTypes.BT_VAR;
    setDefaultColor(Color(0xFFFF6666));
    name = "Param";
    alias = "参数";
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    if (blk == null){
      res["fieldType"] = "INVALID";
      res["extraType"] = "INVALID";
      res["name"] = "INVALID";
      res["hash"] = "INVALID";
      res["index"] = "INVALID";
      res["extra"] = "INVALID";
      return res;
    }
    String guid = blk.values["guid"]??"";
    var field = getParam(guid);
    if (field == null){
      var tp = SSFieldType.getFieldType(blk.values["fieldTypeGuid"]??"");
      res["fieldType"] = tp?.cname??"int";
      res["extraType"] = 1;
      res["name"] = "???";
      res["hash"] = "${guid.hashCode}";
      res["index"] = "???";
      res["extra"] = "???";
      return res;
    }
    var tp = SSFieldType.getFieldType(field.typeGuid);
    res["fieldType"] = tp.cname;
    res["extraType"] = field.extraType;
    res["name"] = "${field.name}";
    res["hash"] = "${field.name.hashCode}";
    res["extra"] = "${field.extraInfo2}";
    res["index"] = CodeBlocky.curentFunction.params.indexWhere((element) => element == field);
    return res;
  }
}