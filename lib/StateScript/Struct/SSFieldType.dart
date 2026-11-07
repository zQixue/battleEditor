


import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTIdSpaceObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTStringSpaceObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSAgentFunction.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSAgentVar.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSBool.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSColor.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSDVector2.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSDouble.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSFloat.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSFunction.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSGroup.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSImage.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSInt.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSIntArray.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSIntRange.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSList.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSMLSkill.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSMXFP.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSMap.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSNameScript.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSQuaternion.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSScene.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSScript.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSScriptVar.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSGlobalScriptVar.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSTileMap.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSUInt.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSUnion.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSVector2.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSVector2d.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSVector3.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSVector3d.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';

import 'FieldTypes/SSRect.dart';




part 'SSFieldType.g.dart';

@JsonSerializable()

class SSFieldType extends SSObjBase {


  String innerTypeGuid0 = "___int___" ;
  String innerTypeGuid1 = "___int___" ;

  @JsonKey(defaultValue: 0)
  int innerTypeCount = 0;
  @JsonKey(defaultValue: 0)
  int flag = 0;

  @JsonKey(ignore: true)
  bool isNodeRef = false;

  @JsonKey(ignore: true)
  String? typeGroup ;

  @JsonKey(defaultValue: 1024)
  int priority = 1024;
  static Map<String , SSFieldType> _typeMap = Map<String , SSFieldType> ();
  static registerTypeMap(Map<String , SSFieldType> tm){
    _typeMap = tm;
  }

  static List<SSFieldType> getTypeMap({int? includeFlag , int? excludeFlag}){
    return _typeMap.values.where((e){
      if (e.flag & FIELD_FLAG_HIDEN != 0) return false;
      if (includeFlag != null && (e.flag & includeFlag) ==0) return false;
      if (excludeFlag != null && (e.flag & excludeFlag) !=0) return false;
      return true;
    }).toList();
  }

  SSFieldType? get innerType0=>getFieldTypeByFullGuid(innerTypeGuid0);
  SSFieldType? get innerType1=>getFieldTypeByFullGuid(innerTypeGuid1);

  static SSFieldType? getFieldTypeByFullGuid(String guid , {FieldInfo? fieldInfo}) {
    var res = _typeMap[guid];
    if (res != null) return res;

    var sps = guid.split(":");
    if (sps.length == 3){
      var tmp = _typeMap[sps[0]];
      if (tmp == null) return null;
      if (tmp.innerTypeCount == null || tmp.innerTypeCount <= 0) return tmp;
      var newGuid = "${sps[0]}:${sps[1]}:${sps[2]}";
      var tbf = _typeMap[newGuid];
      if (tbf == null) {
        tbf = tmp.clone();
        if (tbf == null) return null;
        tbf.innerTypeGuid0 = sps[1];
        tbf.innerTypeGuid1 = sps[2];
        tbf.guid = newGuid;
        _typeMap[newGuid] = tbf;
      }
      return tbf;
    }
    return res;
  }

  static SSFieldType? getFieldType(String guid , {FieldInfo? fieldInfo}) {
    if (fieldInfo == null || fieldInfo.noInnerType()) {
      var res = _typeMap[guid];
      if (res != null) return res;

      var sps = guid.split(":");
      if (sps.length == 3){
        var tmp = _typeMap[sps[0]];
        if (tmp == null) return null;
        if (tmp.innerTypeCount == null || tmp.innerTypeCount <= 0) return tmp;
        var newGuid = "${sps[0]}:${sps[1]}:${sps[2]}";
        var tbf = _typeMap[newGuid];
        if (tbf == null) {
          tbf = tmp.clone();
          if (tbf == null) return null;
          tbf.innerTypeGuid0 = sps[1];
          tbf.innerTypeGuid1 = sps[2];
          tbf.guid = newGuid;
          _typeMap[newGuid] = tbf;
        }
        return tbf;
      }
      return res;
    }

    var tb = _typeMap[guid];
    if (tb == null) return null;
    if (tb.innerTypeCount == null || tb.innerTypeCount <= 0) return tb;
    var newGuid = "$guid:${fieldInfo.innerTypeGuid0}:${fieldInfo.innerTypeGuid1}";

    var tbf = _typeMap[newGuid];
    if (tbf == null) {
      tbf = tb.clone();
      if (tbf == null) return null;
      tbf.innerTypeGuid0 = fieldInfo.innerTypeGuid0;
      tbf.innerTypeGuid1 = fieldInfo.innerTypeGuid1;
      tbf.guid = newGuid;
      _typeMap[newGuid] = tbf;
    }

    return tbf;
  }

  static SSFieldType? getFieldTypeByInnerType(String guid , String id1 , String id2) {
    var tb = _typeMap[guid];
    if (tb == null) return null;
    if (tb.innerTypeCount == null || tb.innerTypeCount <= 0) return tb;
    var count = guid.indexOf(":");
    if (count >=0) {
      guid = guid.substring(0, count);
    }
    var newGuid = "$guid:$id1:$id2";
    var tbf = _typeMap[newGuid];
    if (tbf == null) {
      tbf = tb.clone();
      if (tbf == null) return null;
      tbf.innerTypeGuid0 = id1;
      tbf.innerTypeGuid1 = id2;
      tbf.guid = newGuid;
      _typeMap[newGuid] = tbf;
    }

    return tbf;
  }

  @JsonKey(ignore: true)
  String exportFlag = "";

  static void registerFieldType(String guid , SSFieldType type){
    if (type.guid != guid) {
      type.guid = guid;
    }
    _typeMap[guid] = type;
  }

  static void unregisterFieldType(String guid){
    _typeMap.remove(guid);
  }
  // ignore: non_constant_identifier_names
//  static int FIELD_FLAG_BASE = 0x1;
  // ignore: non_constant_identifier_names
  static int FIELD_FLAG_CONTAINER = 1;

  // ignore: non_constant_identifier_names
  static int FIELD_FLAG_KEY = 2;
  static int FIELD_FLAG_VARIABLE_LENGTH = 4;
  static int FIELD_FLAG_NO_SCRIPT_FIELD = 8; //脚本变量
  static int FIELD_FLAG_NO_OT_FIELD = 16; //对象表变量
  static int FIELD_FLAG_NO_COMP_FIELD = 32; //组件变量
  static int FIELD_FLAG_NO_NODE_FIELD = 64; //node变量
  static int FIELD_FLAG_PARAM = 128;   //参数类型变量
  static int FIELD_FLAG_HIDEN = 1024;
  static int FIELD_FLAG_REF = 512;
  static int FIELD_NO_DEFAULT = 2048;
  static int FIELD_FLAG_ARRAY_ELEMENT = 4096;
  static int FIELD_FLAG_UNION = 4096<<1;
//  static int FIELD_FLAG_VALUE = 0x4;

  static void initSystemType(){
    registerFieldType("___int___" , SSInt()..typeGroup ="基本"..name = "Int"..cname="int"..alias = "整数"..priority=512..flag=(FIELD_FLAG_KEY|FIELD_FLAG_ARRAY_ELEMENT|FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___intarray___" , SSIntArray()..typeGroup ="数组"..name = "IntArray"..cname="intarr"..alias = "整数数组"..priority=512..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_NODE_FIELD|FIELD_FLAG_ARRAY_ELEMENT|FIELD_FLAG_UNION));
    registerFieldType("___uint___" , SSUInt()..typeGroup ="基本"..name = "UInt"..cname="uint"..alias = "正整数"..priority=512..flag=(FIELD_FLAG_KEY|FIELD_FLAG_ARRAY_ELEMENT|FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___float___" , SSFloat()..typeGroup ="基本"..name = "Float"..cname="float"..alias = "浮点数"..priority=513..flag=(FIELD_FLAG_ARRAY_ELEMENT|FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___double___" , SSDouble()..typeGroup ="基本"..name = "Double"..cname="double"..alias = "双精浮点数"..priority=513..flag=(FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___string___" , SSString()..typeGroup ="基本"..name = "String"..cname="string"..alias = "字符串"..priority=514..flag=(FIELD_FLAG_KEY|FIELD_FLAG_VARIABLE_LENGTH|FIELD_FLAG_ARRAY_ELEMENT|FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___bool___" , SSBool()..typeGroup ="基本"..name = "Bool"..cname="bool"..alias = "布尔值"..priority=515..flag=(FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___group___" , SSGroup()..typeGroup ="基本"..name = "Group"..cname="group"..alias = "组"..priority=516..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_OT_FIELD));
    registerFieldType("___script___" , SSScript()..typeGroup ="脚本引用"..name = "Script"..cname="script"..alias = "脚本"..priority=516..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___name_script___" , SSNameScript()..typeGroup ="脚本引用"..name = "NameScript"..cname="NameScript"..alias = "脚本名"..priority=516..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_COMP_FIELD));
    // registerFieldType("___agent___" , SSAgentData()..group ="基本"..name = "Agent"..cname="agent"..alias = "Agent数据"..priority=517..flag=(FIELD_FLAG_NO_SCRIPT_FIELD));
    registerFieldType("___vector3___" , SSVector3()..typeGroup ="向量"..name = "Vector3"..cname="Vector3"..alias = "三维向量"..priority=520..flag=(FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___vector3d___" , SSVector3d()..typeGroup ="向量"..name = "Vector3d"..cname="Vector3d"..alias = "双精三维向量"..priority=520..flag=(0));
    registerFieldType("___vector2___" , SSVector2()..typeGroup ="向量"..name = "Vector2"..cname="Vector2"..alias = "二维向量"..priority=522..flag=(FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    registerFieldType("___vector2d___" , SSVector2d()..typeGroup ="向量"..name = "Vector2d"..cname="Vector2d"..alias = "双精二维向量"..priority=522..flag=(0));
    registerFieldType("___dvector2___" , SSDVector2()..typeGroup ="向量"..name = "DVector2"..cname="DVector2"..alias = "(ML)双精二维向量"..priority=522..flag=(0));
    registerFieldType("___quaternion___" , SSQuaternion()..typeGroup ="向量"..name = "Quaternion"..cname="Quaternion"..alias = "四元数"..priority=524..flag=(0));
    registerFieldType("___rect___" , SSRect()..typeGroup ="向量"..name = "Rect"..cname="Rect"..alias = "矩形"..priority=524..flag=(0));
    registerFieldType("___function___" , SSFunction()..typeGroup ="基本"..name = "Function"..cname="Func"..alias = "函数"..priority=526..flag=(FIELD_FLAG_NO_NODE_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_OT_FIELD|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___agentfunction___" , SSAgentFunction()..typeGroup ="基本"..name = "AgentFunction"..cname="AgentFunc"..alias = "Agent函数"..priority=526..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_OT_FIELD|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___agentvar___" , SSAgentVar()..typeGroup ="基本"..name = "AgentVar"..cname="AVar"..alias = "黑板变量"..priority=528..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_OT_FIELD|FIELD_NO_DEFAULT|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___scriptvar___" , SSScriptVar()..typeGroup ="变量"..name = "ScriptVar"..cname="SVar"..alias = "脚本变量"..priority=529..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_OT_FIELD|FIELD_FLAG_NO_COMP_FIELD|FIELD_NO_DEFAULT|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___globalscriptvar___" , SSGlobalScriptVar()..typeGroup ="变量"..name = "GlobalScriptVar"..cname="SVar"..alias = "全局脚本变量(行为树)"..priority=529..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_OT_FIELD|FIELD_FLAG_NO_COMP_FIELD|FIELD_NO_DEFAULT|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___union___" , SSUnion()..typeGroup ="基本"..name = "Union"..cname="Union"..alias = "变体"..priority=530..flag=(FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_OT_FIELD|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___color___" , SSColor()..typeGroup ="基本"..name = "Color"..cname="Color"..alias = "颜色"..priority=531..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD));
    registerFieldType("___list___" , SSList()..typeGroup ="容器"..name = "List"..cname="List"..alias = "数组列表"..priority=518..innerTypeCount=1..flag=(FIELD_FLAG_CONTAINER|FIELD_FLAG_VARIABLE_LENGTH|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_PARAM));
    registerFieldType("___map___" , SSMap()..typeGroup ="容器"..name = "Map"..cname="Dictionary"..alias = "字典"..priority=519..innerTypeCount=2..flag=(FIELD_FLAG_CONTAINER|FIELD_FLAG_VARIABLE_LENGTH|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_PARAM));
    registerFieldType("___objref___" , FTObjectReference()..typeGroup ="对象引用"..name = "ref"..alias = "对象引用"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_COMP_FIELD));
    registerFieldType("___space_objref___" , FTStringSpaceObjectReference()..typeGroup ="对象引用"..name = "ssref"..alias = "空间对象引用"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_OT_FIELD));
    registerFieldType("___id_space_objref___" , FTIdSpaceObjectReference()..typeGroup ="对象引用"..name = "isref"..alias = "空间对象引用[Id]"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_OT_FIELD));
    //这是新类型对应c# Microsoft.MathLibs.Math.FP
    registerFieldType("___ms_xna_fp___", SSMXFP()..typeGroup="基本"..name="FP"..cname="Microsoft.MathLibs.Math.FP"..alias="定点数"..priority=513..flag=(FIELD_FLAG_ARRAY_ELEMENT|FIELD_FLAG_UNION|FIELD_FLAG_PARAM));
    // 暂时移除
    // registerFieldType("___dobjref___" , FTDynamicObjectReference()..name = "dref"..alias = "动态类型对象引用"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD));

    // excel 数组移除
    // registerFieldType("___earr___" , SSExcelArray()..name = "earr"..cname="Array"..alias = "excel数组"..priority=518..innerTypeCount=1..flag=(FIELD_FLAG_CONTAINER|FIELD_FLAG_VARIABLE_LENGTH|FIELD_FLAG_NO_SCRIPT_FIELD));
    // registerFieldType("___earr2d___" , SSExcelArray2D()..name = "earr2d"..cname="Array2D"..alias = "excel数组2D"..priority=518..innerTypeCount=1..flag=(FIELD_FLAG_CONTAINER|FIELD_FLAG_VARIABLE_LENGTH|FIELD_FLAG_NO_SCRIPT_FIELD));

    registerFieldType("___image___" , SSImage()..typeGroup ="资源"..name = "Image"..cname="image"..alias = "图片"..priority=512..innerTypeCount=1..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_NODE_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_ARRAY_ELEMENT));
    registerFieldType("___intrange___" , SSIntRange()..typeGroup ="基本"..name = "IntRange"..cname="int"..alias = "整形范围"..priority=512..innerTypeCount=2..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_ARRAY_ELEMENT));

    registerFieldType("___scene___" , SSScene()..typeGroup ="资源"..name = "Scene"..cname="Scene"..alias = "场景"..priority=512..innerTypeCount=0..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_ARRAY_ELEMENT));
    registerFieldType("___ml_skill___" , SSMLSkill()..typeGroup ="资源"..name = "MLSkill"..cname="MLSkill"..alias = "技能[ML]"..priority=512..innerTypeCount=0..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_ARRAY_ELEMENT));
    registerFieldType("___tilemap___" , SSTileMap()..typeGroup ="资源"..name = "TileMap"..cname="TileMap"..alias = "地图"..priority=512..innerTypeCount=0..flag=(FIELD_FLAG_NO_COMP_FIELD|FIELD_FLAG_NO_SCRIPT_FIELD|FIELD_FLAG_ARRAY_ELEMENT));
  }

//  static void initSystemTypeForOT(){
//    registerFieldType("___int___" , SSInt()..name = "Int"..alias = "整数"..priority=512..flag=(FIELD_FLAG_KEY));
//    registerFieldType("___float___" , SSFloat()..name = "Float"..alias = "浮点数"..priority=513..flag=(0));
//    registerFieldType("___string___" , SSString()..name = "String"..alias = "字符串"..priority=514..flag=(FIELD_FLAG_KEY|FIELD_FLAG_VARIABLE_LENGTH));
//    registerFieldType("___bool___" , SSBool()..name = "Bool"..alias = "布尔值"..priority=515..flag=(0));
//    registerFieldType("___script___" , SSScript()..name = "Script"..alias = "脚本"..priority=516..flag=(0));
//    registerFieldType("___agent___" , SSAgentData()..name = "Agent"..alias = "Agent数据"..priority=517..flag=(0));
//    registerFieldType("___vector3___" , SSVector3()..name = "Vector3"..alias = "Vector3"..priority=520..flag=(0));
//    registerFieldType("___color___" , SSColor()..name = "Color"..alias = "颜色"..priority=521..flag=(0));
//    registerFieldType("___list___" , SSList()..name = "List"..alias = "数组列表"..priority=518..innerTypeCount=1..flag=(FIELD_FLAG_CONTAINER|FIELD_FLAG_VARIABLE_LENGTH));
//    registerFieldType("___map___" , SSMap()..name = "Map"..alias = "字典"..priority=519..innerTypeCount=2..flag=(FIELD_FLAG_CONTAINER|FIELD_FLAG_VARIABLE_LENGTH));
//  }
  Widget getIcon(){
    return Container();
  }

  @override
  Widget getTypeShowWidget({SSFieldType? fieldType , FunctionStringCallback? onChange}){
    return Row(
      children: [
        Expanded(child:Text(getTypeShowString() , overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
//    return Text(getTypeShowString() , overflow: TextOverflow.clip,maxLines: 1,);
  }
  Widget getDefaultEditWidget(bool bIsEdit , initValue , onChanged , onSubmitted , {Widget? showInfo,bool bOpen = false, FunctionBoolCallback? onVisible , EditorLevelInfo? levelInfo , BuildContext? context} ){
    // return Text(parseValue(initValue).toString());
    var edt = bIsEdit?getEditWidget(
        initValue,
        (v){
          onChanged?.call(v);
        }, (v){
          onSubmitted?.call(v);
        },
      context: context
    ).widget:getValueLabelWidget(initValue);

    return edt;
  }
  EditorHolder getEditWidget(initValue , onChanged , onSubmitted , {Widget? showInfo,bool bOpen = false, FunctionBoolCallback? onVisible , EditorLevelInfo? levelInfo , BuildContext? context} ){
    return EditorHolder()..widget = const Text("need impl") .. height = SSDefines.nodeFieldRowHeight;
  }

  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget? showInfo,bool bOpen = false, FunctionBoolCallback? onVisible , EditorLevelInfo? levelInfo , BuildContext? context} ){
    return EditorHolder()..widget = const Text("need impl") .. height = SSDefines.nodeFieldRowHeight;
  }

  EditorHolder getCellEditWidget(initValue , onChanged , onSubmitted ,{ Widget? showInfo , FunctionDynamicCallback? onExtraEdit}){
    return getEditWidget(initValue , onChanged , onSubmitted);
  }

  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo? gci , BuildContext? context}){
    return EditorHolder()..widget = Container();
  }


  Widget getValueLabelWidget(initValue , {TextStyle? style}){
    return Text(parseValue(initValue).toString() , style: style);
  }

  dynamic parseValue(value){
    return null;
  }

  dynamic createObject({dynamic para}){
    return null;
  }
  void deleteObject(dynamic val , {dynamic para}){

  }

  dynamic parseString(value){
    return null;
  }

  dynamic parseShortShowName(value){
    return "$value";
  }

  dynamic parseFinalValue(value){
    return value;
  }

  String getExportType(){
    return name;
  }

  String? syncSerialize(dynamic value){
    return null;
  }

  dynamic syncDeserialize(String serStr){
    return null;
  }

  dynamic getExportDefault(dynamic defaultValue){
    var dv = parseValue(defaultValue);
    dv  = parseFinalValue(dv);
    return dv;
  }


  SSFieldType();
  //此处与类名一致，由指令自动生成代码
  factory SSFieldType.fromJson(Map<String, dynamic> json) =>
      _$SSFieldTypeFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSFieldTypeToJson(this);

  void export(ByteDataWriter bw, v ,{Map? prms}) {
    // print(name);
    throw UnimplementedError();
  }

  dynamic exportValue(v) {
    throw UnimplementedError();
  }

  getBytesCount(){
    return 4;
  }

  String getFilterString(v) {
    // print(name);
    return "$v";
  }

  EdgeInsets getCanvasEditPadding(){
    return EdgeInsets.fromLTRB(0,0,0,0);
  }

  Color? getCanvasEditBgColor(){
    // var colorContent = CommonUtil.changeColorLightness(Color(0x7F666666),0.3);//clz.color);
    // return colorContent;
    // return Colors.black;
    return null;
  }

  getExportInfo({Map<String,dynamic>? extra}){

    var inner1 ;
    var inner2 ;
    if (innerTypeCount != null){
      if (innerTypeCount>=1){
        var tp1 = SSFieldType.getFieldType(innerTypeGuid0);
        if (tp1!= null) {
          inner1 = tp1.getExportInfo();
        }
        else{
          var clz = ObjectClazz.getClazz(innerTypeGuid0);
          if (clz != null) {
            inner1 = clz.exportInfo();
          }
        }
      }

      if (innerTypeCount>=2){
        var tp2 = SSFieldType.getFieldType(innerTypeGuid1);
        if (tp2!=null) {
          inner2 = tp2.getExportInfo();
        }
        else{
          var clz = ObjectClazz.getClazz(innerTypeGuid1);
          if (clz != null) {
            inner2 = clz.exportInfo();
          }
        }
      }
    }
    // res["fullName"] = DartCommon.isEmpty(namespace)?name:"$namespace.$name";
    var vals = {
      'id' : exportId,
      'name': name,

      "cname":cname,
      'alias': alias,
      'guid': guid,
      'innerType1':inner1,
      'innerType2':inner2,
      'isEnum' : this is SSEnumType,
      'isObject' : this is BehavicAgentClass && (!((this as BehavicAgentClass).isStruct??false)),
    };
    vals.addAll(extra??{});

    var exportType = ExportMappingConfig.instance!.mappingFieldName(name , vals);
    vals['exportType'] = exportType;
    vals['exportTypeFirstUpper'] = exportType.substring(0,1).toUpperCase() + exportType.substring(1);
    vals['fullName'] = exportType;
    var binaryReader = ExportMappingConfig.instance!.mappingBinaryReader(name , vals);
    vals['binaryReader'] = binaryReader;
    return vals;
  }

  clone(){
    return null;
  }

  double getListItemHeight({GridCellInfo? gci}) {
    return 32 ;
  }

  dynamic getTagValue(dynamic v) {
    return  parseValue(v);
  }

  bool useComment() {
    return false;
  }

  dynamic otParseValue(v) {
    return parseValue(v);
  }

  dynamic otImportValue(v) {
    return parseValue(v);
  }


//  @override
//  exportInfo() {
//    // TODO: implement exportInfo
//    throw UnimplementedError();
//  }
}

class GridCellInfo{
  bool isObjectTableMode = false;
  String name = "";
  FieldInfo? fieldInfo;
  AObject? object;
  bool isObjectTableEditMode = false;
}