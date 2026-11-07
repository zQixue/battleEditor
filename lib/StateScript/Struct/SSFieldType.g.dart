// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SSFieldType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SSFieldType _$SSFieldTypeFromJson(Map<String, dynamic> json) => SSFieldType()
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
  ..priority = json['priority'] as int? ?? 1024;

Map<String, dynamic> _$SSFieldTypeToJson(SSFieldType instance) {
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
  return res;
}
