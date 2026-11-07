
import 'dart:io';

import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/GlobalDoard.dart';

import 'package:path/path.dart' as PathUtil;

part 'ResourceList.g.dart';

@JsonSerializable()
class ResourceList extends SSObjBase{
  @JsonKey(defaultValue: "")
  String targetPath = "";
  @JsonKey(defaultValue: "")
  String searchPattern = "";
  @JsonKey(defaultValue: false)
  bool recursively = false;

  @JsonKey(ignore: true)
  Map<String , String> name2Paths = <String , String>{};

  ResourceList();

  //此处与类名一致，由指令自动生成代码
  factory ResourceList.fromJson(Map<String, dynamic> json) =>
      _$ResourceListFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ResourceListToJson(this);

  ResourceList clone(){
    return ResourceList()..name = name ..alias = alias ..targetPath = targetPath ..searchPattern = searchPattern;
  }

  void collect() {
    name2Paths.clear();
    var fullPath = GlobalBoard.getCorrectDirectory(targetPath);
    var pts = Map<String,bool>.fromIterable(searchPattern.split(";"),key:(v)=>(v as String).trim().toLowerCase(), value:(v)=> true);

    if (fullPath != null){
      var files = Directory(fullPath).listSync(recursive: recursively??false);
      files.forEach((element) {
        var ext = PathUtil.extension(element.path);
        if (pts.containsKey(ext.toLowerCase())){
          name2Paths[PathUtil.basenameWithoutExtension(element.path)] = element.path;
          print("collected : ${element.path}");
        }
      });
    }
  }
}