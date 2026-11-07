
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';

part 'PortConnection.g.dart';

@JsonSerializable()
class PortConnection extends SSObjBase{

  String outNodeGuid="";
  String outPortGuid="";

  String inNodeGuid="";
  String inPortGuid="";
  String sopGuid="";

  int lineColor = 0xFF0099CC;

  @JsonKey(defaultValue: 0)
  double offY = 0;

  @JsonKey(defaultValue: 0)
  double outOffX = 0;
  @JsonKey(defaultValue: 0)
  double inOffX = 0;

  @JsonKey(ignore: true)
  Offset? downPointer;

  @JsonKey(ignore: true)
  double? downOffY;

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

    var outPort = outNode.getOutPort(outPortGuid);
    var inPort = inNode.getNodeStructType()!.getInPort(inPortGuid);
    if (outPort?.isDynamic??false) {
      _connectionId = "${outNode.exportId}_D_${outPort!.exportId}_${inNode.exportId}_${inPort!.exportId}";
    }
    else{
      _connectionId = "${outNode.exportId}_${outPort!.exportId}_${inNode.exportId}_${inPort!.exportId}";
    }
    return _connectionId;
  }

  @JsonKey(defaultValue: false)
  bool enableBreakPoint = false;
  void buildLongGuid(){
    guid = "${outNodeGuid}_${outPortGuid}_${inNodeGuid}_$inPortGuid";
  }
  PortConnection();
  //此处与类名一致，由指令自动生成代码
  factory PortConnection.fromJson(Map<String, dynamic> json) =>
      _$PortConnectionFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$PortConnectionToJson(this);


}