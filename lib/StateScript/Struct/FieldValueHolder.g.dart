// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FieldValueHolder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldValueHolder _$FieldValueHolderFromJson(Map<String, dynamic> json) =>
    FieldValueHolder()
      ..name = json['name'] as String?
      ..value = json['value']
      ..fieldType = json['fieldType'] as String?
      ..highlightEdit = json['highlightEdit'] as bool? ?? false
      ..dtis = (json['dtis'] as List<dynamic>?)
          ?.map((e) => DynamicTriggerInfo.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$FieldValueHolderToJson(FieldValueHolder instance) {
  var res = Map<String, dynamic>();

  if (instance.name != null) res['name'] = instance.name;
  if (instance.value != null) res['value'] = instance.value;
  if (instance.fieldType != null) res['fieldType'] = instance.fieldType;
  if (instance.highlightEdit != false)
    res['highlightEdit'] = instance.highlightEdit;
  if (instance.dtis != null) res['dtis'] = instance.dtis;
  return res;
}
