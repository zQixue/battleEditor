
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Tagger/ATag.dart';

part 'TagCamp.g.dart';

@JsonSerializable()
class TagCamp {
  @JsonKey(defaultValue: <String,ATag>{})
  Map<String,ATag> tags = <String,ATag>{};

  TagCamp();

  ATag addTag(){
    var tag = new ATag();
    tags[tag!.guid!] = tag;
    return tag;
  }

  void buildIds(){
    var iCount = 0;
    tags.forEach((key, value) {
      value.id = iCount++;
    });
  }

  void clearExportGenPath(bool isCSharp){


    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    if (isCSharp) {
      for (var t in tags.values) {
        List<String> paths = [t.commonGenPath, t.logicGenPath, t.viewGenPath];
        for (var path in paths) {
          if (!DartCommon.isEmpty(path)) {
            var logicCodePath = GlobalBoard.getCorrectDirectory(path, basePath: basePath);
            if (logicCodePath != null) {
              FileUtils.clearDirectoryFiles(logicCodePath);
            }
          }
        }
      }
    }
    else{
      for (var t in tags.values) {
        List<String> paths = [t.commonGenPathLua, t.logicGenPathLua, t.viewGenPathLua];
        for (var path in paths) {
          if (!DartCommon.isEmpty(path)) {
            var logicCodePath = GlobalBoard.getCorrectDirectory(path, basePath: basePath);
            if (logicCodePath != null) {
              FileUtils.clearDirectoryFiles(logicCodePath);
            }
          }
        }
      }
    }
  }

  //此处与类名一致，由指令自动生成代码
  factory TagCamp.fromJson(Map<String, dynamic> json) =>
      _$TagCampFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$TagCampToJson(this);

}