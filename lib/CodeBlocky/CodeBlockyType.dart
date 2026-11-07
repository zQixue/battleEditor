
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBBehavicAgentMethodInvoke.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBBehavicAgentVar.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFreeCallMethod.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeAgentSet.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeArithmetic.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeBool.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeComment.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeCondition.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeConditionExpr.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeConstBool.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeConstDouble.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeConstFloat.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeConstInt.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeConstUInt.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeDoWhile.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeEnum.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeExpr.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeFor.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeIf.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeInt2Double.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeLog.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeLogic.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeMathFunc.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeMinus.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeNot.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeNull.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeParam.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeReturn.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeSetVar.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeVar.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeVector2.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeVector3.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeWhile.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';

// part 'CodeBlockyType.g.dart';

// @JsonSerializable()
class CodeBlockyType extends SSObjBase{
  static const baseRowHeight = 32.0;
  static const baseRowHeightAdd = 40.0;
  static const baseInterval = 2.0;
  static const baseSplitWidth = 14.0;
  static const basePadding = EdgeInsets.fromLTRB(4, 4 , 4, 4);
  static const baseTextStyle = TextStyle(color: Colors.indigo , fontSize: 14, fontWeight: FontWeight.w600);
  @JsonKey(ignore: true)
  int flag = 0;

  static int FIELD_FLAG_FUNC = 1;
  static int FIELD_FLAG_AGENT_FUNC = 2;
  static int FIELD_FLAG_FREE_AGENT_FUNC = 2;


  static bool isTypeError(CodeBlocky blk , String? targetType){
    if (targetType == null) return false;
    var tp = blk.getFullTypeWithExtra();
    if (tp != null && tp!=targetType) return true;
    return false;
  }

  static bool isObjectTypeValid(String? a , String? b){
    if (a == null || b == null) return true;
    if (a == b) return true;
    if (a == "obj" && b.indexOf("BObj.") == 0) return true;
    if (b == "obj" && a.indexOf("BObj.") == 0) return true;

    return false;
  }

  int? typeFlag ;

  Color _bgColor = Colors.grey ;
  void setDefaultColor(Color clr){
    _bgColor = clr;
  }
  @JsonKey(ignore:true)
  Color get bgColor => _bgColor ;
  Map<String,dynamic> tempValues = Map<String,dynamic> ();

  Widget getBlockWidget(CodeBlocky blocky , String? targetType , CBFunction func){
    print("getBlockWidget NOT impl");
    return Container(child : Center(child : Text("$guid")));
  }

  Widget doGetBlockWidget(CodeBlocky blocky , String? targetType , CBFunction func){

    var con = getBlockWidget(blocky , targetType , func);//Container(child : Center(child : Text("$guid")));
    // return Row(
    //   children: [
    //     con,
    //     IconButton(
    //       icon: Icon(MaterialCommunityIcons.account_box_outline),
    //     ),
    //   ],
    // );
    return InkWell(
      onDoubleTap: (){
        // print("------- taped");
        var ncb = CodeBlocky();
        ncb.copy(blocky);
        StateScriptProject.instance!.shareCodeBlockyTemplates!.addBlocky(ncb);
      },
      child: con,
    );
  }
  static Map<String , CodeBlockyType> _blockTypes = Map<String , CodeBlockyType>();
  static void registerBlockyType(CodeBlockyType tp){
    _blockTypes[tp.guid] = tp;
  }
  static Map<String , CodeBlockyType> getTypes(){
    return _blockTypes;
  }
  String? getBlockyType(CodeBlocky blk){
    return null;
  }

  BehavicAgentClass? getStructType(CodeBlocky blk){
    return null;
  }

  static String? templateData;
  void tryLoadTemplateData(){
    if (templateData != null){
//      return ;
    }

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var tempPath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance!.currentExportConfig!.templatePath, basePath: basePath);
    var tempDir = PathUtil.join(tempPath , "funccode","funccode.temp");
    templateData = File(tempDir).readAsStringSync();
  }

  String exportFuncCode(CodeBlocky blk,{dynamic tag = 0}){
    tryLoadTemplateData();
    var funcInfo = getExportFuncInfo(blk , tag:tag);
    final context = Context.create();

    context.variables.addAll(funcInfo);
    context.variables["type"] = guid;
    final template = Template.parse(context, Source.fromString(templateData!));
    var outCode = (template.render(context));
    outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\n",multiLine:true), "");
//    outCode = outCode.replaceAll(new RegExp(r"^\s*\n",multiLine:true), "");
//    print("${blk.blockyTypeId} : $outCode");
    return outCode;
  }

  String exportBehavicFuncCode(CodeBlocky blk,{dynamic tag = 0}){
    return getExportBehavicFuncInfo(blk , tag:tag);
  }

  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    print(name);
    throw UnimplementedError();
  }

  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    throw UnimplementedError();
  }
  static int doCompile(CodeBlocky? blk , String? targetType , ByteDataWriter bw , List<String> errLst , CBFunction func){
    var tp = CodeBlockyType.getType(blk!.blockyTypeId);

    if (blk == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode!.exportId} , ${tp!.getTypeShowString()} 未设置的 block ${func.getTypeShowString()}");
      return 0;
    }
    // if (!CodeBlockyType.isObjectTypeValid(targetType, tp. isTypeError(blk,targetType)){
    if (!CodeBlockyType.isObjectTypeValid(targetType,blk.getFullTypeWithExtra())){
      errLst.add("结点 ${StateScriptNode.crtExportNode!.exportId} , ${tp!.getTypeShowString()} 类型不匹配 期望 ${targetType} blocky id: [${blk.guid}] 当前类型:${blk.getFullTypeWithExtra()} ");
      return 0;
    }

    return tp!.compile(blk,targetType,bw,errLst,func);
  }

  int compile(CodeBlocky blk , String? targetType , ByteDataWriter bw , List<String> errLst , CBFunction func){
    throw Exception("compile 未实现");
  }

  int compileRef(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst , CBFunction func){
    throw Exception("compileRef 未实现");
  }

  // 操作
  static final OP_ASSIGN_BAVAR = 100;
  static final OP_PUSH_BAVAR = 200;
  static final OP_CALL_FUNC = 300;
  static final OP_PUSH_FUNCID = 400;
  static final OP_ADD = 1000;
  static final OP_SUB = 1100;
  static final OP_MUL = 1200;
  static final OP_FDIV = 1300;
  static final OP_DIV = 1400;
  static final OP_MOD = 1500;

  static final OP_GREATER = 2000;
  static final OP_GE = 2100;
  static final OP_LESS = 2200;
  static final OP_LE = 2300;
  static final OP_EQUAL = 2400;
  static final OP_NOT_EQUAL = 2500;



  static final OP_PUSH = 3000;
  static final OP_POP = 3100;
  static final OP_AND = 4000;
  static final OP_OR = 4100;
  static final OP_AND_SKIP = 4400;
  static final OP_OR_SKIP = 4500;
  static final OP_MINUS = 5000;
  static final OP_I2D = 5100;
  static final OP_NOT = 6000;
  static final OP_CON_JUMP = 7000;
  static final OP_JUMP = 7001;
  static final OP_PUSH_NULL = 8000;

  static final OP_ASSIGN_SSVAR = 9000;
  static final OP_PUSH_SSVAR = 9100;

  static final OP_LOG = 9900;
  static final OP_RETURN= 19998;
  // static final OP_PUSH_V3 = 7000;
  // static final OP_PUSH_V2 = 8000;
  static final OP_EOF = 19999;

  static Map<String , int> ovmOperates = {
    "AssignVar" : OP_ASSIGN_BAVAR ,
    "PushVar" : OP_PUSH_BAVAR ,
    "CallFunc" : OP_CALL_FUNC ,
    "PushFuncId" : OP_PUSH_FUNCID ,
    "Add" : OP_ADD ,
    "Sub" : OP_SUB ,
    "Mul" : OP_MUL ,
    "FDiv" : OP_FDIV ,
    "Div" : OP_DIV ,
    "Mod" : OP_MOD ,
    "Greater" : OP_GREATER ,
    "GE" : OP_GE ,
    "Less" : OP_LESS ,
    "LE" : OP_LE ,
    "Equal" : OP_EQUAL ,
    "NotEqual" : OP_NOT_EQUAL ,
    "Push" : OP_PUSH,
    "Pop" : OP_POP,
    "And" : OP_AND,
    "Or" : OP_OR,
    "AndSkip" : OP_AND_SKIP,
    "OrSkip" : OP_OR_SKIP,
    "Minus" : OP_MINUS,
    "i2f" : OP_I2D,
    "Not" : OP_NOT,
    "ConJump" : OP_CON_JUMP,
    "Jump" : OP_JUMP,
    "PushNull" : OP_PUSH_NULL,
    "AssignScriptVar" : OP_ASSIGN_SSVAR ,
    "PushScriptVar" : OP_PUSH_SSVAR ,
    "Log" : OP_LOG ,
    "Return" : OP_RETURN ,
  };

  static Map<String , List<String>> ovmOperands = {
    "AssignVar" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj","struct"] ,
    "PushVar" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj","struct"] ,
    "CallFunc" : [] ,
    "PushFuncId" : [] ,
    "Add" : ["int", "uint","float","double","long","ulong","Vector3","Vector2"] ,
    "Sub" : ["int", "uint","float","double","long","ulong","Vector3","Vector2"] ,
    "Mul" : ["int", "uint","float","double","long","ulong" ,] ,
    "FDiv" : ["int", "uint","float","double","long","ulong",] ,
    "Div" : ["int", "uint","long","ulong"] ,
    "Mod" : ["int", "uint","long","ulong"] ,
    "Greater" : ["int", "uint","float","double","long","ulong"] ,
    "GE" : ["int", "uint","float","double","long","ulong"] ,
    "Less" : ["int", "uint","float","double","long","ulong"] ,
    "LE" : ["int", "uint","float","double","long","ulong"] ,
    "Equal" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj","struct"]  ,
    "NotEqual" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj","struct"]  ,
    "Push" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj","struct"],
    "Pop" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj","struct"],
    "And" : [],
    "Or" : [],
    "AndSkip" : [],
    "OrSkip" : [],
    "Minus" : ["int", "uint","float","double","long","Vector3","Vector2"],
    "i2f" : ["int", "uint"],
    "Not" : [],
    "ConJump" : [],
    "Jump" : [],
    "PushNull":[],
    "AssignScriptVar" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj"] ,
    "PushScriptVar" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj"] ,
    "Log" : ["int", "uint","float","double","long","ulong","bool","Vector3","Vector2","enum","obj"] ,
    "Return" : [] ,
  };


  static void registerBlockyTypes(){
    registerBlockyType(CBTypeVar()..guid="___var___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeParam()..guid="___param___"..flag = FIELD_FLAG_FUNC);
    registerBlockyType(CBTypeSetVar()..guid="___setVar___"..flag = FIELD_FLAG_FUNC);
    registerBlockyType(CBTypeIf()..guid="___if___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeFor()..guid="___for___"..flag = FIELD_FLAG_FUNC);
    registerBlockyType(CBTypeWhile()..guid="___while___"..flag = FIELD_FLAG_FUNC);
    registerBlockyType(CBTypeDoWhile()..guid="___do_while___"..flag = FIELD_FLAG_FUNC);
    registerBlockyType(CBTypeBool()..guid="___bool___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeCondition()..guid="___condition___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeConditionExpr()..guid="___conditionexpr___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeLogic()..guid="___logic___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeNot()..guid="___not___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeArithmetic()..guid="___arithmetic___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeMinus()..guid="___minus___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeInt2Double()..guid="___i2f___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);

    registerBlockyType(CBTypeMathFunc()..guid="___math___"..flag = FIELD_FLAG_FUNC);

    registerBlockyType(CBTypeConstInt()..guid="___constint___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeConstUInt()..guid="___constuint___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeConstFloat()..guid="___constfloat___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeConstDouble()..guid="___constdouble___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeConstBool()..guid="___constbool___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeNull()..guid="___constnull___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeVector3()..guid="___vector3___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeVector2()..guid="___vector2___"..flag = FIELD_FLAG_FUNC|FIELD_FLAG_AGENT_FUNC);

    registerBlockyType(CBTypeReturn()..guid="___return___"..flag = FIELD_FLAG_FUNC);
    registerBlockyType(CBBehavicAgentVar()..guid="___bavar___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBBehavicAgentMethodInvoke()..guid="___bamethod___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeExpr()..guid="___expr___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeAgentSet()..guid="___agent_set___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeLog()..guid="___log___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeEnum()..guid="___enum___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBFreeCallMethod()..guid="___freecall___"..flag = FIELD_FLAG_AGENT_FUNC);
    registerBlockyType(CBTypeComment()..guid="___comment___"..flag = FIELD_FLAG_AGENT_FUNC);












  }

  static CodeBlockyType? getType(String id){
    return _blockTypes[id];
  }
  // CodeBlockyType();
  // //此处与类名一致，由指令自动生成代码
  // factory CodeBlockyType.fromJson(Map<String, dynamic> json) =>
  //     _$CodeBlockyTypeFromJson(json);
  //
  // //此处与类名一致，由指令自动生成代码
  // Map<String, dynamic> toJson() => _$CodeBlockyTypeToJson(this);

}