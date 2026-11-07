//@dart=2.11


import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/right_tool_bar.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/common/text_editor.dart';

class SSGroup extends SSString{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType  , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.group , color: Colors.indigoAccent,),
        SizedBox(width: 8,),
//        Container(child:Text(getTypeShowString(),maxLines: 1,overflow: TextOverflow.clip)),
        Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }

    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();

    if (ScriptInfo.current != null){
      for(var i in ScriptInfo.current.scriptData.nodeGroups){
        var item = PopupMenuItem<String>(
          value: i.guid,
          child: Text(i.getTypeShowString() , style :TextStyle(color: Colors.black , fontSize: levelInfo?.fontSize)),
        );
        items.add(item);
      }
    }
    var itemNone = PopupMenuItem<String>(
      value: "",
      child: Text("未指定" , style :TextStyle(color: Colors.grey , fontSize: levelInfo?.fontSize)),
    );
    items.add(itemNone);

    var res = PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      icon : Icon(MaterialCommunityIcons.menu , size: SSDefines.iconButtonSize,),

      initialValue:v,
      onSelected: (String result) {
        onSubmitted?.call(result);
      },
      itemBuilder: (BuildContext context) => items,
    );
    var dc =  BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1,color: Colors.grey),
        ));
    return EditorHolder()..widget = Container(
        height: baseHeight,
        decoration: dc,
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded(child:getValueLabelWidget(initValue,style: SSDefines.lineContentStyle)),
            SSDefines.IBC(child: res),
            // Container(
            //   // width: 30,
            //   child: res,
            // ),
//            SizedBox(width: scriptInfo != null?8:0,),
//           res,
//             Container(
//               // width: 30,
//               child: scriptInfo != null?IconButton(
//                 padding: EdgeInsets.all(0),
//                 icon : Icon(MaterialCommunityIcons.link_box_outline),
//                 onPressed: (){
//                   RightToolBarState.scriptStack.push(ScriptInfo.current.guid);
//                   ScriptInfo.current = scriptInfo;
//                   ZoomState.current.centered();
//                   EventCenter.eventBus.fire(GlobalRefreshEvent());
//                 },
//                 tooltip: "打开",
//               ):const SizedBox(width: 0,),
//             ),

          ],
        )
    ) ..height = baseHeight;
  }
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted,{Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    return EditorHolder()..widget = Container()..height = SSDefines.nodeFieldRowHeight;
    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    for(var i in StateScriptProject.instance.scripts){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: Text(i.getTypeShowString()),
      );
      items.add(item);
    }
    var itemNone = PopupMenuItem<String>(
      value: "",
      child: Text("未指定"),
    );
    items.add(itemNone);

    var res = PopupMenuButton<String>(
      icon : Icon(MaterialCommunityIcons.menu),
      initialValue:v,
      onSelected: (String result) {
        onSubmitted?.call(result);
      },
      itemBuilder: (BuildContext context) => items,
    );
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    return EditorHolder()..widget = Container(
        width: levelInfo?.lineWidth,
        height : levelInfo?.lineHeight,
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded( flex: 6, child:getValueLabelWidget(initValue)),
            Container(
              width: 30,
              child: res,
            ),
            SizedBox(width: scriptInfo != null?8:0,),
            scriptInfo != null?IconButton(
              icon : Icon(MaterialCommunityIcons.link_box_outline),
              onPressed: (){
                RightToolBarState.scriptStack.push(ScriptInfo.current.guid);
                ScriptInfo.current = scriptInfo;
                ZoomState.current.centered();
                EventCenter.eventBus.fire(GlobalRefreshEvent());
              },
              tooltip: "打开",
            ):const SizedBox(width: 0,)
          ],
        )
    ) ..height = SSDefines.nodeFieldRowHeight;
//    return TextEditor(
//      initValue: v,
//      onChanged: (v){
//        onChanged?.call(v);
//      },
//      onSubmitted: (v){
//        onSubmitted?.call(v);
//      },
//    );
  }


  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    return EditorHolder()..widget = Container(
      child: Row(
        children: [
          Expanded(
              child: TextEditor(
                contentPadding: EdgeInsets.all(0),
                noUnderline: true,
                textStyle: TextStyle(fontSize: 16),
                initValue: v,
                onChanged: (v){
                  onChanged?.call(v);
                },
                onSubmitted: (v){
                  onSubmitted?.call(v);
                },
              )
          )
        ],
      ),
    );
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    // var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == str, orElse:()=>null);

    bw.writeInt32(str==null || str.trim() ==""?0:str.hashCode , exportFlag);
//    bw.writeString(scriptInfo==null?"":scriptInfo.name, exportFlag);
  }

  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    // var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == str, orElse:()=>null);
    return str==null || str.trim() ==""?0:str.hashCode;
  }

  @override
  dynamic parseFinalValue(value){
    String str = parseValue(value);
    // var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == value, orElse:()=>null);
    var res = str==null || str.trim() ==""?0:str.hashCode;
    return res;
  }

  @override
  Widget getValueLabelWidget(initValue , {TextStyle style}){
    var str = parseValue(initValue);
    if (ScriptInfo.current != null){
      for(var i in ScriptInfo.current.scriptData.nodeGroups){
        if (i.guid == str){
          return Text(i.getTypeShowString() , style: style);
        }
      }
    }

    return Text("未指定", style: style);
    // if (scriptInfo == null){
    //   return const Text("未指定");
    // }
    // return Text(scriptInfo.getTypeShowString());
  }

  @override
  dynamic getExportDefault(dynamic defaultValue){
    return 0;
  }

  @override
  String getExportType(){
    return "String";
  }
}