// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CBFunction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CBFunction _$CBFunctionFromJson(Map<String, dynamic> json) => CBFunction()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..localFields = (json['localFields'] as List<dynamic>?)
          ?.map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..params = (json['params'] as List<dynamic>?)
          ?.map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..active = json['active'] as bool? ?? true
  ..isAgent = json['isAgent'] as bool? ?? false;

Map<String, dynamic> _$CBFunctionToJson(CBFunction instance) {
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
  if (instance.localFields != []) res['localFields'] = instance.localFields;
  if (instance.params != []) res['params'] = instance.params;
  if (instance.active != true) res['active'] = instance.active;
  if (instance.isAgent != false) res['isAgent'] = instance.isAgent;
  return res;
}
