///
//  Generated code. Do not modify.
//  source: transition.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'transition.pbenum.dart';

export 'transition.pbenum.dart';

class V3 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'V3', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  V3._() : super();
  factory V3({
    $core.double? x,
    $core.double? y,
    $core.double? z,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    if (z != null) {
      _result.z = z;
    }
    return _result;
  }
  factory V3.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory V3.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  V3 clone() => V3()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  V3 copyWith(void Function(V3) updates) => super.copyWith((message) => updates(message as V3)) as V3; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static V3 create() => V3._();
  V3 createEmptyInstance() => create();
  static $pb.PbList<V3> createRepeated() => $pb.PbList<V3>();
  @$core.pragma('dart2js:noInline')
  static V3 getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<V3>(create);
  static V3? _defaultInstance;

  @$pb.TagNumber(10)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(10)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(10)
  void clearX() => clearField(10);

  @$pb.TagNumber(20)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(20)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(20)
  void clearY() => clearField(20);

  @$pb.TagNumber(30)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(30)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(30)
  void clearZ() => clearField(30);
}

class AutoShowInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AutoShowInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'objectName', protoName: 'objectName')
    ..a<$core.int>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptId', $pb.PbFieldType.O3, protoName: 'scriptId')
    ..hasRequiredFields = false
  ;

  AutoShowInfo._() : super();
  factory AutoShowInfo({
    $core.String? objectName,
    $core.int? scriptId,
  }) {
    final _result = create();
    if (objectName != null) {
      _result.objectName = objectName;
    }
    if (scriptId != null) {
      _result.scriptId = scriptId;
    }
    return _result;
  }
  factory AutoShowInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AutoShowInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AutoShowInfo clone() => AutoShowInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AutoShowInfo copyWith(void Function(AutoShowInfo) updates) => super.copyWith((message) => updates(message as AutoShowInfo)) as AutoShowInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AutoShowInfo create() => AutoShowInfo._();
  AutoShowInfo createEmptyInstance() => create();
  static $pb.PbList<AutoShowInfo> createRepeated() => $pb.PbList<AutoShowInfo>();
  @$core.pragma('dart2js:noInline')
  static AutoShowInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutoShowInfo>(create);
  static AutoShowInfo? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get objectName => $_getSZ(0);
  @$pb.TagNumber(10)
  set objectName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasObjectName() => $_has(0);
  @$pb.TagNumber(10)
  void clearObjectName() => clearField(10);

  @$pb.TagNumber(20)
  $core.int get scriptId => $_getIZ(1);
  @$pb.TagNumber(20)
  set scriptId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(20)
  void clearScriptId() => clearField(20);
}

class VarInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VarInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'varId', $pb.PbFieldType.O3, protoName: 'varId')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  VarInfo._() : super();
  factory VarInfo({
    $core.int? varId,
    $core.String? value,
  }) {
    final _result = create();
    if (varId != null) {
      _result.varId = varId;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory VarInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VarInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VarInfo clone() => VarInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VarInfo copyWith(void Function(VarInfo) updates) => super.copyWith((message) => updates(message as VarInfo)) as VarInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VarInfo create() => VarInfo._();
  VarInfo createEmptyInstance() => create();
  static $pb.PbList<VarInfo> createRepeated() => $pb.PbList<VarInfo>();
  @$core.pragma('dart2js:noInline')
  static VarInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VarInfo>(create);
  static VarInfo? _defaultInstance;

  @$pb.TagNumber(10)
  $core.int get varId => $_getIZ(0);
  @$pb.TagNumber(10)
  set varId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasVarId() => $_has(0);
  @$pb.TagNumber(10)
  void clearVarId() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(20)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(20)
  void clearValue() => clearField(20);
}

class VarPairInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VarPairInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  VarPairInfo._() : super();
  factory VarPairInfo({
    $core.String? key,
    $core.String? value,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory VarPairInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VarPairInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VarPairInfo clone() => VarPairInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VarPairInfo copyWith(void Function(VarPairInfo) updates) => super.copyWith((message) => updates(message as VarPairInfo)) as VarPairInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VarPairInfo create() => VarPairInfo._();
  VarPairInfo createEmptyInstance() => create();
  static $pb.PbList<VarPairInfo> createRepeated() => $pb.PbList<VarPairInfo>();
  @$core.pragma('dart2js:noInline')
  static VarPairInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VarPairInfo>(create);
  static VarPairInfo? _defaultInstance;

  @$pb.TagNumber(20)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(20)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(20)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(20)
  void clearKey() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(30)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(30)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(30)
  void clearValue() => clearField(30);
}

class MapVarInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MapVarInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'varId', $pb.PbFieldType.O3, protoName: 'varId')
    ..pc<VarPairInfo>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pairs', $pb.PbFieldType.PM, subBuilder: VarPairInfo.create)
    ..hasRequiredFields = false
  ;

  MapVarInfo._() : super();
  factory MapVarInfo({
    $core.int? varId,
    $core.Iterable<VarPairInfo>? pairs,
  }) {
    final _result = create();
    if (varId != null) {
      _result.varId = varId;
    }
    if (pairs != null) {
      _result.pairs.addAll(pairs);
    }
    return _result;
  }
  factory MapVarInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MapVarInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MapVarInfo clone() => MapVarInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MapVarInfo copyWith(void Function(MapVarInfo) updates) => super.copyWith((message) => updates(message as MapVarInfo)) as MapVarInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MapVarInfo create() => MapVarInfo._();
  MapVarInfo createEmptyInstance() => create();
  static $pb.PbList<MapVarInfo> createRepeated() => $pb.PbList<MapVarInfo>();
  @$core.pragma('dart2js:noInline')
  static MapVarInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MapVarInfo>(create);
  static MapVarInfo? _defaultInstance;

  @$pb.TagNumber(10)
  $core.int get varId => $_getIZ(0);
  @$pb.TagNumber(10)
  set varId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasVarId() => $_has(0);
  @$pb.TagNumber(10)
  void clearVarId() => clearField(10);

  @$pb.TagNumber(20)
  $core.List<VarPairInfo> get pairs => $_getList(1);
}

class VarData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VarData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..pc<VarInfo>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptVars', $pb.PbFieldType.PM, protoName: 'scriptVars', subBuilder: VarInfo.create)
    ..pc<VarInfo>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'agentVars', $pb.PbFieldType.PM, protoName: 'agentVars', subBuilder: VarInfo.create)
    ..pc<MapVarInfo>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'agentMapVars', $pb.PbFieldType.PM, protoName: 'agentMapVars', subBuilder: MapVarInfo.create)
    ..hasRequiredFields = false
  ;

  VarData._() : super();
  factory VarData({
    $core.Iterable<VarInfo>? scriptVars,
    $core.Iterable<VarInfo>? agentVars,
    $core.Iterable<MapVarInfo>? agentMapVars,
  }) {
    final _result = create();
    if (scriptVars != null) {
      _result.scriptVars.addAll(scriptVars);
    }
    if (agentVars != null) {
      _result.agentVars.addAll(agentVars);
    }
    if (agentMapVars != null) {
      _result.agentMapVars.addAll(agentMapVars);
    }
    return _result;
  }
  factory VarData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VarData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VarData clone() => VarData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VarData copyWith(void Function(VarData) updates) => super.copyWith((message) => updates(message as VarData)) as VarData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VarData create() => VarData._();
  VarData createEmptyInstance() => create();
  static $pb.PbList<VarData> createRepeated() => $pb.PbList<VarData>();
  @$core.pragma('dart2js:noInline')
  static VarData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VarData>(create);
  static VarData? _defaultInstance;

  @$pb.TagNumber(10)
  $core.List<VarInfo> get scriptVars => $_getList(0);

  @$pb.TagNumber(20)
  $core.List<VarInfo> get agentVars => $_getList(1);

  @$pb.TagNumber(30)
  $core.List<MapVarInfo> get agentMapVars => $_getList(2);
}

class ObjInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ObjInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'increaseId', $pb.PbFieldType.O3, protoName: 'increaseId')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showName', protoName: 'showName')
    ..aOM<V3>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: V3.create)
    ..aOM<V3>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rotation', subBuilder: V3.create)
    ..aOS(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prefab')
    ..aOM<V3>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boxSize', subBuilder: V3.create)
    ..a<$core.double>(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ex', $pb.PbFieldType.OF)
    ..a<$core.double>(75, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ey', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ObjInfo._() : super();
  factory ObjInfo({
    $core.int? increaseId,
    $core.String? guid,
    $core.String? name,
    $core.String? showName,
    V3? position,
    V3? rotation,
    $core.String? prefab,
    V3? boxSize,
    $core.double? ex,
    $core.double? ey,
  }) {
    final _result = create();
    if (increaseId != null) {
      _result.increaseId = increaseId;
    }
    if (guid != null) {
      _result.guid = guid;
    }
    if (name != null) {
      _result.name = name;
    }
    if (showName != null) {
      _result.showName = showName;
    }
    if (position != null) {
      _result.position = position;
    }
    if (rotation != null) {
      _result.rotation = rotation;
    }
    if (prefab != null) {
      _result.prefab = prefab;
    }
    if (boxSize != null) {
      _result.boxSize = boxSize;
    }
    if (ex != null) {
      _result.ex = ex;
    }
    if (ey != null) {
      _result.ey = ey;
    }
    return _result;
  }
  factory ObjInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObjInfo clone() => ObjInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObjInfo copyWith(void Function(ObjInfo) updates) => super.copyWith((message) => updates(message as ObjInfo)) as ObjInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObjInfo create() => ObjInfo._();
  ObjInfo createEmptyInstance() => create();
  static $pb.PbList<ObjInfo> createRepeated() => $pb.PbList<ObjInfo>();
  @$core.pragma('dart2js:noInline')
  static ObjInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjInfo>(create);
  static ObjInfo? _defaultInstance;

  @$pb.TagNumber(5)
  $core.int get increaseId => $_getIZ(0);
  @$pb.TagNumber(5)
  set increaseId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasIncreaseId() => $_has(0);
  @$pb.TagNumber(5)
  void clearIncreaseId() => clearField(5);

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(1);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(1);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(20)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(20)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(20)
  void clearName() => clearField(20);

  @$pb.TagNumber(25)
  $core.String get showName => $_getSZ(3);
  @$pb.TagNumber(25)
  set showName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(25)
  $core.bool hasShowName() => $_has(3);
  @$pb.TagNumber(25)
  void clearShowName() => clearField(25);

  @$pb.TagNumber(30)
  V3 get position => $_getN(4);
  @$pb.TagNumber(30)
  set position(V3 v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasPosition() => $_has(4);
  @$pb.TagNumber(30)
  void clearPosition() => clearField(30);
  @$pb.TagNumber(30)
  V3 ensurePosition() => $_ensure(4);

  @$pb.TagNumber(40)
  V3 get rotation => $_getN(5);
  @$pb.TagNumber(40)
  set rotation(V3 v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasRotation() => $_has(5);
  @$pb.TagNumber(40)
  void clearRotation() => clearField(40);
  @$pb.TagNumber(40)
  V3 ensureRotation() => $_ensure(5);

  @$pb.TagNumber(50)
  $core.String get prefab => $_getSZ(6);
  @$pb.TagNumber(50)
  set prefab($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(50)
  $core.bool hasPrefab() => $_has(6);
  @$pb.TagNumber(50)
  void clearPrefab() => clearField(50);

  @$pb.TagNumber(60)
  V3 get boxSize => $_getN(7);
  @$pb.TagNumber(60)
  set boxSize(V3 v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasBoxSize() => $_has(7);
  @$pb.TagNumber(60)
  void clearBoxSize() => clearField(60);
  @$pb.TagNumber(60)
  V3 ensureBoxSize() => $_ensure(7);

  @$pb.TagNumber(70)
  $core.double get ex => $_getN(8);
  @$pb.TagNumber(70)
  set ex($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(70)
  $core.bool hasEx() => $_has(8);
  @$pb.TagNumber(70)
  void clearEx() => clearField(70);

  @$pb.TagNumber(75)
  $core.double get ey => $_getN(9);
  @$pb.TagNumber(75)
  set ey($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(75)
  $core.bool hasEy() => $_has(9);
  @$pb.TagNumber(75)
  void clearEy() => clearField(75);
}

class DebugInfos extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DebugInfos', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..p<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'debugScriptGuids', $pb.PbFieldType.KU3, protoName: 'debugScriptGuids')
    ..p<$core.int>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stepDebugScriptGuids', $pb.PbFieldType.KU3, protoName: 'stepDebugScriptGuids')
    ..hasRequiredFields = false
  ;

  DebugInfos._() : super();
  factory DebugInfos({
    $core.Iterable<$core.int>? debugScriptGuids,
    $core.Iterable<$core.int>? stepDebugScriptGuids,
  }) {
    final _result = create();
    if (debugScriptGuids != null) {
      _result.debugScriptGuids.addAll(debugScriptGuids);
    }
    if (stepDebugScriptGuids != null) {
      _result.stepDebugScriptGuids.addAll(stepDebugScriptGuids);
    }
    return _result;
  }
  factory DebugInfos.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DebugInfos.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DebugInfos clone() => DebugInfos()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DebugInfos copyWith(void Function(DebugInfos) updates) => super.copyWith((message) => updates(message as DebugInfos)) as DebugInfos; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DebugInfos create() => DebugInfos._();
  DebugInfos createEmptyInstance() => create();
  static $pb.PbList<DebugInfos> createRepeated() => $pb.PbList<DebugInfos>();
  @$core.pragma('dart2js:noInline')
  static DebugInfos getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DebugInfos>(create);
  static DebugInfos? _defaultInstance;

  @$pb.TagNumber(10)
  $core.List<$core.int> get debugScriptGuids => $_getList(0);

  @$pb.TagNumber(20)
  $core.List<$core.int> get stepDebugScriptGuids => $_getList(1);
}

class DebugBlocked extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DebugBlocked', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isBlocked', protoName: 'isBlocked')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'breakPointKey', protoName: 'breakPointKey')
    ..hasRequiredFields = false
  ;

  DebugBlocked._() : super();
  factory DebugBlocked({
    $core.bool? isBlocked,
    $core.String? breakPointKey,
  }) {
    final _result = create();
    if (isBlocked != null) {
      _result.isBlocked = isBlocked;
    }
    if (breakPointKey != null) {
      _result.breakPointKey = breakPointKey;
    }
    return _result;
  }
  factory DebugBlocked.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DebugBlocked.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DebugBlocked clone() => DebugBlocked()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DebugBlocked copyWith(void Function(DebugBlocked) updates) => super.copyWith((message) => updates(message as DebugBlocked)) as DebugBlocked; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DebugBlocked create() => DebugBlocked._();
  DebugBlocked createEmptyInstance() => create();
  static $pb.PbList<DebugBlocked> createRepeated() => $pb.PbList<DebugBlocked>();
  @$core.pragma('dart2js:noInline')
  static DebugBlocked getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DebugBlocked>(create);
  static DebugBlocked? _defaultInstance;

  @$pb.TagNumber(10)
  $core.bool get isBlocked => $_getBF(0);
  @$pb.TagNumber(10)
  set isBlocked($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasIsBlocked() => $_has(0);
  @$pb.TagNumber(10)
  void clearIsBlocked() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get breakPointKey => $_getSZ(1);
  @$pb.TagNumber(20)
  set breakPointKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasBreakPointKey() => $_has(1);
  @$pb.TagNumber(20)
  void clearBreakPointKey() => clearField(20);
}

class RefreshFunction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RefreshFunction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..hasRequiredFields = false
  ;

  RefreshFunction._() : super();
  factory RefreshFunction({
    $core.String? path,
  }) {
    final _result = create();
    if (path != null) {
      _result.path = path;
    }
    return _result;
  }
  factory RefreshFunction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RefreshFunction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RefreshFunction clone() => RefreshFunction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RefreshFunction copyWith(void Function(RefreshFunction) updates) => super.copyWith((message) => updates(message as RefreshFunction)) as RefreshFunction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RefreshFunction create() => RefreshFunction._();
  RefreshFunction createEmptyInstance() => create();
  static $pb.PbList<RefreshFunction> createRepeated() => $pb.PbList<RefreshFunction>();
  @$core.pragma('dart2js:noInline')
  static RefreshFunction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RefreshFunction>(create);
  static RefreshFunction? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(10)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(10)
  void clearPath() => clearField(10);
}

class ObjInfos extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ObjInfos', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..pc<ObjInfo>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'objs', $pb.PbFieldType.PM, subBuilder: ObjInfo.create)
    ..hasRequiredFields = false
  ;

  ObjInfos._() : super();
  factory ObjInfos({
    $core.String? guid,
    $core.Iterable<ObjInfo>? objs,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (objs != null) {
      _result.objs.addAll(objs);
    }
    return _result;
  }
  factory ObjInfos.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjInfos.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObjInfos clone() => ObjInfos()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObjInfos copyWith(void Function(ObjInfos) updates) => super.copyWith((message) => updates(message as ObjInfos)) as ObjInfos; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObjInfos create() => ObjInfos._();
  ObjInfos createEmptyInstance() => create();
  static $pb.PbList<ObjInfos> createRepeated() => $pb.PbList<ObjInfos>();
  @$core.pragma('dart2js:noInline')
  static ObjInfos getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjInfos>(create);
  static ObjInfos? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(5)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(5)
  void clearGuid() => clearField(5);

  @$pb.TagNumber(10)
  $core.List<ObjInfo> get objs => $_getList(1);
}

class ONodeState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ONodeState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isActive', protoName: 'isActive')
    ..aOB(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'flashing')
    ..m<$core.int, $core.String>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inParamValues', protoName: 'inParamValues', entryClassName: 'ONodeState.InParamValuesEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('tutorial'))
    ..aOS(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'debugInfo', protoName: 'debugInfo')
    ..aOB(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isEndNode', protoName: 'isEndNode')
    ..hasRequiredFields = false
  ;

  ONodeState._() : super();
  factory ONodeState({
    $core.int? id,
    $core.bool? isActive,
    $core.bool? flashing,
    $core.Map<$core.int, $core.String>? inParamValues,
    $core.String? debugInfo,
    $core.bool? isEndNode,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (isActive != null) {
      _result.isActive = isActive;
    }
    if (flashing != null) {
      _result.flashing = flashing;
    }
    if (inParamValues != null) {
      _result.inParamValues.addAll(inParamValues);
    }
    if (debugInfo != null) {
      _result.debugInfo = debugInfo;
    }
    if (isEndNode != null) {
      _result.isEndNode = isEndNode;
    }
    return _result;
  }
  factory ONodeState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ONodeState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ONodeState clone() => ONodeState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ONodeState copyWith(void Function(ONodeState) updates) => super.copyWith((message) => updates(message as ONodeState)) as ONodeState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ONodeState create() => ONodeState._();
  ONodeState createEmptyInstance() => create();
  static $pb.PbList<ONodeState> createRepeated() => $pb.PbList<ONodeState>();
  @$core.pragma('dart2js:noInline')
  static ONodeState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ONodeState>(create);
  static ONodeState? _defaultInstance;

  @$pb.TagNumber(5)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(5)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(5)
  void clearId() => clearField(5);

  @$pb.TagNumber(10)
  $core.bool get isActive => $_getBF(1);
  @$pb.TagNumber(10)
  set isActive($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasIsActive() => $_has(1);
  @$pb.TagNumber(10)
  void clearIsActive() => clearField(10);

  @$pb.TagNumber(30)
  $core.bool get flashing => $_getBF(2);
  @$pb.TagNumber(30)
  set flashing($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasFlashing() => $_has(2);
  @$pb.TagNumber(30)
  void clearFlashing() => clearField(30);

  @$pb.TagNumber(50)
  $core.Map<$core.int, $core.String> get inParamValues => $_getMap(3);

  @$pb.TagNumber(60)
  $core.String get debugInfo => $_getSZ(4);
  @$pb.TagNumber(60)
  set debugInfo($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(60)
  $core.bool hasDebugInfo() => $_has(4);
  @$pb.TagNumber(60)
  void clearDebugInfo() => clearField(60);

  @$pb.TagNumber(70)
  $core.bool get isEndNode => $_getBF(5);
  @$pb.TagNumber(70)
  set isEndNode($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(70)
  $core.bool hasIsEndNode() => $_has(5);
  @$pb.TagNumber(70)
  void clearIsEndNode() => clearField(70);
}

class ONodeStates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ONodeStates', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptName', protoName: 'scriptName')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU3)
    ..pc<ONodeState>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodes', $pb.PbFieldType.PM, subBuilder: ONodeState.create)
    ..m<$core.String, $core.int>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prtTriggerCount', protoName: 'prtTriggerCount', entryClassName: 'ONodeStates.PrtTriggerCountEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OU3, packageName: const $pb.PackageName('tutorial'))
    ..m<$core.String, $core.int>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prmTriggerCount', protoName: 'prmTriggerCount', entryClassName: 'ONodeStates.PrmTriggerCountEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OU3, packageName: const $pb.PackageName('tutorial'))
    ..m<$core.String, $core.bool>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prtFlashing', protoName: 'prtFlashing', entryClassName: 'ONodeStates.PrtFlashingEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OB, packageName: const $pb.PackageName('tutorial'))
    ..m<$core.String, $core.bool>(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prmFlashing', protoName: 'prmFlashing', entryClassName: 'ONodeStates.PrmFlashingEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OB, packageName: const $pb.PackageName('tutorial'))
    ..aOM<VarData>(80, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'varData', protoName: 'varData', subBuilder: VarData.create)
    ..a<$core.double>(90, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timelineTime', $pb.PbFieldType.OF, protoName: 'timelineTime')
    ..hasRequiredFields = false
  ;

  ONodeStates._() : super();
  factory ONodeStates({
    $core.String? scriptName,
    $core.int? id,
    $core.Iterable<ONodeState>? nodes,
    $core.Map<$core.String, $core.int>? prtTriggerCount,
    $core.Map<$core.String, $core.int>? prmTriggerCount,
    $core.Map<$core.String, $core.bool>? prtFlashing,
    $core.Map<$core.String, $core.bool>? prmFlashing,
    VarData? varData,
    $core.double? timelineTime,
  }) {
    final _result = create();
    if (scriptName != null) {
      _result.scriptName = scriptName;
    }
    if (id != null) {
      _result.id = id;
    }
    if (nodes != null) {
      _result.nodes.addAll(nodes);
    }
    if (prtTriggerCount != null) {
      _result.prtTriggerCount.addAll(prtTriggerCount);
    }
    if (prmTriggerCount != null) {
      _result.prmTriggerCount.addAll(prmTriggerCount);
    }
    if (prtFlashing != null) {
      _result.prtFlashing.addAll(prtFlashing);
    }
    if (prmFlashing != null) {
      _result.prmFlashing.addAll(prmFlashing);
    }
    if (varData != null) {
      _result.varData = varData;
    }
    if (timelineTime != null) {
      _result.timelineTime = timelineTime;
    }
    return _result;
  }
  factory ONodeStates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ONodeStates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ONodeStates clone() => ONodeStates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ONodeStates copyWith(void Function(ONodeStates) updates) => super.copyWith((message) => updates(message as ONodeStates)) as ONodeStates; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ONodeStates create() => ONodeStates._();
  ONodeStates createEmptyInstance() => create();
  static $pb.PbList<ONodeStates> createRepeated() => $pb.PbList<ONodeStates>();
  @$core.pragma('dart2js:noInline')
  static ONodeStates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ONodeStates>(create);
  static ONodeStates? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get scriptName => $_getSZ(0);
  @$pb.TagNumber(5)
  set scriptName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasScriptName() => $_has(0);
  @$pb.TagNumber(5)
  void clearScriptName() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(6)
  set id($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(6)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(6)
  void clearId() => clearField(6);

  @$pb.TagNumber(20)
  $core.List<ONodeState> get nodes => $_getList(2);

  @$pb.TagNumber(40)
  $core.Map<$core.String, $core.int> get prtTriggerCount => $_getMap(3);

  @$pb.TagNumber(50)
  $core.Map<$core.String, $core.int> get prmTriggerCount => $_getMap(4);

  @$pb.TagNumber(60)
  $core.Map<$core.String, $core.bool> get prtFlashing => $_getMap(5);

  @$pb.TagNumber(70)
  $core.Map<$core.String, $core.bool> get prmFlashing => $_getMap(6);

  @$pb.TagNumber(80)
  VarData get varData => $_getN(7);
  @$pb.TagNumber(80)
  set varData(VarData v) { setField(80, v); }
  @$pb.TagNumber(80)
  $core.bool hasVarData() => $_has(7);
  @$pb.TagNumber(80)
  void clearVarData() => clearField(80);
  @$pb.TagNumber(80)
  VarData ensureVarData() => $_ensure(7);

  @$pb.TagNumber(90)
  $core.double get timelineTime => $_getN(8);
  @$pb.TagNumber(90)
  set timelineTime($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(90)
  $core.bool hasTimelineTime() => $_has(8);
  @$pb.TagNumber(90)
  void clearTimelineTime() => clearField(90);
}

class OLevel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OLevel', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'levelGuid', protoName: 'levelGuid')
    ..hasRequiredFields = false
  ;

  OLevel._() : super();
  factory OLevel({
    $core.String? levelGuid,
  }) {
    final _result = create();
    if (levelGuid != null) {
      _result.levelGuid = levelGuid;
    }
    return _result;
  }
  factory OLevel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OLevel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OLevel clone() => OLevel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OLevel copyWith(void Function(OLevel) updates) => super.copyWith((message) => updates(message as OLevel)) as OLevel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OLevel create() => OLevel._();
  OLevel createEmptyInstance() => create();
  static $pb.PbList<OLevel> createRepeated() => $pb.PbList<OLevel>();
  @$core.pragma('dart2js:noInline')
  static OLevel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OLevel>(create);
  static OLevel? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get levelGuid => $_getSZ(0);
  @$pb.TagNumber(5)
  set levelGuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasLevelGuid() => $_has(0);
  @$pb.TagNumber(5)
  void clearLevelGuid() => clearField(5);
}

class SimpleNode extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SimpleNode', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..hasRequiredFields = false
  ;

  SimpleNode._() : super();
  factory SimpleNode({
    $core.String? guid,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    return _result;
  }
  factory SimpleNode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SimpleNode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SimpleNode clone() => SimpleNode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SimpleNode copyWith(void Function(SimpleNode) updates) => super.copyWith((message) => updates(message as SimpleNode)) as SimpleNode; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SimpleNode create() => SimpleNode._();
  SimpleNode createEmptyInstance() => create();
  static $pb.PbList<SimpleNode> createRepeated() => $pb.PbList<SimpleNode>();
  @$core.pragma('dart2js:noInline')
  static SimpleNode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SimpleNode>(create);
  static SimpleNode? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(5)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(5)
  void clearGuid() => clearField(5);
}

class FocusToNode extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FocusToNode', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..hasRequiredFields = false
  ;

  FocusToNode._() : super();
  factory FocusToNode({
    $core.String? guid,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    return _result;
  }
  factory FocusToNode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FocusToNode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FocusToNode clone() => FocusToNode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FocusToNode copyWith(void Function(FocusToNode) updates) => super.copyWith((message) => updates(message as FocusToNode)) as FocusToNode; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FocusToNode create() => FocusToNode._();
  FocusToNode createEmptyInstance() => create();
  static $pb.PbList<FocusToNode> createRepeated() => $pb.PbList<FocusToNode>();
  @$core.pragma('dart2js:noInline')
  static FocusToNode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FocusToNode>(create);
  static FocusToNode? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(5)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(5)
  void clearGuid() => clearField(5);
}

class CopyObject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CopyObject', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'copyGuid')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'typeGuid', protoName: 'typeGuid')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prefab')
    ..hasRequiredFields = false
  ;

  CopyObject._() : super();
  factory CopyObject({
    $core.String? copyGuid,
    $core.String? guid,
    $core.String? typeGuid,
    $core.String? prefab,
  }) {
    final _result = create();
    if (copyGuid != null) {
      _result.copyGuid = copyGuid;
    }
    if (guid != null) {
      _result.guid = guid;
    }
    if (typeGuid != null) {
      _result.typeGuid = typeGuid;
    }
    if (prefab != null) {
      _result.prefab = prefab;
    }
    return _result;
  }
  factory CopyObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CopyObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CopyObject clone() => CopyObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CopyObject copyWith(void Function(CopyObject) updates) => super.copyWith((message) => updates(message as CopyObject)) as CopyObject; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CopyObject create() => CopyObject._();
  CopyObject createEmptyInstance() => create();
  static $pb.PbList<CopyObject> createRepeated() => $pb.PbList<CopyObject>();
  @$core.pragma('dart2js:noInline')
  static CopyObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CopyObject>(create);
  static CopyObject? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get copyGuid => $_getSZ(0);
  @$pb.TagNumber(5)
  set copyGuid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasCopyGuid() => $_has(0);
  @$pb.TagNumber(5)
  void clearCopyGuid() => clearField(5);

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(1);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(1);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get typeGuid => $_getSZ(2);
  @$pb.TagNumber(20)
  set typeGuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(20)
  $core.bool hasTypeGuid() => $_has(2);
  @$pb.TagNumber(20)
  void clearTypeGuid() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get prefab => $_getSZ(3);
  @$pb.TagNumber(30)
  set prefab($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(30)
  $core.bool hasPrefab() => $_has(3);
  @$pb.TagNumber(30)
  void clearPrefab() => clearField(30);
}

class NodeDataRTRefresh extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NodeDataRTRefresh', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptHashId', $pb.PbFieldType.OU3)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeIndex', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  NodeDataRTRefresh._() : super();
  factory NodeDataRTRefresh({
    $core.int? scriptHashId,
    $core.int? nodeIndex,
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (scriptHashId != null) {
      _result.scriptHashId = scriptHashId;
    }
    if (nodeIndex != null) {
      _result.nodeIndex = nodeIndex;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory NodeDataRTRefresh.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NodeDataRTRefresh.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NodeDataRTRefresh clone() => NodeDataRTRefresh()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NodeDataRTRefresh copyWith(void Function(NodeDataRTRefresh) updates) => super.copyWith((message) => updates(message as NodeDataRTRefresh)) as NodeDataRTRefresh; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NodeDataRTRefresh create() => NodeDataRTRefresh._();
  NodeDataRTRefresh createEmptyInstance() => create();
  static $pb.PbList<NodeDataRTRefresh> createRepeated() => $pb.PbList<NodeDataRTRefresh>();
  @$core.pragma('dart2js:noInline')
  static NodeDataRTRefresh getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodeDataRTRefresh>(create);
  static NodeDataRTRefresh? _defaultInstance;

  @$pb.TagNumber(5)
  $core.int get scriptHashId => $_getIZ(0);
  @$pb.TagNumber(5)
  set scriptHashId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasScriptHashId() => $_has(0);
  @$pb.TagNumber(5)
  void clearScriptHashId() => clearField(5);

  @$pb.TagNumber(10)
  $core.int get nodeIndex => $_getIZ(1);
  @$pb.TagNumber(10)
  set nodeIndex($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasNodeIndex() => $_has(1);
  @$pb.TagNumber(10)
  void clearNodeIndex() => clearField(10);

  @$pb.TagNumber(20)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(20)
  set data($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(20)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(20)
  void clearData() => clearField(20);
}

class ScriptDataRTRefresh extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScriptDataRTRefresh', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptHashId', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ScriptDataRTRefresh._() : super();
  factory ScriptDataRTRefresh({
    $core.int? scriptHashId,
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (scriptHashId != null) {
      _result.scriptHashId = scriptHashId;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory ScriptDataRTRefresh.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScriptDataRTRefresh.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScriptDataRTRefresh clone() => ScriptDataRTRefresh()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScriptDataRTRefresh copyWith(void Function(ScriptDataRTRefresh) updates) => super.copyWith((message) => updates(message as ScriptDataRTRefresh)) as ScriptDataRTRefresh; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScriptDataRTRefresh create() => ScriptDataRTRefresh._();
  ScriptDataRTRefresh createEmptyInstance() => create();
  static $pb.PbList<ScriptDataRTRefresh> createRepeated() => $pb.PbList<ScriptDataRTRefresh>();
  @$core.pragma('dart2js:noInline')
  static ScriptDataRTRefresh getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScriptDataRTRefresh>(create);
  static ScriptDataRTRefresh? _defaultInstance;

  @$pb.TagNumber(5)
  $core.int get scriptHashId => $_getIZ(0);
  @$pb.TagNumber(5)
  set scriptHashId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasScriptHashId() => $_has(0);
  @$pb.TagNumber(5)
  void clearScriptHashId() => clearField(5);

  @$pb.TagNumber(20)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(20)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(20)
  void clearData() => clearField(20);
}

class PlayingState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayingState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isPlaying', protoName: 'isPlaying')
    ..hasRequiredFields = false
  ;

  PlayingState._() : super();
  factory PlayingState({
    $core.bool? isPlaying,
  }) {
    final _result = create();
    if (isPlaying != null) {
      _result.isPlaying = isPlaying;
    }
    return _result;
  }
  factory PlayingState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayingState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayingState clone() => PlayingState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayingState copyWith(void Function(PlayingState) updates) => super.copyWith((message) => updates(message as PlayingState)) as PlayingState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayingState create() => PlayingState._();
  PlayingState createEmptyInstance() => create();
  static $pb.PbList<PlayingState> createRepeated() => $pb.PbList<PlayingState>();
  @$core.pragma('dart2js:noInline')
  static PlayingState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayingState>(create);
  static PlayingState? _defaultInstance;

  @$pb.TagNumber(10)
  $core.bool get isPlaying => $_getBF(0);
  @$pb.TagNumber(10)
  set isPlaying($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasIsPlaying() => $_has(0);
  @$pb.TagNumber(10)
  void clearIsPlaying() => clearField(10);
}

class OPack extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OPack', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..e<OPackType>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: OPackType.O2U_FullObjects, valueOf: OPackType.valueOf, enumValues: OPackType.values)
    ..a<$core.List<$core.int>>(80, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..a<$core.int>(120, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fullLength', $pb.PbFieldType.OU3, protoName: 'fullLength')
    ..a<$core.int>(130, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'packCount', $pb.PbFieldType.OU3, protoName: 'packCount')
    ..a<$core.int>(140, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'packIndex', $pb.PbFieldType.OU3, protoName: 'packIndex')
    ..a<$core.int>(150, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  OPack._() : super();
  factory OPack({
    OPackType? type,
    $core.List<$core.int>? data,
    $core.int? fullLength,
    $core.int? packCount,
    $core.int? packIndex,
    $core.int? guid,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (data != null) {
      _result.data = data;
    }
    if (fullLength != null) {
      _result.fullLength = fullLength;
    }
    if (packCount != null) {
      _result.packCount = packCount;
    }
    if (packIndex != null) {
      _result.packIndex = packIndex;
    }
    if (guid != null) {
      _result.guid = guid;
    }
    return _result;
  }
  factory OPack.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OPack.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OPack clone() => OPack()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OPack copyWith(void Function(OPack) updates) => super.copyWith((message) => updates(message as OPack)) as OPack; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OPack create() => OPack._();
  OPack createEmptyInstance() => create();
  static $pb.PbList<OPack> createRepeated() => $pb.PbList<OPack>();
  @$core.pragma('dart2js:noInline')
  static OPack getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OPack>(create);
  static OPack? _defaultInstance;

  @$pb.TagNumber(10)
  OPackType get type => $_getN(0);
  @$pb.TagNumber(10)
  set type(OPackType v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(10)
  void clearType() => clearField(10);

  @$pb.TagNumber(80)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(80)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(80)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(80)
  void clearData() => clearField(80);

  @$pb.TagNumber(120)
  $core.int get fullLength => $_getIZ(2);
  @$pb.TagNumber(120)
  set fullLength($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(120)
  $core.bool hasFullLength() => $_has(2);
  @$pb.TagNumber(120)
  void clearFullLength() => clearField(120);

  @$pb.TagNumber(130)
  $core.int get packCount => $_getIZ(3);
  @$pb.TagNumber(130)
  set packCount($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(130)
  $core.bool hasPackCount() => $_has(3);
  @$pb.TagNumber(130)
  void clearPackCount() => clearField(130);

  @$pb.TagNumber(140)
  $core.int get packIndex => $_getIZ(4);
  @$pb.TagNumber(140)
  set packIndex($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(140)
  $core.bool hasPackIndex() => $_has(4);
  @$pb.TagNumber(140)
  void clearPackIndex() => clearField(140);

  @$pb.TagNumber(150)
  $core.int get guid => $_getIZ(5);
  @$pb.TagNumber(150)
  set guid($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(150)
  $core.bool hasGuid() => $_has(5);
  @$pb.TagNumber(150)
  void clearGuid() => clearField(150);
}

class BreakPoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BreakPoint', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'breakPointKey', protoName: 'breakPointKey')
    ..hasRequiredFields = false
  ;

  BreakPoint._() : super();
  factory BreakPoint({
    $core.String? breakPointKey,
  }) {
    final _result = create();
    if (breakPointKey != null) {
      _result.breakPointKey = breakPointKey;
    }
    return _result;
  }
  factory BreakPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BreakPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BreakPoint clone() => BreakPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BreakPoint copyWith(void Function(BreakPoint) updates) => super.copyWith((message) => updates(message as BreakPoint)) as BreakPoint; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BreakPoint create() => BreakPoint._();
  BreakPoint createEmptyInstance() => create();
  static $pb.PbList<BreakPoint> createRepeated() => $pb.PbList<BreakPoint>();
  @$core.pragma('dart2js:noInline')
  static BreakPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BreakPoint>(create);
  static BreakPoint? _defaultInstance;

  @$pb.TagNumber(20)
  $core.String get breakPointKey => $_getSZ(0);
  @$pb.TagNumber(20)
  set breakPointKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(20)
  $core.bool hasBreakPointKey() => $_has(0);
  @$pb.TagNumber(20)
  void clearBreakPointKey() => clearField(20);
}

class SyncFieldData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncFieldData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  SyncFieldData._() : super();
  factory SyncFieldData({
    $core.String? guid,
    $core.String? value,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory SyncFieldData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncFieldData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncFieldData clone() => SyncFieldData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncFieldData copyWith(void Function(SyncFieldData) updates) => super.copyWith((message) => updates(message as SyncFieldData)) as SyncFieldData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncFieldData create() => SyncFieldData._();
  SyncFieldData createEmptyInstance() => create();
  static $pb.PbList<SyncFieldData> createRepeated() => $pb.PbList<SyncFieldData>();
  @$core.pragma('dart2js:noInline')
  static SyncFieldData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncFieldData>(create);
  static SyncFieldData? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(20)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(20)
  void clearValue() => clearField(20);
}

class SyncNodeData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncNodeData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'typeGuid', protoName: 'typeGuid')
    ..a<$core.double>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime', $pb.PbFieldType.OF, protoName: 'startTime')
    ..a<$core.double>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endTime', $pb.PbFieldType.OF, protoName: 'endTime')
    ..pc<SyncFieldData>(90, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fieldValues', $pb.PbFieldType.PM, protoName: 'fieldValues', subBuilder: SyncFieldData.create)
    ..hasRequiredFields = false
  ;

  SyncNodeData._() : super();
  factory SyncNodeData({
    $core.String? guid,
    $core.String? typeGuid,
    $core.double? startTime,
    $core.double? endTime,
    $core.Iterable<SyncFieldData>? fieldValues,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (typeGuid != null) {
      _result.typeGuid = typeGuid;
    }
    if (startTime != null) {
      _result.startTime = startTime;
    }
    if (endTime != null) {
      _result.endTime = endTime;
    }
    if (fieldValues != null) {
      _result.fieldValues.addAll(fieldValues);
    }
    return _result;
  }
  factory SyncNodeData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncNodeData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncNodeData clone() => SyncNodeData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncNodeData copyWith(void Function(SyncNodeData) updates) => super.copyWith((message) => updates(message as SyncNodeData)) as SyncNodeData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncNodeData create() => SyncNodeData._();
  SyncNodeData createEmptyInstance() => create();
  static $pb.PbList<SyncNodeData> createRepeated() => $pb.PbList<SyncNodeData>();
  @$core.pragma('dart2js:noInline')
  static SyncNodeData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncNodeData>(create);
  static SyncNodeData? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get typeGuid => $_getSZ(1);
  @$pb.TagNumber(20)
  set typeGuid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasTypeGuid() => $_has(1);
  @$pb.TagNumber(20)
  void clearTypeGuid() => clearField(20);

  @$pb.TagNumber(30)
  $core.double get startTime => $_getN(2);
  @$pb.TagNumber(30)
  set startTime($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasStartTime() => $_has(2);
  @$pb.TagNumber(30)
  void clearStartTime() => clearField(30);

  @$pb.TagNumber(40)
  $core.double get endTime => $_getN(3);
  @$pb.TagNumber(40)
  set endTime($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(40)
  $core.bool hasEndTime() => $_has(3);
  @$pb.TagNumber(40)
  void clearEndTime() => clearField(40);

  @$pb.TagNumber(90)
  $core.List<SyncFieldData> get fieldValues => $_getList(4);
}

class NodeTargetData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NodeTargetData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..hasRequiredFields = false
  ;

  NodeTargetData._() : super();
  factory NodeTargetData({
    $core.String? guid,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    return _result;
  }
  factory NodeTargetData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NodeTargetData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NodeTargetData clone() => NodeTargetData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NodeTargetData copyWith(void Function(NodeTargetData) updates) => super.copyWith((message) => updates(message as NodeTargetData)) as NodeTargetData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NodeTargetData create() => NodeTargetData._();
  NodeTargetData createEmptyInstance() => create();
  static $pb.PbList<NodeTargetData> createRepeated() => $pb.PbList<NodeTargetData>();
  @$core.pragma('dart2js:noInline')
  static NodeTargetData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodeTargetData>(create);
  static NodeTargetData? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);
}

class TimelineSyncData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimelineSyncData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OF)
    ..pc<SyncNodeData>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeValues', $pb.PbFieldType.PM, protoName: 'nodeValues', subBuilder: SyncNodeData.create)
    ..hasRequiredFields = false
  ;

  TimelineSyncData._() : super();
  factory TimelineSyncData({
    $core.double? time,
    $core.Iterable<SyncNodeData>? nodeValues,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (nodeValues != null) {
      _result.nodeValues.addAll(nodeValues);
    }
    return _result;
  }
  factory TimelineSyncData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimelineSyncData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimelineSyncData clone() => TimelineSyncData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimelineSyncData copyWith(void Function(TimelineSyncData) updates) => super.copyWith((message) => updates(message as TimelineSyncData)) as TimelineSyncData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimelineSyncData create() => TimelineSyncData._();
  TimelineSyncData createEmptyInstance() => create();
  static $pb.PbList<TimelineSyncData> createRepeated() => $pb.PbList<TimelineSyncData>();
  @$core.pragma('dart2js:noInline')
  static TimelineSyncData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimelineSyncData>(create);
  static TimelineSyncData? _defaultInstance;

  @$pb.TagNumber(10)
  $core.double get time => $_getN(0);
  @$pb.TagNumber(10)
  set time($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(10)
  void clearTime() => clearField(10);

  @$pb.TagNumber(30)
  $core.List<SyncNodeData> get nodeValues => $_getList(1);
}

class TimelineTime extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TimelineTime', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  TimelineTime._() : super();
  factory TimelineTime({
    $core.double? time,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    return _result;
  }
  factory TimelineTime.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimelineTime.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimelineTime clone() => TimelineTime()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimelineTime copyWith(void Function(TimelineTime) updates) => super.copyWith((message) => updates(message as TimelineTime)) as TimelineTime; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimelineTime create() => TimelineTime._();
  TimelineTime createEmptyInstance() => create();
  static $pb.PbList<TimelineTime> createRepeated() => $pb.PbList<TimelineTime>();
  @$core.pragma('dart2js:noInline')
  static TimelineTime getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimelineTime>(create);
  static TimelineTime? _defaultInstance;

  @$pb.TagNumber(10)
  $core.double get time => $_getN(0);
  @$pb.TagNumber(10)
  set time($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(10)
  void clearTime() => clearField(10);
}

class OLog extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OLog', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..e<OLogType>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: OLogType.OLT_Log, valueOf: OLogType.valueOf, enumValues: OLogType.values)
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  OLog._() : super();
  factory OLog({
    OLogType? type,
    $core.String? message,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory OLog.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OLog.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OLog clone() => OLog()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OLog copyWith(void Function(OLog) updates) => super.copyWith((message) => updates(message as OLog)) as OLog; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OLog create() => OLog._();
  OLog createEmptyInstance() => create();
  static $pb.PbList<OLog> createRepeated() => $pb.PbList<OLog>();
  @$core.pragma('dart2js:noInline')
  static OLog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OLog>(create);
  static OLog? _defaultInstance;

  @$pb.TagNumber(10)
  OLogType get type => $_getN(0);
  @$pb.TagNumber(10)
  set type(OLogType v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(10)
  void clearType() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(20)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(20)
  void clearMessage() => clearField(20);
}

class OT_OpenScene extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_OpenScene', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'searchPath', protoName: 'searchPath')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sceneName', protoName: 'sceneName')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'editorName', protoName: 'editorName')
    ..hasRequiredFields = false
  ;

  OT_OpenScene._() : super();
  factory OT_OpenScene({
    $core.String? searchPath,
    $core.String? sceneName,
    $core.String? editorName,
  }) {
    final _result = create();
    if (searchPath != null) {
      _result.searchPath = searchPath;
    }
    if (sceneName != null) {
      _result.sceneName = sceneName;
    }
    if (editorName != null) {
      _result.editorName = editorName;
    }
    return _result;
  }
  factory OT_OpenScene.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_OpenScene.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_OpenScene clone() => OT_OpenScene()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_OpenScene copyWith(void Function(OT_OpenScene) updates) => super.copyWith((message) => updates(message as OT_OpenScene)) as OT_OpenScene; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_OpenScene create() => OT_OpenScene._();
  OT_OpenScene createEmptyInstance() => create();
  static $pb.PbList<OT_OpenScene> createRepeated() => $pb.PbList<OT_OpenScene>();
  @$core.pragma('dart2js:noInline')
  static OT_OpenScene getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_OpenScene>(create);
  static OT_OpenScene? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get searchPath => $_getSZ(0);
  @$pb.TagNumber(10)
  set searchPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasSearchPath() => $_has(0);
  @$pb.TagNumber(10)
  void clearSearchPath() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get sceneName => $_getSZ(1);
  @$pb.TagNumber(20)
  set sceneName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasSceneName() => $_has(1);
  @$pb.TagNumber(20)
  void clearSceneName() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get editorName => $_getSZ(2);
  @$pb.TagNumber(30)
  set editorName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasEditorName() => $_has(2);
  @$pb.TagNumber(30)
  void clearEditorName() => clearField(30);
}

class OT_CreateObject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_CreateObject', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tag')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'searchPath', protoName: 'searchPath')
    ..aOS(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'prefab')
    ..aOM<V3>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pos', subBuilder: V3.create)
    ..aOM<V3>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rot', subBuilder: V3.create)
    ..aOM<V3>(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scale', subBuilder: V3.create)
    ..hasRequiredFields = false
  ;

  OT_CreateObject._() : super();
  factory OT_CreateObject({
    $core.String? guid,
    $core.String? tag,
    $core.String? searchPath,
    $core.String? prefab,
    V3? pos,
    V3? rot,
    V3? scale,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (tag != null) {
      _result.tag = tag;
    }
    if (searchPath != null) {
      _result.searchPath = searchPath;
    }
    if (prefab != null) {
      _result.prefab = prefab;
    }
    if (pos != null) {
      _result.pos = pos;
    }
    if (rot != null) {
      _result.rot = rot;
    }
    if (scale != null) {
      _result.scale = scale;
    }
    return _result;
  }
  factory OT_CreateObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_CreateObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_CreateObject clone() => OT_CreateObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_CreateObject copyWith(void Function(OT_CreateObject) updates) => super.copyWith((message) => updates(message as OT_CreateObject)) as OT_CreateObject; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_CreateObject create() => OT_CreateObject._();
  OT_CreateObject createEmptyInstance() => create();
  static $pb.PbList<OT_CreateObject> createRepeated() => $pb.PbList<OT_CreateObject>();
  @$core.pragma('dart2js:noInline')
  static OT_CreateObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_CreateObject>(create);
  static OT_CreateObject? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get tag => $_getSZ(1);
  @$pb.TagNumber(20)
  set tag($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasTag() => $_has(1);
  @$pb.TagNumber(20)
  void clearTag() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get searchPath => $_getSZ(2);
  @$pb.TagNumber(30)
  set searchPath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasSearchPath() => $_has(2);
  @$pb.TagNumber(30)
  void clearSearchPath() => clearField(30);

  @$pb.TagNumber(40)
  $core.String get prefab => $_getSZ(3);
  @$pb.TagNumber(40)
  set prefab($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(40)
  $core.bool hasPrefab() => $_has(3);
  @$pb.TagNumber(40)
  void clearPrefab() => clearField(40);

  @$pb.TagNumber(50)
  V3 get pos => $_getN(4);
  @$pb.TagNumber(50)
  set pos(V3 v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasPos() => $_has(4);
  @$pb.TagNumber(50)
  void clearPos() => clearField(50);
  @$pb.TagNumber(50)
  V3 ensurePos() => $_ensure(4);

  @$pb.TagNumber(60)
  V3 get rot => $_getN(5);
  @$pb.TagNumber(60)
  set rot(V3 v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasRot() => $_has(5);
  @$pb.TagNumber(60)
  void clearRot() => clearField(60);
  @$pb.TagNumber(60)
  V3 ensureRot() => $_ensure(5);

  @$pb.TagNumber(70)
  V3 get scale => $_getN(6);
  @$pb.TagNumber(70)
  set scale(V3 v) { setField(70, v); }
  @$pb.TagNumber(70)
  $core.bool hasScale() => $_has(6);
  @$pb.TagNumber(70)
  void clearScale() => clearField(70);
  @$pb.TagNumber(70)
  V3 ensureScale() => $_ensure(6);
}

class OT_RefreshSceneWithObject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_RefreshSceneWithObject', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'searchPath', protoName: 'searchPath')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sceneName', protoName: 'sceneName')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'editorName', protoName: 'editorName')
    ..pc<OT_CreateObject>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'objects', $pb.PbFieldType.PM, subBuilder: OT_CreateObject.create)
    ..hasRequiredFields = false
  ;

  OT_RefreshSceneWithObject._() : super();
  factory OT_RefreshSceneWithObject({
    $core.String? guid,
    $core.String? searchPath,
    $core.String? sceneName,
    $core.String? editorName,
    $core.Iterable<OT_CreateObject>? objects,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (searchPath != null) {
      _result.searchPath = searchPath;
    }
    if (sceneName != null) {
      _result.sceneName = sceneName;
    }
    if (editorName != null) {
      _result.editorName = editorName;
    }
    if (objects != null) {
      _result.objects.addAll(objects);
    }
    return _result;
  }
  factory OT_RefreshSceneWithObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_RefreshSceneWithObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_RefreshSceneWithObject clone() => OT_RefreshSceneWithObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_RefreshSceneWithObject copyWith(void Function(OT_RefreshSceneWithObject) updates) => super.copyWith((message) => updates(message as OT_RefreshSceneWithObject)) as OT_RefreshSceneWithObject; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_RefreshSceneWithObject create() => OT_RefreshSceneWithObject._();
  OT_RefreshSceneWithObject createEmptyInstance() => create();
  static $pb.PbList<OT_RefreshSceneWithObject> createRepeated() => $pb.PbList<OT_RefreshSceneWithObject>();
  @$core.pragma('dart2js:noInline')
  static OT_RefreshSceneWithObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_RefreshSceneWithObject>(create);
  static OT_RefreshSceneWithObject? _defaultInstance;

  @$pb.TagNumber(5)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(5)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(5)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(5)
  void clearGuid() => clearField(5);

  @$pb.TagNumber(10)
  $core.String get searchPath => $_getSZ(1);
  @$pb.TagNumber(10)
  set searchPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasSearchPath() => $_has(1);
  @$pb.TagNumber(10)
  void clearSearchPath() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get sceneName => $_getSZ(2);
  @$pb.TagNumber(20)
  set sceneName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(20)
  $core.bool hasSceneName() => $_has(2);
  @$pb.TagNumber(20)
  void clearSceneName() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get editorName => $_getSZ(3);
  @$pb.TagNumber(30)
  set editorName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(30)
  $core.bool hasEditorName() => $_has(3);
  @$pb.TagNumber(30)
  void clearEditorName() => clearField(30);

  @$pb.TagNumber(40)
  $core.List<OT_CreateObject> get objects => $_getList(4);
}

class OT_CreateMap extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_CreateMap', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'searchPath', protoName: 'searchPath')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapName', protoName: 'mapName')
    ..a<$core.int>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapID', $pb.PbFieldType.O3, protoName: 'mapID')
    ..pc<OT_CreateObject>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'objects', $pb.PbFieldType.PM, subBuilder: OT_CreateObject.create)
    ..hasRequiredFields = false
  ;

  OT_CreateMap._() : super();
  factory OT_CreateMap({
    $core.String? guid,
    $core.String? searchPath,
    $core.String? mapName,
    $core.int? mapID,
    $core.Iterable<OT_CreateObject>? objects,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (searchPath != null) {
      _result.searchPath = searchPath;
    }
    if (mapName != null) {
      _result.mapName = mapName;
    }
    if (mapID != null) {
      _result.mapID = mapID;
    }
    if (objects != null) {
      _result.objects.addAll(objects);
    }
    return _result;
  }
  factory OT_CreateMap.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_CreateMap.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_CreateMap clone() => OT_CreateMap()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_CreateMap copyWith(void Function(OT_CreateMap) updates) => super.copyWith((message) => updates(message as OT_CreateMap)) as OT_CreateMap; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_CreateMap create() => OT_CreateMap._();
  OT_CreateMap createEmptyInstance() => create();
  static $pb.PbList<OT_CreateMap> createRepeated() => $pb.PbList<OT_CreateMap>();
  @$core.pragma('dart2js:noInline')
  static OT_CreateMap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_CreateMap>(create);
  static OT_CreateMap? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get searchPath => $_getSZ(1);
  @$pb.TagNumber(20)
  set searchPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasSearchPath() => $_has(1);
  @$pb.TagNumber(20)
  void clearSearchPath() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get mapName => $_getSZ(2);
  @$pb.TagNumber(30)
  set mapName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasMapName() => $_has(2);
  @$pb.TagNumber(30)
  void clearMapName() => clearField(30);

  @$pb.TagNumber(40)
  $core.int get mapID => $_getIZ(3);
  @$pb.TagNumber(40)
  set mapID($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(40)
  $core.bool hasMapID() => $_has(3);
  @$pb.TagNumber(40)
  void clearMapID() => clearField(40);

  @$pb.TagNumber(50)
  $core.List<OT_CreateObject> get objects => $_getList(4);
}

class OT_ObjectTransform extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_ObjectTransform', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..aOM<V3>(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pos', subBuilder: V3.create)
    ..aOM<V3>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rot', subBuilder: V3.create)
    ..aOM<V3>(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scale', subBuilder: V3.create)
    ..aOB(80, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatePos', protoName: 'updatePos')
    ..aOB(90, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateRot', protoName: 'updateRot')
    ..aOB(100, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateScale', protoName: 'updateScale')
    ..hasRequiredFields = false
  ;

  OT_ObjectTransform._() : super();
  factory OT_ObjectTransform({
    $core.String? guid,
    V3? pos,
    V3? rot,
    V3? scale,
    $core.bool? updatePos,
    $core.bool? updateRot,
    $core.bool? updateScale,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    if (pos != null) {
      _result.pos = pos;
    }
    if (rot != null) {
      _result.rot = rot;
    }
    if (scale != null) {
      _result.scale = scale;
    }
    if (updatePos != null) {
      _result.updatePos = updatePos;
    }
    if (updateRot != null) {
      _result.updateRot = updateRot;
    }
    if (updateScale != null) {
      _result.updateScale = updateScale;
    }
    return _result;
  }
  factory OT_ObjectTransform.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_ObjectTransform.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_ObjectTransform clone() => OT_ObjectTransform()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_ObjectTransform copyWith(void Function(OT_ObjectTransform) updates) => super.copyWith((message) => updates(message as OT_ObjectTransform)) as OT_ObjectTransform; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_ObjectTransform create() => OT_ObjectTransform._();
  OT_ObjectTransform createEmptyInstance() => create();
  static $pb.PbList<OT_ObjectTransform> createRepeated() => $pb.PbList<OT_ObjectTransform>();
  @$core.pragma('dart2js:noInline')
  static OT_ObjectTransform getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_ObjectTransform>(create);
  static OT_ObjectTransform? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);

  @$pb.TagNumber(50)
  V3 get pos => $_getN(1);
  @$pb.TagNumber(50)
  set pos(V3 v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasPos() => $_has(1);
  @$pb.TagNumber(50)
  void clearPos() => clearField(50);
  @$pb.TagNumber(50)
  V3 ensurePos() => $_ensure(1);

  @$pb.TagNumber(60)
  V3 get rot => $_getN(2);
  @$pb.TagNumber(60)
  set rot(V3 v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasRot() => $_has(2);
  @$pb.TagNumber(60)
  void clearRot() => clearField(60);
  @$pb.TagNumber(60)
  V3 ensureRot() => $_ensure(2);

  @$pb.TagNumber(70)
  V3 get scale => $_getN(3);
  @$pb.TagNumber(70)
  set scale(V3 v) { setField(70, v); }
  @$pb.TagNumber(70)
  $core.bool hasScale() => $_has(3);
  @$pb.TagNumber(70)
  void clearScale() => clearField(70);
  @$pb.TagNumber(70)
  V3 ensureScale() => $_ensure(3);

  @$pb.TagNumber(80)
  $core.bool get updatePos => $_getBF(4);
  @$pb.TagNumber(80)
  set updatePos($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(80)
  $core.bool hasUpdatePos() => $_has(4);
  @$pb.TagNumber(80)
  void clearUpdatePos() => clearField(80);

  @$pb.TagNumber(90)
  $core.bool get updateRot => $_getBF(5);
  @$pb.TagNumber(90)
  set updateRot($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(90)
  $core.bool hasUpdateRot() => $_has(5);
  @$pb.TagNumber(90)
  void clearUpdateRot() => clearField(90);

  @$pb.TagNumber(100)
  $core.bool get updateScale => $_getBF(6);
  @$pb.TagNumber(100)
  set updateScale($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(100)
  $core.bool hasUpdateScale() => $_has(6);
  @$pb.TagNumber(100)
  void clearUpdateScale() => clearField(100);
}

class OT_SelectObject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_SelectObject', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'guid')
    ..hasRequiredFields = false
  ;

  OT_SelectObject._() : super();
  factory OT_SelectObject({
    $core.String? guid,
  }) {
    final _result = create();
    if (guid != null) {
      _result.guid = guid;
    }
    return _result;
  }
  factory OT_SelectObject.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_SelectObject.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_SelectObject clone() => OT_SelectObject()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_SelectObject copyWith(void Function(OT_SelectObject) updates) => super.copyWith((message) => updates(message as OT_SelectObject)) as OT_SelectObject; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_SelectObject create() => OT_SelectObject._();
  OT_SelectObject createEmptyInstance() => create();
  static $pb.PbList<OT_SelectObject> createRepeated() => $pb.PbList<OT_SelectObject>();
  @$core.pragma('dart2js:noInline')
  static OT_SelectObject getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_SelectObject>(create);
  static OT_SelectObject? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(10)
  set guid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(10)
  void clearGuid() => clearField(10);
}

class UpdateCSVList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCSVList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..pPS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tableNames', protoName: 'tableNames')
    ..hasRequiredFields = false
  ;

  UpdateCSVList._() : super();
  factory UpdateCSVList({
    $core.Iterable<$core.String>? tableNames,
  }) {
    final _result = create();
    if (tableNames != null) {
      _result.tableNames.addAll(tableNames);
    }
    return _result;
  }
  factory UpdateCSVList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCSVList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCSVList clone() => UpdateCSVList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCSVList copyWith(void Function(UpdateCSVList) updates) => super.copyWith((message) => updates(message as UpdateCSVList)) as UpdateCSVList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCSVList create() => UpdateCSVList._();
  UpdateCSVList createEmptyInstance() => create();
  static $pb.PbList<UpdateCSVList> createRepeated() => $pb.PbList<UpdateCSVList>();
  @$core.pragma('dart2js:noInline')
  static UpdateCSVList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCSVList>(create);
  static UpdateCSVList? _defaultInstance;

  @$pb.TagNumber(10)
  $core.List<$core.String> get tableNames => $_getList(0);
}

class RunScript extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RunScript', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptName', protoName: 'scriptName')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'group')
    ..pPS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tags')
    ..hasRequiredFields = false
  ;

  RunScript._() : super();
  factory RunScript({
    $core.String? scriptName,
    $core.String? group,
    $core.Iterable<$core.String>? tags,
  }) {
    final _result = create();
    if (scriptName != null) {
      _result.scriptName = scriptName;
    }
    if (group != null) {
      _result.group = group;
    }
    if (tags != null) {
      _result.tags.addAll(tags);
    }
    return _result;
  }
  factory RunScript.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RunScript.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RunScript clone() => RunScript()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RunScript copyWith(void Function(RunScript) updates) => super.copyWith((message) => updates(message as RunScript)) as RunScript; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RunScript create() => RunScript._();
  RunScript createEmptyInstance() => create();
  static $pb.PbList<RunScript> createRepeated() => $pb.PbList<RunScript>();
  @$core.pragma('dart2js:noInline')
  static RunScript getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RunScript>(create);
  static RunScript? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get scriptName => $_getSZ(0);
  @$pb.TagNumber(10)
  set scriptName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasScriptName() => $_has(0);
  @$pb.TagNumber(10)
  void clearScriptName() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get group => $_getSZ(1);
  @$pb.TagNumber(20)
  set group($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(20)
  void clearGroup() => clearField(20);

  @$pb.TagNumber(30)
  $core.List<$core.String> get tags => $_getList(2);
}

class OpenMLScript extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenMLScript', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptName', protoName: 'scriptName')
    ..hasRequiredFields = false
  ;

  OpenMLScript._() : super();
  factory OpenMLScript({
    $core.String? scriptName,
  }) {
    final _result = create();
    if (scriptName != null) {
      _result.scriptName = scriptName;
    }
    return _result;
  }
  factory OpenMLScript.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenMLScript.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenMLScript clone() => OpenMLScript()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenMLScript copyWith(void Function(OpenMLScript) updates) => super.copyWith((message) => updates(message as OpenMLScript)) as OpenMLScript; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenMLScript create() => OpenMLScript._();
  OpenMLScript createEmptyInstance() => create();
  static $pb.PbList<OpenMLScript> createRepeated() => $pb.PbList<OpenMLScript>();
  @$core.pragma('dart2js:noInline')
  static OpenMLScript getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenMLScript>(create);
  static OpenMLScript? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get scriptName => $_getSZ(0);
  @$pb.TagNumber(10)
  set scriptName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasScriptName() => $_has(0);
  @$pb.TagNumber(10)
  void clearScriptName() => clearField(10);
}

class OpenScene extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenScene', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pathInfo', protoName: 'pathInfo')
    ..hasRequiredFields = false
  ;

  OpenScene._() : super();
  factory OpenScene({
    $core.String? name,
    $core.String? pathInfo,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (pathInfo != null) {
      _result.pathInfo = pathInfo;
    }
    return _result;
  }
  factory OpenScene.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenScene.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenScene clone() => OpenScene()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenScene copyWith(void Function(OpenScene) updates) => super.copyWith((message) => updates(message as OpenScene)) as OpenScene; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenScene create() => OpenScene._();
  OpenScene createEmptyInstance() => create();
  static $pb.PbList<OpenScene> createRepeated() => $pb.PbList<OpenScene>();
  @$core.pragma('dart2js:noInline')
  static OpenScene getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenScene>(create);
  static OpenScene? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(10)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(10)
  void clearName() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get pathInfo => $_getSZ(1);
  @$pb.TagNumber(20)
  set pathInfo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasPathInfo() => $_has(1);
  @$pb.TagNumber(20)
  void clearPathInfo() => clearField(20);
}

class OpenMap extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpenMap', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pathInfo', protoName: 'pathInfo')
    ..hasRequiredFields = false
  ;

  OpenMap._() : super();
  factory OpenMap({
    $core.String? name,
    $core.String? pathInfo,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (pathInfo != null) {
      _result.pathInfo = pathInfo;
    }
    return _result;
  }
  factory OpenMap.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpenMap.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpenMap clone() => OpenMap()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpenMap copyWith(void Function(OpenMap) updates) => super.copyWith((message) => updates(message as OpenMap)) as OpenMap; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpenMap create() => OpenMap._();
  OpenMap createEmptyInstance() => create();
  static $pb.PbList<OpenMap> createRepeated() => $pb.PbList<OpenMap>();
  @$core.pragma('dart2js:noInline')
  static OpenMap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenMap>(create);
  static OpenMap? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(10)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(10)
  void clearName() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get pathInfo => $_getSZ(1);
  @$pb.TagNumber(20)
  set pathInfo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasPathInfo() => $_has(1);
  @$pb.TagNumber(20)
  void clearPathInfo() => clearField(20);
}

class OT_LogNodePortData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OT_LogNodePortData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'tutorial'), createEmptyInstance: create)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scriptId', $pb.PbFieldType.O3, protoName: 'scriptId')
    ..a<$core.int>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodeExportId', $pb.PbFieldType.O3, protoName: 'nodeExportId')
    ..aOB(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'needLog', protoName: 'needLog')
    ..hasRequiredFields = false
  ;

  OT_LogNodePortData._() : super();
  factory OT_LogNodePortData({
    $core.int? scriptId,
    $core.int? nodeExportId,
    $core.bool? needLog,
  }) {
    final _result = create();
    if (scriptId != null) {
      _result.scriptId = scriptId;
    }
    if (nodeExportId != null) {
      _result.nodeExportId = nodeExportId;
    }
    if (needLog != null) {
      _result.needLog = needLog;
    }
    return _result;
  }
  factory OT_LogNodePortData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OT_LogNodePortData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OT_LogNodePortData clone() => OT_LogNodePortData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OT_LogNodePortData copyWith(void Function(OT_LogNodePortData) updates) => super.copyWith((message) => updates(message as OT_LogNodePortData)) as OT_LogNodePortData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OT_LogNodePortData create() => OT_LogNodePortData._();
  OT_LogNodePortData createEmptyInstance() => create();
  static $pb.PbList<OT_LogNodePortData> createRepeated() => $pb.PbList<OT_LogNodePortData>();
  @$core.pragma('dart2js:noInline')
  static OT_LogNodePortData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OT_LogNodePortData>(create);
  static OT_LogNodePortData? _defaultInstance;

  @$pb.TagNumber(10)
  $core.int get scriptId => $_getIZ(0);
  @$pb.TagNumber(10)
  set scriptId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasScriptId() => $_has(0);
  @$pb.TagNumber(10)
  void clearScriptId() => clearField(10);

  @$pb.TagNumber(20)
  $core.int get nodeExportId => $_getIZ(1);
  @$pb.TagNumber(20)
  set nodeExportId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasNodeExportId() => $_has(1);
  @$pb.TagNumber(20)
  void clearNodeExportId() => clearField(20);

  @$pb.TagNumber(30)
  $core.bool get needLog => $_getBF(2);
  @$pb.TagNumber(30)
  set needLog($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasNeedLog() => $_has(2);
  @$pb.TagNumber(30)
  void clearNeedLog() => clearField(30);
}

