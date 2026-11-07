

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';

part 'NodeGroup.g.dart';

@JsonSerializable()
class NodeGroup extends SSObjBase {

  @JsonKey(defaultValue: "")
  String msg = "";
  int backgroundColor = Colors.blueAccent.value;
  @JsonKey(ignore: true)
  Rectangle<double>? currentGroupRect;

  @JsonKey(ignore: true)
  List<StateScriptNode>? nodes;

  static void buildCurrentScriptGroupNodes(){
    if (ScriptInfo.current == null) return ;
    var sd = ScriptInfo.current!.getScriptData();
    if (sd == null) return ;
    Map<String,NodeGroup> groupMaps = Map<String,NodeGroup>();
    sd.nodeGroups.forEach((element) { groupMaps[element.guid] = element;element.nodes?.clear(); });
    sd.nodes.forEach((node) {
      var groupId = node.group;
      var g = groupMaps[groupId];
      if (g != null){
        if (g.nodes == null) g.nodes = <StateScriptNode>[];
      }
      g!.nodes!.add(node);
    });
  }
  // List<StateScriptNode> getNodes(){
  //
  //
  //   if (ScriptInfo.current != null){
  //     List<StateScriptNode> res = List<StateScriptNode>();
  //     for(var n in ScriptInfo.current.getScriptData().nodes){
  //       if (n.group == guid){
  //         res.add(n);
  //       }
  //     }
  //
  //     return res;
  //   }
  //   return null;
  // }

  void doRemove(){
    if (ScriptInfo.current != null){
      for(var n in ScriptInfo.current!.getScriptData()!.nodes){
        if (n.group == guid){
          n.group = "";
        }
      }
    }
    ScriptInfo.current!.getScriptData()!.nodeGroups.remove(this);
  }

  Rectangle<double>? getRect(){
    var lst = nodes;//getNodes();
    if (lst == null || lst.length<=0) return null;
    double x1 = double.maxFinite;
    double y1 = double.maxFinite;
    double x2 = double.minPositive;
    double y2 = double.minPositive;
    double xEx = 80;
    double yEx1 = 100;
    double yEx2 = 140;
    for(var n in lst){
      if (n.getNodeStructType() == null) continue;
      x1 = min(x1,n.x - xEx);
      y1 = min(y1,n.y - yEx1);
      x2 = max(x2,n.x + (n?.getWidth()??0) + xEx);
      var hs = max(n.getInPortCount() , n .getOutPortCount()) * SSDefines.nodeFieldRowHeight ;
      y2 = max(y2,n.y + hs + yEx2);
    }
    currentGroupRect = Rectangle<double>(x1,y1,x2-x1,y2-y1);
    return Rectangle<double>(x1,y1,x2-x1,y2-y1);
  }

  NodeGroup();

  //此处与类名一致，由指令自动生成代码
  factory NodeGroup.fromJson(Map<String, dynamic> json) =>
      _$NodeGroupFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$NodeGroupToJson(this);

}
