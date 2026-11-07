//@dart=2.11


import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSUnion.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class SSScriptVar extends SSString{

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

  Widget getScriptVarChooser(String current ){
    var scripts = ScriptInfo.current.scriptData.scriptFieldVars;//.where((element) => false == element.isModule).toList();?
    ATreeNode<FieldInfo> _compRoot = DartCommon.buildTree<FieldInfo>(scripts, (item){
      return <String>[];
    });

    // scripts.add(empty);
    var con = SearchableThemeTreeView(
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<FieldInfo>).data;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node , expanded , highlightPattern){
        // print(highlightPattern);
        var agent = node as ATreeNode<FieldInfo>;
        if (agent.isLeaf) {

          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var txt = Text((agent.data).getShowStringAndName()??"" ,style: TextStyle( color: ThemeCenter.mainTextStepColor(8)));
          // var iconSize = 28.0;
          // var cate = SSCategory.categories.where((element) => element.id == agent.data.category).toList();
          var con = Container(
            color: current == agent.data.guid? CommonUtil.alphaColorD(Colors.blue,0.2):ThemeCenter.systemTheme.scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 32,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                // cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
                SizedBox(width: 4,),
                Expanded(child : txt),
              ],
            ),
          );
          // return txt;
          return Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
          var con = Container(
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 36,
            //CommonUtil.alphaColor(nd.isExpand ? Colors.green : Colors.grey , 50),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                !expanded ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,color: Colors.blueAccent,),
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
        }
      },
      onGetChildren: (node){
        return (node as ATreeNode<FieldInfo>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<FieldInfo>;
        if (ns != null) {

          if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.alias}";
          // if (ns.isLeaf) return n.//return "${n.name}`${n.defaultValue}";
          // return "${ns.id}";
        }
        return "";
      },

      onSortLeaf: (a,b){
        return (a as ATreeNode<FieldInfo>).data.name.compareTo((b as ATreeNode<FieldInfo>).data.name);
      },

      onItemTap: (item){
        // var a = item as ATreeNode<ScriptInfo>;
        // if (a != null && a.data != null) {
        //   onSubmitted?.call(a.data);
        //   Navigator.pop(context, a.data);
        // }

        // widget.subScript.scriptId = (item.data as ScriptInfo).guid;
        // ScriptInfo.current.scriptData.loadSubScripts(widget.subScript.guid);
        // ScriptInfo.current.scriptData.initConnectionCount();
        // EventCenter.eventBus.fire(GlobalRefreshEvent());
        // setState(() {
        //
        // });
        Navigator.pop(CommonUtil.getGlobalContex() , (item.data as FieldInfo).guid);
      },

      actions: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(CommonUtil.scaleColor(Colors.red,1.0))),
          // padding: EdgeInsets.all(0),
          // color: CommonUtil.scaleColor(Colors.red,1.0),
          child: Text("清空"),
          onPressed: (){
            // ScriptInfo.current.scriptData.loadSubScripts(widget.subScript.guid);
            // ScriptInfo.current.scriptData.initConnectionCount();
            // EventCenter.eventBus.fire(GlobalRefreshEvent());
            // setState(() {
            //   widget.subScript.scriptId = "";
            // });

            Navigator.pop(CommonUtil.getGlobalContex() , "");
          },
        ),
      ],
    );

    return ThemeCenter.area(
      width: 600,
      child: con,
    );
  }
  FieldInfo empty = FieldInfo()..group = "空"..name ="empty"..alias="空";

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    // print(initValue);
    // print(v);
    if (ScriptInfo.current.scriptData == null){
      ScriptInfo.current.loadScript();
    }
    // List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    // // for(var i in ScriptInfo.current.scriptData.scriptFieldVars){
    // ScriptInfo.current.scriptData.fullScriptsFields.forEach((key, i) {
    //   // print("full : $key");
    //   var item = PopupMenuItem<String>(
    //     value: i.guid,
    //     child: Text(i.getTypeShowString() , style :TextStyle(color: Colors.black , fontSize: levelInfo?.fontSize)),
    //   );
    //   items.add(item);
    // });
    // var itemNone = PopupMenuItem<String>(
    //   value: "",
    //   child: Text("未指定" , style :TextStyle(color: Colors.grey , fontSize: levelInfo?.fontSize)),
    // );
    // items.add(itemNone);

    // print("ref : $v");
    // var res = PopupMenuButton<String>(
    //   padding: EdgeInsets.all(0),
    //   icon : Icon(MaterialCommunityIcons.menu ,size: SSDefines.iconButtonSize,),
    //   initialValue:v,
    //   onSelected: (String result) {
    //     onSubmitted?.call(result);
    //   },
    //   itemBuilder: (BuildContext context) => items,
    // );

    var res =  ThemeCenter.iconBtn(MaterialCommunityIcons.menu,
      // padding: EdgeInsets.all(0),
      // icon : Icon(MaterialCommunityIcons.menu , ),
      // iconSize: SSDefines.iconButtonSize,
      tooltip: "选择变量",
      color: Colors.white,
      onPressed: (){
        showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext context) {
            var child = getScriptVarChooser(v);
            return Dialog(child: child);
          },
        ).then((value) {
          // print(value);
          if (value == null) return ;
          // HistoryManager.scriptHistory.appendHistory();
          if (value == empty) {
            onSubmitted?.call("");
            // widget.onSubmitted?.call("");
            // widget.subScript.scriptId = "";
            // setState(() {
            //   widget.subScript.reload(ScriptInfo.current.guid);
            // });
            // ScriptInfo.current.scriptData.loadSubScripts(ScriptInfo.current.guid);
            // ScriptInfo.current.scriptData.initConnectionCount();
            // EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
          else{

            if (value != null){
              onSubmitted?.call(value);
            }
            // widget.subScript.scriptId = (value as ScriptInfo).guid;
            // widget.onSubmitted?.call((value as ScriptInfo).guid);
            // setState(() {
            //   widget.subScript.reload(ScriptInfo.current.guid);
            // });
            // ScriptInfo.current.scriptData.loadSubScripts(ScriptInfo.current.guid);
            // ScriptInfo.current.scriptData.initConnectionCount();
            // EventCenter.eventBus.fire(GlobalRefreshEvent());
          }

        });
      },
    );
    // var scriptInfo = ScriptInfo.current.scriptData.scriptFields.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var dc =  BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1,color: Colors.black),
        ));
    return EditorHolder()..widget = Container(
        height: baseHeight,
        decoration: dc,
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded(child:getValueLabelWidget(v , style: const TextStyle(fontSize: 12 , color: Colors.lightBlueAccent))),
            SSDefines.IBC(
              // width: 30,
              child: res,
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
    return EditorHolder()..widget = Container()..height = SSDefines.nodeFieldRowHeight;

  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);

    var field = StateScript.exportingScript.fullScriptsFields[str];//StateScript.exportingScript.scriptFields.firstWhere((element) => element.guid == str, orElse:()=>null);

    //切换成 export id 导出
    // bw.writeInt32(field==null?0:field.guid.hashCode , exportFlag);
    bw.writeInt32(field==null?0:field.exportId??0 , exportFlag);
    //
    // var fields = StateScript.exportingScript.scriptFields;
    // var field = CommonUtil.getItemByGuid(fields, guid);
    if (field != null){
      SSUnion.lastVarTypeGuid = field.typeGuid;
    }
//    bw.writeString(scriptInfo==null?"":scriptInfo.name, exportFlag);
  }

  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    var field = StateScript.exportingScript.fullScriptsFields[str];////StateScript.exportingScript.scriptFields.firstWhere((element) => element.guid == str, orElse:()=>null);

    // var fields = StateScript.exportingScript.scriptFields;
    // var field = CommonUtil.getItemByGuid(fields, guid);
    if (field != null){
      SSUnion.lastVarTypeGuid = field.typeGuid;
    }

    // return field==null?0:field.guid.hashCode;
    return field==null?0:field.exportId??0;
    // return field==null?"___dummy___":field.name;
  }

  @override
  dynamic parseFinalValue(value){
    // throw Exception("SSScriptVar parseFinalValue NOT IMPL");
    var scriptInfo = StateScript.exportingScript.fullScriptsFields[value];//StateScript.exportingScript.scriptFields.firstWhere((element) => element.guid == value, orElse:()=>null);
    var res = scriptInfo==null?0:scriptInfo.exportId??0;
    return res;
  }

  @override
  Widget getValueLabelWidget(initValue , {TextStyle style}){
    var str = parseValue(initValue);
    var scriptInfo = ScriptInfo.current.scriptData.fullScriptsFields[str];//ScriptInfo.current.scriptData.scriptFields.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return Text("未指定" , style:style);
    }
    return Text(scriptInfo.getTypeShowString(),style:style);
  }

  @override
  dynamic getExportDefault(dynamic defaultValue){
    return 0;
  }

  dynamic parseShortShowName(value){
    var str = parseValue(value);
    var scriptInfo = ScriptInfo.current.scriptData.fullScriptsFields[str];//ScriptInfo.current.scriptData.scriptFields.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return "未指定变量";
    }
    return scriptInfo.getTypeShowString();
  }

  @override
  String getExportType(){
    return "int";
  }
}