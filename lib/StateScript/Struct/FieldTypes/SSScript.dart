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
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/common/searchable_tree_view.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
class SSScript extends SSString{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType  , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.script_text_outline , color: Colors.indigoAccent,),
        SizedBox(width: 8,),
//        Container(child:Text(getTypeShowString(),maxLines: 1,overflow: TextOverflow.clip)),
        Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  static ScriptInfo empty = ScriptInfo()..group = "空"..name ="empty"..alias="空";
  static Widget getScriptChooser(context , ScriptInfo current , {bool onlyModule = false}){

    // var dc = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: )],
    // );
    List scripts = List();
    if (onlyModule){
      scripts.addAll(StateScriptProject.instance.scripts.where((element) => element.isModule??false));
    }
    else{
      scripts.addAll(StateScriptProject.instance.scripts);
    }
    // scripts.add(empty);

    var con = SearchableTreeView(
      indent: 16,
      // itemBaseWidth: 200,
      // decoration: dc,
      items: scripts,
      onBuildDir: (name , nd){
        // var txt = Text(name??"",style: TextStyle( color:  nd.isExpand?Colors.black:Colors.grey));
        var txt = Text(name??"",style: ThemeCenter.mainTextStyle(step: 8 , fontSize: 13));
        var con = Container(
          padding: EdgeInsets.fromLTRB(8,0,8,0),
          height: 36,
          color: CommonUtil.alphaColor(Colors.grey, 50),
          // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
          child: Row(
            children: [
              !nd.isExpand ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,),
              SizedBox(width: 8,),
              Expanded(child : txt),
            ],
          ),
        );
        // return txt;
        return Container(
          padding: EdgeInsets.all(1),
          child: con,
        );
      },
      onBuildItem: (ascript,nd){

        // return Text((nodeStruct as ScriptInfo).name , style: style,);
        var txt = Text((ascript as ScriptInfo).getShowStringAndName()??"" ,style: TextStyle( color: ThemeCenter.mainTextStepColor(8)));
        // var iconSize = 28.0;
        var cate = SSCategory.categories.where((element) => element.id == (ascript as ScriptInfo).category).toList();
        var con = Container(
          color: current == ascript? CommonUtil.alphaColorD(Colors.blue,0.2):ThemeCenter.systemTheme.scaffoldBackgroundColor,
          padding: EdgeInsets.fromLTRB(8,0,8,0),
          height: 32,
          // color: CommonUtil.scaleColor(Colors.grey, 0.15),
          // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
          child: Row(
            children: [
              cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
              SizedBox(width: 4,),
              Expanded(child : txt),
              // Container(
              //     width: iconSize,
              //     height: iconSize,
              //     child:IconButton(
              //       padding: EdgeInsets.all(0),
              //       icon : Icon(MaterialCommunityIcons.square_edit_outline),
              //       color: Colors.indigo,
              //       tooltip: "打开编辑脚本",
              //       iconSize: iconSize,
              //       onPressed: (){
              //       },
              //     )
              // ),
              // !nd.isExpand ? Icon(FontAwesome.folder_o , size: 20,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 20,)
            ],
          ),
        );
        // return txt;
        return Container(

          padding: EdgeInsets.all(1),
          child: con,
        );
      },
      onGetTreePath: (nodeStruct){
        var sp = (nodeStruct as ScriptInfo).group.split("/");
        return sp;
      },
      onFilter: (nodeStruct){
        var ns  = nodeStruct as ScriptInfo;
        return "${ns.name}`${ns.group}`${ns.alias}";
      },
      onSort: (a,b){
        return (a as ScriptInfo).getShowStringAndName().compareTo((b as ScriptInfo).getShowStringAndName());
      },
      onItemTap: (item){
        Navigator.pop(context , item);
      },

      actions: [
        ElevatedButton(
          // padding: EdgeInsets.all(0),
          style : ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(CommonUtil.scaleColor(Colors.red,1.0))),
          // color: CommonUtil.scaleColor(Colors.red,1.0),
          child: Text("清空"),
          onPressed: (){
            Navigator.pop(context , empty);
          },
        ),
        SizedBox(width: 8,),
        ElevatedButton(
          // padding: EdgeInsets.all(0),
          // color: Colors.indigo,
          child: Text("取消"),
          onPressed: (){
            Navigator.pop(context , null);
          },
        ),

      ],
    );
    return ThemeCenter.area(
      width: 600,
      child: con,
    );

  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }

    // List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    // for(var i in StateScriptProject.instance.scripts){
    //   var item = PopupMenuItem<String>(
    //     value: i.guid,
    //     child: Text(i.getTypeShowString() , style :TextStyle(color: Colors.black , fontSize: levelInfo?.fontSize)),
    //   );
    //   items.add(item);
    // }
    // var itemNone = PopupMenuItem<String>(
    //   value: "",
    //   child: Text("未指定" , style :TextStyle(color: Colors.grey , fontSize: levelInfo?.fontSize)),
    // );
    // items.add(itemNone);

    // var res = PopupMenuButton<String>(
    //   padding: EdgeInsets.all(0),
    //   icon : Icon(MaterialCommunityIcons.menu , size: SSDefines.iconButtonSize,),
    //   initialValue:v,
    //   onSelected: (String result) {
    //     onSubmitted?.call(result);
    //   },
    //   itemBuilder: (BuildContext context) => items,
    // );
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);

    var res = IconButton(
      color:Colors.white,
      padding: EdgeInsets.all(0),
      icon : Icon(MaterialCommunityIcons.menu , ),
      iconSize: SSDefines.iconButtonSize,
      onPressed: (){
        showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext context) {
            var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
            return Dialog(child: child);
          },
        ).then((value) {
          // print(value);
          if (value == null) return ;
          if (value == empty) {
            onSubmitted?.call("");
          }
          else{
            onSubmitted?.call((value as ScriptInfo).guid);
          }
        });
      },
    );

    var dc =  const BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1.2,color: Colors.black),
        ));
    return EditorHolder()..widget = Container(
      height: baseHeight,
      decoration: dc,
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded(child:getValueLabelWidget(initValue,style: const  TextStyle(fontSize: 12 , color: Colors.greenAccent),)),
           SSDefines.IBC(
             // width: 30,
             child: res,
           ),
//            SizedBox(width: scriptInfo != null?8:0,),
//           res,
            if (scriptInfo != null)SSDefines.IBC(
              // width: 30,
              child: IconButton(
                color: Colors.lightBlueAccent,
                padding: EdgeInsets.all(0),
                icon : Icon(MaterialCommunityIcons.link_box_outline),
                iconSize: SSDefines.iconButtonSize,
                onPressed: (){
                  RightToolBarState.scriptStack.push(ScriptInfo.current.guid);
                  ScriptInfo.current = scriptInfo;
                  ScriptInfo.addOpenScript(scriptInfo);
                  ZoomState.current.centered();
                  EventCenter.eventBus.fire(GlobalRefreshEvent());
                },
                tooltip: "打开",
              ),
            ),

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

    // List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    // for(var i in StateScriptProject.instance.scripts){
    //   var item = PopupMenuItem<String>(
    //     value: i.guid,
    //     child: Text(i.getTypeShowString()),
    //   );
    //   items.add(item);
    // }
    // var itemNone = PopupMenuItem<String>(
    //   value: "",
    //   child: Text("未指定"),
    // );
    // items.add(itemNone);

    // var res = PopupMenuButton<String>(
    //   icon : Icon(MaterialCommunityIcons.menu),
    //   initialValue:v,
    //   onSelected: (String result) {
    //     onSubmitted?.call(result);
    //   },
    //   itemBuilder: (BuildContext context) => items,
    // );
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var res = IconButton(
      padding: EdgeInsets.all(0),
      icon : Icon(MaterialCommunityIcons.menu ),
      onPressed: (){
        showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext context) {
            var child = getScriptChooser(context,scriptInfo);
            return Dialog(child: child);
          },
        ).then((value) {
          // print(value);
          if (value == null) return ;
          if (value == empty) {
            onSubmitted?.call("");
          }
          else{
            onSubmitted?.call((value as ScriptInfo).guid);
          }
        });
      },
    );
    return EditorHolder()..widget = Container(
        width: levelInfo?.lineWidth,
        height : levelInfo?.lineHeight,
      child:Row(
        children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
          Expanded( flex: 6, child:getValueLabelWidget(initValue)),
          res,
          // Container(
          //   width: 30,
          //   child: res,
          // ),
          // SizedBox(width: scriptInfo != null?8:0,),
          if (scriptInfo != null && !levelInfo.isObjectTableMode)IconButton(
            icon : Icon(MaterialCommunityIcons.link_box_outline),
            onPressed: (){
              RightToolBarState.scriptStack.push(ScriptInfo.current.guid);

              ScriptInfo.current = scriptInfo;
              ScriptInfo.addOpenScript(scriptInfo);
              ZoomState.current.centered();
              EventCenter.eventBus.fire(GlobalRefreshEvent());
            },
            tooltip: "打开",
          ),
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
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var res = ThemeCenter.iconBtn(MaterialCommunityIcons.menu,
      width: 24 , height: 24,
      onPressed: (){
        showDialog(
          context: context,

          builder: (BuildContext context) {
            var child = getScriptChooser(context,scriptInfo);
            return Dialog(child: child);
          },
        ).then((value) {

          if (value == null) return ;
          if (value == empty) {
            onSubmitted?.call("");
          }
          else{
            onSubmitted?.call((value as ScriptInfo).guid);
          }
        });
      },
    );
    return EditorHolder()..widget = Container(
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded( flex: 6, child:getValueLabelWidget(initValue)),
            res,
            // SizedBox(width: scriptInfo != null?8:0,),
            SizedBox(width: 8,),
            if (scriptInfo != null && !gci.isObjectTableMode)ThemeCenter.iconBtn(MaterialCommunityIcons.link_box_outline,
              width: 24, height:24,
              onPressed: (){
                RightToolBarState.scriptStack.push(ScriptInfo.current.guid);

                ScriptInfo.current = scriptInfo;
                ScriptInfo.addOpenScript(scriptInfo);
                ZoomState.current.centered();
                EventCenter.eventBus.fire(GlobalRefreshEvent());
              },
              tooltip: "打开",
            ),
          ],
        )
    ) ..height = SSDefines.nodeFieldRowHeight;
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == str, orElse:()=>null);

    // bw.writeInt32(scriptInfo==null?-1:scriptInfo.exportId??-1 , exportFlag);
    // bw.writeString(str,exportFlag);
    bw.writeString(scriptInfo==null?"":scriptInfo.name , "script name");
//    bw.writeString(scriptInfo==null?"":scriptInfo.name, exportFlag);
  }

  @override
  String getFilterString(v) {
    // print(name);
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == v, orElse:()=>null);
    if (scriptInfo != null){
      return "${scriptInfo.name}`${scriptInfo.alias}";
    }
    return "$v";
  }


  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == str, orElse:()=>null);
    return scriptInfo==null?"":scriptInfo.name??"";
  }

  @override
  dynamic parseFinalValue(value){
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == value, orElse:()=>null);
    var res = scriptInfo==null?-1:scriptInfo.exportId??-1;
    return res;
  }

  @override
  Widget getValueLabelWidget(initValue, {TextStyle style}){
    var str = parseValue(initValue);
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return Text("未指定", style: style,);
    }
    return Text(scriptInfo.getTypeShowString(), style: style);
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