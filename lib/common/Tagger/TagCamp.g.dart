// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TagCamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagCamp _$TagCampFromJson(Map<String, dynamic> json) => TagCamp()
  ..tags = (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ATag.fromJson(e as Map<String, dynamic>)),
      ) ??
      {};

Map<String, dynamic> _$TagCampToJson(TagCamp instance) {
  var res = Map<String, dynamic>();

  if (instance.tags != {}) res['tags'] = instance.tags;
  return res;
}
