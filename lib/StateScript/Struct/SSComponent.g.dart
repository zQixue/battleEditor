// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SSComponent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SSComponent _$SSComponentFromJson(Map<String, dynamic> json) => SSComponent()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..fields = (json['fields'] as List<dynamic>?)
          ?.map((e) => SyncFieldInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..group = json['group'] as String? ?? '';

Map<String, dynamic> _$SSComponentToJson(SSComponent instance) {
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
  if (instance.fields != []) res['fields'] = instance.fields;
  if (instance.group != '') res['group'] = instance.group;
  return res;
}
