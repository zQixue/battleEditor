//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class CBTypeVar extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){
    String v = blk.values["guid"]??"";
    var avar = StateScriptProject.instance.globalScriptVars[v];//behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (avar != null){
      return avar.getFullTypeWithExtra();
    }

    return null;
  }



  Widget getScriptVarChooser(String current ){
    var scripts = StateScriptProject.instance.globalScriptVars.values.toList();//.where((element) => false == element.isModule).toList();?
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
        var avar = node as ATreeNode<FieldInfo>;
        if (avar.isLeaf) {

          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var txt = Text((avar.data).getShowStringAndName()??"" ,style: TextStyle( color: ThemeCenter.mainTextStepColor(8)));
          // var iconSize = 28.0;
          // var cate = SSCategory.categories.where((element) => element.id == agent.data.category).toList();
          var con = Container(
            color: current == avar.data.guid? CommonUtil.alphaColorD(Colors.blue,0.2):ThemeCenter.systemTheme.scaffoldBackgroundColor,
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
          var txt = Text(avar.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
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
          // padding: EdgeInsets.all(0),
          // color: CommonUtil.scaleColor(Colors.red,1.0),
          style : ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(CommonUtil.scaleColor(Colors.red,1.0))),
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
        width: 80,
        decoration: dc,
        child:Center(child : Text(getTypeShowString() , style: CodeBlockyType.baseTextStyle,)),
      );
    }

    String v = blocky.values["guid"]??"";


    if (CodeBlockyType.isTypeError(blocky , targetType)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 0.5),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
    }
    var res =  ThemeCenter.iconBtn(MaterialCommunityIcons.menu,
      // padding: EdgeInsets.all(0),
      // icon : Icon(MaterialCommunityIcons.menu , ),
      // iconSize: SSDefines.iconButtonSize,
      tooltip: "选择脚本变量",
      color: Colors.black,
      onPressed: (){
        showDialog(
          context: CommonUtil.getGlobalContex(),
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
            blocky.values["guid"] = "";
            EventCenter.eventBus.fire(BlockContainerRefresh());
          }
          else{

            if (value != null){
              blocky.values["guid"] = value;
              EventCenter.eventBus.fire(BlockContainerRefresh());
            }

          }

        });
      },
    );
    FieldInfo crt = StateScriptProject.instance.globalScriptVars[v] ;
    // if (agent != null){
    //   crt = fmap[v];
    // }
    //
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      key: ValueKey(blocky.guid),
      height: CodeBlockyType.baseRowHeight ,
      child:Row(
        children: [
          Tooltip(
            child: Icon(MaterialCommunityIcons.alpha_s_box,color: Colors.indigoAccent ),
            message: "${crt?.getFullTypeWithExtra()??"未指定"} ${crt?.exportId}",
          ),
          Text(crt?.getTypeShowString()??"" , style : TextStyle(color: Colors.brown , fontWeight: FontWeight.w600)),
          res,

        ],
      ),
      decoration: dc,
    );
  }

  CBTypeVar(){
    typeFlag = BlockyTypes.BT_VAR;
    setDefaultColor(Color(0xFF666699));
    name = "Var";
    alias = "脚本变量";
  }


  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){
    String guid = blk.values["guid"]??"";
    var field = StateScriptProject.instance.globalScriptVars[guid];//getField(guid);
    if (field == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , 无效的脚本变量, ${func.getTypeShowString()}");
      return 0;
    }

    int optextra = blk.getOperateExtraType();
    if (optextra == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
      return 0;
    }
    // var ft = SSFieldType.getFieldType(field.typeGuid);
    // if (ft == null){
    //   errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 获得变量类型失败, ${func.getTypeShowString()}");
    //   return 0;
    // }

    bw.writeUint16(CodeBlockyType.OP_PUSH_SSVAR + optextra, "脚本变量压栈");

    // bw.writeUint32(ft.exportId??null, "脚本变量类型 id");
    bw.writeUint32(field.exportId, "脚本变量 id");
    return 1;
  }

  @override
  int compileRef(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst , CBFunction func){
    String guid = blk.values["guid"]??"";
    var field = StateScriptProject.instance.globalScriptVars[guid];//getField(guid);
    int optextra = blk.getOperateExtraType();
    bw.writeUint16(CodeBlockyType.OP_ASSIGN_SSVAR + optextra , "ref 设置脚本变量");
    bw.writeUint32(field.exportId, "脚本变量id");
    return 1;
  }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    // if (blk == null){
    //   res["fieldType"] = "INVALID";
    //   res["extraType"] = "INVALID";
    //   res["name"] = "INVALID";
    //   res["hash"] = "INVALID";
    //   res["extra"] = "INVALID";
    //   return res;
    // }
    // String guid = blk.values["guid"]??"";
    // var field = getField(guid);
    // if (field == null){
    //   print("fieldTypeGuid = ${blk.values["fieldTypeGuid"]??""}");
    //   var tp = SSFieldType.getFieldType(blk.values["fieldTypeGuid"]??"");
    //   print("tp1 = ${tp?.name}");
    //   res["fieldType"] = tp?.cname??"int";
    //   res["extraType"] = 1;
    //   res["name"] = "???";
    //   res["hash"] = "${guid.hashCode}";
    //   res["id"] = "???";
    //   res["extra"] = "???";
    //   return res;
    // }
    // var tp = SSFieldType.getFieldType(field.typeGuid);
    // // print("tp2 = ${tp?.name}");
    // res["fieldType"] = tp.cname;
    // res["extraType"] = field.extraType;
    // res["name"] = "${field.name}";
    // res["hash"] = "${field.name.hashCode}";
    // res["extra"] = "${field.extraInfo2}";
    // res["id"] = field.exportId;

    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){

    String guid = blk.values["guid"]??"";
    var field = StateScriptProject.instance.globalScriptVars[guid];

    if (field != null){
      return field.name;
    }
    return "未知脚本变量";
  }
}