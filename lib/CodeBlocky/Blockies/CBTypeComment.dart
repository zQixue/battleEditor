//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';

import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/text_editor.dart';

class CBTypeComment extends CodeBlockyType{


  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 1),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((5.0))
    );

    if (blocky == null) {
      return Container(
        height: CodeBlockyType.baseRowHeightAdd,
        padding: CodeBlockyType.basePadding,
        width: 100,
        decoration: dc,
        child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
      );
    }
    // var dtgt1 = BlockySlotEditor(targetType: null ,blockFlag: BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_EXPR,
    //     container: blocky, slot : "0");
    var val = blocky.values["comment"]??"";

    // var input = AutoSizeTextEditor(
    //   decoration: InputDecoration(
    //     // fillColor: ThemeCenter.systemTheme.scaffoldBackgroundColor,
    //     // border: InputBorder.none,
    //     // prefixIcon: Text("$txt: ",style:TextStyle(fontSize: 12,color: Colors.grey)),
    //     //   prefixText:"$txt: ",
    //     // prefixStyle : TextStyle(fontSize: 12,color: Colors.grey),
    //     // labelText: "$txt: ",
    //     // hintStyle : TextStyle(fontSize: 30,color: Colors.grey),
    //     // isDense: true,
    //
    //     contentPadding: EdgeInsets.only(top: 0),
    //
    //   ),
    //   style: TextStyle(fontSize: 18 , color: Colors.grey),
    //   withFocusManager: false,
    //   initValue: val,
    //   fullWidth: false,
    //   // controller: _textEditingController,
    //   // style: TextStyle(fontSize: 13),
    //   maxLines: 1,
    //   onChanged: (v){
    //     blocky.values["comment"] = v;
    //   },
    //
    //   onSubmitted: (v){
    //     blocky.values["comment"] = v;
    //   },
    // );
    var con = Container(
      padding: CodeBlockyType.basePadding,
      key: ValueKey(blocky.guid),
      // padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      // width: 120,

      decoration: dc,
      width: 540,
      // child:TextField(
      //   maxLines: null,
      //   keyboardType: TextInputType.multiline,
      //   decoration: InputDecoration.collapsed(
      //     hintText: "Write a comment",
      //   ),
      child: Center(child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("//",style: TextStyle(fontSize: 18 , color: Colors.grey)),
          Expanded(child:TextEditor(
            maxLines: null,
            textStyle: TextStyle(fontSize: 18 , color: Colors.grey),
            textInputType :TextInputType.multiline,
            initValue: val,
              onChanged: (v){
                blocky.values["comment"] = v;
              },

              onSubmitted: (v){
                blocky.values["comment"] = v;
              },
          )),
          Icon(MaterialCommunityIcons.drag,color: Colors.grey,size: 20,),
        ],
      ),
    ));
    return con;
    // return Column(
    //   children: [
    //     con,
    //     SizedBox(height: CodeBlockyType.baseInterval ,)
    //   ],
    // );
  }
  CBTypeComment(){
    typeFlag = BlockyTypes.BT_BLOCK;
    setDefaultColor(Colors.green);
    name = "Comment";
    alias = "注释";
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    return 0;
  }


  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    // var varBlk = blk.getBlocky("0");
    // res["var"] = blk.getBlockyCode("0");//CodeBlockyType.getType("___var___").getExportFuncInfo(varBlk);
    res["expr"] = blk.getBlockyCode("0");
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    return null;
  }
}