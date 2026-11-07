//@dart=2.11


import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_dropdown_ex.dart';

class SSFunction extends SSString{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType  , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.function_variant , color: Colors.indigoAccent,),
        SizedBox(width: 8,),
//        Container(child:Text(getTypeShowString(),maxLines: 1,overflow: TextOverflow.clip)),
        Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  static Map<String , CBFunction> searchKey2Object = {};
  static List<DropdownMenuItem<String>> getItems(){
    List<DropdownMenuItem<String>> items = new  List<DropdownMenuItem<String>>();
    for(var i in StateScriptProject.instance.functions){
      if (!(i.active??false)) continue;
      var key = i.getSearchKey();
      searchKey2Object[key] = i;

      var item = DropdownMenuItem<String>(
        value: key,
        child: Text(i.getTypeShowString() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.indigoAccent)),
      );
      items.add(item);
    }

    var itemNone = DropdownMenuItem<String>(
      value: "",
      child: Text("空",style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.red)),
    );
    items.add(itemNone);
    return items;
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    baseHeight = 25.0;
//    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
//    for(var i in StateScriptProject.instance.functions){
//      var item = PopupMenuItem<String>(
//        value: i.guid,
//        child: Text(i.getTypeShowString() , style :TextStyle(color: Colors.black , fontSize: levelInfo?.fontSize)),
//      );
//      items.add(item);
//    }
//    var itemNone = PopupMenuItem<String>(
//      value: "",
//      child: Text("未指定" , style :TextStyle(color: Colors.grey , fontSize: levelInfo?.fontSize)),
//    );
//    items.add(itemNone);
//
//    var res = PopupMenuButton<String>(
//      padding: EdgeInsets.all(0),
//      icon : Container( width: 24 , height: 30, child :Icon(MaterialCommunityIcons.menu)),
//      initialValue:v,
//      onSelected: (String result) {
//        onSubmitted?.call(result);
//      },
//      itemBuilder: (BuildContext context) => items,
//    );
    var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var res = SearchableDropdown.single(
      underline:SizedBox(height: 0,),
      iconSize: SSDefines.iconButtonSize,
      items: getItems(),
      style:TextStyle(fontSize: 12),
      value: scriptInfo==null?"":scriptInfo.getSearchKey(),
      hint: "选择对象",
      searchHint: "选择函数",
      onChanged: (v) async {
        var newValue = searchKey2Object[v];
        if (newValue != null) {
          onSubmitted?.call(newValue.guid);
        }
        else{
          onSubmitted?.call("");
        }
      },
      closeButton: "关闭",
      isExpanded: true,
    );

//    var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var dc =  const BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1,color: Colors.grey),
        ));
    return EditorHolder()..widget = Container(
        height: baseHeight,
        decoration: dc,
        child:Row(
          children: [

            Expanded(child:res),
        scriptInfo != null?SSDefines.IBC(child :IconButton(
                padding: EdgeInsets.all(0),
                iconSize: SSDefines.iconButtonSize,
                icon : const Icon(MaterialCommunityIcons.link_box_outline),
                onPressed: (){
                  // goto edit

                  var funcs = StateScriptProject.instance.functions.where((element) => element.guid == v).toList();
                  if (funcs != null && funcs.length>0){
                    Navigator.pushNamed(context, "/FunctionEditorView" , arguments: funcs[0]..load());
                  }
                  else{
                    BotToast.showText(text: "脚本不存在" , contentColor:  Colors.red);
                  }
                },
                tooltip: "打开",
              )):SizedBox(width: 0,),
            SSDefines.IBC(child :IconButton(
              padding: EdgeInsets.all(0),
              icon : const Icon(MaterialCommunityIcons.plus_box_outline),
              iconSize: SSDefines.iconButtonSize,
              onPressed: (){
                // goto edit
                CBFunction func = CBFunction();
                StateScriptProject.instance.addFunction(func);
                onChanged?.call(func.guid);
                onSubmitted?.call(func.guid);
                Navigator.pushNamed(context, "/FunctionEditorView" , arguments: func);
              },
              tooltip: "新建",
            )),
          ],
        )
    ) ..height = baseHeight;
  }
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted,{Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    return EditorHolder()..widget = Container();
    //     String v = "";
//     if (initValue is String ){
//       v = initValue;
//     }
//
//     List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
//     for(var i in StateScriptProject.instance.scripts){
//       var item = PopupMenuItem<String>(
//         value: i.guid,
//         child: Text(i.getTypeShowString()),
//       );
//       items.add(item);
//     }
//     var itemNone = PopupMenuItem<String>(
//       value: "",
//       child: Text("未指定"),
//     );
//     items.add(itemNone);
//
//     var res = PopupMenuButton<String>(
//       icon : Icon(MaterialCommunityIcons.menu),
//       initialValue:v,
//       onSelected: (String result) {
//         onSubmitted?.call(result);
//       },
//       itemBuilder: (BuildContext context) => items,
//     );
//     var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
//     return EditorHolder()..widget = Container(
//         width: levelInfo?.lineWidth,
//         height : levelInfo?.lineHeight,
//         child:Row(
//           children: [
// //        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
//             Expanded( flex: 6, child:getValueLabelWidget(initValue)),
//             Container(
//               width: 30,
//               child: res,
//             ),
//             SizedBox(width: scriptInfo != null?8:0,),
//             scriptInfo != null?IconButton(
//               icon : Icon(MaterialCommunityIcons.link_box_outline),
//               onPressed: (){
//                 RightToolBarState.scriptStack.push(ScriptInfo.current.guid);
//                 ScriptInfo.current = scriptInfo;
//                 ZoomState.current.centered();
//                 EventCenter.eventBus.fire(GlobalRefreshEvent());
//               },
//               tooltip: "打开",
//             ):const SizedBox(width: 0,)
//           ],
//         )
//     ) ..height = SSDefines.nodeFieldRowHeight;
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
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == str, orElse:()=>null);

    bw.writeInt32(scriptInfo==null?-1:scriptInfo.guid.hashCode , exportFlag);
//    bw.writeString(scriptInfo==null?"":scriptInfo.name, exportFlag);
  }

  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == str, orElse:()=>null);
    return scriptInfo==null?-1:scriptInfo.guid.hashCode;
  }

  @override
  dynamic parseFinalValue(value){
    var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == value, orElse:()=>null);
    var res = scriptInfo==null?-1:scriptInfo.guid.hashCode;
    return res;
  }

  @override
  Widget getValueLabelWidget(initValue, {TextStyle style}){
    var str = parseValue(initValue);
    var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return Text("未指定",style:style);
    }
    return Text(scriptInfo.getTypeShowString(),style:style);
  }

  @override
  dynamic getExportDefault(dynamic defaultValue){
    return -1;
  }

  @override
  String getExportType(){
    return "String";
  }
}