// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResourceList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceList _$ResourceListFromJson(Map<String, dynamic> json) => ResourceList()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..targetPath = json['targetPath'] as String? ?? ''
  ..searchPattern = json['searchPattern'] as String? ?? ''
  ..recursively = json['recursively'] as bool? ?? false;

Map<String, dynamic> _$ResourceListToJson(ResourceList instance) {
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
  if (instance.targetPath != '') res['targetPath'] = instance.targetPath;
  if (instance.searchPattern != '')
    res['searchPattern'] = instance.searchPattern;
  if (instance.recursively != false) res['recursively'] = instance.recursively;
  return res;
}
