// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BehavicAgentProject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BehavicAgentProject _$BehavicAgentProjectFromJson(Map<String, dynamic> json) =>
    BehavicAgentProject()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..enums = (json['enums'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, SSEnumType.fromJson(e as Map<String, dynamic>)),
          ) ??
          {};

Map<String, dynamic> _$BehavicAgentProjectToJson(BehavicAgentProject instance) {
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
  if (instance.enums != {}) res['enums'] = instance.enums;
  return res;
}
