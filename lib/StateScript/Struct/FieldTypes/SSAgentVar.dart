//@dart=2.11


import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSUnion.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class SSAgentVar extends SSString{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType  , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.script_text_outline , color: Colors.indigoAccent,),
        SizedBox(width: 8,),
//        Container(child:Text(getTypeShowString(),maxLines: 1,overflow: TextOverflow.clip)),
        Expanded(child:Text(getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    baseHeight = 20;
    var datas = StateScriptProject.instance.getAgentFieldInfos();
    var current = CommonUtil.getItemByGuid(datas , v);

    var res = CommonUtil.getStringSearchableDropdown(
      "选择字段",
        (i){
          return CommonUtil.getSearchKey(i);
        },
        (i){
          return "${(i as FieldInfo).extraInfo}.${(i as FieldInfo).getTypeShowString()}";
        },
        datas,current,
        (v){
          onSubmitted?.call(v);
        },
        color: Colors.white,
      fontSize: 12,
      iconSize: SSDefines.iconButtonSize,
      getSelectWidgetCallback:(data){
        // return Container();
        var txt = Text("${(data as FieldInfo).getTypeShowString()}",overflow: TextOverflow.clip,maxLines: 1,style : TextStyle( fontSize: 12, fontWeight: FontWeight.w600 , color:Colors.indigoAccent));
        return Tooltip(
          message: "${(data as FieldInfo).extraInfo}.${(data as FieldInfo).getTypeShowString()}",
          child: txt,
        );
      }
    );
    var dc =  BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1,color: Colors.grey),
        ));
    return EditorHolder()..widget = Container(
      padding: EdgeInsets.all(0),
        height: baseHeight,//*1.6 ,
        decoration: dc,
        child:Row(
          children: [
            Expanded( child : Container(
              padding: EdgeInsets.all(0),
              // width: 100,
              child: res,
            )),
          ],
        )
    ) ..height = baseHeight;//*1.6 ;
  }
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted,{Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    // return EditorHolder()..widget = Container()..height = SSDefines.nodeFieldRowHeight;
    var datas = StateScriptProject.instance.getAgentFieldInfos();
    var targetType = levelInfo.varType;
    if (targetType != null) {
      datas = datas.where((element) {
        var fi = SSFieldType.getFieldType(element.typeGuid);
        return fi.guid == targetType;
      }).toList();
    }
    var current = CommonUtil.getItemByGuid(datas , v);

    var res = CommonUtil.getStringSearchableDropdown(
        "选择字段",
            (i){
          return CommonUtil.getSearchKey(i);
        },
            (i){
          return "${(i as FieldInfo).extraInfo}.${(i as FieldInfo).getTypeShowString()}";
        },
        datas,current,
            (v){
          onSubmitted?.call(v);
        }
    );
    var dc =  BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1,color: Colors.grey),
        ));
    return EditorHolder()..widget = Container(
        // height: SSDefines.nodeFieldRowHeight ,
        decoration: dc,
        child:Row(
          children: [
            Expanded( child : Container(
              padding: EdgeInsets.all(0),
              // width: 100,
              child: res,
            )),
          ],
        )
    ) ..height = SSDefines.nodeFieldRowHeight ;
  }


  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    var fields = StateScriptProject.instance.getAgentFieldInfos();
    var field = fields.firstWhere((element) => element.guid == str, orElse:()=>null);

    // bw.writeInt32(field==null?0:field.guid.hashCode , exportFlag);
    bw.writeInt32(field==null?0:field.exportId??0 , exportFlag);
    if (field != null){
      SSUnion.lastVarTypeGuid = field.typeGuid;
      // print("set SSUnion.lastVarTypeGuid = ${field.typeGuid}");
    }
//    bw.writeString(scriptInfo==null?"":scriptInfo.name, exportFlag);
  }

  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    var fields = StateScriptProject.instance.getAgentFieldInfos();
    var field = fields.firstWhere((element) => element.guid == str, orElse:()=>null);
    // var scriptInfo = datas.firstWhere((element) => element.guid == str, orElse:()=>null);

    // var fields = StateScriptProject.instance.getAgentFieldInfos();
    // var field = CommonUtil.getItemByGuid(fields, guid);
    if (field != null){
      SSUnion.lastVarTypeGuid = field.typeGuid;
    }

    // return field==null?0:field.guid.hashCode;
    return field==null?"___dummy___":field.name;
  }

  @override
  dynamic parseFinalValue(value){
    var datas = StateScriptProject.instance.getAgentFieldInfos();
    var scriptInfo = datas.firstWhere((element) => element.guid == value, orElse:()=>null);
    var res = scriptInfo==null?0:scriptInfo.exportId??0;
    // SSUnion.lastVarTypeGuid = guid;
    return res;
  }

  @override
  Widget getValueLabelWidget(initValue , {TextStyle style}){
    var str = parseValue(initValue);
    var datas = StateScriptProject.instance.getAgentFieldInfos();
    var scriptInfo = datas.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return Text("未指定" , style:style);
    }
    return Text(scriptInfo.getTypeShowString(), style:style);
  }

  @override
  dynamic getExportDefault(dynamic defaultValue){
    return 0;
  }

  dynamic parseShortShowName(value){
    var str = parseValue(value);
    var datas = StateScriptProject.instance.getAgentFieldInfos();
    var scriptInfo = datas.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return "未指定黑板变量";
    }
    return scriptInfo.getTypeShowString();
  }

  @override
  String getExportType(){
    return "int";
  }

  @override
  String getFilterString(v){
    var datas = StateScriptProject.instance.getAgentFieldInfos();
    var current = CommonUtil.getItemByGuid(datas , v);
    if(current != null)
      return current.alias;
    else
     return "$v";
  }
}