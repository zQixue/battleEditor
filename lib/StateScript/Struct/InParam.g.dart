// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InParam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InParam _$InParamFromJson(Map<String, dynamic> json) => InParam()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..paramType = json['paramType'] as String
  ..bindFieldGuid = json['bindFieldGuid'] as String? ?? ''
  ..dataId = json['dataId'] as int? ?? 0
  ..fieldId = json['fieldId'] as String? ?? '';

Map<String, dynamic> _$InParamToJson(InParam instance) {
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
  if (instance.paramType != null) res['paramType'] = instance.paramType;
  if (instance.bindFieldGuid != '')
    res['bindFieldGuid'] = instance.bindFieldGuid;
  if (instance.dataId != 0) res['dataId'] = instance.dataId;
  if (instance.fieldId != '') res['fieldId'] = instance.fieldId;
  return res;
}
