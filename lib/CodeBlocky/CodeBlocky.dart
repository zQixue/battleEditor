
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyContainer.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyList.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/EventCenter.dart';
part 'CodeBlocky.g.dart';

@JsonSerializable()
class CodeBlocky extends SSObjBase implements IBlockyContainer{

  static CBFunction? curentFunction;
  @JsonKey(defaultValue: "")
  String blockyTypeId="";

  @JsonKey(ignore: true)
  bool readonlyFlag = false;
  @JsonKey(ignore: true)
  bool freeFunctionFlag = false;

  @JsonKey(defaultValue: <String,CodeBlocky>{})
  Map<String,CodeBlocky> subBlockies = Map<String , CodeBlocky> ();

  @JsonKey(defaultValue: <String,dynamic>{})
  Map<String,dynamic> values = Map<String,dynamic> ();

  @JsonKey(defaultValue: <String,BlockyList>{})
  Map<String , BlockyList?>? blockyBodys;

  BlockyList? getCreateBody({String key = "default"}){
    if (blockyBodys == null){
      blockyBodys = Map<String,BlockyList>();
    }
//    while (index>=blockyBodys.length){
//      blockyBodys.add(BlockyList());
//    }
    if (blockyBodys![key] == null) blockyBodys![key] = BlockyList();
    return blockyBodys![key];
  }

  void removeBody({String key = "default"}){
    blockyBodys!.remove(key);
  }

  String? getFullTypeWithExtra(){
    var tp = CodeBlockyType.getType(blockyTypeId);
    return tp!.getBlockyType(this);
  }

  BehavicAgentClass? getStructType(){
    var tp = CodeBlockyType.getType(blockyTypeId);
    return tp!.getStructType(this);
  }



  static Map<String,int> operateExtras = {
    "int":0,
    "uint":1,
    "float":2,
    "double":3,
    "long":4,
    "ulong":5,
    "short":6,
    "ushort":7,
    "boolean":8,
    "bool":8,
    // "void":9,
    "Vector3":10,
    "Vector2":11,
    "enum":20,
    "obj":21,
    "struct":22
  };

  int? getOperateExtraType(){
    var tp = getFullTypeWithExtra()??"";
    var eid = operateExtras[tp];
    if (eid != null) return eid;
    if (tp.startsWith("Enum.")){
      return operateExtras["enum"];
    }
    if (tp.startsWith("BObj.")){
      return operateExtras["obj"];
    }
    if (tp.startsWith("BStruct.")){
      return operateExtras["struct"];
    }

    return null;
  }



  @JsonKey(ignore: true)
  IBlockyContainer? container;

  void checkRemove(){

  }
  @override
  bool isParentOf(CodeBlocky cb){
    if (blockyBodys == null) return false;
    for(var bl in blockyBodys!.values) {
      if (bl == null)
        continue;
      // print("###3");
      // print(StackTrace.current);
      var blks = bl.getBlockies();
      if (blks!.contains(cb)) {
        return true;
      }
      for(var sb in blks){
        var ipo = sb.isParentOf(cb);
        if (ipo) return true;
      }
    }

    return false;
  }

  @override
  CodeBlocky? getBlocky(String key){
    if (subBlockies == null){
      subBlockies = new Map<String , CodeBlocky>();
    }
//    while (iIndex>=subBlockies.length){
//      subBlockies.add(null);
//    }
//    if (subBlockies[key] == null) subBlockies[key] = null;
    var res = subBlockies[key];
    if (res != null) res.container = this;
    return res;
  }

  String getBlockyCode(String key){
    var cb = getBlocky(key);
    if (cb == null) return "INVALID";
    return cb.getExportCode();
  }

  String getBlockyBehavicCode(String key){
    var cb = getBlocky(key);
    if (cb == null) return "INVALID";
    return cb.getBehavicCode();
  }

  @override
  void setBlocky(String key , CodeBlocky val){
    if (subBlockies == null){
      subBlockies = new Map<String , CodeBlocky>();
    }
//    while (iIndex>=subBlockies.length){
//      subBlockies.add(null);
//    }

    if (subBlockies[key] == val) return;

    if (val.container != null){
      val.container!.removeBlocky(val);
    }
    val.container = this;
    subBlockies[key] = val;
    EventCenter.eventBus.fire(BlockContainerRefresh()..container = this);
  }

  Widget getBlockWidget(CBFunction func , {String? targetType} ){
    var tp = CodeBlockyType.getType(blockyTypeId);
    if (tp == null){
      return Text("无效的 blocky 类型");
    }

    return tp.doGetBlockWidget(this , targetType ,func);
  }

  CodeBlocky();
  //此处与类名一致，由指令自动生成代码
  factory CodeBlocky.fromJson(Map<String, dynamic> json) =>
      _$CodeBlockyFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$CodeBlockyToJson(this);

  @override
  void addBlocky(CodeBlocky val) {
    throw UnimplementedError();
//    if (subBlockies == null){
//      subBlockies = new List<CodeBlocky>();
//    }
//
//    if (val.container != null){
//      val.container.removeBlocky(val);
//    }
//    val.container = this;
//    subBlockies.add(val);
  }

  @override
  void removeBlocky(CodeBlocky val) {
//    throw UnimplementedError();
    if (subBlockies == null){
      return;
    }
//    int iIndex = subBlockies.re(val);
    subBlockies.removeWhere((key, value) {
      if (value == val){
        val.container = null;
        EventCenter.eventBus.fire(BlockContainerRefresh()..container = this);
        return true;
      }
      return false;
    });
//    if (iIndex>=0) {
//      // print("remove");
//      val.container = null;
//      subBlockies[iIndex] = null;
//      EventCenter.eventBus.fire(BlockContainerRefresh()..container = this);
//    }
  }

  @override
  List<CodeBlocky> getBlockies() {
    // TODO: implement getBlockies
    throw UnimplementedError();
  }

  String getExportCode({dynamic tag = 0}){
    var tp = CodeBlockyType.getType(blockyTypeId);
    var code = tp!.exportFuncCode(this,tag : tag);
    return code;
  }

  String getBehavicCode({dynamic tag = 0}){
    var tp = CodeBlockyType.getType(blockyTypeId);
    var code = tp!.exportBehavicFuncCode(this,tag : tag);
    return code;
  }

  void copy2(CodeBlocky cb) {
    blockyTypeId = cb.blockyTypeId;
    values.addAll(cb.values);

    subBlockies.addAll(cb.subBlockies);
    if (cb.blockyBodys != null) {
      blockyBodys = Map<String , BlockyList>();
      blockyBodys!.addAll(cb.blockyBodys!);
    }
  }

  void copy(CodeBlocky cb) {
    blockyTypeId = cb.blockyTypeId;
    values.addAll(cb.values);

    if (cb.subBlockies != null){
      subBlockies = Map<String,CodeBlocky>();
      for(var sb in cb.subBlockies.keys){
        var csb = CodeBlocky();
        csb.copy(cb.subBlockies[sb]!);
        subBlockies[sb] = csb;
      }
    }
    // subBlockies.addAll(cb.subBlockies);
    if (cb.blockyBodys != null) {
      blockyBodys = Map<String , BlockyList>();
      if (cb.blockyBodys!= null){
        for (var key in cb.blockyBodys!.keys){
          var blk = cb.blockyBodys![key];
          if (blk == null) continue;
          var sblk = BlockyList();

          if (blk.blockies != null){
            sblk.blockies = <CodeBlocky>[];
            for(var sb in blk.blockies!){
              var csb = CodeBlocky();
              csb.copy(sb);
              sblk.blockies!.add(csb);
            }
          }

          blockyBodys![key] = sblk;
        }

      }

      // blockyBodys.addAll(cb.blockyBodys);
    }
  }

}