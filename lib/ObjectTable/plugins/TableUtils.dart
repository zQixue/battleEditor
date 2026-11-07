//@dart=2.11

// import 'package:battlepus/MultiLans/TableReader/TableManager.dart';

import 'dart:io';
import 'package:iso/iso.dart';
import 'package:lua_dardo/lua.dart';
import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/TableManager.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Logger.dart';
import 'package:battlepus/common/lua/LuaVm.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:xml/xml.dart';

// typedef  AttrPrioMap = Map<String,int>;
class TableUtiles{

  static String rootPath ;
  static String namespace ;
  static int setRootPath(LuaState ls) {
    var args = LuaVm.getArgs(ls, 1);
    rootPath = args[0];
    return 0;
  }

  static List<String> searchPaths = List<String>();
  static int setSearchPath(LuaState ls) {
    searchPaths.clear();
    var args = LuaVm.getArgs(ls, 1);
    var paths = args[0];
    (paths as Map).forEach((key, value) {
      searchPaths.add(value);
    });
    return 0;
  }



  static Map<String , Map<String,String>> pathFiles = Map<String , Map<String,String>>();
  static String findPath(String searchPath , String ext , String name){

    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    if (DartCommon.isEmpty(basePath)) return null;
    var rPath = rootPath??".";
    var fullPath = PathUtil.canonicalize(PathUtil.join(basePath,rPath,searchPath));
    var dir = Directory(fullPath);
    if (!dir.existsSync()) return null;
    var key = "$searchPath#$ext";
    var files = pathFiles[key];
    if (files == null) {
      files = pathFiles[key] = Map<String,String>();
      var dirFiles = dir.listSync(recursive: false);
      dirFiles.forEach((element) {
        if (element is File){
          if (element.path.toLowerCase().endsWith(ext)){
            var fKey = PathUtil.basenameWithoutExtension(element.path).toLowerCase();
            if (files.containsKey(fKey)){
              TableImporter.logger.appendLog(LogType.error,"发现重复命名的文件 : $fKey , ${element.path} , 同名文件位于 ${files[fKey]}");
            }
            else {
              files[fKey] = element.path;
            }
          }
        }
      });
    }

    return files[name.toLowerCase()];
  }
  static int searchFiles(LuaState ls) {
    var args = LuaVm.getArgs(ls, 1);
    var ext = args[0];

    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    if (DartCommon.isEmpty(basePath)) return 0;
    var rPath = rootPath??".";
    // var fullPath = PathUtil.canonicalize(PathUtil.join(basePath,rPath,searchPath));
    // var dir = Directory(fullPath);
    // if (!dir.existsSync()) return 0;
    List<String> res = List<String>();
    for(var i = 0 ; i < searchPaths.length ; ++i){
      var sPath = searchPaths[i];
      var fullPath = PathUtil.canonicalize(PathUtil.join(basePath,rPath,sPath));
      var dir = Directory(fullPath);
      if (!dir.existsSync()) continue;
      var key = "$sPath#$ext";
      var files = pathFiles[key];
      if (files == null) {
        files = pathFiles[key] = Map<String,String>();
        var dirFiles = dir.listSync(recursive: false);
        dirFiles.forEach((element) {
          if (element is File){
            if (element.path.toLowerCase().endsWith(ext)){
              var fKey = PathUtil.basenameWithoutExtension(element.path).toLowerCase();
              if (files.containsKey(fKey)){
                TableImporter.logger.appendLog(LogType.error,"发现重复命名的文件 : $fKey , ${element.path} , 同名文件位于 ${files[fKey]}");
              }
              else {
                files[fKey] = element.path;
              }
            }
          }
        });
      }
      // res.addAll(files.keys);
      files.forEach((key, value) {
        res.add(PathUtil.basenameWithoutExtension(value));
      });

    }
    LuaVm.pushList2Stack(ls, res);
    return 1;
  }
  static int readCsvTable(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var name = args[1];
    var path = args[0];
    print("$path $name");
    var filaPath = findPath(path , ".csv" ,name);
    // print("$filaPath");
    if (filaPath == null) {
      return 0;
    }
    var tbl = TableManager.getTable(filaPath);
    // print(tbl);
    LuaVm.pushTable2Stack(ls, tbl.convertMap());
    return 1 ;//TableManager.getTable(filaPath);
  }

  static Map<String , ObjectClazz> name2clazzes ;
  static void initName2Clazzes(){
    name2clazzes = Map<String , ObjectClazz>();
    print(ObjectClazz.clazzes);
    ObjectClazz.clazzes.forEach((key, value) {
      name2clazzes[value.name] = value;
    });
  }

  static int importCsvTable(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var clzName = args[2];
    var name = args[1];
    var path = args[0];
    var filaPath = findPath(path , ".csv" ,name);
    // print("$filaPath");
    if (filaPath == null) {
      return 0;
    }
    var tbl = TableManager.getTable(filaPath);
    // print(tbl);
    var clz = name2clazzes[clzName];
    if (clz == null) {
      return 0;
    }
    // print(clz);
    clz.table.objects.clear();
    tbl.rows.forEach((row) {
      var obj = clz.table.addObjectWithoutBuildMap();
      tbl.columns.forEach((col) {
        var colName = col.name;
        if(DartCommon.isEmpty(colName)){
          colName = col.desc;
        }

        if (DartCommon.isEmpty(colName)) return ;
        var val = tbl.getRowCellByColName(row, colName);
        try {
          obj.setFieldValueByName(colName, val);
        }
        catch(e){
          TableImporter.logger.appendLog(LogType.error,"${e.toString()}");
        }
        obj.rebuildTag();
      });
    });
    clz.table.buildMap();


    // GlobalRefreshEvent
    EventCenter.eventBus.fire(GlobalRefreshEvent());
    return 0;
  }

  static Map<String , ATable> _exportCsvTables = Map<String , ATable>();
  static void exportClear(){
    _exportCsvTables.clear();
  }

  static ATable getExportTable(String path){
    var res = _exportCsvTables[path];
    if (res == null){
      res = TableManager.getTable(path);
      _exportCsvTables[path] = res;
    }

    return res;
  }

  static int saveCsvTable(LuaState ls) {
    var args = LuaVm.getArgs(ls, 2);
    var path = args[0];
    var name = args[1];
    var filaPath = findPath(path , ".csv" ,name);
    if (filaPath == null) {
      return 0;
    }

    var tbl = getExportTable(filaPath);
    if (tbl == null) return 0;
    tbl.save(filaPath+".new.csv");
  }

  static int exportObjectsToCsvTable(LuaState ls){
    var args = LuaVm.getArgs(ls, 5);
    var path = args[0];
    var name = args[1];
    var idField = args[2]; //映射 id 字段
    var aMaps = args[3] as Map; //映射 id 字段
    var removeOther = args[4]; //映射 id 字段

    var filaPath = findPath(path , ".csv" ,name);
    // print("$filaPath");
    if (filaPath == null) {
      return 0;
    }
    var tbl = getExportTable(filaPath);
    if (tbl == null) return 0;
    tbl.buildId2RowMapByKeys([idField]);
    // var objMap = tbl.id2RowMap;

    if (aMaps == null) return 0;
    Map<String,bool> validIds = Map<String,bool>();
    aMaps.forEach((key, value) {
      updateACsvObject(tbl,value,idField);
      var fieldValues =value["fields"] as Map;
      var id = fieldValues[idField].toString();
      validIds[id.toString()] = true;
    });

    if (removeOther??true){
      var objMap = tbl.id2RowMap.keys.toList();
      objMap.forEach((element) {
        if (validIds[element] != true){
          tbl.remove(element);
        }
      });
    }
  }

  static int updateCsvObject(LuaState ls){
    var args = LuaVm.getArgs(ls, 4);
    var path = args[0];
    var name = args[1];
    var idField = args[2]; //映射 id 字段
    var aMap = args[3]; //映射 id 字段


    var filaPath = findPath(path , ".csv" ,name);
    // print("$filaPath");
    if (filaPath == null) {
      return 0;
    }
    var tbl = getExportTable(filaPath);
    if (tbl == null) return 0;
    tbl.buildId2RowMapByKeys([idField]);
    // var objMap = tbl.id2RowMap;
    // print(tbl);
    // var clz = name2clazzes[clzName];
    // if (clz == null) {
    //   return 0;
    // }
    updateACsvObject(tbl,aMap,idField);
    // var m = aMap;
    // var fieldValues = m["fields"] as Map;
    // var aliases = m["aliases"] as Map;
    // var id = fieldValues[idField].toString();
    // if (id == null) return 0 ;
    // var row = objMap[id];
    // if (row == null){
    //   row = tbl.addRow(idField, 1024);
    // }
    //
    // if (row != null) {
    //   fieldValues.forEach((fKey, fVal) {
    //     var bingo = tbl.setRowCellByColName(row, fKey, fVal);
    //     if (!bingo){
    //       var alias = aliases[fKey];
    //       if (alias != null){
    //         tbl.setRowCellByColName(row, alias, fVal);
    //       }
    //     }
    //   });
    // }
    return 0;
  }

  static void updateACsvObject(ATable tbl , Map m , String idField){
    var fieldValues = m["fields"] as Map;
    var aliases = m["aliases"] as Map;
    var id = fieldValues[idField].toString();
    if (id == null) return ;
    var objMap = tbl.id2RowMap;
    var row = objMap[id];
    if (row == null){
      row = tbl.addRow(id, 1024);
    }

    if (row != null) {
      fieldValues.forEach((fKey, fVal) {
        var bingo = tbl.setRowCellByColName(row, fKey, fVal);
        if (!bingo){
          var alias = aliases[fKey];
          if (alias != null){
            tbl.setRowCellByColName(row, alias, fVal);
          }
        }
      });
    }
  }

  static int exportCsvTable(LuaState ls){
    var args = LuaVm.getArgs(ls, 4);
    var path = args[0];
    var name = args[1];
    var clzName = args[2];
    var idField = args[3]; //映射 id 字段


    var filaPath = findPath(path , ".csv" ,name);
    // print("$filaPath");
    if (filaPath == null) {
      return 0;
    }
    var tbl = TableManager.getTable(filaPath);
    tbl.buildId2RowMapByKeys([idField]);
    var objMap = tbl.id2RowMap;
    // print(tbl);
    var clz = name2clazzes[clzName];
    if (clz == null) {
      return 0;
    }

    clz.table.objects.forEach((oObj) {
      var m = oObj.toMap();
      var fieldValues = m["fields"] as Map;
      var id = fieldValues[idField];
      if (id == null) return ;
      var row = objMap[id];
      fieldValues.forEach((fKey, fVal) {
        tbl.setRowCellByColName(row, fKey, fVal);
      });
    });
    // GlobalRefreshEvent
    EventCenter.eventBus.fire(GlobalRefreshEvent());
    return 0;
  }

  static int printTable(LuaState ls){// , Map id , String colName, String val ,String tblName){
    var args = LuaVm.getArgs(ls, 1);
    var t = args[0];
    print("print table : $t");
    return 0;
  }

  static int loadOrCreateXml(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var fName = args[0];
    var fType = args[1];
    var fPath = args[2];
    // var fName = args[1];
    var filaPath ;
    for(var i = 0 ; i < searchPaths.length ; ++i){
      var sPath = searchPaths[i];
      filaPath = findPath(sPath , ".xml" ,fName);
      if (filaPath != null) break;
    }


    if (filaPath == null) {
      var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
      filaPath = PathUtil.join(basePath , fPath??'.' , "${fName}.xml");
      var tempPath = PathUtil.join(basePath , "templates" , "${fType}.xml");
      var fTemp = File(tempPath);
      if (!fTemp.existsSync()){
        TableImporter.logger.appendLog(LogType.error,"导出 $fName 出错，模板文件 $tempPath 不存在");
        return 0;
      }
      fTemp.copySync(filaPath);
    }

    var m;
    final file = new File(filaPath);
    try{
      final document = XmlDocument.parse(file.readAsStringSync());
      m = xmlToMap(document);
      m["path"] = PathUtil.canonicalize(filaPath.replaceAll("\\", "/"));
      m["name"] = fName;
    }
    catch(e){
      return 0;
    }

    if (m == null) {
      return 0;
    }
    LuaVm.pushTable2Stack(ls, m);

    return 1;

  }

  static int loadXml(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var fName = args[0];
    // var fName = args[1];
    var filaPath ;
    for(var i = 0 ; i < searchPaths.length ; ++i){
      var sPath = searchPaths[i];
      filaPath = findPath(sPath , ".xml" ,fName);
      if (filaPath != null) break;
    }


    if (filaPath == null) {
      return 0;
    }
    var m;
    final file = new File(filaPath);
    try{
      final document = XmlDocument.parse(file.readAsStringSync());
      m = xmlToMap(document);
      m["path"] = PathUtil.canonicalize(filaPath.replaceAll("\\", "/"));
      m["name"] = fName;
    }
    catch(e){
      return 0;
    }

      if (m == null) {
        return 0;
      }
      LuaVm.pushTable2Stack(ls, m);

      return 1;

  }

  static int createObject(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var tpName = args[0];
    var clz = name2clazzes[tpName];
    if (clz == null) return 0;
    var obj = clz.table.addObjectWithoutBuildMap();
    if (!DartCommon.isEmpty(namespace)){
      obj.namespace = namespace;
    }
    ls.pushString(obj.guid);
    return 1;
  }

  static int createObjectWithUniqueId(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var tpName = args[0];
    var id = args[1];
    var clz = name2clazzes[tpName];
    if (clz == null) return 0;
    AObject obj ;
    if (DartCommon.isEmpty(id)){
      obj = clz.table.addObjectWithoutBuildMap();
    }
    else {
      var fullId = "${namespace ?? ""}_${id ?? "invalid_id"}";
      obj = clz.table.addObjectWithoutBuildMap(id: fullId);
    }

    if (!DartCommon.isEmpty(namespace)) {
      obj.namespace = namespace;
    }
    // obj.guid = "${namespace??""}_${id??"invalid_id"}";
    ls.pushString(obj.guid);
    return 1;
  }

  static int setTableRefable(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var tpName = args[0];

    var clz = name2clazzes[tpName];
    if (clz == null) return 0;
    clz.pluginTableRefable = true;
    return 0;
  }


  static int setNamespace(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var ns = args[0];
    namespace = ns;
    return 0;
  }

  static int saveXml(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var xml = args[0];
    var path = args[1];

    // print(xml);

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    //从lua过来，list 其实是 map，下标从 1 开始
    _buildXml(builder , xml["children"][1]);
    final document = builder.buildDocument();
    var str = document.toXmlString(pretty: true, indent: '\t');
    File(path).writeAsStringSync(str);
    return 0;
  }

  static void _buildXml(XmlBuilder builder , Map node){
    if(node == null) return ;
    var nodeName = node["name"].toString();
    builder.element(nodeName ,nest: () {
      List attrs = List();
      (node["attrs"] as Map).forEach((key, value) {
        // builder.attribute(key, value);
        attrs.add({"key":key,"value":value});
      });
      var ap = attrPrios[nodeName];
      if (ap!= null) {
        attrs.sort((a, b) {
          var pa = ap[a["key"]??""]??0;
          var pb = ap[b["key"]??""]??0;
          return pa-pb;
        });
      }
      attrs.forEach((element) {
        builder.attribute(element["key"], element["value"]);
      });


      // var ap = attrPrios[name];
      // if (ap == null){
      //   ap = attrPrios[name] = new Map<String,int>();
      // }

      var children = node["children"] as Map;
      if (children != null) {
        children.forEach((key, ch) {
          if (ch["isComment"] == true) {
            builder.comment(ch["comment"] ?? "");
          }
          else {
            _buildXml(builder, ch);
          }
        });
      }
    });
  }

  static int getXmlObjectFieldNames(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var tpName = args[0];
    var m = attrPrios[tpName];
    if (m == null) return 0;
    LuaVm.pushTable2Stack(ls, m);
    return 1;
  }


  static int buildMap(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var tpName = args[0];
    var clz = name2clazzes[tpName];
    if (clz == null) return 0;
    clz.table.buildMap();
    return 0;
  }

  static int setObjectAField(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var guid = args[0];
    var fieldName = args[1];
    var value = args[2];
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;
    try {
      obj.setFieldValueByName(fieldName, value);
    }
    catch(e){
      TableImporter.logger.appendLog(LogType.error,"${e.toString()}");
    }

    return 0;
  }

  static int setGroupFromPath(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var guid = args[0];
    var path = args[1];
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;
    try {

      var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
      // if (DartCommon.isEmpty(basePath)) return null;
      var rPath = rootPath??".";
      var fullPath = PathUtil.canonicalize(PathUtil.join(basePath,rPath));

      var rpath = PathUtil.relative(PathUtil.dirname(path),from:fullPath);
      obj.group = rpath.replaceAll("\\", "/");
      // obj.setFieldValueByName(fieldName, value);
    }
    catch(e){
      TableImporter.logger.appendLog(LogType.error,"${e.toString()}");
    }

    return 0;
  }

  static int setObjectComment(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var guid = args[0];
    var value = args[1];
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;
    try {
      if (value != null) {
        obj.comment = value;
        obj.isComment = true;
      }
    }
    catch(e){
      TableImporter.logger.appendLog(LogType.error,"${e.toString()}");
    }

    return 0;
  }

  static int appendToObjectList(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var guid = args[0];
    var fieldName = args[1];
    var value = args[2];
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;
    obj.appendListValueByName(fieldName, value);
    return 0;
  }

  static int setObjectFields(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var guid = args[0];
    var attrs = args[1] as Map;
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;

    attrs.forEach((key, value) {
      try {
        // obj.setFieldValueByName(fieldName, value);
        obj.setFieldValueByName(key, value);
      }
      catch(e){
        TableImporter.logger.appendLog(LogType.error,"${e.toString()}");
      }
    });

    // obj.setFieldValueByName(fieldName, value);
    return 0;
  }

  static int clearAllObjects(LuaState ls){
    ObjectClazz.clazzes.forEach((key, value) {
      if (value.isTableValid()) {
        value.clearTable();
      }
    });
    attrPrios.clear();
    _crt_prio = 1000;
    EventCenter.eventBus.fire(AObjectTableCleared());
    return 0;
  }

  static int getObjectsMap(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var clzName = args[0];
    var keyName = args[1];
    if (keyName == null) return 0;
    var clz = name2clazzes[clzName];
    if (clz == null) return 0;
    var objs = clz.table.objects;
    Map res = Map();
    objs.forEach((element) {
      var val = element.toMap();
      var key = val["fields"][keyName];
      if (key == null){
        key = val[keyName];
      }
      if (key != null) {
        res[key.toString()] = val;
      }
    });
    LuaVm.pushTable2Stack(ls, res);
    return 1;
  }

  static int getObjectsList(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var clzName = args[0];
    var clz = name2clazzes[clzName];
    if (clz == null) return 0;
    var objs = clz.table.objects;
    List res = [];
    objs.forEach((element) {
      var val = element.toMap();
      res.add(val);
      // var key = val["fields"][keyName];
      // if (key == null){
      //   key = val[keyName];
      // }
      // if (key != null) {
      //   res[key.toString()] = val;
      // }
    });
    LuaVm.pushList2Stack(ls, res);
    return 1;
  }

  static int getObjectByGuid(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var guid = args[0];

    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;

    LuaVm.pushTable2Stack(ls, obj.toMap());
    return 1;
  }


  static int getClassObjectDefaultValue(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var clzName = args[0];

    var obj = name2clazzes[clzName];
    if (obj == null) return 0;

    LuaVm.pushTable2Stack(ls, obj.getDefaultValues());
    return 1;
  }

  static int setObjectAlias(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var guid = args[0];
    var alias = args[1];
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return 0;
    try {
      obj.alias = alias;
    }
    catch(e){
      TableImporter.logger.appendLog(LogType.error,"${e.toString()}");
    }

    return 0;
  }



  static Map xmlToMap(XmlDocument doc){
    Map<String,bool> types = Map<String,bool>();
    // Map<String,List<Map>> type2Objects = Map<String,List<Map>>();
    var res = collectMap(doc.root,types);
    res["types"] = types;
    // res["type2objs"] = type2Objects;

    return res;
  }


  static Map<String,Map<String,int>> attrPrios = Map<String,Map<String,int>>();

  static int _crt_prio = 0 ;
  static Map collectMap(XmlNode node , Map<String,bool> types ){
    if (! (node is XmlElement || node is XmlDocument || node is XmlComment)){
      return null;
    }
    var name = "root";

    if (node is XmlComment){
      // name = node.name.toString();
      // return null;
      var comment = node.toString().replaceFirst("<!--", "").replaceFirst("-->", "");
      return { "comment" : comment , "isComment" : true};
    }
    if (node is XmlElement){
      name = node.name.toString();
    }
    {
      types[name] = true;
      // var lst = type2Objects[name];
      // if (lst == null)lst = type2Objects[name] = List<Map>();

      Map attrs = Map();
      node.attributes.forEach((attr) {
        var attrName = attr.name.toString();
        var attrVal = attr.value;
        attrs[attrName] = attrVal;

        var ap = attrPrios[name];
        if (ap == null){
          ap = attrPrios[name] = new Map<String,int>();
        }

        // var prioKey = "${name}_$attrName";
        if (ap[attrName] == null) {
          ap[attrName] = _crt_prio++;
        }
      });
      List children = List();
      String lastComment = "" ;
      node.children.forEach((n) {
        var ch = collectMap(n, types);
        if (ch != null) children.add(ch);
        // if (ch != null) {
        //   var cmt = ch["__comment__"];
        //   if (cmt != null){
        //     lastComment += cmt;
        //   }
        //   else {
        //     if (lastComment != null) {
        //       ch["comment"] = lastComment;
        //     }
        //     lastComment = "";
        //     children.add(ch);
        //
        //   }
        // }
      });

      var resMap = {
        "name": name,
        "attrs": attrs,
        "children": children,
      };

      // lst.add(resMap);
      return resMap;
    }
  }

  static int o2u_SceneClear(LuaState ls){
    otTransformFieldMap.clear();
    return 0;
  }

  static int o2u_LoadScene(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var subPath = args[0];
    var name = args[1];
    //发送命令到 unity
    OT_OpenScene os = OT_OpenScene();
    os.searchPath = subPath;
    os.sceneName = name;
    Transport.instance.sendUdpData(OPackType.O2U_OT_OPEN_SCENE, os);
    return 0;
  }
  static AObject currentObject;
  static int o2u_getCurrentFocusObject(LuaState ls){
    //发送命令到 unity
    if (currentObject == null) return 0;
    LuaVm.pushTable2Stack(ls, currentObject.toMap());
    return 1;
  }

  static V3 mapToV3(map){
    V3 res = V3();
    if (map == null){
      return res;
    }
    res.x = map["x"]??0.0;
    res.y = map["y"]??0.0;
    res.z = map["z"]??0.0;
    return res;
  }

  static int o2u_CreateObject(LuaState ls){
    var args = LuaVm.getArgs(ls, 7);
    var guid = args[0];
    var tag = args[1];
    var searchPath = args[2];
    var prefab = args[3];
    var pos = args[4];
    var rot = args[5];
    var scale = args[6];

    //发送命令到 unity
    OT_CreateObject po = OT_CreateObject();
    po.guid = guid ;
    po.tag = tag ;
    po.searchPath = searchPath ;
    po.prefab = prefab ;
    po.pos = mapToV3(pos) ;
    po.rot = mapToV3(rot) ;
    po.scale = mapToV3(scale) ;

    Transport.instance.sendUdpData(OPackType.O2U_OT_CREATE_OBJECT, po);
    return 0;
  }

  static int o2u_RefreshScene(LuaState ls){
    var args = LuaVm.getArgs(ls, 5);
    var guid = args[0];
    var edtName = args[1];
    var subPath = args[2];
    var name = args[3];
    var objs = args[4] as Map;

    //发送命令到 unity
    OT_RefreshSceneWithObject po = OT_RefreshSceneWithObject();
    po.guid = guid;
    po.searchPath = subPath ;
    po.sceneName = name ;
    po.editorName = edtName;
    objs?.forEach((key, value) {
      OT_CreateObject obj = OT_CreateObject();
      obj.guid = value["guid"] ;
      obj.tag = value["tag"] ;
      obj.searchPath = value["searchPath"] ;
      obj.prefab = value["prefab"] ;
      obj.pos = mapToV3(value["pos"]) ;
      obj.rot = mapToV3(value["rot"]) ;
      obj.scale = mapToV3( value["scale"]) ;
      po.objects.add(obj);
    });

    Transport.instance.sendUdpData(OPackType.O2U_OT_REFRESH_SCENE_WITH_OBJECTS, po);
    return 0;
  }

  static int o2u_CreateMap(LuaState ls){
    var args = LuaVm.getArgs(ls, 5);
    var guid = args[0];
    var subPath = args[1];
    var name = args[2];
    var id = args[3];
    var objs = args[4] as Map;

    //发送命令到 unity
    OT_CreateMap po = OT_CreateMap();
    po.guid = guid;
    po.searchPath = subPath ;
    po.mapName = name ;
    po.mapID = id;
    objs?.forEach((key, value) {
      OT_CreateObject obj = OT_CreateObject();
      obj.guid = value["guid"] ;
      obj.tag = value["tag"] ;
      obj.searchPath = value["searchPath"] ;
      obj.prefab = value["prefab"] ;
      obj.pos = mapToV3(value["pos"]) ;
      obj.rot = mapToV3(value["rot"]) ;
      obj.scale = mapToV3( value["scale"]) ;
      po.objects.add(obj);
    });

    Transport.instance.sendUdpData(OPackType.O2U_OT_CREATE_MAP, po);
    return 0;
  }

  static Map<String , Map> otTransformFieldMap = Map<String , Map>();

  static Map getTransformFieldMapBy(String guid , String fieldName){
    var fullGuid = "${guid}_$fieldName";
    var res = otTransformFieldMap[fullGuid];
    if (res != null) return res;
    return null;
  }
  static int u2o_BindPosition(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var guid = args[0];
    var fieldName = args[1];
    var mapGuid = args[2];
    var m = otTransformFieldMap[guid];
    if (m == null){
      m = otTransformFieldMap[guid] = Map();
    }
    m["pos"] = fieldName;
    m["mapGuid"] = mapGuid;
    m["guid"] = guid;
  }

  static int u2o_BindRotation(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var guid = args[0];
    var fieldName = args[1];
    var mapGuid = args[2];
    var m = otTransformFieldMap[guid];
    if (m == null){
      m = otTransformFieldMap[guid] = Map();
    }
    m["rot"] = fieldName;
    m["mapGuid"] = mapGuid;
    m["guid"] = guid;
  }

  static void focusUnityObject(String guid){
    // var args = LuaVm.getArgs(ls, 1);
    // var guid = args[0];

    //发送命令到 unity
    OT_SelectObject po = OT_SelectObject();
    po.guid = guid;

    Transport.instance.sendUdpData(OPackType.O2U_OT_SELECT_OBJECT, po);
  }

  static IsoRunner iso ;
  static int sendProgressInfo(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var str = args[0];
    // EventCenter.eventBus.fire(ProgressEvent()..info = str);
    if (iso != null) {
      iso.send({
        "process": str,
      });
    }

    return 0;
  }
}