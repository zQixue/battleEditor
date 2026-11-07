// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConnectAssist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectAssist _$ConnectAssistFromJson(Map<String, dynamic> json) =>
    ConnectAssist()
      ..records = (json['records'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Map<String, int>.from(e as Map)),
          ) ??
          {};

Map<String, dynamic> _$ConnectAssistToJson(ConnectAssist instance) {
  var res = Map<String, dynamic>();

  if (instance.records != {}) res['records'] = instance.records;
  return res;
}
