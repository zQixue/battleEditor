//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/SSEnumItem.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';

class CBTypeEnum extends CodeBlockyType{

  // static FieldInfo getField(String guid){
  //   var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current.behavicAgentGuid??""];
  //   return agent.getFieldByGuid(guid);
  // }

  @override
  String getBlockyType(CodeBlocky blk){
    String enumId = blk.values["enum"]??"";
    var e = SSFieldType.getFieldType(enumId);
    if (e != null) {
      return "Enum.${e.name}";
    }
    // String v = blk.values["guid"]??"";
    // var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    // var fmap = agent?.getAllFields();
    // if (fmap != null){
    //   return fmap[v]?.getFullType();
    // }

    return null;
  }

  static Map<String , SSEnumItem>  _allEnumItems ;//= Map<String , SSEnumItem> ();
  static void buildAllEnumMaps(){
    if (_allEnumItems == null) _allEnumItems = Map<String , SSEnumItem> ();
    if (_allEnumItems != null)  _allEnumItems.clear();
    var enums = SSFieldType.getTypeMap().where((element) => element is SSEnumType).toList();
    for(var a in enums){
      var e = a as SSEnumType;
      for(var i in e.items){
        i.enumId = e.guid;
        i.group = e.getTypeShowString();
        i.codeName = e.name;
        _allEnumItems[i.guid] = i;
      }
    }
  }

  static Map<String , SSEnumItem> getAllEnumItems(){
    if (_allEnumItems == null) buildAllEnumMaps();
    // Map<String , SSEnumItem>  res = Map<String , SSEnumItem> ();
    // var enums = SSFieldType.getTypeMap().where((element) => element is SSEnumType).toList();
    // for(var a in enums){
    //   var e = a as SSEnumType;
    //   for(var i in e.items){
    //     i.enumId = e.guid;
    //     i.group = e.getTypeShowString();
    //     res[i.guid] = i;
    //   }
    // }

    return _allEnumItems;
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
        // height: CodeBlockyType.baseRowHeight,
        padding: CodeBlockyType.basePadding,
        height: CodeBlockyType.baseRowHeightAdd,
        // padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: 90,
        decoration: dc,
        child : Center(child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(MaterialCommunityIcons.alpha_e_box,color: Colors.indigo,size: 20,),
            Text("枚举" , style: CodeBlockyType.baseTextStyle,)
          ],
        )),
      );
    }

    String enumId = blocky.values["enum"]??"";
    String vitem = blocky.values["item"]??"";
    // var agent = SSFieldType.getFieldType(v);//StateScriptProject.instance.registerEnumTypes().classes[ScriptInfo.current?.behavicAgentGuid??""];
    // Map<String,FieldInfo> allFields =  agent.fields;
    var itemMap = getAllEnumItems();//SSFieldType.getTypeMap().where((element) => element is SSEnumType).toList();

    SSEnumItem crt = itemMap[vitem];
    // crt =  SSFieldType.getFieldType(v);
    SSEnumType e = SSFieldType.getFieldType(enumId);

    var fields = itemMap.values.toList();
    //
    if (targetType != null) {
      var rtt = targetType.replaceFirst("Enum.", "");
      fields = fields.where((element){
        var enumId = element.enumId;
        var e = SSFieldType.getFieldType(enumId);
        // print("${e.name} $targetType");
        return e.name == rtt;
      }).toList();
    }

    if (CodeBlockyType.isTypeError(blocky , targetType)){
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
            child: Icon(MaterialCommunityIcons.alpha_e_box,color: Colors.brown ),
            message: "${crt?.name??"未指定"}",
          ),
          Text("${e?.getTypeShowString()??""} . ${crt?.getTypeShowString()??""}"  , style : TextStyle(color: Colors.brown , fontWeight: FontWeight.w600)),
          ThemeCenter.iconBtn(MaterialCommunityIcons.menu,color: Colors.black,
              tooltip: "选择枚举值",

              onPressed: (){
                CommonUtil.popupTreeMenu(fields, CommonUtil.getGlobalContex(),
                  title: "选择枚举值",
                  width: 600,
                  height: 800,
                  onBuildItem: (clz){
                    var txt = Text((clz as SSEnumItem).getTypeShowString() , style : clz == crt ? TextStyle(color: Colors.greenAccent):null);
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
                    HistoryManager.functionHistory?.appendHistory();
                    blocky.values["enum"] = clz.enumId;
                    blocky.values["item"] = clz.guid;
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

  CBTypeEnum(){
    typeFlag = BlockyTypes.BT_VAR;
    setDefaultColor(Color(0xFF666699));
    name = "enum";
    alias = "枚举";
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    // String enumId = blk.values["enum"]??"";
    String vitem = blk.values["item"]??"";

    var itemMap = getAllEnumItems();//SSFieldType.getTypeMap().where((element) => element is SSEnumType).toList();
    SSEnumItem crt = itemMap[vitem];
    if (crt == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 无效的枚举值, ${func.getTypeShowString()}");
      return 0;
    }
    // crt =  SSFieldType.getFieldType(v);
    // SSEnumType e = SSFieldType.getFieldType(enumId);
    bw.writeUint16(CodeBlockyType.OP_PUSH + CodeBlocky.operateExtras["int"] , "enum 转 int 压栈");
    bw.writeUint32(crt.enumValue??crt.exportId??0 , "enum 转 int 值");
    return 1;
  }
  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    // StringBuffer sb = StringBuffer();

    String vitem = blk.values["item"]??"";
    var itemMap = getAllEnumItems();//SSFieldType.getTypeMap().where((element) => element is SSEnumType).toList();
    SSEnumItem crt = itemMap[vitem];
    if (crt == null){
      return "无效枚举";
    }
    return "${crt.codeName}.${crt.name}";
    // return sb.toString();
  }
  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    String vitem = blk.values["item"]??"";
    var itemMap = getAllEnumItems();//SSFieldType.getTypeMap().where((element) => element is SSEnumType).toList();
    SSEnumItem crt = itemMap[vitem];
    if (crt == null){
      return res;
    }
    res["enumItem"] = {
      "enum" : crt.group,
      "item" : crt.name,
    };
    return res;
  }
}