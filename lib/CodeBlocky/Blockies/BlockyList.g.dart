// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BlockyList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockyList _$BlockyListFromJson(Map<String, dynamic> json) => BlockyList()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..blockies = (json['blockies'] as List<dynamic>?)
      ?.map((e) => CodeBlocky.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$BlockyListToJson(BlockyList instance) {
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
  if (instance.blockies != null) res['blockies'] = instance.blockies;
  return res;
}
