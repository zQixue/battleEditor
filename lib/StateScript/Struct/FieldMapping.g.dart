// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FieldMapping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldMapping _$FieldMappingFromJson(Map<String, dynamic> json) => FieldMapping()
  ..srcName = json['srcName'] as String? ?? ''
  ..dstName = json['dstName'] as String? ?? ''
  ..defaultValueTemplate = json['defaultValueTemplate'] as String? ?? ''
  ..binaryReader = json['binaryReader'] as String? ?? '';

Map<String, dynamic> _$FieldMappingToJson(FieldMapping instance) {
  var res = Map<String, dynamic>();

  if (instance.srcName != '') res['srcName'] = instance.srcName;
  if (instance.dstName != '') res['dstName'] = instance.dstName;
  if (instance.defaultValueTemplate != '')
    res['defaultValueTemplate'] = instance.defaultValueTemplate;
  if (instance.binaryReader != '') res['binaryReader'] = instance.binaryReader;
  return res;
}
