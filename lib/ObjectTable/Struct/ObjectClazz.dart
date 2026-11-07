 

import 'dart:math';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/OTStorage.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ATable.dart';
import 'package:battlepus/ObjectTable/Struct/ClassDecoration.dart';
import 'package:battlepus/ObjectTable/Struct/FieldGroup.dart';
import 'package:battlepus/ObjectTable/Struct/FieldLayout.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSList.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSMap.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/Transition/PackSolver.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/Logger.dart';
import 'package:battlepus/protos/transition.pb.dart';

part 'ObjectClazz.g.dart';

@JsonSerializable()
class ObjectClazz extends SSObjBase implements CodeExporter{

  @JsonKey(defaultValue: "")
  String group = "";

  @JsonKey(defaultValue: <FieldInfo>[])
  List<FieldInfo> fields = <FieldInfo>[];

  @JsonKey(defaultValue: <ClassDecoration>{})
  Map<String,ClassDecoration> decorations = Map<String,ClassDecoration>();


  @JsonKey(ignore: true)
  Map<String,AObject> searchKey2Object = Map<String,AObject>();

  @JsonKey(defaultValue: <String>[])
  List<String> tagFields = <String>[];

  @JsonKey(defaultValue: true)
  bool refable = true;

  @JsonKey(ignore: true)
  bool pluginTableRefable = false;

  @JsonKey(defaultValue: false)
  bool showOnNavigatorBar = false;

  @JsonKey(defaultValue: false)
  bool isDefaultClazz = false;

  @JsonKey(defaultValue: false)
  bool forceExportBinary = false;

  @JsonKey(ignore: true)
  bool isAllKeyUnique = false;

  @JsonKey(defaultValue: false)
  bool buildSpaceMap = false;

  @JsonKey(defaultValue: "%6s: %s")
  String tagFormat = "%6s: %s";

  @JsonKey(defaultValue: <String , FieldLayout>{})
  Map<String , FieldLayout> fieldsLayouts = Map<String , FieldLayout>();
  @JsonKey(defaultValue: <int>[])
  List<int> dataHashs = <int>[];

  @JsonKey(defaultValue: <String , FieldGroup>{})
  Map<String, FieldGroup> groups = Map<String, FieldGroup>();

  Map<String , String> getFiled2GroupMap(){
    Map<String , String> res = Map<String , String>();
    groups.forEach((key, value) {
      value.fieldGuids.forEach((element) {
        res[element] = key;
      });
    });

    return res;
  }

  @JsonKey(ignore: true)
  ATable? _table;
  @JsonKey(defaultValue: "")
  String? baseClazz;

  bool isTableValid(){
    return _table != null;
  }
  ATable? get table {
    tryCreateTable();
    return _table;
  }

  void clearTable(){
    if (_table == null) return ;
    _table?.objects.forEach((obj) {
      ObjectClazz.removeObject(obj);
      obj.isDeleted = true;
      // EventCenter.eventBus.fire(AObjectForceChanged()..obj = obj);
    });
    // objects.clear();
    _table?.buildMap();
    _table?.objects.clear();
    _table = null;
  }
  getShowName(){
    //return "$name [${exportId??"--------"}]";
    // return "[${exportId??"--------"}] $name";
    return "$name";
  }
  static Map<String , ObjectClazz> clazzes = Map<String , ObjectClazz>();
  static void registerClazz(ObjectClazz clazz){
    clazzes[clazz.guid] = clazz;
  }
  static void unregisterClazz(ObjectClazz clazz){
    clazzes.remove(clazz.guid);
  }
  static ObjectClazz? getClazz(String guid){
    return clazzes[guid];
  }

  ClassDecoration addDecoration(){
    var d = ClassDecoration();
    decorations[d.guid] = d;
    EventCenter.eventBus.fire(AObjectClassChanged()..clz = this);
    return d;
  }

  void removeDecoration(ClassDecoration d){
    decorations.remove(d.guid);
  }



  static List<ObjectClazz> getClazzes({int? includeFlag , int? excludeFlag}){
    return clazzes.values.toList();
  }
  String getSearchKey() {
    if (name == "" || name == null){
      return "$guid";
    }
    var pinyin1 = PinyinHelper.getShortPinyin(name);
    var pinyin2 = PinyinHelper.getPinyin(name);
    return "${pinyin1}_${pinyin2}_${exportId}_${name}_$guid";
  }


  void save(){
    // var path = OTStorage.getTableStorePath();
    for(var obj in table!.objects){
      var fields = getAllFields();
      var keys = <String>[];
      keys.addAll(obj.fieldValues.keys);
      for(var key in keys){
        if (fields!.where((element) => element.guid == key).length<=0){
          obj.fieldValues.remove(key);
        }
      }
    }
    OTStorage.saveJson("tables/$name" , _table);
  }

  static Map<String ,AObject> allObjects = Map<String ,AObject>();
  static void registerObject(AObject obj){
    allObjects[obj.guid] = obj;
  }

  static void removeObject(AObject obj){
    allObjects.remove(obj.guid);
  }

  void load(){
    if (_table != null) return;
    var path = OTStorage.getTableStorePath();
    var json = OTStorage.loadJson("tables/$name");
    if (json == null)return ;
    _table = ATable.fromJson(OTStorage.loadJson("tables/$name"));

    for(var obj in _table!.objects){
      obj.clazzGuid = guid;
      registerObject(obj);
    }
  }

  void registerObjects(){
    if (_table == null) return;
    for(var obj in _table!.objects){
      obj.clazzGuid = guid;
      registerObject(obj);
    }
  }

  void tryCreateTable(){
    if (!ObjectTableProject.withPlugins() || forceExportBinary) {
      if (_table == null) {
        load();
      }
    }
    if (_table == null) {_table = new ATable();}
    _table!.clazzGuid = guid;
  }

  FieldInfo addField(){
    FieldInfo f = new FieldInfo();
    fields.add(f);
    return f;
  }

  void removeField(FieldInfo f){
    if (fields.contains(f)){
      fields.remove(f);
    }
  }

  void export(ByteDataWriter bw, AObject node) {
    //?? 支持继承？
    var bt = ObjectTableProject.instance!.clazzMap![baseClazz??""];
    if (bt!= null) bt.export(bw,node);

    ///字段
    for(var f in fields){
      var v = f.defaultValue;
      var vh = node.fieldValues[f.guid];

      if (vh != null){
        v = vh.value;
      }
      var ft = SSFieldType.getFieldType(f.typeGuid, fieldInfo: f);
      ft!.exportFlag = f.name;
      ft!.export(bw , v);
    }

  }

  @JsonKey(defaultValue: 0xFFFFFFFF)
  int color = 0xFFFFFFFF ;
  @JsonKey(defaultValue: "")
  String description = "";

  @JsonKey(defaultValue: 0)
  int idStart = 0;

  ObjectClazz();
  //此处与类名一致，由指令自动生成代码
  factory ObjectClazz.fromJson(Map<String, dynamic> json) =>
      _$ObjectClazzFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ObjectClazzToJson(this);

  @override
  dynamic exportInfo() {
    // var base = StateScriptProject.instance.structMap[baseType];
    // var baseName = base==null?"":base.name;

    /// 静态字段
    var fieldInfos = [];
    var searchFields = [];
    String? lastKey;
    for(var f in fields){
      var fo = f.exportInfo();
      fieldInfos.add(fo);
      if (f.isSearchKey){
        searchFields.add(fo);
        lastKey = f.name;
      }
    }

    var baseClz = ObjectTableProject.instance!.clazzMap![baseClazz??""];
    return {
      'name': name,
      'base': baseClz == null?"ObjectTableBase":"A${baseClz.name}",
      'alias': alias,
      'guid': guid,
      'exportId':exportId??-1,
      'fields' : fieldInfos,
      'withSearch' : searchFields.length > 0,
      'searchKeys':searchFields,
      'lastKey':lastKey,
      "refClazzes":getRefClazzes(),
    };

  }

  @override
  ObjInfo? getUnityTransformInfo(data, objList){
    if (data is AObject){
      ObjInfo obj = ObjInfo();
      obj.guid = data.guid;
      obj.name = name; //TP name
      obj.showName = alias + "[${data.getTag()}]";
      bool bValid = false;
      for (var field in fields ){
        var ftp = SSFieldType.getFieldType(field.typeGuid,fieldInfo: field);
        if (field.name == "position"){
          // print(data.fieldValues);
          // data.fieldValues.forEach((key, value) {
          //   print(value);
          // });
          var pos = ftp!.parseValue(data.fieldValues[field.guid]?.value??[0.0,0.0,0.0]);
          obj.position = V3()..x = pos[0]..y = pos[1]..z = pos[2];
          bValid = true;
        }
        if (field.name == "rotation"){
          // var ftp = SSFieldType.getFieldType(field.typeGuid);
          var rot = ftp!.parseValue(data.fieldValues[field.guid]?.value??[0.0,0.0,0.0]);
          // print(rot);
          obj.rotation = V3()..x = rot[0]..y = rot[1]..z = rot[2];
          bValid = true;
        }
        if (field.name == "box_size"){
          // var ftp = SSFieldType.getFieldType(field.typeGuid);
          var size = ftp!.parseValue(data.fieldValues[field.guid]?.value??[0.0,0.0,0.0]);
          // print(rot);
          obj.boxSize = V3()..x = size[0]..y = size[1]..z = size[2];
          bValid = true;
        }

        if (ftp is FTObjectReference){
          // print(ftp.innerType0);
          var clz = ObjectClazz.getClazz(field.innerTypeGuid0);
          if (clz!.syncTransform) {

            var otobj = ObjectClazz.allObjects[data.fieldValues[field.guid]?.value];
            if (otobj != null){
              clz.getUnityTransformInfo(otobj , objList);
            }
          }
        }

        if (ftp is SSList){
          var intp = SSFieldType.getFieldType(ftp.innerTypeGuid0);
          if (intp is FTObjectReference){
            var clz = ObjectClazz.getClazz(intp.innerTypeGuid0);
            if (clz!.syncTransform) {
              var objInList = ftp.parseValue(data.fieldValues[field.guid]?.value??[]);
              for(var objid in objInList) {
                var otobj = ObjectClazz.allObjects[objid];
                if (otobj != null) {
                  clz!.getUnityTransformInfo(otobj, objList);
                }
              }
            }
          }
        }

        if (ftp is SSMap){
          var intp = SSFieldType.getFieldType(ftp.innerTypeGuid0);
          if (intp is FTObjectReference){
            var clz = ObjectClazz.getClazz(intp.innerTypeGuid0);
            if (clz!.syncTransform) {
              // print("SSMap");
              var objInList = ftp.parseValue(data.fieldValues[field.guid]?.value??[]);

              objInList.forEach((element) {
                var key = element["key"];
                var val = element["value"];
                if (key != null && val != null) {
                  var otobj = ObjectClazz.allObjects[val];
                  if (otobj != null) {
                    clz!.getUnityTransformInfo(otobj, objList);
                  }
                }
              }
              );
            }
          }
        }

      }
      if (bValid) {
        if (!PackSolver.objectExists(data)) {
          objList?.add(obj);
          PackSolver.registerTransitionObject(data);
        }
        return obj;
      }
      return null;
    }
    else {
      return null;
    }
  }

  @override
  void setUnityTransformInfo(ObjInfo udata , data){
    for (var field in fields ){
      if (field.name == "position"){
        //
        // data.fieldValues[field.guid].value = [DartCommon.fixValue(udata.position.x , 6),DartCommon.fixValue(udata.position.y, 6),DartCommon.fixValue(udata.position.z, 6)];

        (data as AObject).setFieldValue(field.guid, [DartCommon.fixValue(udata.position.x , 6),DartCommon.fixValue(udata.position.y, 6),DartCommon.fixValue(udata.position.z, 6)], field.name);
      }
      if (field.name == "rotation"){
        // data.fieldValues[field.guid].value = [DartCommon.fixAngle(udata.rotation.x , 3),DartCommon.fixAngle(udata.rotation.y , 3),DartCommon.fixAngle(udata.rotation.z , 3)];
        (data as AObject).setFieldValue(field.guid, [DartCommon.fixAngle(udata.rotation.x , 3),DartCommon.fixAngle(udata.rotation.y , 3),DartCommon.fixAngle(udata.rotation.z , 3)], field.name);
      }
      if (field.name == "box_size"){
        // data.fieldValues[field.guid].value = [DartCommon.fixAngle(udata.rotation.x , 3),DartCommon.fixAngle(udata.rotation.y , 3),DartCommon.fixAngle(udata.rotation.z , 3)];
        (data as AObject).setFieldValue(field.guid, [DartCommon.fixAngle(udata.boxSize.x , 3),DartCommon.fixAngle(udata.boxSize.y , 3),DartCommon.fixAngle(udata.boxSize.z , 3)], field.name);
      }
    }
  }

  void exportCodeData(List<dynamic> outArray, AObject aObject) {
    List<dynamic> outFields = <dynamic>[];
    ///字段
    for(var f in fields){
      var v = f.defaultValue;
      var vh = aObject.fieldValues[f.guid];

      if (vh != null){
        v = vh.value;
      }
      var ft = SSFieldType.getFieldType(f.typeGuid, fieldInfo: f);
      ft!.exportFlag = f.name;
//      print("${f.guid} ${f.typeGuid}");
//      ft.export(bw , v);
      var expVal = ft!.exportValue(v);
      // print(expVal);
      expVal = ExportMappingConfig.instance!.mappingFieldValue(ft.name, expVal , {});
      // print("expVal");
      outFields.add({'name' :f.name ,'value':expVal});
      // print("BBBBBB");
    }
    // print(outFields);

    outArray.add({
      'typeName' : name,
      'fields' : outFields,
    });
  }

  bool isParentOf(ObjectClazz data) {
    var pid = data.baseClazz;
    while (!DartCommon.isEmpty(pid) ) {
      if (pid == guid) {
        return true;
      }
      ObjectClazz? pc = ObjectTableProject.instance!.clazzMap![pid];
      if (pc == null) return false;
      pid = pc.baseClazz;
    }

    return false;
  }

  List<double> getAllGridWidths() {
    List<double> widths = <double>[];
    _getGridWidth(widths);
    return widths;
  }

  _getGridWidth(List<double> outLst) {

    var baseClz = ObjectTableProject.instance!.clazzMap![baseClazz??""];
    if (baseClz != null){
      baseClz._getGridWidth(outLst);
    }
    for(var f in fields){
      outLst.add(f.gridWidth+0.0);
    }
  }

  List<FieldInfo>? _allfields ;//= List<FieldInfo>();
  Map<String,FieldInfo>? _allfieldsMap ;//= List<FieldInfo>();
  Map<String,FieldInfo>? _allNameToFieldsMap ;//= List<FieldInfo>();

  List<FieldInfo>? getAllFields() {
    if (_allfields != null) return _allfields;
    _allfields = <FieldInfo>[];
    _getFields(_allfields!);



    _allfieldsMap = Map<String,FieldInfo>();
    _allfields!.forEach((element) {
      _allfieldsMap![element.guid] = element;
    });

    _allNameToFieldsMap = Map<String,FieldInfo>();
    _allfields!.forEach((element) {

      if (!DartCommon.isEmpty(element.name)) {
        var n = element.name.trim();
        if (_allNameToFieldsMap![n] != null){
          TableImporter.logger.appendLog(LogType.error,"重复的字段命名 ${n}");
          if (TableUtiles.iso == null) {
            BotToast.showText(text: "重复的字段命名 ${n}", contentColor: Colors.redAccent);
          }

        }
        else {
          _allNameToFieldsMap![n] = element;
        }
      }
      if (!DartCommon.isEmpty(element.alias)) {
        var alias = element.alias.trim();
        if (alias != element.name.trim()) {
          if (_allNameToFieldsMap![alias] != null) {
            TableImporter.logger.appendLog(LogType.error,"重复的字段命名 ${alias}");
            if (TableUtiles.iso == null) {
              BotToast.showText(text: "重复的字段别名 ${alias}", contentColor: Colors.redAccent);
            }

          }
          else {
            _allNameToFieldsMap![alias] = element;
          }
        }
      }

    });
    return _allfields;
  }

  void rebuildAllFields() {
    _allfields = null;
    _allfieldsMap = null;
    _allNameToFieldsMap = null;
    getAllFields();

    ObjectClazz.clazzes.forEach((key, value) {
      if (isParentOf(value)){
        value.rebuildAllFields();
      }
    });
  }

  _getFields(List<FieldInfo> outLst) {

    var baseClz = ObjectTableProject.instance!.clazzMap![baseClazz??""];
    if (baseClz != null){
      baseClz._getFields(outLst);
    }
    for(var f in fields){
      outLst.add(f);
    }

    decorations.forEach((key, value) {
      // print("----------------------------------- decoration ----------------------------------");
      outLst.add(value);
    });
  }

  List<String> getAllFieldNames() {
    List<String> names = <String>[];
    _getAllFieldNames(names);
    return names;
  }

  _getAllFieldNames(List<String> names) {
    var baseClz = ObjectTableProject.instance!.clazzMap![baseClazz??""];
    if (baseClz != null){
      baseClz._getAllFieldNames(names);
    }
    for(var f in fields){
      names.add(f.getTypeShowString());
    }
  }
  ObjectClazz? getBaseClazz(){
    var bc = baseClazz;
    if (DartCommon.isEmpty(bc)) return null;
    var bclz = ObjectClazz.clazzes[bc];
    return bclz;
  }
  bool containTag(String guid) {

    var exist =  tagFields.contains(guid);
    if (exist) return true;
    var baseClz = getBaseClazz();
    if (baseClz != null){
      return baseClz.containTag(guid);
    }
    return false;
  }

  List<String> getAllTagFields(){
    List<String> res = <String>[];
    _getAllTagFields(res);
    return res;
  }


  void _getAllTagFields(List<String> res){
    var baseClz = getBaseClazz();
    if (baseClz != null){
      baseClz._getAllTagFields(res);
    }

    tagFields.forEach((element) {
      res.add(element);
    });
  }

  void buildTags() {
    var objs = table!.objects;
    objs.forEach((element) {
      element.buildTag(getAllTagFields());
      // if (tagFields.length >0){
      //   var tag = "";
      //   int iCount = 0;
      //   tagFields.forEach((f) {
      //     var val = element.fieldValues[f]?.value??"[X]".toString();
      //     tag +=iCount>0?" "+val:val;
      //     iCount++;
      //   });
      //   element.name = tag;
      // }
      // else{
      //   element.name = null;
      // }
    });
  }
  List<String> dels = <String>[];
  void reorderTags() {
    Map<String,int> f2Ids = Map<String,int>();
    int iCount = 0;
    fields.forEach((element) {
      f2Ids[element.guid] = iCount ++;
    });
    dels = <String>[];
    tagFields.forEach((element) {
      if (!f2Ids.containsKey(element)){
        dels.add(element);
      }
    });
    dels.forEach((element) {
      tagFields.remove(element);
    });
    tagFields.sort((a,b){
      return f2Ids[a]! - f2Ids[b]!;
    });
    buildTags();
  }

  void combineGroup(List<String> fields) {
    print("combineGroup : $fields");
    var f2g = getFiled2GroupMap();
    String? groupId;
    for(var f in fields){
      if (f2g.containsKey(f) && groupId == null){
        groupId = f2g[f]!;
      }
    }

    if (groupId == null){
      var g = FieldGroup();
      groups[g.guid!] = g;
      groupId = g.guid;
    }
    var tgtGroup = groups[groupId];

    for(var f in fields){
      var oldGroupId = f2g[f];
      if (!tgtGroup!.fieldGuids.contains(f)) {
        tgtGroup.fieldGuids.add(f);
      }
      if (oldGroupId != groupId && oldGroupId !=null){
        groups[oldGroupId]!.fieldGuids.remove(f);
        EventCenter.eventBus.fire(AGroupChanged()..group = groups[oldGroupId]);
      }
    }

    EventCenter.eventBus.fire(AGroupChanged()..group = tgtGroup);
  }

  void uncombineGroup(List<String> fields) {
    var f2g = getFiled2GroupMap();
    for(var f in fields){
      if (f2g.containsKey(f)){
        var groupId = f2g[f];
        var tgtGroup = groups[groupId];
        if (tgtGroup == null) continue;
        tgtGroup.fieldGuids.remove(f);
        EventCenter.eventBus.fire(AGroupChanged()..group = tgtGroup);
      }
    }

  }
  void unSelectAll(){
    var fields = getAllFields();
    for(var f in fields!){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      if (fl == null) continue;
      var old = fl.selected??false;
      fl.selected = false;
      if (old != fl.selected ){
        EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = f.guid);
      }
    }
  }

  FieldLayout? _getFieldLayout(String id){
    var fl = fieldsLayouts[id];
    if (fl == null){
      if (!DartCommon.isEmpty(baseClazz)){
        var bclz = ObjectClazz.clazzes[baseClazz];
        if (bclz != null){
          var parent = bclz._getFieldLayout(id);
          if (parent != null){
            fieldsLayouts[id] = parent.clone();
            fl = fieldsLayouts[id];
          }
        }
      }
    }
    return fl;
  }

  FieldLayout getFieldLayoutById(String id){
    var fl = _getFieldLayout(id);

    if (fl == null){
      var fields = getAllFields();
      var fi = _allfieldsMap![id];
      var index = fields!.indexOf(fi!);
      fl = FieldLayout();
      fl.x = 0;
      fl.y = index * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);
      fieldsLayouts[id] = fl;
    }
    return fl;
  }

  FieldLayout getFieldLayout(FieldInfo fi){
    var fl = _getFieldLayout(fi.guid);

    if (fl == null){
      var fields = getAllFields();
      var index = fields!.indexOf(fi);
      fl = FieldLayout();
      fl.x = 0;
      fl.y = index * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);
      fieldsLayouts[fi.guid] = fl;
    }
    return fl;
  }


  void storeSelectedSize(){
    var fields = getAllFields();
    for(var f in fields!){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      if (!fl.selected) continue;

      if (fl.width<=0) fl.width = OTDefines.fieldViewWidth;
      if (fl.height<=0) fl.height = OTDefines.fieldViewHeight;
      fl.storeWidth = fl.width;
      fl.storeHeight = fl.height;
      if (fl.storeWidth!<=0) fl.storeWidth = OTDefines.fieldViewWidth;
      if (fl.storeHeight!<=0) fl.storeHeight = OTDefines.fieldViewHeight;
    }
  }

  void updateSelectedSize(Offset off , {bool bFixed = false}){
    var fields = getAllFields();
    for(var f in fields!){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      if (!fl.selected) continue;

      fl.width = fl.storeWidth! + off.dx;
      fl.height = fl.storeHeight! + off.dy;

      if (fl.width < OTDefines.fieldViewMinWidth ) fl.width = OTDefines.fieldViewMinWidth;
      if (fl.height < OTDefines.fieldViewMinHeight ) fl.height = OTDefines.fieldViewMinHeight;



      EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = f.guid);
      if (!bFixed){
        return;
      }

      var pos = Offset(fl.width,fl.height);
      pos = OTDefines.fixPosition(pos);
      fl.width = pos.dx ;
      fl.height = pos.dy ;
    }
  }


  void storeSelectedPos(){
    var fields = getAllFields();
    for(var f in fields!){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      if (!fl.selected) continue;
      fl.storeX = fl.x;
      fl.storeY = fl.y;
    }
  }

  void updateSelectedPos(Offset off , {bool bFixed = false}){
    var fields = getAllFields();
    for(var f in fields!){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      if (!fl.selected) continue;

      fl.x = fl.storeX! + off.dx;
      fl.y = fl.storeY! + off.dy;

      if (fl.x < 0 ) fl.x = 0;
      if (fl.y < 0 ) fl.y = 0;

      EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = f.guid);
      if (!bFixed){
        return;
      }

      var pos = Offset(fl.x,fl.y);
      pos = OTDefines.fixPosition(pos);
      fl.x = pos.dx ;
      fl.y = pos.dy ;
    }
  }


  void storePos(List<FieldInfo> fields){

    for(var f in fields){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      fl.storeX = fl.x;
      fl.storeY = fl.y;
    }
  }

  void updatePos(List<FieldInfo> fields , Offset off , {bool bFixed = false}){
    for(var f in fields){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];

      fl.x = fl.storeX! + off.dx;
      fl.y = fl.storeY! + off.dy;

      if (fl.x < 0 ) fl.x = 0;
      if (fl.y < 0 ) fl.y = 0;

      EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = f.guid);
      if (!bFixed){
        return;
      }

      var pos = Offset(fl.x,fl.y);
      pos = OTDefines.fixPosition(pos);
      fl.x = pos.dx ;
      fl.y = pos.dy ;
    }
  }

  void fixSelectedPos(){
    var fields = getAllFields();
    for(var f in fields!){
      var fl = getFieldLayout(f);//fieldsLayouts[f.guid];
      if (!fl.selected) continue;

      if (fl.x < 0 ) fl.x = 0;
      if (fl.y < 0 ) fl.y = 0;

      EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = f.guid);

      var pos = Offset(fl.x,fl.y);
      fl.x = pos.dx ;
      fl.y = pos.dy ;
    }
  }

  Map<String , FieldInfo>? getFieldMap(){
    if (_allfieldsMap != null) return _allfieldsMap;
    rebuildAllFields();
    return _allfieldsMap;
  }


  Map<String , FieldInfo>? getNameToFieldMap(){
    if (_allNameToFieldsMap != null) return _allNameToFieldsMap;
    rebuildAllFields();
    return _allNameToFieldsMap;
  }


  List<FieldInfo> getGroupFields(FieldGroup group) {
    List<FieldInfo> res = <FieldInfo>[];
    var fmap = getFieldMap();
    group.fieldGuids.forEach((element) {
      var f = fmap![element];
      if (f!= null){
        res.add(f);
      }
    });
    return res;
  }

  Rect getObjectRect({bool bEditMode = false}){
    // Rect res = Rect.fromLTRB(double.maxFinite, double.maxFinite, double.minPositive, double.minPositive);
    var left = double.maxFinite;
    var top = double.maxFinite;
    var right = double.minPositive;
    var bottom = double.minPositive;
    var clz = this;//widget.object.getClazz();
    var f2g = clz.getFiled2GroupMap();
    // Map<String , FieldGroup> fieldGuidToGroup = {};
    clz.groups.forEach((key, value) {
      // value.fieldGuids.forEach((element) {
      //   fieldGuidToGroup[element] = value;
      // });
      if (!(value.visible??value.defaultVisible)){
        return;
      }
      var r = value.getGroupRect(clz , bEditMode: bEditMode);
      left = min(left , r.left);
      top = min(top , r.top);
      right = max(right , r.right);
      bottom = max(bottom , r.bottom);
    });

    int iCount = 0;
    var fields = clz.getAllFields();
    fields!.forEach((element) {
      // return;
      if (f2g.containsKey(element.guid)) return;
      double x = 0;
      double y = iCount * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);
      double width = OTDefines.fieldViewWidth;
      double height = OTDefines.fieldViewHeight;

      var fl = clz.getFieldLayoutById(element.guid);
      if (fl != null){
        x = fl.x;
        y = fl.y;
        if (fl.width>0) width = fl.width;
        if (fl.height>0) height = fl.height;
      }
      left = min(left , x);
      top = min(top , y);
      right = max(right , x + width);
      bottom = max(bottom , y + height);
      ++iCount;
    });
    return Rect.fromLTRB(0 , 0 , right, bottom);
    // return Rect.fromLTRB(0 - OTDefines.frameBorderSize, 0 - OTDefines.frameBorderSize - OTDefines.objectHeaderHeight, right+OTDefines.frameBorderSize, bottom+OTDefines.frameBorderSize);
  }

  void cloneLayout(ObjectClazz copyObjectClazz) {
    copyObjectClazz.fieldsLayouts.forEach((key, value) {
      fieldsLayouts[key] = value.clone();
    });

    copyObjectClazz.groups.forEach((key, value) {
      groups[key] = value.clone();
    });


  }

  Map getDefaultValues() {
    Map res = Map();
    var clz = this;//getClazz();
    var fmap = clz?.getNameToFieldMap();
    if (fmap == null) return res ;

    fmap.forEach((key, f) {
      var vi = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      if (vi == null){
        return;
      }
      var finalVal = vi.otParseValue(f.defaultValue);
      res[f.name] = finalVal;
    });
    // var fres = {};
    // fres["guid"] = guid;
    // fres["isComment"] = isComment??"";
    // fres["comment"] = comment??"";
    // fres["fields"] = res;
    // fres["type"] = clz.name;
    return res;
  }
  List<FieldInfo>? _searchFields ;
  List<FieldInfo>? getSearchFields() {
    if (_searchFields != null) return _searchFields;
    rebuildSearchFields();
    return _searchFields;
  }

  void rebuildSearchFields() {
    _searchFields = <FieldInfo>[];
    _rebuildSearchFields(_searchFields!);
  }

  void _rebuildSearchFields(List<FieldInfo> lst) {
    var bclz = getBaseClazz();
    if (bclz != null) bclz._rebuildSearchFields(lst);
    fields.forEach((element) {
      if (element.isSearchKey){
        lst.add(element);
      }
    });
  }

  List getRefClazzes(){
    List res = [];
    fields.forEach((element) {
      var fo = element.exportInfo() as Map;
      if (fo == null) return ;
      if (fo["type"]["name"] == "ref"){
        var innerType1 = fo["type"]["innerType1"];
        if (innerType1 == null) return ;
        if (!res.contains(innerType1["name"])) res.add(innerType1["name"]);
      }
      if (fo["type"]["name"] == "List"){
        var innerType1 = fo["type"]["innerType1"];
        if (innerType1 == null) return ;
        if (innerType1["name"] == "ref"){
          var innerType1_1 = innerType1["innerType1"];
          if (innerType1_1 == null) return ;
          if (!res.contains(innerType1_1["name"]))res.add(innerType1_1["name"]);
        }
      }
      if (fo["type"]["name"] == "Map"){
        var innerType1 = fo["type"]["innerType1"];
        if (innerType1 == null) return ;
        if (innerType1["name"] == "ref"){
          var innerType1_1 = innerType1["innerType1"];
          if (innerType1_1 == null) return ;
          if (!res.contains(innerType1_1["name"]))res.add(innerType1_1["name"]);
        }
      }
    });
    return res;
  }

}