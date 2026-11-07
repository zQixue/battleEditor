 
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iso/iso.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/OTStorage.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/OTExportConfig.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Logger.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/log_list_page_view.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';

part 'ObjectTableProject.g.dart';

@JsonSerializable()
class ObjectTableProject {

  @JsonKey(ignore:true)
  List<ObjectClazz> clazzes = <ObjectClazz>[];

//  @JsonKey(
//      defaultValue: <ScriptInfo>[])
//  List<ScriptInfo> scripts = List<ScriptInfo>(
//  );
//
  @JsonKey(ignore:true)
  List<SSEnumType> enums = <SSEnumType>[];
//
//  @JsonKey(
//      defaultValue: <SSAgent>[])
//  List<SSAgent> agents = List<SSAgent>(
//  );

//  SSAgent addAgent() {
//    var agent = SSAgent(
//    );
//    agents.add(
//        agent);
//    return agent;
//  }
//
//  void removeAgent(SSAgent agent) {
//    agents.remove(
//        agent);
//  }

//  @JsonKey(
//      defaultValue: <SSComponent>[])
//  List<SSComponent> components = List<SSComponent>(
//  );

//  SSComponent addComponent() {
//    var com = SSComponent(
//    );
//    components.add(
//        com);
//    return com;
//  }
//
//  void removeComponent(SSComponent com) {
//    components.remove(
//        com);
//  }

  // @JsonKey(defaultValue: "")
  // String nodeCodeExportPath;

  @JsonKey(defaultValue: true)
  bool csExport = true;
  @JsonKey(defaultValue: false)
  bool luaExport = false;
  @JsonKey(defaultValue: false)
  bool cppExport = false;

  @JsonKey(defaultValue: "")
  String? csCodeExportPath;

  @JsonKey(defaultValue: "")
  String? csTemplatePath;

  @JsonKey(defaultValue: "")
  String? cppCodeExportPath;

  @JsonKey(defaultValue: "")
  String? cppTemplatePath;

  @JsonKey(defaultValue: "")
  String? luaCodeExportPath;

  @JsonKey(defaultValue: "")
  String? luaTemplatePath;

  @JsonKey(defaultValue: "")
  String? byteExportPath;

  @JsonKey(defaultValue: false)
  bool groupSave = false;

  @JsonKey(defaultValue: false)
  bool useNewExportConfig = false;

  @JsonKey(fromJson: parseMainConfig)
  OTExportConfig mainExportConfig = OTExportConfig();

  @JsonKey(defaultValue: <OTExportConfig>[])
  List<OTExportConfig>? otExportConfigs = <OTExportConfig>[];

  void registerEnumTypes() {
    for (var e in enums) {
      SSFieldType.registerFieldType(
          e.guid, e..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD..typeGroup = "枚举");
    }
  }

  SSEnumType addEnum() {
    SSEnumType tmp = new SSEnumType(
    );
    enums.add(
        tmp);
    SSFieldType.registerFieldType(
        tmp.guid, tmp..typeGroup = "枚举");
    return tmp;
  }

  void removeEnum(SSEnumType item) {
    enums.remove(
        item);
    SSFieldType.unregisterFieldType(
        item.guid);
  }

  Map<String , List<ObjectClazz> > getClazzGroups(){
    var res = Map<String , List<ObjectClazz> >();

    for(var ns in clazzes){
      var lst = res[ns.group];
      if (lst == null){
        lst = <ObjectClazz>[];
        res[ns.group] = lst;
      }
      lst.add(ns);
    }

    res.forEach((key, value) {
      value.sort((a,b)=>a.name.compareTo(b.name));
    });
    return res;
  }

  @JsonKey(
      ignore: true)
  Map<String, ObjectClazz>? _clazzMap;

  Map<String, ObjectClazz>? get clazzMap {
    if (_clazzMap == null) {
      refreshClazzMap();
    }
    return _clazzMap;
  }

  void refreshClazzMap() {
    _clazzMap = new Map<String, ObjectClazz>();
    for (var s in clazzes) {
      _clazzMap![s.guid] = s;
    }
  }

//  /// 脚本
//  ///
//  Map<String, List<ScriptInfo>> getScriptGroups() {
//    var res = Map<String, List<ScriptInfo>>(
//    );
//
//    for (var ns in scripts) {
//      ns.group = ns.group ?? "";
//      var lst = res[ns.group];
//      if (lst == null) {
//        lst = List<ScriptInfo>(
//        );
//        res[ns.group] = lst;
//      }
//      lst.add(
//          ns);
//    }
//
//    res.forEach(
//            (key, value) {
//          value.sort(
//                  (a, b) =>
//                  a.name.compareTo(
//                      b.name));
//        });
//    return res;
//  }

//  ScriptInfo addScript() {
//    var n = ScriptInfo(
//    );
//    scripts.add(
//        n);
//    return n;
//  }
//
//  void deleteScript(ScriptInfo script) {
//    if (scripts.contains(
//        script)) {
//      scripts.remove(
//          script);
//    }
//  }

//  /// 结点
//  ///
//  Map<String, List<NodeStructData>> getStructGroups() {
//    var res = Map<String, List<NodeStructData>>(
//    );
//
//    for (var ns in clazzes) {
//      var lst = res[ns.group];
//      if (lst == null) {
//        lst = List<NodeStructData>(
//        );
//        res[ns.group] = lst;
//      }
//      lst.add(
//          ns);
//    }
//
//    res.forEach(
//            (key, value) {
//          value.sort(
//                  (a, b) =>
//                  a.name.compareTo(
//                      b.name));
//        });
//    return res;
//  }

  ObjectClazz addClazz() {
    var n = ObjectClazz(
    );
    clazzes.add(
        n);
    ObjectClazz.registerClazz(n);
    return n;
  }

  void deleteClazz(ObjectClazz nodeType) {
    if (clazzes.contains(
        nodeType)) {
      clazzes.remove(
          nodeType);
      ObjectClazz.unregisterClazz(nodeType);
    }
  }


  ObjectTableProject();

  //此处与类名一致，由指令自动生成代码
  factory ObjectTableProject.fromJson(Map<String, dynamic> json) =>
      _$ObjectTableProjectFromJson(
          json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() =>
      _$ObjectTableProjectToJson(
          this);


  static ObjectTableProject? parse(String file) {
    var jm = OTStorage.loadJson(file);
    if (jm != null) return ObjectTableProject.fromJson(jm);

    return null;
  }

  Widget getSaveCheckResultView(List<String> result ,BuildContext context){
    var ws = <Widget>[];
    var dc = new BoxDecoration(
      border: Border(
        top: Divider.createBorderSide(context, color: CommonUtil.alphaColorD(Colors.grey , 0.3), width: 1),
      ),
    ); // 圆角度
    for(var s in result){
      var txt = Container(
        decoration: dc,
        child: Text(s , style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12),),
      );
      ws.add(txt);
    }
    var lst = ListView(
      children: ws,
    );
    return ThemeCenter.block(headTitle: "对象表检查告警" , child: Container(padding: EdgeInsets.all(4),
      child: lst,
    ),);

    return CommonUtil.getWidgetBlock("对象表检查告警", CommonUtil.scaleColor(Colors.red,0.5),
        Container(padding: EdgeInsets.all(4),

          child: lst,
        ),
        null , actions: null);
  }
  void prepareExport({List<int>? enumExistsHashs}){
    SSObjBase.buildHashExportId(enums);
    for(var e in enums){
      // SSObjBase.buildExportId(e.items);
      e.buildItemId();
    }
    SSObjBase.buildHashExportId(clazzes);

    List<AObject> all = <AObject>[];
    ObjectClazz.clazzes.forEach((key, value) {
      all.addAll(value.table?.objects??[]);
    });
    SSObjBase.buildHashExportId(all);
  }

  static bool checkShowLog(Logger err , {BuildContext? context}){
    if (err.iErrorCount > 0 || err.iWarningCount > 0){
      var filaPath = saveError("ot_log",err);
      showDialog(
        context: context!,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          var child = Container(
            padding: EdgeInsets.all(0),
            width: 1200,
            height: 800,
            child:LogListPageView(logger: err,savePath: filaPath,),
          );
          return Dialog(child: child);
        },
      );

      return true;
    }

    return false;
  }
  void clearPath(Directory dir){
    if (dir == null) return ;
    var files = dir.listSync(recursive: true);
    for(var f in files){
      if (f is File) {
        f.deleteSync();
      }
    }
  }
  void saveAllClazzes(){
    var path = OTStorage.getClazzStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in clazzes){
      SSObjBase.buildFieldHashDataIdWithExist(s.fields , s.dataHashs);
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      if (groupSave) {
        var group = s.group.trim();
        savePath = DartCommon.isEmpty(group) ? PathUtil.join(path.path, "${s.guid}.json") : PathUtil.join(path.path, group, "${s.guid}.json");
        OTStorage.tryCreateDir(savePath);
      }
      OTStorage.checkDeleteOldPathFile(s.guid, savePath);
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }
  void saveAllEnums(){
    var path = OTStorage.getEnumStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in enums){
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      if (groupSave) {
        savePath = DartCommon.isEmpty(s.group) ? PathUtil.join(path.path, "${s.guid}.json") : PathUtil.join(path.path, s.group, "${s.guid}.json");
        OTStorage.tryCreateDir(savePath);

      }
      OTStorage.checkDeleteOldPathFile(s.guid, savePath);
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }
  void save({BuildContext? context , bool saveObject = false}) {
    prepareExport();
    saveAllClazzes();
    saveAllEnums();
    //todo 拆分 class 和 enum 保存
    OTStorage.saveJson("object_table_project", this);

    if (saveObject) {


      // //同步
      // if (!withPlugins()) {
      //   for (var clz in clazzes) {
      //     clz.save();
      //   }
      // }
      // else {
      //   if (!OTDefines.editMode) {
      //     TableImporter.export();
      //     if (context != null){
      //       var err = TableImporter.logger;
      //       checkShowLog(err , context: context,);
      //     }
      //   }
      // }
      if (context != null){
        var err = checkBeforeSave();
        if (checkShowLog(err , context: context)){
          // return;
        }
      }
      //异步
      CommonUtil.showProgress(CommonUtil.getGlobalContex());
      var prms = {
        "project" : ObjectTableProject.instance,
        "setting" : ObjectTableSetting.instance,
        "fileCache": OTStorage.globalGuid2FilePaths,
      };
      DartCommon.runIsolate(_save , prms , onDataOut: (dynamic data){
        //通信
        if (data["process"] != null){
          EventCenter.eventBus.fire(ProgressEvent()..info = data["process"]);
        }
        if (data["done"]??false){

          TableImporter.logger = data["errorLogger"];
          Navigator.pop(CommonUtil.getGlobalContex());

          Future.delayed(Duration(milliseconds: 20)).then((value) {
            var err = TableImporter.logger;
            if (!checkShowLog(err , context: CommonUtil.getGlobalContex(),)){
              BattlePusGlobal.broadcastToMain("ot_reload");
            }
          });



          // EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
      });
    }
  }

  static Future _save(IsoRunner iso) async {
    TableUtiles.iso = iso;

    iso.send({"process":"init system types",});
    SSFieldType.initSystemType();
    initExtraType();

    iso.send({"process":"load iso params",});
    var prms = DartCommon.getIsolateParams(iso);
    var prjSetting = prms["setting"] as ObjectTableSetting;
    var prj = prms["project"] as ObjectTableProject;
    ObjectTableSetting.setInstance(prjSetting);
    ObjectTableProject.setInstance(prj);
    // _instance = ObjectTableProject.parse("object_table_project");//LocalStorage.instance.get("setting") as Setting;
    _instance!.registerEnumTypes();
    OTStorage.globalGuid2FilePaths = prms["fileCache"];
    // TableImporter.logger = data["errorLogger"];


    for (var c in _instance!.clazzes) {
      ObjectClazz.registerClazz(c);
      c.registerObjects();
    }


    if (!withPlugins()) {

      for (var clz in prj.clazzes) {
        iso.send({"process":"save : ${clz.name}",});
        clz.save();
      }
    }
    else {
      if (!OTDefines.editMode) {

        for (var clz in prj.clazzes) {
          if (clz.forceExportBinary) {
            iso.send({"process":"save : ${clz.name}",});
            clz.save();
          }
        }

        iso.send({"process":"export original tables",});
        TableImporter.export();
        // if (context != null){
        //   var err = TableImporter.logger;
        //   checkShowLog(err , context: context,);
        // }
      }
    }

    iso.send({
      "done":true,
      // "project":_instance,
      // "fileCache": OTStorage.globalGuid2FilePaths,
      "errorLogger" : TableImporter.logger,
    });
//    _instance?.checkEmpty();
  }

  static String? saveError(String name , Logger errs , {String? root}){
    if (root == null) root = ObjectTableSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);
    if (path == null || !Directory(path).existsSync()){
      return null;
    }
    path = PathUtil.join(path, name+".txt");
    print("ot err save path : $path");
    var f = File(path);
    StringBuffer sb = StringBuffer();
    errs.logs.forEach((element) {
      var tp = element.type;
      var pMsg = (tp == LogType.error?"!!!ERROR!!!  ":(tp == LogType.warning?"!!!WARNING!!!  ":"  ")) + element.message;
      sb.write(pMsg);
      sb.write("\n");
    });
    f.writeAsStringSync(sb.toString());
    return path;
  }

  static bool isLoaded(){
    return _instance != null;
  }

  Logger checkBeforeSave(){
    // List<String> res = List<String>();
    var logger = Logger();
    Map<String,AObject> tagMapping = Map<String,AObject>();
    Map<int,AObject> guidMapping = Map<int,AObject>();

    if (_instance != null){
      for (var c in _instance!.clazzes) {
        for(var obj in c.table!.objects){
          if (obj.isComment!) continue;
          var clz = ObjectClazz.getClazz(obj.clazzGuid!);
          var sid = obj.getSearchID();
          if (tagMapping.containsKey(sid)){
            var existObj = tagMapping[sid];
            var existClz = ObjectClazz.getClazz(existObj!.clazzGuid!);

            logger.appendLog(LogType.error, "查询键 ${obj.getSearchIDKeys()} 重复 , type = ${existClz!.getTypeShowString()}\n\t${obj.getLogString()}\n\t已存在于 ${existObj.getLogString()}");
          }
          else{
            tagMapping[sid] = obj;
          }
          // var intGuid = obj.guid.hashCode;
          // if (guidMapping.containsKey(intGuid)){
          //   var existObj = guidMapping[intGuid];
          //   var existClz = ObjectClazz.getClazz(existObj.clazzGuid);
          //   res.add("重复的对象 [${clz.getTypeShowString()}].[$intGuid] , 已存在于 [${existClz.getTypeShowString()}].[$intGuid]");
          // }
          // else{
          //   guidMapping[intGuid] = obj;
          // }
          var allFields = clz!.getAllFields();
          for(var f in allFields!){
            // if (obj.isComment) continue;
            if (!f.allowEmpty){
              var v = obj.fieldValues[f.guid];
              if (v == null || v.value == null || v.value.toString().trim() == ""){
                var existClz = ObjectClazz.getClazz(obj.clazzGuid!);
                // logger.appendLog(LogType.error,"内容不能为空 ${clz.getTypeShowString()}.${obj.getLogString()}");
                logger.appendLog(LogType.error, "内容不能为空 ${f.getTypeShowString()} , type = ${existClz!.getTypeShowString()}\n\t${obj.getLogString()}");
              }
            }
            if (f.isRef){
              //检查重复
              var existClz = ObjectClazz.getClazz(obj.clazzGuid!);
              var sid = obj.getUniqueIDByField(f);
              if (sid == null){
                logger.appendLog(LogType.error, "单键 ${f.getTypeShowString()} 无效 , type = ${existClz!.getTypeShowString()}\n\t${obj.getLogString()}");
                continue;
              }
              if (tagMapping.containsKey(sid)){
                var existObj = tagMapping[sid];
                var existClz = ObjectClazz.getClazz(existObj!.clazzGuid!);

                logger.appendLog(LogType.error, "单键 ${f.getTypeShowString()} 重复 , type = ${existClz!.getTypeShowString()}\n\t${obj.getLogString()}\n\t已存在于 ${existObj.getLogString()}");
              }
              else{
                tagMapping[sid] = obj;
              }
            }
          }
        }
      }
    }
    return logger;
  }
  static bool? _withPlugins;
  static bool withPlugins(){
    if (_withPlugins == null){
      var wp = ObjectTableSetting.instance!.workingPath;
      var path = GlobalBoard.getCorrectDirectory(wp);
      if (!DartCommon.isEmpty(path)){
        var importer = PathUtil.join(path , "plugins/importer.lua");
        var exporter = PathUtil.join(path , "plugins/exporter.lua");
        _withPlugins = File(importer).existsSync() && File(exporter).existsSync();
      }
    }

    return _withPlugins??false;
  }

  void loadAllEnums(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "enums");
    if (!Directory(path).existsSync()) return ;

    OTStorage.loadFilePathAt(path);

    enums.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String,dynamic> userMap = jsonDecode(str);
        var s = SSEnumType.fromJson(userMap);
        enums.add(s);
      }
    }
  }

  void loadAllClasses(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;

    path = PathUtil.join(path , "classes");
    OTStorage.loadFilePathAt(path);
    if (!Directory(path).existsSync()) return ;
    clazzes.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        // print(f.path);
        // print(str);
        Map<String,dynamic> userMap = jsonDecode(str);
        var s = ObjectClazz.fromJson(userMap);
        clazzes.add(s);
      }
    }
  }

  static void load(){

    _instance = ObjectTableProject.parse("object_table_project");//LocalStorage.instance.get("setting") as Setting;
    OTStorage.clearGlobalGuid2FilePaths();

    var root = ObjectTableSetting.instance!.workingPath;//prjSetting.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    _instance?.loadAllEnums(path);
    _instance?.loadAllClasses(path);

    if (_instance != null) {
      for (var c in _instance!.clazzes) {
        ObjectClazz.registerClazz(c);
      }
      _instance!.registerEnumTypes();
    }

    tryLoadObjects();
  }

  static void loadSync(){

    _instance = ObjectTableProject.parse("object_table_project");//LocalStorage.instance.get("setting") as Setting;
    OTStorage.clearGlobalGuid2FilePaths();

    var root = ObjectTableSetting.instance!.workingPath;//prjSetting.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    _instance?.loadAllEnums(path);
    _instance?.loadAllClasses(path);

    if (_instance != null) {
      for (var c in _instance!.clazzes) {
        ObjectClazz.registerClazz(c);
      }
      _instance!.registerEnumTypes();
    }

    _load(null);
  }

  static void clearObjects(){
    for (var c in _instance!.clazzes) {
      c.clearTable();
    }

    ObjectClazz.allObjects.clear();
  }
  static void tryLoadObjects(){
    //异步
    CommonUtil.showProgress(CommonUtil.getGlobalContex());
    var prms = {
      "project" : ObjectTableProject.instance,
      "setting" : ObjectTableSetting.instance,
    };
    DartCommon.runIsolate(_load , prms , onDataOut: (dynamic data){
      //通信
      if (data["process"] != null){
        EventCenter.eventBus.fire(ProgressEvent()..info = data["process"]);
      }
      if (data["done"]??false){
        var prj = data["project"] as ObjectTableProject;
        OTStorage.globalGuid2FilePaths = data["fileCache"];
        TableImporter.logger = data["errorLogger"];
        ObjectTableProject.setInstance(prj);
        // _instance.registerEnumTypes();
        for (var c in _instance!.clazzes) {
          ObjectClazz.registerClazz(c);
          c.registerObjects();
        }
        Navigator.pop(CommonUtil.getGlobalContex());

        Future.delayed(Duration(milliseconds: 20)).then((value) {
          var err = TableImporter.logger;
          checkShowLog(err , context: CommonUtil.getGlobalContex(),);
        });
        // BotToast.showText(text: "查找完毕");
        EventCenter.eventBus.fire(GlobalRefreshEvent());
        EventCenter.eventBus.fire(ObjectTableLoadedEvent());


      }
    });
  }

  static void initExtraType(){
    SSFieldType.registerFieldType("___objref___" , FTObjectReference()..typeGroup = "对象引用"..name = "ref"..alias = "对象引用"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD));
  }

  static Future _load(IsoRunner? iso) async {
  // static void _load(IsoRunner ir){
    TableUtiles.iso = iso;
    SSFieldType.initSystemType();
    initExtraType();
    if (iso !=  null) {

      var prms = DartCommon.getIsolateParams(iso);
      var prjSetting = prms["setting"] as ObjectTableSetting;
      var prj = prms["project"] as ObjectTableProject;
      ObjectTableSetting.setInstance(prjSetting);
      ObjectTableProject.setInstance(prj);
    }


    OTStorage.clearGlobalGuid2FilePaths();

    // var root = ObjectTableSetting.instance.workingPath;//prjSetting.workingPath;
    // var path = GlobalBoard.getCorrectDirectory(root);
    //
    // _instance?.loadAllEnums(path);
    // _instance?.loadAllClasses(path);

    if (_instance != null) {
      for (var c in _instance!.clazzes) {
        ObjectClazz.registerClazz(c);
        // if (!withPlugins() || c.forceExportBinary) {
        //   c.load();
        // }
      }
      _instance!.registerEnumTypes();
    }
    if (withPlugins()) {
      TableImporter.import();
      // Future.delayed(Duration(milliseconds: 20)).then((value) {
      //   var err = TableImporter.logger;
      //   checkShowLog(err , context: CommonUtil.getGlobalContex(),);
      // });
    }
    if (_instance != null) {
      for (var c in _instance!.clazzes) {
        if (!withPlugins() || c.forceExportBinary) {
          // c.table!.clear();
          c.load();
        }
      }
      _instance!.registerEnumTypes();
    }

    ObjectClazz.allObjects.forEach((key, value) {
      value.buildSpaceObjectMap();
    });

    if (iso!= null) {
      iso.send({
        "done": true,
        "project": _instance,
        "fileCache": OTStorage.globalGuid2FilePaths,
        "errorLogger": TableImporter.logger,
      });
    }
//    _instance?.checkEmpty();
  }

  static ObjectTableProject? _instance;
  static ObjectTableProject? get instance {
    if (_instance == null) _instance = new ObjectTableProject();
    return _instance;
  }
  String getTempExt(String temp){
    return PathUtil.extension(temp.replaceAll(".temp", ""));
  }

  void exportBinary(String codePath ,String tempPath , {bool exportBin = false }){
    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance!.workingPath);
    var bep = byteExportPath;
    GlobalBoard.tryCreateDirectory(bep, basePath: basePath);
    var bytePath = GlobalBoard.getCorrectDirectory(bep, basePath: basePath);
    if (exportBin) {
      //不清空
      // FileUtils.ClearDirectory(bytePath);
    }

    final context = Context.create();
    context.variables['namespace'] = ExportMappingConfig.instance!.namespace;

    var exportClazzes = clazzes;
    if (ObjectTableProject.withPlugins()){
      exportClazzes= clazzes.where((element) => element.forceExportBinary??false).toList();
    }

    for(var clz in exportClazzes){
      clz.load();
      if (exportBin){
        ByteDataWriter bw = ByteDataWriter();
        var tbl = clz.table;
        bw.writeUint32(tbl!.objects.length , "object count : ${tbl.objects.length}");
        for (var obj in tbl!.objects){
          obj.export(bw);
        }

        var fpath = PathUtil.join(bytePath,"${clz.name}.bytes");
        File(fpath).writeAsBytesSync(bw.toBytes());

        // var fDebugPath = PathUtil.join(bytePath,"${clz.name.toLowerCase()}.txt");
        // File(fDebugPath).writeAsStringSync(bw.debugOut.join("\n"));
      }
      else {
        print(clz.name);
        var data = clz.table!.exportCodeData();

        data["name"] = clz.name;
        data["alias"] = clz.alias;
  //      print(data);
        context.variables['data'] = data;

        var tempDir = PathUtil.join(tempPath , "code_data");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {

              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              print(data);
              var outCode = (template.render(context));
              // print("done");
              outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\n",multiLine:true), "");
              var savePath = PathUtil.join(codePath, "${clz.name}${getTempExt(f.path)}");
              Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
              File(savePath).writeAsStringSync(outCode);
            }
          }
        }
      }
    }
  }

  static bool isValid(){
    if (ObjectTableSetting.instance!.workingPath == null || ObjectTableSetting.instance!.workingPath == "" || GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance!.workingPath) == null){
      return false;
    }
    return true;
  }

  void exportOnlyBinary() {
    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance!.workingPath);

    SSObjBase.buildHashExportId(enums);
    for(var e in enums){
      // SSObjBase.buildExportId(e.items);
      e.buildItemId();
    }
    SSObjBase.buildHashExportId(clazzes);

    List<Map> exportConfigs = [
      { "active" :csExport , "exportPath":csCodeExportPath, "templatePath":csTemplatePath,"bin":true},
      { "active" :luaExport , "exportPath":luaCodeExportPath, "templatePath":luaTemplatePath , "bin":false},
    ];
    if (useNewExportConfig){
      exportConfigs = getAllExportConfigs();
    }
    for(var con in exportConfigs){
      if (con["active"] == true) {
        GlobalBoard.tryCreateDirectory(con["exportPath"] as String, basePath: basePath);
        var tempPath = GlobalBoard.getCorrectDirectory(con["templatePath"]as String, basePath: basePath);
        var codePath = GlobalBoard.getCorrectDirectory(con["exportPath"] as String, basePath: basePath);
        ExportMappingConfig.load(tempPath,force: true);
        exportBinary(codePath , tempPath, exportBin: con["bin"] == true );
      }
    }
  }

  List<Map> getAllExportConfigs(){
    var res = <Map>[];
    if (mainExportConfig.active){
      res.add({ "active" : true , "exportPath" : mainExportConfig.codeExportPath, "templatePath" : mainExportConfig.templatePath,"bin":true});
    }
    if (otExportConfigs != null) {
      for (var c in otExportConfigs!) {
        if (c.active){
          res.add({ "active" : true , "exportPath" : c.codeExportPath, "templatePath" : c.templatePath,"bin":false});
        }
      }
    }
    return res;
  }

  void export() {
    // if (withPlugins()) return ;
    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance!.workingPath);

    prepareExport();
    // SSObjBase.buildHashExportId(enums);
    // for(var e in enums){
    //   // SSObjBase.buildExportId(e.items);
    //   e.buildItemId();
    // }
    // SSObjBase.buildHashExportId(clazzes);


    List<Map> exportConfigs = [
      { "active" :csExport , "exportPath":csCodeExportPath, "templatePath":csTemplatePath,"bin":true},
      { "active" :luaExport , "exportPath":luaCodeExportPath, "templatePath":luaTemplatePath , "bin":false},
    ];

    if (useNewExportConfig){
      exportConfigs = getAllExportConfigs();
    }

    int platIndex = 0;//c# 版本
    for(var con in exportConfigs){
      ++platIndex;
      if (con["active"] == true) {
        if (platIndex != 1) {
          GlobalBoard.tryCreateDirectory(con["exportPath"] as String, basePath: basePath);
        }
        var tempPath = GlobalBoard.getCorrectDirectory(con["templatePath"]as String, basePath: basePath);
        var codePath = GlobalBoard.getCorrectDirectory(con["exportPath"]as String , basePath: basePath);

        bool codePathExists = codePath != null && Directory(codePath).existsSync();
        if (codePathExists){

          ExportMappingConfig.load(tempPath,force: true);

          FileUtils.ClearDirectory(codePath);
          final context = Context.create();
          var clzList = <dynamic>[];
          context.variables['namespace'] = ExportMappingConfig.instance!.otnamespace;
          var exportClazzes = clazzes;
          if (ObjectTableProject.withPlugins()){
            exportClazzes= clazzes.where((element) => element.forceExportBinary??false).toList();
          }

          for(var clz in exportClazzes){
            clz.load();
            var clzInfo = clz.exportInfo();
            context.variables['clz'] = clzInfo;
            clzList.add(clzInfo);
            {
              var tempDir = PathUtil.join(tempPath , "class_data");
              var dir = Directory(tempDir);
              if (dir.existsSync()){
                var files = dir.listSync();
                for(var f in files){
                  if (f is File && f.path.endsWith(".temp")){
                    var templateData = f.readAsStringSync();
                    final template = Template.parse(context, Source.fromString(templateData));
                    var outCode = (template.render(context));
                    outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\n",multiLine:true), "");
                    var savePath = PathUtil.join(codePath, "A${clz.name}${getTempExt(f.path)}");
                    Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                    File(savePath).writeAsStringSync(outCode);
                  }
                }
              }
            }
          }

          context.variables['clzs'] = clzList;
          {
            var tempDir = PathUtil.join(tempPath , "object_creater");
            var dir = Directory(tempDir);
            if (dir.existsSync()){
              var files = dir.listSync();
              for(var f in files){
                if (f is File && f.path.endsWith(".temp")){
                  var templateData = f.readAsStringSync();
                  final template = Template.parse(context, Source.fromString(templateData));
                  var outCode = (template.render(context));
                  var savePath = PathUtil.join(codePath, "${PathUtil.basenameWithoutExtension(f.path)}");
                  Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                  File(savePath).writeAsStringSync(outCode);
                }
              }
            }
          }
          var expEnums = [];
          for(var e in enums){
    //      var en = {'name' : e.name};
            var items = [];
            for(var i in e.items){
              items.add({'name' : i.name , 'id' : i.enumValue??i.exportId??0});
            }
            var en = {'name' : e.name , 'items' :items };
            expEnums.add(en);
          }
          context.variables['enums'] = expEnums;

          {

            var tempDir = PathUtil.join(tempPath , "define");
            var dir = Directory(tempDir);
            if (dir.existsSync()) {
              var files = dir.listSync();
              for (var f in files) {
                if (f is File && f.path.endsWith(".temp")) {

                  var templateData = f.readAsStringSync();
                  final template = Template.parse(context, Source.fromString(templateData));
                  var outCode = (template.render(context));
                  var savePath = PathUtil.join(codePath, "${getTemp2Name(f.path)}");
                  Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                  File(savePath).writeAsStringSync(outCode);
                }
              }
            }
          }
        }
        exportBinary(codePath , tempPath, exportBin: con["bin"] == true );
      }
    }

  }
  String getTemp2Name(String temp){
    return PathUtil.basename(temp).replaceAll(".temp", "");
  }

  static void setInstance(ObjectTableProject prj) {
    _instance = prj;
  }


  static parseMainConfig(dynamic jsonData) {
    return jsonData == null
        ? OTExportConfig()
        : OTExportConfig.fromJson(
        jsonData as Map<String, dynamic>);
  }
}