
import 'dart:convert';
import 'dart:io';

import 'package:lpinyin/lpinyin.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyList.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSStorage.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;
part 'CBFunction.g.dart';

@JsonSerializable()
class CBFunction extends SSObjBase {

  // @JsonKey(defaultValue: <CodeBlocky>[])
//  @JsonKey(ignore: true)
//  List<CodeBlocky> _blockies;
  @JsonKey(ignore: true)
  BlockyList? _blockiesList;

  @JsonKey(ignore: true)
  BlockyList? _binList;

  @JsonKey(defaultValue: <FieldInfo>[])
  List<FieldInfo> localFields = <FieldInfo>[];

  @JsonKey(defaultValue: <FieldInfo>[])
  List<FieldInfo> params = <FieldInfo>[];
  @JsonKey(defaultValue: true)
  bool active = true;

  @JsonKey(ignore: true)
  HistoryManager? history;

  @JsonKey(defaultValue : false)
  bool isAgent = false;
  @JsonKey(ignore: true)
  String? extraParam ;

  void copy(CBFunction tgt){
    active = tgt.active;
    params = tgt.params;
    localFields = tgt.localFields;
    _binList = tgt._binList;
    _blockiesList = tgt._blockiesList;
  }

  @override
  BlockyList? getBlockiesList(){
    if (_blockiesList == null){
      load();
    }
    return _blockiesList;
  }

  String getBlockBehavicCode(){
    if (_blockiesList == null){
      load();
    }
    var code = _blockiesList!.getBehavicCode(breakLine: true);
    return code;
  }

  void setBlockiesList(BlockyList? lst){
    _blockiesList = lst;
  }


  BlockyList? getBinList(){
    if (_binList == null){
      load();
    }
    return _binList;
  }

  void setBinList(BlockyList lst){
    _binList = lst;
  }

  void load(){
    if (_blockiesList != null) return;
    // var dir = SSStorage.getFunctionsStorePath();
    // var jm = SSStorage.loadJson("$guid" , root: dir.path);
    var filePath = SSStorage.globalGuid2FilePaths[guid];
    var jm = filePath != null?jsonDecode(File(filePath).readAsStringSync()):null;
    if (jm != null){
      var bd = BlockyList.fromJson(jm);
      _blockiesList = bd;
    }
    else{
      _blockiesList = BlockyList();
    }
    // print("###1");
    var blockies = _blockiesList?.getBlockies();
    for(var i = blockies!.length -1;i>=0;--i){
      if ( CodeBlockyType.getType(blockies[i].blockyTypeId)==null){
        blockies.removeAt(i);
      }
    }

    // var jmBin = SSStorage.loadJson("$guid-bin" , root: dir.path);
    var binFilePath = SSStorage.globalGuid2FilePaths["$guid-bin"];
    var jmBin = binFilePath != null?jsonDecode(File(binFilePath).readAsStringSync()):null;
    if (jmBin != null){
      var bd = BlockyList.fromJson(jmBin);
      _binList = bd;
    }
    else{
      _binList = BlockyList();
    }
    // print("###2");
    var blockiesBin = _binList!.getBlockies();
    for(var i = blockiesBin!.length -1;i>=0;--i){
      if ( CodeBlockyType.getType(blockiesBin[i].blockyTypeId)==null){
        blockiesBin.removeAt(i);
      }
    }
  }
  // int getOperateExtraType(String tp){
  //   var eid = CodeBlocky.operateExtras[tp];
  //   if (eid != null) return eid;
  //   if (tp.startsWith("Enum.")){
  //     return CodeBlocky.operateExtras["enum"];
  //   }
  //   if (tp.startsWith("BObj.")){
  //     return CodeBlocky.operateExtras["obj"];
  //   }
  //   return -1;
  // }
  void compile(ByteDataWriter bw , List<String> errLst){
    var blockies = _blockiesList!.getBlockies();
    if (blockies!.length > 0) {
      // var tp = CodeBlockyType.getType(blockies[0].blockyTypeId);
      // for(var b in blockies) {
      for(var i = 0 ; i < blockies.length ; ++i) {
        var b = blockies[i];
        CodeBlockyType.doCompile(b, null, bw, errLst, this);

        if (i<blockies.length-1){
          if (b.blockyTypeId == "___expr___"){
            errLst.add("结点 ${StateScriptNode.crtExportNode!.exportId} , 检测到return之后不可能执行到的代码");
            return ;
          }
        }
      }
    }

    bw.writeUint16(CodeBlockyType.OP_EOF  , "代码终止");
  }

  void save(String? scriptGuid){
    if (_blockiesList == null) return;
    var path = SSStorage.getFunctionsStorePath()!.path;

    var si = ScriptInfo.current!;
    if (si.moduleGuid.isNotEmpty){
      var sm = StateScriptProject.instance!.scriptModules![si.moduleGuid];
      if (sm != null){
        var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
        // var realGroupPath = si.group;
        path = PathUtil.join(basePath, sm.savePath, "functions",si.group);
      }
    }

    if (scriptGuid != null){
      var rPath = PathUtil.join(path , scriptGuid , "$guid.json");
      SSStorage.checkDeleteOldPathFile(guid, rPath);
      var newPath = PathUtil.join(path , scriptGuid);
      if (newPath != null && !Directory(newPath).existsSync()) Directory(newPath).createSync(recursive: true);
      SSStorage.saveJson("$guid", _blockiesList, root: newPath);

      SSStorage.globalGuid2FilePaths[guid] = rPath;
    }
    else {
      var savePath = SSStorage.globalGuid2FilePaths[guid];
      if (savePath != null){
        SSStorage.saveJson("$guid", _blockiesList, root: PathUtil.dirname(savePath));
      }
      else {
        SSStorage.saveJson("$guid", _blockiesList, root: path);
        SSStorage.globalGuid2FilePaths[guid] = PathUtil.join(path , "$guid.json");
      }
    }



    if (_binList == null) return;
    if (scriptGuid != null){
      var rPath = PathUtil.join(path , scriptGuid , "$guid-bin.json");
      SSStorage.checkDeleteOldPathFile("$guid-bin", rPath);

      var newPath = PathUtil.join(path , scriptGuid);
      if (newPath != null && !Directory(newPath).existsSync()) Directory(newPath).createSync(recursive: true);
      SSStorage.saveJson("$guid-bin", _binList, root: newPath);

      SSStorage.globalGuid2FilePaths["$guid-bin"] = rPath;
    }
    else {
      var savePath = SSStorage.globalGuid2FilePaths["$guid-bin"];
      if (savePath != null){
        SSStorage.saveJson("$guid-bin", _binList, root: PathUtil.dirname(savePath));
      }
      else {
        SSStorage.saveJson("$guid-bin", _binList, root: path);
        SSStorage.globalGuid2FilePaths[guid] = PathUtil.join(path , "$guid-bin");
      }
    }
  }

  void delete(){
    // var dir = SSStorage.getFunctionsStorePath();
    // SSStorage.deleteJson("$guid"  , root: dir.path);
    // SSStorage.deleteJson("$guid-bin"  , root: dir.path);
    var dir = SSStorage.globalGuid2FilePaths[guid];
    if (dir != null && File(dir).existsSync()){
      File(dir).deleteSync();
    }

    dir = SSStorage.globalGuid2FilePaths["$guid-bin"];
    if (dir != null && File(dir).existsSync()){
      File(dir).deleteSync();
    }
  }

//  @JsonKey(ignore: true)
//  Map<String , CodeBlocky> _id2Blockies ;

//  void initBlockyMap(){
//    if (_id2Blockies == null) _id2Blockies = Map<String , CodeBlocky>();
//    _id2Blockies.clear();
//    _blockies.forEach((blk) { _id2Blockies[blk.guid] = blk; });
//  }
  @override
  String getTypeShowString(){
    if (alias != null && alias != "") return alias;
    if (name != null && name != "") return name;
    return guid.substring(0,8);
  }
  
//  CodeBlocky getBlockyByGuid(String guid){
//    if (_id2Blockies == null) initBlockyMap();
//    return _id2Blockies[guid];
//  }

//  @override
//  void addBlocky(CodeBlocky blocky){
////    CodeBlocky ext = getBlockyByGuid(blocky.guid);
////    if (ext != null) return ;
////
////    _blockies.add(blocky);
////    _id2Blockies[blocky.guid] = blocky;
//
//    if (_blockies == null){
//      _blockies = new List<CodeBlocky>();
//    }
//
//    if (blocky.container != null){
//      blocky.container.removeBlocky(blocky);
//    }
//    blocky.container = this;
//    _blockies.add(blocky);
////    _id2Blockies[blocky.guid] = blocky;
//  }

//  @override
//  void removeBlocky(CodeBlocky blocky){
////    CodeBlocky ext = getBlockyByGuid(blocky.guid);
////    if (ext == null) return ;
////
////    _blockies.remove(blocky);
////    _id2Blockies.remove(blocky.guid);
//    if (_blockies == null){
//      return;
//    }
//    int iIndex = _blockies.indexOf(blocky);
//    if (iIndex>=0) {
//      blocky.container = null;
//      _blockies.removeAt(iIndex);
////      _id2Blockies.remove(blocky.guid);
//    }
//  }

  CBFunction();
  //此处与类名一致，由指令自动生成代码
  factory CBFunction.fromJson(Map<String, dynamic> json) =>
      _$CBFunctionFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$CBFunctionToJson(this);

  FieldInfo addField() {
    FieldInfo n = FieldInfo();
    localFields.add(n);
    return n;
  }

  void removeField(FieldInfo f) {
    localFields.remove(f);
  }

  FieldInfo? getLocalField(fiGuid) {
    for(var fi in localFields){
      if (fi.guid == fiGuid){
        return fi;
      }
    }
    return null;
  }
  String getSearchKey() {
    if (name == "" || name == null){
      return "$guid";
    }
    var pinyin1 = PinyinHelper.getShortPinyin(name);
    var pinyin2 = PinyinHelper.getPinyin(name);
    return "${pinyin1}_${pinyin2}_${exportId}_${name}_$guid";
  }

  getShowName(){
    return "$name";
  }

  CBFunction clone(ScriptInfo newScript){
    var inFunc = this;
    var newfunc = CBFunction();
    newfunc.params = inFunc.params;
    newfunc.localFields = inFunc.localFields;
    newfunc.isAgent = inFunc.isAgent;
    newfunc.active = inFunc.active;

    newfunc.setBlockiesList(inFunc.getBlockiesList());
    newfunc.save(newScript.guid);


    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(newfunc);
    JsonDecoder dec = JsonDecoder();
    newfunc = CBFunction.fromJson(dec.convert(json));
    newfunc.load();

    return newfunc;
  }
//  @override
//  CodeBlocky getBlocky(int iIndex) {
//    // TODO: implement getBlocky
//    throw UnimplementedError();
//  }
//
//  @override
//  void setBlocky(int iIndex, CodeBlocky val) {
//    // TODO: implement setBlocky
//    throw UnimplementedError();
//  }


  // loadBlockies(jsonData) {
  //   List<CodeBlocky> blks = List<CodeBlocky>();
  //   if (jsonData == null) return blks;
  //
  //   for(var b in jsonData){
  //     var blk = CodeBlocky.fromJson(b);
  //     blks.add(blk);
  //     _id2Blockies[blk.guid] = blk;
  //   }
  //
  // }
}