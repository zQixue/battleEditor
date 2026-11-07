// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BehavicAgentClass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BehavicAgentClass _$BehavicAgentClassFromJson(Map<String, dynamic> json) =>
    BehavicAgentClass()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..innerTypeGuid0 = json['innerTypeGuid0'] as String
      ..innerTypeGuid1 = json['innerTypeGuid1'] as String
      ..innerTypeCount = json['innerTypeCount'] as int? ?? 0
      ..flag = json['flag'] as int? ?? 0
      ..priority = json['priority'] as int? ?? 1024
      ..fields = (json['fields'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, FieldInfo.fromJson(e as Map<String, dynamic>)),
          ) ??
          {}
      ..methods = (json['methods'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, BehavicAgentMethod.fromJson(e as Map<String, dynamic>)),
          ) ??
          {}
      ..group = json['group'] as String? ?? ''
      ..baseAgentGuid = json['baseAgentGuid'] as String? ?? ''
      ..isStruct = json['isStruct'] as bool? ?? false
      ..desc = json['desc'] as String? ?? ''
      ..exportPath = json['exportPath'] as String? ?? ''
      ..namespace = json['namespace'] as String? ?? ''
      ..needExportCode = json['needExportCode'] as bool? ?? true;

Map<String, dynamic> _$BehavicAgentClassToJson(BehavicAgentClass instance) {
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
  if (instance.innerTypeGuid0 != null)
    res['innerTypeGuid0'] = instance.innerTypeGuid0;
  if (instance.innerTypeGuid1 != null)
    res['innerTypeGuid1'] = instance.innerTypeGuid1;
  if (instance.innerTypeCount != 0)
    res['innerTypeCount'] = instance.innerTypeCount;
  if (instance.flag != 0) res['flag'] = instance.flag;
  if (instance.priority != 1024) res['priority'] = instance.priority;
  if (instance.fields != {}) res['fields'] = instance.fields;
  if (instance.methods != {}) res['methods'] = instance.methods;
  if (instance.group != '') res['group'] = instance.group;
  if (instance.baseAgentGuid != '')
    res['baseAgentGuid'] = instance.baseAgentGuid;
  if (instance.isStruct != false) res['isStruct'] = instance.isStruct;
  if (instance.desc != '') res['desc'] = instance.desc;
  if (instance.exportPath != '') res['exportPath'] = instance.exportPath;
  if (instance.namespace != '') res['namespace'] = instance.namespace;
  if (instance.needExportCode != true)
    res['needExportCode'] = instance.needExportCode;
  return res;
}
