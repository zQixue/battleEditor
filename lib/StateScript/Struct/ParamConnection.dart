
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';

part 'ParamConnection.g.dart';

@JsonSerializable()
class ParamConnection extends SSObjBase{

  String outNodeGuid="";
  String outParamGuid="";

  String inNodeGuid="";
  String inParamGuid="";
  String sopGuid="";

  int lineColor = 0xFFCCFF66;

  @JsonKey(defaultValue: 0)
  double offY = 0;
  @JsonKey(defaultValue: 0)
  double outOffX = 0;
  @JsonKey(defaultValue: 0)
  double inOffX = 0;
  @JsonKey(ignore: true)
  Offset? downPointer;

  @JsonKey(defaultValue: false)
  bool enableBreakPoint = false;

  @JsonKey(ignore: true)
  double? downOffY;
  void buildLongGuid(){
    guid = "${outNodeGuid}_${outParamGuid}_${inNodeGuid}_$inParamGuid";
  }

  @JsonKey(ignore: true)
  String? _connectionId;
  String? getConnectionId(StateScript sd){
    if (_connectionId != null){
      return _connectionId;
    }
    var outNode = sd.nodeMap![outNodeGuid];
    var inNode = sd.nodeMap![inNodeGuid];

    if (outNode == null || inNode == null) {
      _connectionId = "";
      return _connectionId;
    }

    var outPort = outNode.getNodeStructType()!.getOutParam(outParamGuid);
    var inPort = inNode.getInParam(inParamGuid);
    if (inPort?.isDynamic??false) {
      _connectionId = "${inNode.exportId}_D_${inPort!.exportId}_${outNode.exportId}_${outPort!.exportId}";
    }
    else {
      _connectionId = "${inNode.exportId}_${inPort!.exportId}_${outNode.exportId}_${outPort!.exportId}";
    }
    return _connectionId;
  }

  ParamConnection();
  //此处与类名一致，由指令自动生成代码
  factory ParamConnection.fromJson(Map<String, dynamic> json) =>
      _$ParamConnectionFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ParamConnectionToJson(this);
}