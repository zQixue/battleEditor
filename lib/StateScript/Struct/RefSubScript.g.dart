// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RefSubScript.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefSubScript _$RefSubScriptFromJson(Map<String, dynamic> json) => RefSubScript()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..scriptId = json['scriptId'] as String? ?? ''
  ..x = (json['x'] as num?)?.toDouble() ?? 0
  ..y = (json['y'] as num?)?.toDouble() ?? 0
  ..fullWidth = (json['fullWidth'] as num).toDouble()
  ..fullHeight = (json['fullHeight'] as num).toDouble();

Map<String, dynamic> _$RefSubScriptToJson(RefSubScript instance) {
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
  if (instance.scriptId != '') res['scriptId'] = instance.scriptId;
  if (instance.x != 0) res['x'] = instance.x;
  if (instance.y != 0) res['y'] = instance.y;
  if (instance.fullWidth != null) res['fullWidth'] = instance.fullWidth;
  if (instance.fullHeight != null) res['fullHeight'] = instance.fullHeight;
  return res;
}
