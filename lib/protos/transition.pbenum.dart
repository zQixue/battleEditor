///
//  Generated code. Do not modify.
//  source: transition.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class OPackType extends $pb.ProtobufEnum {
  static const OPackType O2U_FullObjects = OPackType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_FullObjects');
  static const OPackType O2U_SigleObject = OPackType._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_SigleObject');
  static const OPackType O2U_ReloadScript = OPackType._(20, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_ReloadScript');
  static const OPackType O2U_DeleteObject = OPackType._(30, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_DeleteObject');
  static const OPackType O2U_RTRefreshNodeData = OPackType._(40, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_RTRefreshNodeData');
  static const OPackType O2U_RTRefreshScriptData = OPackType._(50, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_RTRefreshScriptData');
  static const OPackType O2U_DebugInfos = OPackType._(60, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_DebugInfos');
  static const OPackType O2U_StepMode = OPackType._(75, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_StepMode');
  static const OPackType O2U_StepForward = OPackType._(70, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_StepForward');
  static const OPackType O2U_StepForwardAndStop = OPackType._(71, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_StepForwardAndStop');
  static const OPackType O2U_RefreshFunction = OPackType._(80, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_RefreshFunction');
  static const OPackType O2U_OpenRuntimeShowObject = OPackType._(81, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OpenRuntimeShowObject');
  static const OPackType O2U_CloseRuntimeShowObject = OPackType._(82, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_CloseRuntimeShowObject');
  static const OPackType O2U_EnableBreakPoints = OPackType._(88, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_EnableBreakPoints');
  static const OPackType O2U_DisableBreakPoints = OPackType._(89, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_DisableBreakPoints');
  static const OPackType O2U_AddBreakPoint = OPackType._(90, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_AddBreakPoint');
  static const OPackType O2U_RemoveBreakPoint = OPackType._(96, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_RemoveBreakPoint');
  static const OPackType O2U_ClearBreakPoints = OPackType._(98, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_ClearBreakPoints');
  static const OPackType O2U_FrameStepMode = OPackType._(1201, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_FrameStepMode');
  static const OPackType O2U_ExitFrameStepMode = OPackType._(1203, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_ExitFrameStepMode');
  static const OPackType O2U_FocusFrameMode = OPackType._(1204, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_FocusFrameMode');
  static const OPackType O2U_ExitFocusFrameMode = OPackType._(1205, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_ExitFocusFrameMode');
  static const OPackType O2U_RuntimeSetTime = OPackType._(1200, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_RuntimeSetTime');
  static const OPackType O2U_RunWithScript = OPackType._(1210, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_RunWithScript');
  static const OPackType O2SO_OpenMLScript = OPackType._(1220, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2SO_OpenMLScript');
  static const OPackType O2U_OpenScene = OPackType._(1221, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OpenScene');
  static const OPackType O2U_OpenMap = OPackType._(1222, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OpenMap');
  static const OPackType U2O_UpdateTransform = OPackType._(100, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_UpdateTransform');
  static const OPackType U2O_RuntimeState = OPackType._(101, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_RuntimeState');
  static const OPackType U2O_RuntimeClear = OPackType._(102, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_RuntimeClear');
  static const OPackType U2O_LevelSelected = OPackType._(103, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_LevelSelected');
  static const OPackType U2O_FocusNode = OPackType._(104, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_FocusNode');
  static const OPackType U2O_CreateNode = OPackType._(120, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_CreateNode');
  static const OPackType U2O_DeleteNode = OPackType._(122, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_DeleteNode');
  static const OPackType U2O_PlayingState = OPackType._(130, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_PlayingState');
  static const OPackType U2O_StepBlocked = OPackType._(140, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_StepBlocked');
  static const OPackType U2O_VarValues = OPackType._(150, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_VarValues');
  static const OPackType U2O_ResponceRuntimeSetTime = OPackType._(1206, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_ResponceRuntimeSetTime');
  static const OPackType O2U_MAP_SynTime = OPackType._(1000, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MAP_SynTime');
  static const OPackType O2U_MAP_DeleteObject = OPackType._(1002, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MAP_DeleteObject');
  static const OPackType O2U_MAP_SyncObject = OPackType._(1003, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MAP_SyncObject');
  static const OPackType O2U_MAP_FocusNode = OPackType._(1004, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MAP_FocusNode');
  static const OPackType O2U_MAP_SyncTimeline = OPackType._(1010, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MAP_SyncTimeline');
  static const OPackType O2U_MAP_Sync2Unity = OPackType._(1100, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MAP_Sync2Unity');
  static const OPackType O2U_OT_OPEN_SCENE = OPackType._(1501, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OT_OPEN_SCENE');
  static const OPackType O2U_OT_CREATE_OBJECT = OPackType._(1502, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OT_CREATE_OBJECT');
  static const OPackType O2U_OT_REFRESH_SCENE_WITH_OBJECTS = OPackType._(1503, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OT_REFRESH_SCENE_WITH_OBJECTS');
  static const OPackType O2U_OT_SELECT_OBJECT = OPackType._(1504, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OT_SELECT_OBJECT');
  static const OPackType O2U_OT_TRANSFORM_CHANGED = OPackType._(1505, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OT_TRANSFORM_CHANGED');
  static const OPackType O2U_OT_CREATE_MAP = OPackType._(1506, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_OT_CREATE_MAP');
  static const OPackType U2O_OT_TRANSFORM_CHANGED = OPackType._(1601, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_OT_TRANSFORM_CHANGED');
  static const OPackType U2O_OT_SELECT_OBJECT = OPackType._(1602, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_OT_SELECT_OBJECT');
  static const OPackType U2O_MAP_SelectMap = OPackType._(2000, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_MAP_SelectMap');
  static const OPackType U2O_MAP_DeleteObject = OPackType._(2002, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_MAP_DeleteObject');
  static const OPackType U2O_MAP_SyncObject = OPackType._(2003, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_MAP_SyncObject');
  static const OPackType U2O_MAP_FocusNode = OPackType._(2004, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_MAP_FocusNode');
  static const OPackType O2U_MLSkill_CSVUpdate = OPackType._(8001, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_MLSkill_CSVUpdate');
  static const OPackType U2O_Log = OPackType._(9001, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'U2O_Log');
  static const OPackType O2U_LOG_NODE_PORT_DATA = OPackType._(9100, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'O2U_LOG_NODE_PORT_DATA');

  static const $core.List<OPackType> values = <OPackType> [
    O2U_FullObjects,
    O2U_SigleObject,
    O2U_ReloadScript,
    O2U_DeleteObject,
    O2U_RTRefreshNodeData,
    O2U_RTRefreshScriptData,
    O2U_DebugInfos,
    O2U_StepMode,
    O2U_StepForward,
    O2U_StepForwardAndStop,
    O2U_RefreshFunction,
    O2U_OpenRuntimeShowObject,
    O2U_CloseRuntimeShowObject,
    O2U_EnableBreakPoints,
    O2U_DisableBreakPoints,
    O2U_AddBreakPoint,
    O2U_RemoveBreakPoint,
    O2U_ClearBreakPoints,
    O2U_FrameStepMode,
    O2U_ExitFrameStepMode,
    O2U_FocusFrameMode,
    O2U_ExitFocusFrameMode,
    O2U_RuntimeSetTime,
    O2U_RunWithScript,
    O2SO_OpenMLScript,
    O2U_OpenScene,
    O2U_OpenMap,
    U2O_UpdateTransform,
    U2O_RuntimeState,
    U2O_RuntimeClear,
    U2O_LevelSelected,
    U2O_FocusNode,
    U2O_CreateNode,
    U2O_DeleteNode,
    U2O_PlayingState,
    U2O_StepBlocked,
    U2O_VarValues,
    U2O_ResponceRuntimeSetTime,
    O2U_MAP_SynTime,
    O2U_MAP_DeleteObject,
    O2U_MAP_SyncObject,
    O2U_MAP_FocusNode,
    O2U_MAP_SyncTimeline,
    O2U_MAP_Sync2Unity,
    O2U_OT_OPEN_SCENE,
    O2U_OT_CREATE_OBJECT,
    O2U_OT_REFRESH_SCENE_WITH_OBJECTS,
    O2U_OT_SELECT_OBJECT,
    O2U_OT_TRANSFORM_CHANGED,
    O2U_OT_CREATE_MAP,
    U2O_OT_TRANSFORM_CHANGED,
    U2O_OT_SELECT_OBJECT,
    U2O_MAP_SelectMap,
    U2O_MAP_DeleteObject,
    U2O_MAP_SyncObject,
    U2O_MAP_FocusNode,
    O2U_MLSkill_CSVUpdate,
    U2O_Log,
    O2U_LOG_NODE_PORT_DATA,
  ];

  static final $core.Map<$core.int, OPackType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OPackType? valueOf($core.int value) => _byValue[value];

  const OPackType._($core.int v, $core.String n) : super(v, n);
}

class OLogType extends $pb.ProtobufEnum {
  static const OLogType OLT_Log = OLogType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OLT_Log');
  static const OLogType OLT_Warnning = OLogType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OLT_Warnning');
  static const OLogType OLT_Error = OLogType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OLT_Error');

  static const $core.List<OLogType> values = <OLogType> [
    OLT_Log,
    OLT_Warnning,
    OLT_Error,
  ];

  static final $core.Map<$core.int, OLogType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OLogType? valueOf($core.int value) => _byValue[value];

  const OLogType._($core.int v, $core.String n) : super(v, n);
}

