//@dart=2.11
 
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;
class SSStorage{
  static Map<String, dynamic> loadJson(String name , {String root}){
    if (root == null) root = SSMainSetting.instance.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var jsonPath = PathUtil.join(path,name + ".json");
    print("json --- $jsonPath");
    var f = File(jsonPath);
    if (f.existsSync()){
//      JsonDecoder decoder = JsonDecoder();
      Map userMap = jsonDecode(f.readAsStringSync());
      return userMap;
    }

    return null;
  }
  static void deleteJson(String name , {String root}){
    if (root == null) root = SSMainSetting.instance.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);
    if (path ==null || !Directory(path).existsSync()){
      return ;
    }
    path = PathUtil.join(path, name+".json");
    var f = File(path);
    if(f.existsSync()){
      f.deleteSync();
    }
  }
  // static Directory getFunctionsStorePath(){
  //   var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
  //   if (path ==null || !Directory(path).existsSync()){
  //     return null;
  //   }
  //   var scriptPath = PathUtil.join(path, "functions");
  //   var dir = Directory(scriptPath);
  //   if (!dir.existsSync())dir.createSync(recursive: true);
  //
  //   return dir;
  // }
  static void saveJson(String name , dynamic obj , {String root}){
    if (root == null) root = SSMainSetting.instance.workingPath;
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(obj);
    var path = GlobalBoard.getCorrectDirectory(root);
    if (path ==null || !Directory(path).existsSync()){
      return ;
    }
    path = PathUtil.join(path, name+".json");
    var f = File(path);
    f.writeAsStringSync(json);
  }
  static Directory getFunctionsStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "functions");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }
  static Directory getScriptStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "scripts");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getNodeStructStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "structs");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getEnumStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "enums");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getBehavicStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "behavics");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getComponentStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "components");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getScriptInfoStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "scriptInfos");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getStorePathByName(String name){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, name);
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getGlobalVarStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "vars");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getAgentStorePath(){
    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "agents");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static String getScriptFile(String name){
    // var path = getScriptStorePath().path;

    return globalGuid2FilePaths[name];
    // var realPath = PathUtil.join(path , group);
    // if (!Directory(realPath).existsSync()) return null;
    // var scriptFilePath = PathUtil.join(path, name + ".json");
    // var f = File(scriptFilePath);
    // if (f.existsSync()){
    //   return f.path;
    // }
    //
    // return null;
  }

  static void deleteScriptFile(String guidKey , String groupPath , ScriptInfo script , String scriptName){
    {
      groupPath = groupPath??"";
      if (!StateScriptProject.instance.groupSave) groupPath = "";
      var path = getScriptStorePath().path;
      var realGroupPath = PathUtil.join(path, groupPath);
      // if (!Directory(realGroupPath).existsSync()){
      //   Directory(realGroupPath).createSync(recursive: true);
      // }
      var scriptFilePath = PathUtil.join(realGroupPath, guidKey + ".json");
      if (StateScriptProject.instance.addNameToFilePath) {
        scriptFilePath = PathUtil.join(realGroupPath, "${scriptName}_${guidKey}.json"); //guidKey + ".json");
      }
      var f = File(scriptFilePath);
      if (f.existsSync()) {
        f.deleteSync();
      }
    }
    {
      var path = getScriptInfoStorePath().path;
      var scriptFilePath = PathUtil.join(path, guidKey + ".json");
      var f = File(scriptFilePath);
      if (f.existsSync()) {
        f.deleteSync();
      }
    }

    {
      var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
      var bep = StateScriptProject.instance.byteExportPath;
      GlobalBoard.tryCreateDirectory(bep, basePath: basePath);
      var bytePath = GlobalBoard.getCorrectDirectory(bep, basePath: basePath);
      var fpath = PathUtil.join(bytePath, "${script.name}.bytes");
      if (!DartCommon.isEmpty(script.specialExportPath)){
        var exPath = PathUtil.canonicalize(PathUtil.join(basePath ,  script.specialExportPath));//GlobalBoard.getCorrectDirectory(s.specialExportPath, basePath: basePath);
        // print("basePath = $basePath , specialExportPath = ${script.specialExportPath} ->$exPath");
        fpath = PathUtil.join(exPath ,  "${script.name}.bytes");
        // // var exPath = PathUtil.join(bytePath, s.exportPath);
        // if (!Directory(exPath).existsSync()){
        //   Directory(exPath).createSync(recursive: true);
        // }
      }
      if(File(fpath).existsSync()){
        File(fpath).deleteSync();
      }
    }

  }

  static Map<String,String> globalGuid2FilePaths = Map<String,String>();
  static void clearGlobalGuid2FilePaths(){
    if (bImportOtherProject) return ;
    globalGuid2FilePaths.clear();
  }

  static bool bImportOtherProject = false;

  static void loadFilePathAt(String rootPath){
    if (bImportOtherProject) return ;
    var dir = Directory(rootPath);
    if (!dir.existsSync()) return ;
    var files = dir.listSync(recursive: true);
    for(var f in files){
      if (f is File){
        var name = PathUtil.basenameWithoutExtension(f.path);
        if (name.length>36){
          if(!name.endsWith("-bin")){
            name = name.substring(name.length - 36);
          }
        }
        if (globalGuid2FilePaths.containsKey(name)){
          // BotToast.showText(text: "重复的文件名\n${f.path}\n${globalGuid2FilePaths[name]}");
          throw Exception("重复的文件名\n${f.path}\n${globalGuid2FilePaths[name]}\n请保证文件唯一");
        }
        globalGuid2FilePaths[name] = f.path;
      }
    }
  }
  static void registerFilePath(String id , String path){
    if (bImportOtherProject) return ;
    if (id == null) return ;
    globalGuid2FilePaths[id] = path;
  }

  static void checkDeleteOldPathFile(String id , String newPath){
    var existPath = globalGuid2FilePaths[id];
    if (existPath!= null && File(existPath).existsSync()){

      if (PathUtil.canonicalize(existPath) != PathUtil.canonicalize(newPath)){
        File(existPath).deleteSync();
        BotToast.showText(text: "保存路径变化\n文件 $existPath 已移除\n替换为 $newPath");
      }
    }
  }

  static void tryCreateDir(String newPath){
    var path = PathUtil.dirname(newPath);
    if (!Directory(path).existsSync()){
      Directory(path).createSync(recursive: true);
    }
  }

  static String getGroupScriptSavePath(String name , String groupPath , String scriptName, ScriptInfo si){
    groupPath = groupPath??"";
    if (!StateScriptProject.instance.groupSave) groupPath = "";
    var path = getScriptStorePath().path;

    if (si.moduleGuid.isNotEmpty){
      var sm = StateScriptProject.instance.scriptModules[si.moduleGuid];
      if (sm != null){
        var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
        path = PathUtil.join(basePath, sm.savePath , "scripts");
      }
    }

    var realGroupPath = PathUtil.join(path, groupPath);

    var scriptFilePath = PathUtil.join(realGroupPath, name + ".json");
    if (StateScriptProject.instance.addNameToFilePath) {
      scriptFilePath = PathUtil.join(realGroupPath, "${scriptName}_${name}.json"); //name + ".json");
    }
    return scriptFilePath;
  }

  static void saveScriptFile(String guidKey , String groupPath , StateScript script , String scriptName , ScriptInfo si){
    groupPath = groupPath??"";
    if (!StateScriptProject.instance.groupSave) groupPath = "";
    var path = getScriptStorePath().path;
    if (si.moduleGuid.isNotEmpty){
      var sm = StateScriptProject.instance.scriptModules[si.moduleGuid];
      if (sm != null){
        var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
        path = PathUtil.join(basePath, sm.savePath, "scripts");
      }
    }
    var realGroupPath = PathUtil.join(path, groupPath);
    if (!Directory(realGroupPath).existsSync()){
      Directory(realGroupPath).createSync(recursive: true);
    }
    var scriptFilePath = PathUtil.join(realGroupPath, guidKey + ".json");
    if (StateScriptProject.instance.addNameToFilePath) {
      scriptFilePath = PathUtil.join(realGroupPath, "${scriptName}_${guidKey}.json"); //guidKey + ".json");
    }
    // var scriptFilePath = PathUtil.join(realGroupPath, guidKey + ".json");

    checkDeleteOldPathFile(guidKey , scriptFilePath);

    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(script);

    var f = File(scriptFilePath);
    f.writeAsStringSync(json);
    registerFilePath(guidKey , scriptFilePath);
    //

    return null;
  }

  static StateScript loadOrCreate(String name , String group ,ScriptInfo si){
    group = group??"";
    if (!StateScriptProject.instance.groupSave) group = "";
    var fp = getScriptFile(name);
    if (fp == null){
      StateScriptProject.cancelWatchProject();
      var res = new StateScript();
      saveScriptFile(name , group , res , "NoName" ,si);
      StateScriptProject.doWatchProject();
      return res;
    }

//    JsonDecoder decoder = JsonDecoder();
    Map m = jsonDecode(File(fp).readAsStringSync());
    var res =StateScript.fromJson(m);
    SSObjBase.buildExportId(res.nodes);
    res.loadSubScripts(name);

    res.initConnectionCount();
    res.buildScriptGroupNodes();
    res.buildNodePositions();
    // registerFilePath(name,fp);
    return res;
  }
}