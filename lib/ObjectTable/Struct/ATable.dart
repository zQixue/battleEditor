 
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/Logger.dart';

part 'ATable.g.dart';

@JsonSerializable()
class ATable extends SSObjBase{

  @JsonKey(defaultValue: <dynamic>[])
  List<AObject> objects = <AObject>[];

  @JsonKey(ignore: true)
  String? clazzGuid;

  @JsonKey(ignore: true)
  Map<String , AObject>? objectMaps ;

  ATable();
  //此处与类名一致，由指令自动生成代码
  factory ATable.fromJson(Map<String, dynamic> json) =>
      _$ATableFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ATableToJson(this);

  AObject? getObjectByGuid(String guid){
    if (objectMaps == null){
      buildMap();
    }
    return objectMaps![guid];
  }

  void buildMap(){
    objectMaps = Map<String , AObject>();
    bool bUnique = true;
    objects.forEach((element) {
      if (objectMaps!.containsKey(element.guid)){
        //
        bUnique = false;
        TableImporter.logger.appendLog(LogType.warning,"namespace : ${TableUtiles.namespace} , 发现重名的 guid ： ${element.guid}");
        return;
      }
      objectMaps![element.guid] = element;
    });
    var clz = ObjectClazz.getClazz(clazzGuid??"");
    clz?.isAllKeyUnique = bUnique;
  }


  AObject addObject() {
    var obj = AObject();
    obj.clazzGuid = clazzGuid;
    objects.add(obj);
    ObjectClazz.registerObject(obj);
    buildMap();
    return obj;
  }

  AObject addObjectWithoutBuildMap({String? id}) {
    var obj = AObject();
    if (id != null){
      obj.guid = id;
    }
    obj.clazzGuid = clazzGuid;
    objects.add(obj);
    ObjectClazz.registerObject(obj);
    // buildMap();
    return obj;
  }

  void addExistObject(AObject obj) {
    // var obj = AObject();
    obj.clazzGuid = clazzGuid;
    objects.add(obj);
    ObjectClazz.registerObject(obj);
    buildMap();
  }

  void deleteObject(AObject obj){
    ObjectClazz.removeObject(obj);
    obj.isDeleted = true;
    objects.remove(obj);
    EventCenter.eventBus.fire(AObjectForceChanged()..obj = obj);
    buildMap();
  }

  // @override
  dynamic exportCodeData() {

    var outData = { 'name' : name ,"exportId" : exportId};
    List<dynamic> subnodes = [];
    for(var n in objects){
      // print(n.name);
      var nd = n.exportCodeData();
      // print(nd);
      subnodes.add(nd);
    }

    outData['objs'] = subnodes;

    return outData;
  }

  // void clear() {
  //   objects.forEach((obj) {
  //     ObjectClazz.removeObject(obj);
  //     obj.isDeleted = true;
  //     // EventCenter.eventBus.fire(AObjectForceChanged()..obj = obj);
  //   });
  //   objects.clear();
  //   buildMap();
  //
  // }
}