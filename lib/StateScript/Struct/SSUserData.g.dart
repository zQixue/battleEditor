// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SSUserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SSUserData _$SSUserDataFromJson(Map<String, dynamic> json) => SSUserData()
  ..scriptListExpandedFlags =
      (json['scriptListExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..moduleListExpandedFlags =
      (json['moduleListExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..templateListExpandedFlags =
      (json['templateListExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..nodeStructListExpandedFlags =
      (json['nodeStructListExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..agentListExpandedFlags =
      (json['agentListExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..componentListExpandedFlags =
      (json['componentListExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..tempElementExpandedFlags =
      (json['tempElementExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..tempFilesExpandedFlags =
      (json['tempFilesExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..behavicAgentExpandedFlags =
      (json['behavicAgentExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..nodeSelectorExpandedFlags =
      (json['nodeSelectorExpandedFlags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
  ..debugMode = json['debugMode'] as bool? ?? false;

Map<String, dynamic> _$SSUserDataToJson(SSUserData instance) {
  var res = Map<String, dynamic>();

  if (instance.scriptListExpandedFlags != {})
    res['scriptListExpandedFlags'] = instance.scriptListExpandedFlags;
  if (instance.moduleListExpandedFlags != {})
    res['moduleListExpandedFlags'] = instance.moduleListExpandedFlags;
  if (instance.templateListExpandedFlags != {})
    res['templateListExpandedFlags'] = instance.templateListExpandedFlags;
  if (instance.nodeStructListExpandedFlags != {})
    res['nodeStructListExpandedFlags'] = instance.nodeStructListExpandedFlags;
  if (instance.agentListExpandedFlags != {})
    res['agentListExpandedFlags'] = instance.agentListExpandedFlags;
  if (instance.componentListExpandedFlags != {})
    res['componentListExpandedFlags'] = instance.componentListExpandedFlags;
  if (instance.tempElementExpandedFlags != {})
    res['tempElementExpandedFlags'] = instance.tempElementExpandedFlags;
  if (instance.tempFilesExpandedFlags != {})
    res['tempFilesExpandedFlags'] = instance.tempFilesExpandedFlags;
  if (instance.behavicAgentExpandedFlags != {})
    res['behavicAgentExpandedFlags'] = instance.behavicAgentExpandedFlags;
  if (instance.nodeSelectorExpandedFlags != {})
    res['nodeSelectorExpandedFlags'] = instance.nodeSelectorExpandedFlags;
  if (instance.debugMode != false) res['debugMode'] = instance.debugMode;
  return res;
}
