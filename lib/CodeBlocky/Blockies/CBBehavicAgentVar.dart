//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class CBBehavicAgentVar extends CodeBlockyType{

  static FieldInfo getField(String guid){
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current.behavicAgentGuid??""];
    var f = agent?.getFieldByGuid(guid);
    // if (!f.isPublic) return null;
    return f;
  }

  @override
  String getBlockyType(CodeBlocky blk){
    String v = blk.values["guid"]??"";
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    var fmap = agent?.getAllFields();
    if (fmap != null){
      return fmap[v]?.getFullTypeWithExtra();
    }

    return null;
  }

  @override
  BehavicAgentClass getStructType(CodeBlocky blk){
    String v = blk.values["guid"]??"";
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    var fmap = agent?.getAllFields();
    if (fmap != null){
      var fi = fmap[v];
      if (fi != null){
        var tp = SSFieldType.getFieldType(fi.typeGuid);
        if (tp is BehavicAgentClass){
          return tp;
        }
      }
    }
    return null;
  }

  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
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

        height: CodeBlockyType.baseRowHeightAdd,
        // padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: 120,
        decoration: dc,
        // child : Center(child : Text("Agent变量" , style: CodeBlockyType.baseTextStyle,)),
        child : Center(child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(MaterialCommunityIcons.alpha_f_box_outline,color: Colors.indigo,size: 20,),
            Text("Agent变量" , style: CodeBlockyType.baseTextStyle,)
          ],
        )),
      );
    }

    String v = blocky.values["guid"]??"";
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    // Map<String,FieldInfo> allFields =  agent.fields;
    var fmap = agent?.getAllFields();
    FieldInfo crt ;
    if (agent != null){
      crt = fmap[v];
    }
    List<FieldInfo> fields = fmap?.values?.where((element){
      if (blocky.readonlyFlag){
        return !element.isReadOnly;
      }
      else return true;//element.isPublic;

    })?.toList()??List<FieldInfo>();

    dc = new BoxDecoration(
      border: new Border.all(color: bgColor, width: 0.5),
      color :(targetType != null && crt != null && crt.getFullTypeWithExtra() != targetType)?Colors.redAccent: bgcolor2,
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
      borderRadius: new BorderRadius.circular((90.0))
    );
    // if (crt == null && v != ""){
    //   var temp = FieldInfo()..guid = v;
    //   temp.name = "INVALID";
    //   temp.alias = "无效";
    //   temp.extraType = blocky.values["type"]??1;
    //   crt = temp;
    //   fields.add(temp);
    // }
    if (targetType != null) {
      fields = fields.where((element) => element.getFullTypeWithExtra() == targetType).toList();
    }

    if (CodeBlockyType.isTypeError(blocky , targetType) || !isCurrentFieldValid(blocky)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 0.5),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      key: ValueKey(blocky.guid),
      height: CodeBlockyType.baseRowHeight ,
      child:Row(
        children: [
          // Icon(MaterialCommunityIcons.alpha_f_box,color: Colors.brown ),
          Tooltip(
            child: Icon(MaterialCommunityIcons.alpha_f_box,color: Colors.brown ),
            message: "${crt?.getFullTypeWithExtra()??"未指定"}",
          ),
          Text(crt?.getTypeShowString()??"" , style : TextStyle(color: Colors.brown , fontWeight: FontWeight.w600)),
          ThemeCenter.iconBtn(MaterialCommunityIcons.menu,color: Colors.black,
            tooltip: "选择 agent 字段",

            onPressed: (){
              CommonUtil.popupTreeMenu(fields, CommonUtil.getGlobalContex(),
                title: "选择 agent 字段",
                width: 600,
                height: 800,
                onBuildItem: (clz){
                  var txt = Text((clz as FieldInfo).getTypeShowString() , style : clz == crt ? TextStyle(color: Colors.greenAccent):null);
                  return Row(
                    children: [
                      Container(width: 4,),
                      Expanded(child : txt),
                    ],
                  );
                },
                // onBuildGroup: (node){
                //   return Text(node.name??"");
                // },
                onResult: (clz){
                  if (clz == null) return ;
                  // widget.onChanged?.call(clz);
                  // blocky.values["guid"] = (clz as FieldInfo).guid;
                  HistoryManager.functionHistory?.appendHistory();
                  blocky.values["guid"] = (clz as FieldInfo).guid;
                  blocky.values["fieldTypeGuid"] = clz.typeGuid??"";
                  // print(allFields[v].guid);
                  EventCenter.eventBus.fire(BlockContainerRefresh());
                },
                // actions: [
                //   RaisedButton(
                //     child: Text("清空"),
                //     color: Colors.redAccent,
                //     onPressed: (){
                //       widget.onClear?.call();
                //       Navigator.pop(context);
                //     },
                //   )
                // ]
              );
            }
          ),
        ],
      ),
      decoration: dc,
    );
  }

  CBBehavicAgentVar(){
    typeFlag = BlockyTypes.BT_VAR;
    setDefaultColor(Color(0xFF666699));
    name = "BAVar";
    alias = "Behavic Var";
  }
  bool isCurrentFieldValid(CodeBlocky blk){
    String guid = blk.values["guid"]??"";
    var field = getField(guid);
    if (field != null){
      if (blk.readonlyFlag){
        return !(field.isReadOnly??false);
      }
      else {
        return true;//field.isPublic ?? false;
      }
    }

    return true;
  }
  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    String guid = blk.values["guid"]??"";
    var field = getField(guid);
    if (field == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , 无效的 BA 变量, 结点类型:${func.getTypeShowString()}");
      return 0;
    }
    // if (!field.isPublic){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , BA 变量不可访问, ${func.getTypeShowString()}");
    //   return 0;
    // }
    // if (blk.readonlyFlag && field.isReadOnly){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , BA 变量只读，不可访问, ${func.getTypeShowString()}");
    //   return 0;
    // }
    int optextra = blk.getOperateExtraType();
    if (optextra == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
      return 0;
    }
    bw.writeUint16(CodeBlockyType.OP_PUSH_BAVAR + optextra, "BA变量压栈");
    bw.writeUint32(field.exportId, "BA 变量 id");
    return 1;
  }

  @override
  int compileRef(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst , CBFunction func){
    String guid = blk.values["guid"]??"";
    var field = getField(guid);
    int optextra = blk.getOperateExtraType();
    bw.writeUint16(CodeBlockyType.OP_ASSIGN_BAVAR + optextra, "ref 设置BA变量");
    bw.writeUint32(field.exportId, "BA变量id");
    return 1;
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    String guid = blk.values["guid"]??"";
    var field = getField(guid);

    if (field != null){
      res = field.exportInfo();
    }
    else{
      res["fieldType"] = "INVALID";
      res["extraType"] = "INVALID";
      res["name"] = "INVALID";
      res["hash"] = "INVALID";
      res["extra"] = "INVALID";
      return res;
    }
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){

    String guid = blk.values["guid"]??"";
    var field = getField(guid);

    if (field != null){
      return field.name;
    }
    return "未知BA变量";
  }
}