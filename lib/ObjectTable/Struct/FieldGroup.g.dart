// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FieldGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldGroup _$FieldGroupFromJson(Map<String, dynamic> json) => FieldGroup()
  ..tag = json['tag'] as String? ?? ''
  ..x = (json['x'] as num?)?.toDouble() ?? 0
  ..y = (json['y'] as num?)?.toDouble() ?? 0
  ..width = (json['width'] as num?)?.toDouble() ?? 320.0
  ..height = (json['height'] as num?)?.toDouble() ?? 320.0
  ..guid = json['guid'] as String?
  ..name = json['name'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..desc = json['desc'] as String? ?? ''
  ..showTitle = json['showTitle'] as bool? ?? true
  ..bgColor = json['bgColor'] as int?
  ..defaultVisible = json['defaultVisible'] as bool? ?? true
  ..fieldGuids = (json['fieldGuids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [];

Map<String, dynamic> _$FieldGroupToJson(FieldGroup instance) {
  var res = Map<String, dynamic>();

  if (instance.tag != '') res['tag'] = instance.tag;
  if (instance.x != 0) res['x'] = instance.x;
  if (instance.y != 0) res['y'] = instance.y;
  if (instance.width != 320.0) res['width'] = instance.width;
  if (instance.height != 320.0) res['height'] = instance.height;
  if (instance.guid != null) res['guid'] = instance.guid;
  if (instance.name != '') res['name'] = instance.name;
  if (instance.alias != '') res['alias'] = instance.alias;
  if (instance.desc != '') res['desc'] = instance.desc;
  if (instance.showTitle != true) res['showTitle'] = instance.showTitle;
  if (instance.bgColor != null) res['bgColor'] = instance.bgColor;
  if (instance.defaultVisible != true)
    res['defaultVisible'] = instance.defaultVisible;
  if (instance.fieldGuids != []) res['fieldGuids'] = instance.fieldGuids;
  return res;
}
