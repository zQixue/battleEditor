// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BehavicAgentMethod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BehavicAgentMethod _$BehavicAgentMethodFromJson(Map<String, dynamic> json) =>
    BehavicAgentMethod()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..isStatic = json['isStatic'] as bool? ?? false
      ..isPublic = json['isPublic'] as bool? ?? true
      ..returnType = json['returnType'] == null
          ? null
          : FieldInfo.fromJson(json['returnType'] as Map<String, dynamic>)
      ..withReturn = json['withReturn'] as bool? ?? false
      ..hide = json['hide'] as bool? ?? false
      ..params = (json['params'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, FieldInfo.fromJson(e as Map<String, dynamic>)),
          ) ??
          {}
      ..desc = json['desc'] as String? ?? '';

Map<String, dynamic> _$BehavicAgentMethodToJson(BehavicAgentMethod instance) {
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
  if (instance.isStatic != false) res['isStatic'] = instance.isStatic;
  if (instance.isPublic != true) res['isPublic'] = instance.isPublic;
  if (instance.returnType != null) res['returnType'] = instance.returnType;
  if (instance.withReturn != false) res['withReturn'] = instance.withReturn;
  if (instance.hide != false) res['hide'] = instance.hide;
  if (instance.params != {}) res['params'] = instance.params;
  if (instance.desc != '') res['desc'] = instance.desc;
  return res;
}
