// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StateScript.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateScript _$StateScriptFromJson(Map<String, dynamic> json) => StateScript()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..nodes = (json['nodes'] as List<dynamic>)
      .map((e) => StateScriptNode.fromJson(e as Map<String, dynamic>))
      .toList()
  ..portConnections = (json['portConnections'] as List<dynamic>?)
          ?.map((e) => PortConnection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..paramConnections = (json['paramConnections'] as List<dynamic>?)
          ?.map((e) => ParamConnection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..scriptFieldVars = (json['scriptFields'] as List<dynamic>?)
          ?.map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..nodeGroups = (json['nodeGroups'] as List<dynamic>?)
          ?.map((e) => NodeGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..subScripts = (json['subScripts'] as List<dynamic>?)
          ?.map((e) => RefSubScript.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..overrideFieldValues = (json['overrideFieldValues'] as Map<String, dynamic>?)
          ?.map(
        (k, e) =>
            MapEntry(k, FieldValueHolder.fromJson(e as Map<String, dynamic>)),
      ) ??
      {};

Map<String, dynamic> _$StateScriptToJson(StateScript instance) {
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
  if (instance.nodes != null) res['nodes'] = instance.nodes;
  if (instance.portConnections != [])
    res['portConnections'] = instance.portConnections;
  if (instance.paramConnections != [])
    res['paramConnections'] = instance.paramConnections;
  if (instance.scriptFieldVars != [])
    res['scriptFields'] = instance.scriptFieldVars;
  if (instance.nodeGroups != []) res['nodeGroups'] = instance.nodeGroups;
  if (instance.subScripts != []) res['subScripts'] = instance.subScripts;
  if (instance.overrideFieldValues != {})
    res['overrideFieldValues'] = instance.overrideFieldValues;
  return res;
}
