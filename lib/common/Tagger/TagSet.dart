
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/Tagger/ATag.dart';

part 'TagSet.g.dart';

@JsonSerializable()
class TagSet {
  @JsonKey(defaultValue: <String>[])
  List<String> tagGuids = <String>[];


  TagSet();

  //此处与类名一致，由指令自动生成代码
  factory TagSet.fromJson(Map<String, dynamic> json) =>
      _$TagSetFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$TagSetToJson(this);

  TagSet clone() {
    TagSet res = TagSet();
    res.tagGuids.addAll(tagGuids);
    return res;
  }

  List<String> getTagNames(){
    List<String> res = <String>[];

    tagGuids.forEach((element) {
      var tag = StateScriptProject.instance!.tagCamp.tags[element];
      res.add(tag?.getTypeShowString()??"");
    });


    return res;
  }


  int getIDFlag(){
    int res = 0;
    if (tagGuids == null || tagGuids.length <=0 || StateScriptProject.instance!.tagCamp == null || StateScriptProject.instance!.tagCamp.tags == null || StateScriptProject.instance!.tagCamp.tags
        .length<=0){
      res = ATag.tagCommonFlag;
      return res;
    }
    tagGuids.forEach((element) {
      var tag = StateScriptProject.instance!.tagCamp.tags[element];
      if (tag != null) {
        res |= 1 << tag!.id!;
      }
    });

    return res;
  }

}