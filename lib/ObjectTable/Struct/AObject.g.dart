// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AObject _$AObjectFromJson(Map<String, dynamic> json) => AObject()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..fieldValues = (json['fieldValues'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, FieldValueHolder.fromJson(e as Map<String, dynamic>)),
      ) ??
      {}
  ..comment = json['comment'] as String? ?? ''
  ..group = json['group'] as String? ?? ''
  ..isComment = json['isComment'] as bool? ?? false;

Map<String, dynamic> _$AObjectToJson(AObject instance) {
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
  if (instance.fieldValues != {}) res['fieldValues'] = instance.fieldValues;
  if (instance.comment != '') res['comment'] = instance.comment;
  if (instance.group != '') res['group'] = instance.group;
  if (instance.isComment != false) res['isComment'] = instance.isComment;
  return res;
}
