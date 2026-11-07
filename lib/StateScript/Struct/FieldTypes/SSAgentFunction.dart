//@dart=2.11



import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class SSAgentFunction extends SSString{

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
//     var scriptInfo = StateScriptProject.instance.functions.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    // var res = SearchableDropdown.single(
    //   underline:SizedBox(height: 0,),
    //   iconSize: SSDefines.iconButtonSize,
    //   items: getItems(),
    //   style:TextStyle(fontSize: 12),
    //   value: scriptInfo==null?"":scriptInfo.getSearchKey(),
    //   hint: "选择对象",
    //   searchHint: "选择函数",
    //   onChanged: (v) async {
    //     var newValue = searchKey2Object[v];
    //     if (newValue != null) {
    //       onSubmitted?.call(newValue.guid);
    //     }
    //     else{
    //       onSubmitted?.call("");
    //     }
    //   },
    //   closeButton: "关闭",
    //   isExpanded: true,
    // );

   var scriptInfo = ScriptInfo.current.scriptData.getFunction(initValue);//StateScriptProject.instance.functions.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var dc =  BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1.2,color: Colors.black),
        ));

     // var code = scriptInfo.getBlockiesList().getExportCode();
    // List<Widget> tips = List<Widget>() ;
    // if (scriptInfo!= null){
    //   if (scriptInfo.getBlockiesList() != null){
    //     var blockys = scriptInfo.getBlockiesList().getBlockies();
    //     if (blockys != null && blockys.length>0){
    //       for(var b in blockys){
    //         var tp = CodeBlockyType.getType(b.blockyTypeId);
    //         // print("code : ${tp.name}");
    //         b.container = scriptInfo.getBlockiesList();
    //         // var tip = ThemeConsumer(child : Material(color: Colors.white,  child: IgnorePointer(child:tp.getBlockWidget(b,null),)));
    //         var tip = IgnorePointer(child:tp.getBlockWidget(b,null,scriptInfo));//Transform.scale(scale : 0.5,child :tp.getBlockWidget(b,null));
    //         tips.add(tip);
    //       }
    //     }
    //   }
    // }
    // if (tips.length<=0 == null) tips.add(Container());
    return EditorHolder()..widget = Container(
        height: baseHeight,
        decoration: dc,
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
//            Expanded(child:getValueLabelWidget(initValue)),
            // SizedBox(width: scriptInfo != null?8:0,),
//            Container(
//             // width: 30,
//             child: res,
//           ),

            // Expanded(child:Text(v?.substring(0,min(8,v.length))??"")),
            Expanded(
              child: Tooltip(
                message:scriptInfo?.getBlockBehavicCode()??"空",
                child: Text(scriptInfo?.getTypeShowString()??"" , style: const TextStyle(fontSize: 12 , color: Colors.white),),
              ),

              // child: SimpleTooltip(
              //   //
              //   // minHeight: 200,
              //   // minWidth: 380,
              //   // backgroundColor: Colors.black,
              //   // borderColor: Colors.white,
              //   ballonPadding: EdgeInsets.all(0),
              //   // tooltipTap: () {
              //   //   print("Tooltip tap");
              //   // },
              //   animationDuration: Duration(milliseconds: 200),
              //   show: true,
              //   tooltipDirection: TooltipDirection.down,
              //   child: Container(
              //     // width: 200,
              //     // height: 120,
              //     // child: Placeholder(),
              //   ),
              //   content: ThemeConsumer(child : Material(color: Colors.white,  child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child:SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: tips,
              //       ),
              //     ))) ,
              //   )
              // )
            ),
            Container(
              // width: 30,
                child: SSDefines.IBC(child :IconButton(
                  padding: EdgeInsets.all(0),
                  color:Colors.green,
                  iconSize: SSDefines.iconButtonSize,
                  icon : Icon(MaterialCommunityIcons.square_edit_outline),
                  onPressed: (){
                    // goto edit
                    if (scriptInfo == null){
                      // scriptInfo = CBFunction();
                      // scriptInfo.isAgent = true;
                      // StateScriptProject.instance.addFunction(scriptInfo);
                      scriptInfo = ScriptInfo.current.scriptData.addFunction();
                      onChanged?.call(scriptInfo.guid);
                      onSubmitted?.call(scriptInfo.guid);
                      // Navigator.pushNamed(context, "/FunctionEditorView" , arguments: func);
                    }

                    // var funcs = StateScriptProject.instance.functions.where((element) => element.guid == v).toList();
                    if (scriptInfo != null){
                      scriptInfo.isAgent = true;
                      scriptInfo.extraParam = levelInfo?.fi?.extraParam;
                      Navigator.pushNamed(context, "/FunctionEditorView" , arguments: scriptInfo..load());
                    }
                    else{
                      BotToast.showText(text: "脚本不存在" , contentColor:  Colors.red);
                    }
                  },
                  tooltip: "编辑函数",
                ))
            ),
            if(!DartCommon.isEmpty(initValue))SSDefines.IBC(child :IconButton(
              padding: EdgeInsets.all(0),
              icon : Icon(MaterialCommunityIcons.close_box_outline),
              color: Colors.red,
              iconSize: SSDefines.iconButtonSize,
              onPressed: (){

                CommonUtil.confirm(context, "确定要清除吗?",onOk: (){
                  ScriptInfo.current.scriptData.removeFunction(initValue);
                  onChanged?.call("");
                  onSubmitted?.call("");
                });


              },
              tooltip: "清除",
            )),
            // if(!DartCommon.isEmpty(initValue))SSDefines.IBC(child :IconButton(
            //   padding: EdgeInsets.all(0),
            //   icon : Icon(MaterialCommunityIcons.content_copy),
            //   color: Colors.red,
            //   iconSize: SSDefines.iconButtonSize,
            //   onPressed: (){
            //     Clipboard.setData(ClipboardData(text: '$initValue'));
            //     BotToast.showText(text: "已复制");
            //   },
            //   tooltip: "复制",
            // )),
            // SSDefines.IBC(child :IconButton(
            //   padding: EdgeInsets.all(0),
            //   icon : Icon(MaterialCommunityIcons.content_paste),
            //   color: Colors.red,
            //   iconSize: SSDefines.iconButtonSize,
            //   onPressed: (){
            //     // Clipboard.setData(ClipboardData(text: '$initValue'));
            //     Clipboard.getData("text/plain").then((value){
            //       onChanged?.call(value);
            //       print(value.text);
            //       BotToast.showText(text: "已粘贴");
            //     });
            //
            //   },
            //   tooltip: "粘贴",
            // )),
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
    ByteDataWriter tgt = bw;
    if (StateScriptProject.instance.exportAgentFunctionLength??false){
      tgt = ByteDataWriter();
    }
    String str = parseValue(v);
    var scriptInfo = StateScriptProject.instance.getFunction(str);//StateScriptProject.instance.functions.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      tgt.writeUint16(CodeBlockyType.OP_EOF  , "代码终止");
    }
    else {
      scriptInfo.load();
      var errs = new List<String>();
      scriptInfo.compile(tgt, errs);

      if (errs.length > 0) {
        StateScriptProject.instance.fullLogs.add("脚本: ${ScriptInfo.current.name} 表达式编译");
        StateScriptProject.instance.fullLogs.addAll(errs);
      }
    }
    if (StateScriptProject.instance.exportAgentFunctionLength??false){
      bw.writeBufferWithLength(tgt);
    }

    // bw.writeInt32(scriptInfo==null?-1:scriptInfo.guid.hashCode , exportFlag);
//    bw.writeString(scriptInfo==null?"":scriptInfo.name, exportFlag);
  }

  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    var scriptInfo = ScriptInfo.current.scriptData.getFunction(str);//StateScriptProject.instance.functions.firstWhere((element) => element.guid == str, orElse:()=>null);
    return scriptInfo==null?-1:scriptInfo.guid.hashCode;
  }

  @override
  dynamic parseFinalValue(value){
    var scriptInfo = ScriptInfo.current.scriptData.getFunction(value);//StateScriptProject.instance.functions.firstWhere((element) => element.guid == value, orElse:()=>null);
    var res = scriptInfo==null?-1:scriptInfo.guid.hashCode;
    return res;
  }

  @override
  Widget getValueLabelWidget(initValue, {TextStyle style}){
    var str = parseValue(initValue);
    var scriptInfo = ScriptInfo.current.scriptData.getFunction(str);//StateScriptProject.instance.functions.firstWhere((element) => element.guid == str, orElse:()=>null);
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