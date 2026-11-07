// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ScriptInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScriptInfo _$ScriptInfoFromJson(Map<String, dynamic> json) => ScriptInfo()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..group = json['group'] as String
  ..exportCharp = json['exportCharp'] as bool? ?? true
  ..exportLua = json['exportLua'] as bool? ?? true
  ..isModule = json['isModule'] as bool? ?? false
  ..category = json['category'] as String? ?? 'default'
  ..behavicAgentGuid = json['behavicAgentGuid'] as String? ?? ''
  ..pinned = json['pinned'] as bool? ?? false
  ..logicOrView = json['logicOrView'] as bool? ?? true
  ..specialExportPath = json['specialExportPath'] as String? ?? ''
  ..tagSet = json['tagSet'] == null
      ? null
      : TagSet.fromJson(json['tagSet'] as Map<String, dynamic>)
  ..moduleGuid = json['moduleGuid'] as String? ?? ''
  ..isTemplate = json['isTemplate'] as bool? ?? false;

Map<String, dynamic> _$ScriptInfoToJson(ScriptInfo instance) {
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
  if (instance.group != null) res['group'] = instance.group;
  if (instance.exportCharp != true) res['exportCharp'] = instance.exportCharp;
  if (instance.exportLua != true) res['exportLua'] = instance.exportLua;
  if (instance.isModule != false) res['isModule'] = instance.isModule;
  if (instance.category != 'default') res['category'] = instance.category;
  if (instance.behavicAgentGuid != '')
    res['behavicAgentGuid'] = instance.behavicAgentGuid;
  if (instance.pinned != false) res['pinned'] = instance.pinned;
  if (instance.logicOrView != true) res['logicOrView'] = instance.logicOrView;
  if (instance.specialExportPath != '')
    res['specialExportPath'] = instance.specialExportPath;
  if (instance.tagSet != null) res['tagSet'] = instance.tagSet;
  if (instance.moduleGuid != '') res['moduleGuid'] = instance.moduleGuid;
  if (instance.isTemplate != false && instance.isTemplate != null) res['isTemplate'] = instance.isTemplate;
  return res;
}
