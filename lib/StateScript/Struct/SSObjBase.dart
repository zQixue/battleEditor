
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:uuid/uuid.dart';
 
import 'package:json_annotation/json_annotation.dart';

part 'SSObjBase.g.dart';

@JsonSerializable()
class SSObjBase{
  @JsonKey(defaultValue: "")
  String guid = "";
  @JsonKey(defaultValue: "")
  String name = "";
  @JsonKey(defaultValue: "")
  String cname = "";
  @JsonKey(defaultValue: "")
  String alias = "";
  @JsonKey(defaultValue: "")
  String cateTag = "";

  @JsonKey(defaultValue: -1)
  int index = -1;

  static void sortByIndex(List<SSObjBase> lst){
    lst.sort((a,b)=>a.index - b.index);
  }

  static void refreshIndex(List<SSObjBase> lst){
    int count = 0;
    lst.forEach((element) {element.index = count++;});
  }

  @JsonKey(ignore: true)
  bool inEditName = false;

  //不要有默认值，保持空
  int? exportId ;

  @JsonKey(defaultValue: false)
  bool syncTransform = false;

  // //是否可以引用
  // @JsonKey(defaultValue: true)
  // bool refable = true;

  void getUnityTransformInfo(data, objList){
    return null;
  }

  void setUnityTransformInfo(ObjInfo udata , data){

  }

  void rebuildGuid(){
    guid = Uuid().v4();
    exportId = null;
  }

  static int getFreeId(Map<int,bool> idMaps){
    for(int i = 1 ; ; ++i){
      if (idMaps[i] != null) continue;
      return i;
    }
    throw Exception("getFreeId 错误，未找到空闲id");
  }
  static void buildExportId(List<SSObjBase> objs){
    var maxId = -1;
    Map<int,bool> m_exists = Map<int,bool>();
    for(var obj in objs){
      if (obj.exportId != null && m_exists[obj.exportId] == true){
        obj.exportId = null;
      }
      if (obj.exportId != null ){
        m_exists[obj!.exportId!] = true;
      }
      if (obj.exportId != null && obj.exportId! >=0 && obj.exportId! > maxId){
        maxId = obj.exportId!;
      }
    }
    for(var obj in objs){
      if (obj.exportId == null || obj.exportId! <0){
        // obj.exportId = ++maxId;
        obj.exportId = getFreeId(m_exists);
        m_exists[obj.exportId!] = true;
      }
    }
  }

  static List<int> buildHashExportId(List<SSObjBase> objs){

    Map<int,bool> exists = Map<int,bool>();
    // exists[0] = true;
    for(var obj in objs){
      if (obj.exportId != null && exists[obj.exportId] == true){
        obj.exportId = null;
      }
      if (obj.exportId != null ){
        exists[obj.exportId!] = true;
      }
    }

    for(var obj in objs){
      if (obj.exportId != null ) continue;
      var aguid = obj.guid;
      obj.exportId = aguid.hashCode;
      while (exists[obj.exportId] == true){
        aguid = "${aguid}_";
        obj.exportId = aguid.hashCode;
      }

      if (obj.exportId! > 0x7FFFFFFF){
        print("!!! error !!! 哈希 id 溢出 ${aguid}.hash = ${obj.exportId}");
      }
      exists[obj.exportId!] = true;
    }

    return exists.keys.toList();
  }

  static void buildHashDataIdWithExist(List<dynamic> objs , List<int> existHashs){

    Map<int,bool> exists = Map<int,bool>();
    // exists[0] = true;

    for(var obj in objs){
      if (obj.dataId == 0 || (obj.dataId != null && exists[obj.dataId] == true)){
        obj.dataId = null;
      }
      if (obj.dataId != null ){
        exists[obj.dataId] = true;
      }
    }

    for(var h in existHashs){
      exists[h] = true;
    }
    // exists[0] = true;

    for(var obj in objs){
      if (obj.dataId != null ) continue;
      var aguid = obj.guid;
      obj.dataId = aguid.hashCode;
      while (exists[obj.dataId] == true){
        aguid = "${aguid}_";
        obj.dataId = aguid.hashCode;
      }

      if (obj.dataId > 0x7FFFFFFF){
        print("!!! error !!! 哈希 id 溢出 ${aguid}.hash = ${obj.dataId}");
      }
      exists[obj.dataId] = true;
    }

    for(var obj in objs){
      if (!existHashs.contains(obj.dataId)){
        existHashs.add(obj.dataId);
      }
    }
  }

  static void buildFieldHashDataIdWithExist(List<FieldInfo> objs , List<int> existHashs){

    Map<int,bool> exists = Map<int,bool>();
    // exists[0] = true;

    for(var obj in objs){
      if (obj.dataId == 0 || (obj.dataId != null && exists[obj.dataId] == true)){
        obj.dataId = null;
      }
      if (obj.dataId != null ){
        exists[obj.dataId!] = true;
      }
    }

    for(var h in existHashs){
      exists[h] = true;
    }
    // exists[0] = true;

    for(var obj in objs){
      if (obj.dataId != null ) continue;
      var aguid = obj.getFullGuidWithType();
      obj.dataId = aguid.hashCode;
      while (exists[obj.dataId] == true){
        aguid = "${aguid}_";
        obj.dataId = aguid.hashCode;
      }

      if (obj.dataId! > 0x7FFFFFFF){
        print("!!! error !!! 哈希 id 溢出 ${aguid}.hash = ${obj.dataId}");
      }
      exists[obj.dataId!] = true;
    }

    for(var obj in objs){
      if (!existHashs.contains(obj.dataId)){
        existHashs.add(obj.dataId!);
      }
    }
  }

  SSObjBase(){
    guid = Uuid().v4();
  }

  String getTypeShowString(){
    if (alias != null && alias != "") return alias;
    if (name != null && name != "") return name;
    return guid.substring(0,8);
  }

  String getShowStringAndName(){
    var res = getTypeShowString();
    if (res != name){
      res += " "+name;
    }
    return res;
  }

  copyTo(SSObjBase to){
    to.name = name;
    to.alias = alias;
  }


  //此处与类名一致，由指令自动生成代码
  factory SSObjBase.fromJson(Map<String, dynamic> json) =>
      _$SSObjBaseFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSObjBaseToJson(this);
}