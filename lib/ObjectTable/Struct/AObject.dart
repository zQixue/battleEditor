  
import 'dart:collection';

import 'package:lpinyin/lpinyin.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSList.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSMap.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/Transition/PackSolver.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:sprintf/sprintf.dart';

part 'AObject.g.dart';

@JsonSerializable()
class AObject extends SSObjBase{
  @JsonKey(defaultValue: <String , dynamic>{})
  Map<String , FieldValueHolder> fieldValues = Map<String , FieldValueHolder>();

  @JsonKey(ignore: true)
  String? clazzGuid;

  @JsonKey(ignore: true)
  bool isDeleted = false;

  @JsonKey(defaultValue: "")
  String? comment;
  @JsonKey(defaultValue: "")
  String? group;
  @JsonKey(defaultValue: false)
  bool isComment = false;

  @JsonKey(ignore: true)
  String? namespace;


  getShowName(){
    //return "$name [${exportId??"--------"}]";
    // return "[${exportId??"--------"}] $name";
    return "$name";
  }
   getFieldValue(String guid){
    var fvh = fieldValues[guid];
    if (fvh == null) return null;
    return fvh.value;
  }

  setFieldValue(String guid , dynamic val , String name){
    FieldValueHolder v = FieldValueHolder()..value = val..name = name;
    fieldValues[guid] = v;
  }

  @override
  void export(ByteDataWriter bw) {

    bw.writeUint32(exportId??0 ,"object hash id : $guid.hash = ${guid.hashCode}");
    var objType = ObjectClazz.getClazz(clazzGuid!);
    objType!.export(bw , this);
  }


  AObject();
  //此处与类名一致，由指令自动生成代码
  factory AObject.fromJson(Map<String, dynamic> json) =>
      _$AObjectFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$AObjectToJson(this);

  String getSearchKey() {
    if (name == "" || name == null){
      return "$guid";
    }
    var pinyin1 = PinyinHelper.getShortPinyin(name);
    var pinyin2 = PinyinHelper.getPinyin(name);
    return "${pinyin1}_${pinyin2}_${exportId}_${name}_$guid";
  }

  String getTag(){
    //return "[${exportId??"--------"}] $name";
    if (!DartCommon.isEmpty(alias)) return alias;
    if (!DartCommon.isEmpty(name)) return name;
    return "${getClazz()?.getTypeShowString()??""} [${guid.substring(0,8)}]";
  }

  String getSearchID(){
    var clz = ObjectClazz.getClazz(clazzGuid!);
    var flst = clz!.getSearchFields();
    StringBuffer sb = StringBuffer();
    if (!DartCommon.isEmpty(namespace)){
      sb.write(namespace);
      sb.write("_");
    }
    sb.write(clazzGuid);
    sb.write("_");

    if(flst!.length>0) {
      flst.forEach((field) {
        // var field = flst[f];
        var fi = SSFieldType.getFieldType(field.typeGuid, fieldInfo: field);
        var val = fi!.parseValue(fieldValues[field.guid]?.value ?? ""); // parseValue(fieldValues[f]?.value??"");//.toString();
        sb.write(val);
        sb.write("_");
      });
    }
    else{
      sb.write(guid);
    }

    return sb.toString();
  }

  String getExportSearchID(){
    var clz = ObjectClazz.getClazz(clazzGuid!);
    var flst = clz!.getSearchFields();
    StringBuffer sb = StringBuffer();

    bool bFirst= true;
    if(flst!.length>0) {
      flst.forEach((field) {
        // var field = flst[f];
        if (!bFirst) sb.write(",");
        var fi = SSFieldType.getFieldType(field.typeGuid, fieldInfo: field);
        var val = fi!.exportValue(fieldValues[field.guid]?.value ?? ""); // parseValue(fieldValues[f]?.value??"");//.toString();
        sb.write(val);
        bFirst = false;
      });
    }
    else{
      // sb.write(guid);
    }

    return sb.toString();
  }

  String getSearchIDKeys(){
    var clz = ObjectClazz.getClazz(clazzGuid!);
    var flst = clz!.getSearchFields();
    StringBuffer sb = StringBuffer();
    flst!.forEach((field) {
      sb.write(field.getTypeShowString());
      sb.write("_");
    });

    return sb.toString();
  }

  String? getUniqueIDByField(FieldInfo? field){
    if (field == null) return null;
    // var clz = ObjectClazz.getClazz(clazzGuid);
    // var flst = clz.getSearchFields();
    StringBuffer sb = StringBuffer();
    sb.write("SK_");
    if (!DartCommon.isEmpty(namespace)){
      sb.write(namespace);
      sb.write("_");
    }
    sb.write(clazzGuid);
    sb.write("_");
    sb.write(field.guid);
    sb.write("_");

    var fi = SSFieldType.getFieldType(field.typeGuid, fieldInfo: field);
    var val = fi!.parseValue(fieldValues[field.guid]?.value ?? ""); // parseValue(fieldValues[f]?.value??"");//.toString();
    sb.write(val);
    sb.write("_");


    return sb.toString();
  }

  ObjInfo? getTransformInfo(objList) {
    var clz = ObjectClazz.getClazz(clazzGuid!);
    if (!clz!.syncTransform) return null;
    PackSolver.registerTransitionObject(this);
    return clz.getUnityTransformInfo(this,objList);
  }
  // @override
  dynamic exportCodeData() {
    var clz = ObjectClazz.getClazz(clazzGuid!);
    Map<String,dynamic> out = {'index' : exportId , 'nodeTypeId' : clz!.exportId , 'guid' : guid.hashCode};

//
//     print(name);
    List<dynamic> outData = <dynamic>[];
    clz.exportCodeData(outData , this);
    out['datas'] = outData;

    return out;
  }
  void rebuildTag() {
    var all = getClazz()?.getAllTagFields();
    if (all != null) buildTag(all);
  }
  void buildTag(List<String> tagFields) {
    // print("buildtag $tagFields");
      if (tagFields.length >0){
        var clz = ObjectClazz.getClazz(clazzGuid!);
        List vals = [];
        // Map<String,FieldInfo> fieldsMap = Map<String,FieldInfo>();
        // clz.fields.forEach((element) {
        //   fieldsMap[element.guid] = element;
        // });
        Map<String,FieldInfo>? fieldsMap = clz!.getFieldMap();

        tagFields.forEach((f) {
          var field = fieldsMap![f];
          var fi = SSFieldType.getFieldType(field!.typeGuid,fieldInfo: field);
          var val = fi!.getTagValue(fieldValues[f]?.value??"");// parseValue(fieldValues[f]?.value??"");//.toString();
          vals.add(val);
        });

        name = sprintf(clz.tagFormat,vals);
      }
      else{
        name = "";
      }
      if (!(OTDefines.inloading??false)){
        EventCenter.eventBus.fire(AObjectChanged()..obj = this);
      }
  }

  ObjectClazz? getClazz() {
    return ObjectClazz.clazzes[clazzGuid!];
  }

  void setFieldValueByName(String name, dynamic val , {bool sendEvent = false}) {
      var clz = getClazz();
      var fmap = clz?.getNameToFieldMap();
      if (fmap == null) return ;
      var f = fmap[name];
      if (f == null) return ;
      var vi = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      if (vi == null){
        throw(Exception("setFieldValueByName 获取变量类型失败 : ${clz!.name} ${f.name}"));
      }
      var finalVal = vi.otImportValue(val);

      FieldValueHolder v = FieldValueHolder()..value = finalVal..name = f.name;
      // if (fieldValues.containsKey(f.guid)){
      //   throw Exception("读入字段发现重复命名: ${f.name}");
      // }
      fieldValues[f.guid] = v;
      // if (!(OTDefines.inloading??false)){
        if (clz!.getAllTagFields().contains(f.guid)) {
          buildTag(clz.getAllTagFields());
          // EventCenter.eventBus.fire(AObjectChanged()..obj = this);
        }

      if (sendEvent){
        EventCenter.eventBus.fire(AFieldTransformChanged()..obj = this..fieldGuid = f.guid);
      }
      // }
  }

  Map toMap() {
    Map res = Map();
    var clz = getClazz();
    var fmap = clz?.getNameToFieldMap();
    if (fmap == null) return res ;
    Map aliases = Map();
    fmap.forEach((key, f) {
      var vi = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      if (vi == null){
        return;
      }
      var v = fieldValues[f.guid]?.value;
      if (v == null){
        v = f.defaultValue;
        // return;
      }
      aliases[f.name] = f.alias;
      var finalVal = vi.otParseValue(v);
      res[f.name] = finalVal;
    });
    var fres = {};
    fres["guid"] = guid;
    fres["name"] = name;
    fres["alias"] = alias;
    fres["group"] = group;
    fres["isComment"] = isComment;
    fres["comment"] = comment??"";
    fres["fields"] = res;
    fres["aliases"] = aliases;
    fres["type"] = clz!.name;
    fres["tag"] = getTag();
    return fres;
  }

  void appendListValueByName(String name, dynamic val) {
    var clz = getClazz();
    var fmap = clz?.getNameToFieldMap();
    if (fmap == null) return ;
    var f = fmap[name];
    if (f == null) return ;
    var vi = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);

    var finalVal = vi!.innerType0!.parseValue(val);
    var v = fieldValues[f.guid];
    if (v == null){
      v = fieldValues[f.guid] = FieldValueHolder()..value = [finalVal]..name = f.name;
    }
    else{
      // FieldValueHolder v = FieldValueHolder()..value = finalVal..name = f.name;
      // fieldValues[f.guid] = v;
      var lst = v.value??[];
      lst.add(finalVal);
    }
    // fieldValues[f.guid] = v;
    // if (!(OTDefines.inloading??false)){
      if (clz!.getAllTagFields().contains(f.guid)) {
        buildTag(clz.getAllTagFields());
        // EventCenter.eventBus.fire(AObjectChanged()..obj = this);
      }
    // }
  }
  @override
  copyTo(SSObjBase to){
    if (!(to is AObject)) return ;
    var toObj= to as AObject;
    if (toObj.clazzGuid != clazzGuid) return ;
    toObj.fieldValues.clear();
    fieldValues.forEach((key, value) {
      toObj.fieldValues[key] = FieldValueHolder()..name = value.name..value = value.value..fieldType = value.fieldType;
    });
    toObj.isComment = isComment;
    toObj.comment = comment;
    toObj.namespace = namespace;
    super.copyTo(to);

  }

  String getLogString(){
    StringBuffer sb = StringBuffer();
    sb.write("{ ");
    if (!DartCommon.isEmpty(namespace)){
      sb.write("空间 = ");
      var obj = ObjectClazz.allObjects[namespace];
      if (obj != null) sb.write(obj.getTypeShowString());
      else {
        if (namespace!.length > 8){
          var subnamespace = namespace!.substring(0,8);
          sb.write(subnamespace);
        }
      }
      sb.write(" ,");
    }
    sb.write(" tag =");
    sb.write(getTag());
    sb.write(" ,");
    sb.write(" guid = ");
    sb.write(guid.substring(0,8));
    sb.write(" }");
    return sb.toString();

  }
  @JsonKey(ignore: true)
  Map<String , Map<String,int>>? spaceObjectMap;
  //创建对象内部引用映射表
  void buildSpaceObjectMap(){
    var objType = ObjectClazz.getClazz(clazzGuid!);
    if(!objType!.buildSpaceMap) return ;

    spaceObjectMap = new Map<String , Map<String,int>>();
    HashSet<String> objStack = HashSet<String>();
    _collectSpaceObjects(spaceObjectMap!, this , objType , objStack);
    // print(spaceObjectMap);
  }

  static void _collectSpaceObjects(Map<String , Map<String,int>> res , AObject obj , ObjectClazz clz , HashSet<String> objStack){

    if (objStack.contains(obj.guid)) return ;
    objStack.add(obj.guid);

    var fields = clz.getAllFields();
    for (var field in fields! ){
      var ftp = SSFieldType.getFieldType(field.typeGuid,fieldInfo: field);

      if (ftp is FTObjectReference){
        // print(ftp.innerType0);
        var clz = ObjectClazz.getClazz(field.innerTypeGuid0);
        var objGuid = obj.fieldValues[field.guid]?.value;
        var subObj = ObjectClazz.allObjects[objGuid];
        if (clz != null && objGuid != null && subObj != null){
          var lst = res[field.innerTypeGuid0];
          if (lst == null) lst = res[field.innerTypeGuid0] = new Map<String,int>();
          lst[objGuid] = (lst[objGuid]??0) + 1;
          _collectSpaceObjects(res, subObj!, clz, objStack);

        }
      }

      if (ftp is SSList){
        var intp = SSFieldType.getFieldType(ftp.innerTypeGuid0);
        if (intp is FTObjectReference){
          var clz = ObjectClazz.getClazz(intp.innerTypeGuid0);
          if (clz != null) {
            var objInList = ftp.parseValue(obj.fieldValues[field.guid]?.value ?? []);
            for (var objid in objInList) {
              var subObj = ObjectClazz.allObjects[objid];
              if (subObj != null) {
                var lst = res[intp.innerTypeGuid0];
                if (lst == null) lst = res[intp.innerTypeGuid0] = new Map<String,int>();
                // lst.add(objid);
                lst[objid] = (lst[objid]??0) + 1;
                _collectSpaceObjects(res, subObj!, clz, objStack);
              }
            }
          }
        }
      }
      if (ftp is SSMap){
        var intp = SSFieldType.getFieldType(ftp.innerTypeGuid0);
        if (intp is FTObjectReference){
          var clz = ObjectClazz.getClazz(intp.innerTypeGuid0);
          if (clz != null) {
            var objInList = ftp.parseValue(obj.fieldValues[field.guid]?.value ?? []);
            objInList.forEach((element) {
              var key = element["key"];
              var val = element["value"];
              if (key != null && val != null) {
                var subObj = ObjectClazz.allObjects[val];
                if (subObj!=null) {
                  var lst = res[intp.innerTypeGuid0];
                  if (lst == null) lst = res[intp.innerTypeGuid0] = new Map<String,int>();
                  // lst.add(val);
                  lst[val] = (lst[val]??0) + 1;
                  _collectSpaceObjects(res, subObj!, clz, objStack);
                }
              }
            }
            );
          }
        }
      }
    }
  }

  //向 Unity 发送
  bool flush2Unity() {
    return TableImporter.flushObjectToUnity(this);
  }

  // Map convertToMap() {
  //
  // }
}