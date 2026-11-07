// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CodeBlocky.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeBlocky _$CodeBlockyFromJson(Map<String, dynamic> json) => CodeBlocky()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..blockyTypeId = json['blockyTypeId'] as String? ?? ''
  ..subBlockies = (json['subBlockies'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, CodeBlocky.fromJson(e as Map<String, dynamic>)),
      ) ??
      {}
  ..values = json['values'] as Map<String, dynamic>? ?? {}
  ..blockyBodys = (json['blockyBodys'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k,
            e == null ? null : BlockyList.fromJson(e as Map<String, dynamic>)),
      ) ??
      {};

Map<String, dynamic> _$CodeBlockyToJson(CodeBlocky instance) {
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
  if (instance.blockyTypeId != '') res['blockyTypeId'] = instance.blockyTypeId;
  if (instance.subBlockies != {}) res['subBlockies'] = instance.subBlockies;
  if (instance.values != {}) res['values'] = instance.values;
  if (instance.blockyBodys != {}) res['blockyBodys'] = instance.blockyBodys;
  return res;
}
