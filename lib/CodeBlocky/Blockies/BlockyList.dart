
import 'package:battlepus/CodeBlocky/Blockies/BlockyContainer.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/EventCenter.dart';
part 'BlockyList.g.dart';

@JsonSerializable()
class BlockyList extends SSObjBase implements IBlockyContainer{
//  @JsonKey(ignore: true)

  List<CodeBlocky>? blockies;

//  void load(){
//
//  }
//  void save(){
//
//  }
  List<CodeBlocky>? getBlockies(){
    if (blockies == null){
//      load();
      blockies = <CodeBlocky>[];
    }
    return blockies;
  }
  @override
  void addBlocky(CodeBlocky blocky){
    if (blockies == null){
      blockies = <CodeBlocky>[];
    }

    if (blocky.container != null){
      blocky.container?.removeBlocky(blocky);
    }
    blocky.container = this;
    blockies?.add(blocky);
    EventCenter.eventBus.fire(BlockContainerRefresh()..container = this);

  }

  @override
  void removeBlocky(CodeBlocky blocky){
    if (blockies == null){
      return;
    }
    int iIndex = blockies!.indexOf(blocky);
    if (iIndex>=0) {
      blocky.container = null;
      blockies?.removeAt(iIndex);
      EventCenter.eventBus.fire(BlockContainerRefresh()..container = this);
    }
  }

  @override
  CodeBlocky getBlocky(String iIndex) {
    // TODO: implement getBlocky
    throw UnimplementedError();
  }

  @override
  void setBlocky(String iIndex, CodeBlocky val) {
    // TODO: implement setBlocky
    throw UnimplementedError();
  }

  BlockyList();
  //此处与类名一致，由指令自动生成代码
  factory BlockyList.fromJson(Map<String, dynamic> json) =>
      _$BlockyListFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BlockyListToJson(this);

  @override
  bool isParentOf(CodeBlocky cb) {
    // TODO: implement isParentOf
    // throw UnimplementedError();
    return false;
  }


  String getExportCode(){
    var blks = getBlockies();
    var buffer = new StringBuffer();
    for(var blk in  blks!) {
      var code = blk.getExportCode();
      buffer.write(code);
      buffer.write("\n");
    }

    return buffer.toString();
  }

  String getBehavicCode({bool breakLine = false}){
    var blks = getBlockies();
    var buffer = new StringBuffer();
    for(var blk in  blks!) {
      var code = blk.getBehavicCode();
      if (code == null) continue;
      buffer.write(code);buffer.write(";");if (breakLine) buffer.write("\n");
    }

    return buffer.toString();
  }


  int doCompile(ByteDataWriter bw , List<String> errLst , CBFunction func){
    var blockies = getBlockies();
    int iCount = 0;
    if (blockies!.length > 0) {
      // var tp = CodeBlockyType.getType(blockies[0].blockyTypeId);
      // for(var b in blockies) {
      for(var i = 0 ; i < blockies.length ; ++i) {
        var b = blockies[i];
        iCount += CodeBlockyType.doCompile(b, null, bw, errLst, func);

        if (i<blockies.length-1){
          if (b.blockyTypeId == "___expr___"){
            errLst.add("结点 ${StateScriptNode.crtExportNode!.exportId} , 检测到return之后不可能执行到的代码");
            return iCount;
          }
        }
      }
    }

    return iCount;
  }
}