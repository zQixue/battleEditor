

import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSAgent.dart';
import 'package:battlepus/StateScript/Struct/SSComponent.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;

part 'NodeCamp.g.dart';

@JsonSerializable()
class NodeCamp {
  @JsonKey(defaultValue: <NodeStructData>[])
  List<NodeStructData> nodeStructs = <NodeStructData>[];

  @JsonKey(defaultValue: <SSEnumType>[])
  List<SSEnumType> enums = <SSEnumType>[];

  @JsonKey(defaultValue: <SSAgent>[])
  List<SSAgent> agents = <SSAgent>[];

  @JsonKey(defaultValue: <SSComponent>[])
  List<SSComponent> components = <SSComponent>[];

  NodeCamp();
  //此处与类名一致，由指令自动生成代码
  factory NodeCamp.fromJson(Map<String, dynamic> json) =>
      _$NodeCampFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$NodeCampToJson(this);


  void saveTo(String filePath){
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(this);
//    var path = PathUtil.join(GlobalBoard.getWorkingPath(),"state_script");//, name+".json");
    var path = PathUtil.dirname(filePath);
    var d = Directory(path);
    if (!d.existsSync()) d.createSync();
    var f = File(filePath);
    f.writeAsStringSync(json);
  }

  void save(){
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(this);
    var path = PathUtil.join(GlobalBoard.getWorkingPath(),"state_script");//, name+".json");

    var d = Directory(path);
    if (!d.existsSync()) d.createSync();
    var f = File(PathUtil.join(path,"ss_nodes_store.json"));
    f.writeAsStringSync(json);
  }

  static NodeCamp? loadFrom(String filePath){
//    var path = PathUtil.join(GlobalBoard.getWorkingPath(),"state_script");
//    path = PathUtil.canonicalize(path);
//
//    var jsonPath = PathUtil.join(path , "ss_nodes_store.json");
    var f = File(filePath);
    if (f.existsSync()){
      Map<String,dynamic> userMap = jsonDecode(f.readAsStringSync());
      return NodeCamp.fromJson(userMap);
    }

    return null;
  }

  static void load(){
    var path = PathUtil.join(GlobalBoard.getWorkingPath(),"state_script");
    path = PathUtil.canonicalize(path);

    var jsonPath = PathUtil.join(path , "ss_nodes_store.json");
    var f = File(jsonPath);
    if (f.existsSync()){
//      JsonDecoder decoder = JsonDecoder();
      Map<String,dynamic> userMap = jsonDecode(f.readAsStringSync());
      _instance = NodeCamp.fromJson(userMap);
    }
  }

//  NodeStructData getBaseType(NodeStructData n){
//    var bt = nodeStructs[n.baseType??""];
//    return bt;
//  }

//  bool isTypeOf(NodeStructData n , NodeStructData parent){
//    if (n.guid == parent.guid) return true;
//    var bt = getBaseType(n);
//    if (bt == null) return false;
//    return isTypeOf(bt , parent);
//  }

//  bool removeNodeType(NodeStructData nodeType) {
//    var _deleted = List<NodeStructData>();
//    nodeStructs.forEach((key, ns) {
//      if (ns == nodeType || isTypeOf(ns , nodeType))
//        _deleted.add(ns);
//    });
//
//    for(var n in _deleted){
//      nodeStructs.remove(n.guid);
//    }
//
//  }

  bool appendNodeType(NodeStructData? nodeType){
    if (nodeType == null) return false;
    var bt = nodeType.getBaseType();
    appendNodeType(bt);

    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(nodeType);
    var node = NodeStructData.fromJson(jsonDecode(json));

    var codePath = StateScriptProject.instance!.currentExportConfig!.nodeCodeExportPath;
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var codeNodePath = GlobalBoard.getCorrectDirectory(codePath, basePath: basePath);

    var nodeCodePath = PathUtil.join(codeNodePath , "${node.name}.cs");
//    print(nodeCodePath);
    node.guid = nodeType.guid;
    if (File(nodeCodePath).existsSync()){
//      var code = File(nodeCodePath).readAsStringSync();
    var codebytes = File(nodeCodePath).readAsBytesSync();
    var code = String.fromCharCodes(codebytes);
      node.code = code;
    }
    nodeStructs.add(node);
//    if (nodeStructs.)
//    bool res = nodeStructs.containsKey(node.guid);
//    nodeStructs[node.guid] = node;


    return true;
  }
  SSComponent? getComponent(String guid) {
    for(var c in components){
      if (c.guid == guid) return c;
    }

    return null;
  }
  Map<String , List<NodeStructData> > getStructGroups(){
    var res = Map<String , List<NodeStructData> >();

    for(var ns in nodeStructs){
//    nodeStructs.forEach((key, ns) {
      var lst = res[ns.group];
      if (lst == null){
        lst = <NodeStructData>[];
        res[ns.group] = lst;
      }
      lst.add(ns);
    }

    res.forEach((key, value) {
      value.sort((a,b)=>a.name.compareTo(b.name));
    });
    return res;
  }

  static NodeCamp? _instance;
  static NodeCamp? get instance {
    if (_instance == null) _instance = new NodeCamp();
    return _instance;
  }

}