// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModuleInterface.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleInterface _$ModuleInterfaceFromJson(Map<String, dynamic> json) =>
    ModuleInterface()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..nodeGuid = json['nodeGuid'] as String? ?? ''
      ..interfaceGuid = json['interfaceGuid'] as String? ?? ''
      ..prio = json['prio'] as int? ?? 512
      ..type = $enumDecodeNullable(_$InterfaceTypeEnumMap, json['type']) ??
          InterfaceType.InPort
      ..x = (json['x'] as num?)?.toDouble()
      ..y = (json['y'] as num?)?.toDouble();

Map<String, dynamic> _$ModuleInterfaceToJson(ModuleInterface instance) {
  var res = Map<String, dynamic>();

  if (instance.guid != '') res['guid'] = instance.guid;
  if (instance.name != '') res['name'] = instance.name;
  if (instance.cname != '') res['cname'] = instance.cname;
  if (instance.alias != '') res['alias'] = instance.alias;
  if (instance.cateTag != '') res['cateTag'] = instance.cateTag;
  if (instance.index != -1) res['index'] = instance.index;
  if (instance.exportId != null) res['exportId'] = instance.exportId;
  if (instance.syncTransform != false)
    res['syncTransform'] = instance.syncTransform;
  if (instance.nodeGuid != '') res['nodeGuid'] = instance.nodeGuid;
  if (instance.interfaceGuid != '')
    res['interfaceGuid'] = instance.interfaceGuid;
  if (instance.prio != 512) res['prio'] = instance.prio;
  if (_$InterfaceTypeEnumMap[instance.type] != InterfaceType.InPort)
    res['type'] = _$InterfaceTypeEnumMap[instance.type];
  if (instance.x != null) res['x'] = instance.x;
  if (instance.y != null) res['y'] = instance.y;
  return res;
}

const _$InterfaceTypeEnumMap = {
  InterfaceType.InPort: 'InPort',
  InterfaceType.OutPort: 'OutPort',
  InterfaceType.InParam: 'InParam',
  InterfaceType.OutParam: 'OutParam',
};
