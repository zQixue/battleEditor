//@dart=2.11

import 'dart:convert';
import 'dart:io';

 

import 'package:bot_toast/bot_toast.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;
class OTStorage{
  static Map<String, dynamic> loadJson(String name , {String root}){
    if (root == null) root = ObjectTableSetting.instance.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var jsonPath = PathUtil.join(path,name + ".json");
    var f = File(jsonPath);
    if (f.existsSync()){
//      JsonDecoder decoder = JsonDecoder();
      Map userMap = jsonDecode(f.readAsStringSync());
      return userMap;
    }

    return null;
  }

  static void saveJson(String name , dynamic obj , {String root}){
    if (root == null) root = ObjectTableSetting.instance.workingPath;
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
        if (name.length>36) name = name.substring(name.length - 36);
        if (globalGuid2FilePaths.containsKey(name)){
          // BotToast.showText(text: "重复的文件名\n${f.path}\n${globalGuid2FilePaths[name]}");
          throw Exception("重复的文件名\n${f.path}\n${globalGuid2FilePaths[name]}\n请保证文件唯一");
        }
        globalGuid2FilePaths[name] = f.path;
      }
    }
  }

  static void tryCreateDir(String newPath){
    var path = PathUtil.dirname(newPath);
    if (!Directory(path).existsSync()){
      Directory(path).createSync(recursive: true);
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
  static Directory getClazzStorePath(){
    var path = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "classes");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getEnumStorePath(){
    var path = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "enums");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static Directory getTableStorePath(){
    var path = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    if (path ==null || !Directory(path).existsSync()){
      return null;
    }
    var scriptPath = PathUtil.join(path, "tables");
    var dir = Directory(scriptPath);
    if (!dir.existsSync())dir.createSync(recursive: true);

    return dir;
  }

  static String getTableFile(String name){
    var path = getTableStorePath().path;
    var scriptFilePath = PathUtil.join(path, name + ".json");
    var f = File(scriptFilePath);
    if (f.existsSync()){
      return f.path;
    }

    return null;
  }

//  static void saveScriptFile(String name , StateScript script){
//    var path = getScriptStorePath().path;
//    var scriptFilePath = PathUtil.join(path, name + ".json");
//
//    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
//    String json = encoder.convert(script);
//
//    var f = File(scriptFilePath);
//    f.writeAsStringSync(json);
//
//    return null;
//  }
//
//  static StateScript loadOrCreate(String name){
//    var fp = getScriptFile(name);
//    if (fp == null){
//      var res = new StateScript();
//      saveScriptFile(name , res);
//      return res;
//    }
//
////    JsonDecoder decoder = JsonDecoder();
//    Map m = jsonDecode(File(fp).readAsStringSync());
//    var res =StateScript.fromJson(m);
//    return res;
//  }
}