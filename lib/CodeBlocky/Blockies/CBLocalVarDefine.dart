
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
// import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/CodeBlocky/local_var_define_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
// part 'CBLocalVarDefine.g.dart';

@JsonSerializable()
class CBLocalVarDefine extends CodeBlockyType{


  @override
  Widget getBlockWidget(CodeBlocky? blocky , String? targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.5),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );
    if (blocky == null) {
      return Container(
        height: CodeBlockyType.baseRowHeight,
        width: 120,
        decoration: dc,
        child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
      );
    }

    var fiGuid = blocky.values["guid"];
    var fi = CodeBlocky.curentFunction!.getLocalField(fiGuid);

    return Container(
      // key: ValueKey(blocky.guid),
      // height: CodeBlockyType.baseRowHeight,
      // child: Row(
      //   children: [
      //     TextEditor(
      //       initValue: fi.name,
      //       onChanged: (v){
      //         fi.name = v;
      //       },
      //     )
      //   ],
      // ),
      child:LocalVarDefineView(field: fi,function: CodeBlocky.curentFunction,),
      // width: 120,
      decoration: dc,
    );
  }


  CBLocalVarDefine();
  // //此处与类名一致，由指令自动生成代码
  // factory CBLocalVar.fromJson(Map<String, dynamic> json) =>
  //     _$CBLocalVarFromJson(json);
  //
  // //此处与类名一致，由指令自动生成代码
  // Map<String, dynamic> toJson() => _$CBLocalVarToJson(this);

}