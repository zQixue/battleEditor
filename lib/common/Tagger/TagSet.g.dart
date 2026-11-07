// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TagSet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagSet _$TagSetFromJson(Map<String, dynamic> json) => TagSet()
  ..tagGuids =
      (json['tagGuids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [];

Map<String, dynamic> _$TagSetToJson(TagSet instance) {
  var res = Map<String, dynamic>();

  if (instance.tagGuids != []) res['tagGuids'] = instance.tagGuids;
  return res;
}
