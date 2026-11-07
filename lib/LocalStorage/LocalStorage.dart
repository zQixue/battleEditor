//@dart=2.11
import 'dart:convert';


import 'package:path/path.dart' as PathUtil;
import 'dart:io';

import 'package:battlepus/common/GlobalDoard.dart';
class LocalStorage
{
//  static Box _localStorage ;
//  static Future init() async{
//
//    var path = GlobalBoard.getWorkingPath();//Directory.current.path;
//    print("working path : $path" );
//    _localStorage = await Hive.openBox('battlepusdb' , path :path);
//  }
//
//  static Box get instance => _localStorage;


  static Map<String, dynamic> loadJson(String name){
    var path = GlobalBoard.getWorkingPath();
    var jsonPath = PathUtil.join(path,"save",name + ".json");
    var f = File(jsonPath);
    if (f.existsSync()){
      JsonDecoder decoder = JsonDecoder();
      Map userMap = jsonDecode(f.readAsStringSync());
      return userMap;
    }

    return null;
  }

  static void saveJson(String name , dynamic obj){

    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(obj);

    var path = PathUtil.join(GlobalBoard.getWorkingPath(),"save");//, name+".json");
    var d = Directory(path);
    if (!d.existsSync()) d.createSync();
    var f = File(PathUtil.join(path,name+".json"));
    f.writeAsStringSync(json);
  }

  static void saveJsonTpPath(String path ,String name, dynamic obj){

    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(obj);

    var d = Directory(path);
    if (!d.existsSync()) d.createSync();
    var f = File(PathUtil.join(path,name+".json"));
    f.writeAsStringSync(json);
  }

  static Map<String, dynamic> loadJsonFromPath(String path , String name){

    var jsonPath = PathUtil.join(path , name + ".json");
    var f = File(jsonPath);
    if (f.existsSync()){
//      JsonDecoder decoder = JsonDecoder();
      Map userMap = jsonDecode(f.readAsStringSync(encoding : utf8));
      return userMap;
    }

    return null;
  }
}