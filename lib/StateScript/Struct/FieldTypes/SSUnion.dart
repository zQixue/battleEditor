//@dart=2.11

import 'dart:collection';

import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/union_type_selector.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class SSUnion extends SSFieldType{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.alpha_i_box_outline , color: Colors.indigo,),
        SizedBox(width: 8,),
        Expanded (child : Text(getTypeShowString(),style : ThemeCenter.mainTextStyle(step:9,fontSize: 13),)),
      ],
    );
  }
  HashSet<String> supportTypes = HashSet<String>.from(  [
    "___int___" ,
    "___uint___" ,
    "___float___" ,
    "___double___" ,
    "___string___" ,
    "___bool___" ,
    "___vector3___" ,
    "___vector2___" ,
    "___quaternion___" ,
  ]);


  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    // var v = 0;
    // if (initValue is int ){
    //   v = initValue;
    // }
    var realType = levelInfo.lastVarTypeGuid;//levelInfo.fieldValueHolder.fieldType;
    if (DartCommon.isEmpty(realType) || !supportTypes.contains(realType)){
      realType = levelInfo.fieldValueHolder.fieldType ?? "___int___";
      var uts = UnionTypeSelector(
        height:baseHeight,
        initType: realType,
        onSelected: (t){
          levelInfo.fieldValueHolder.fieldType = t;
        // onChanged?.call(t);
          onSubmitted?.call(initValue);
      },);

      var tp = SSFieldType.getFieldType(realType);
      // print(realType);
      var edt = tp.getThinEditWidget(initValue , onChanged,onSubmitted,baseHeight,showInfo:showInfo,bOpen:bOpen,onVisible:onVisible,levelInfo:levelInfo,context:context);
      levelInfo.lastVarTypeGuid = null;
      // return edt..height = baseHeight;

      return EditorHolder()..widget = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded( child:edt.widget),
          uts,
        ],
      )..height=edt.height;
    }
    var tp = SSFieldType.getFieldType(realType);
    print(realType);
    var edt = tp.getThinEditWidget(initValue , onChanged,onSubmitted,baseHeight,showInfo:showInfo,bOpen:bOpen,onVisible:onVisible,levelInfo:levelInfo,context:context);
    levelInfo.lastVarTypeGuid = null;
    return edt..height = baseHeight;
  }


  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    return EditorHolder()..widget = Container(
    )..height = 20;
  }

  static String lastVarTypeGuid;

  static Map<int , String> unionStringHashId2StrMap = Map<int , String>();
  @override
  dynamic parseValue(value){
    var realType = lastVarTypeGuid;
    if (realType == null || !supportTypes.contains(realType)){
      realType = "___int___";
    }
    var tp = SSFieldType.getFieldType(realType);
    // lastVarTypeGuid = null;
    return tp.parseValue(value);
  }
  @override
  void export(ByteDataWriter bw, v,{Map prms}) {
    var realType = lastVarTypeGuid;

    if (realType == null || !supportTypes.contains(realType)){
      realType = "___int___";
    }

    var tp = SSFieldType.getFieldType(realType);
    if (tp.exportId == null){
      print("get SSUnion.lastVarTypeGuid = $realType");
      tp = SSFieldType.getFieldType("___int___");
    }
    
    lastVarTypeGuid = null;
    bw.writeUint8(tp.exportId, "union type : ${tp.name}");
    tp.exportFlag = exportFlag;
    tp.export(bw , v);
  }

  @override
  dynamic exportValue(v) {

    var realType = lastVarTypeGuid;
    if (realType == null || !supportTypes.contains(realType)){
      realType = "___int___";
    }
    var tp = SSFieldType.getFieldType(realType);
    lastVarTypeGuid = null;
    return tp.exportValue(v);
  }
}