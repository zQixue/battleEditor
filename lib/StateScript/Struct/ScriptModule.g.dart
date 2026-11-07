// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ScriptModule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScriptModule _$ScriptModuleFromJson(Map<String, dynamic> json) => ScriptModule()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..savePath = json['savePath'] as String? ?? ''
  ..tagSet = json['tagSet'] == null
      ? null
      : TagSet.fromJson(json['tagSet'] as Map<String, dynamic>)
  ..color = json['color'] as int? ?? 4294967295
  ..iconCode = json['iconCode'] as int? ?? 0;

Map<String, dynamic> _$ScriptModuleToJson(ScriptModule instance) {
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
  if (instance.savePath != '') res['savePath'] = instance.savePath;
  if (instance.tagSet != null) res['tagSet'] = instance.tagSet;
  if (instance.color != 4294967295) res['color'] = instance.color;
  if (instance.iconCode != 0) res['iconCode'] = instance.iconCode;
  return res;
}
