// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NodeCamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeCamp _$NodeCampFromJson(Map<String, dynamic> json) => NodeCamp()
  ..nodeStructs = (json['nodeStructs'] as List<dynamic>?)
          ?.map((e) => NodeStructData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..enums = (json['enums'] as List<dynamic>?)
          ?.map((e) => SSEnumType.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..agents = (json['agents'] as List<dynamic>?)
          ?.map((e) => SSAgent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..components = (json['components'] as List<dynamic>?)
          ?.map((e) => SSComponent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

Map<String, dynamic> _$NodeCampToJson(NodeCamp instance) {
  var res = Map<String, dynamic>();

  if (instance.nodeStructs != []) res['nodeStructs'] = instance.nodeStructs;
  if (instance.enums != []) res['enums'] = instance.enums;
  if (instance.agents != []) res['agents'] = instance.agents;
  if (instance.components != []) res['components'] = instance.components;
  return res;
}
