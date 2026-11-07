// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FieldLayout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldLayout _$FieldLayoutFromJson(Map<String, dynamic> json) => FieldLayout()
  ..tag = json['tag'] as String? ?? ''
  ..showTitle = json['showTitle'] as bool? ?? true
  ..x = (json['x'] as num?)?.toDouble() ?? 0
  ..y = (json['y'] as num?)?.toDouble() ?? 0
  ..width = (json['width'] as num?)?.toDouble() ?? 320.0
  ..height = (json['height'] as num?)?.toDouble() ?? 320.0;

Map<String, dynamic> _$FieldLayoutToJson(FieldLayout instance) {
  var res = Map<String, dynamic>();

  if (instance.tag != '') res['tag'] = instance.tag;
  if (instance.showTitle != true) res['showTitle'] = instance.showTitle;
  if (instance.x != 0) res['x'] = instance.x;
  if (instance.y != 0) res['y'] = instance.y;
  if (instance.width != 320.0) res['width'] = instance.width;
  if (instance.height != 320.0) res['height'] = instance.height;
  return res;
}
