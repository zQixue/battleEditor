//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/script_var_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/protos/transition.pb.dart';

class ScriptVarRuntimeView extends StatefulWidget {
  final double width;
  final double height;
  final bool visible;
  ScriptVarRuntimeView({Key key , this.width , this.height , this.visible}) : super(key: key);

  @override
  _ScriptVarRuntimeViewState createState() => _ScriptVarRuntimeViewState();
}

class VarKeyValue{
  String extra;
  FieldInfo fieldInfo;
  String name;
  String key;
  String value;
  String group;
}

class _ScriptVarRuntimeViewState extends State<ScriptVarRuntimeView> {

  StreamSubscription<VarsRefreshEvent> _lis;
  StreamSubscription<VarsDataRefreshEvent> _lis2;

  VarData varData;
  bool bVisible = false;
  @override
  void initState() {
    bVisible = widget.visible;
    _lis = EventCenter.eventBus.on<VarsRefreshEvent>().listen((event) {
      if (event.bShowing != bVisible) {
        setState(() {
          bVisible = event.bShowing ?? false;
        });
      }
    });

    _lis2 = EventCenter.eventBus.on<VarsDataRefreshEvent>().listen((event) {
      setState(() {
        varData = event.varData;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _lis?.cancel();
    _lis2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!bVisible || varData == null) return Container();

    var con = Container(
      width: widget.width/ 4,
      height: widget.height * 2 / 3,
      // color: Colors.red,
      child: getVarsTree(),
    );
    return Positioned.directional(
      textDirection:TextDirection.ltr,
      child: con ,
      end:10,
      bottom: 10,
    );
  }



  ATreeNode<VarKeyValue> _varsRoot;
  // bool _nodeRootNR = false;
  ATreeNode<VarKeyValue> getVarTreeRoot(){

    var sfs = ScriptInfo.current.scriptData.scriptFieldVars;
    Map<int , FieldInfo> sfMap= Map<int , FieldInfo>();
    sfs.forEach((element) { sfMap[element.exportId] = element;});

    Map<int , FieldInfo> agMap= Map<int , FieldInfo>();
    Map<int , String> extras = Map<int , String>();
    for(var ag in StateScriptProject.instance.components){
      ag.fields.forEach((element) { agMap[element.exportId] = element; extras[element.exportId] = ag.getTypeShowString(); });

    }

    List<VarKeyValue> vars = List<VarKeyValue>();
    var scriptVars = varData.scriptVars;
    for(var sv in scriptVars){
      var fieldInfo = sfMap[sv.varId];
      if (fieldInfo == null) continue;
      vars.add(VarKeyValue()..fieldInfo = fieldInfo..name = "${fieldInfo.getTypeShowString()}"..value = sv.value..group = "脚本变量");
    }

    for(var sv in varData.agentVars){
      var fieldInfo = agMap[sv.varId];
      if (fieldInfo == null) continue;
      var extra = extras[sv.varId];
      vars.add(VarKeyValue()..fieldInfo = fieldInfo..name ="$extra.${fieldInfo.getTypeShowString()}" ..value = sv.value..group = "黑板变量");
    }

    for(var sv in varData.agentMapVars){
      var fieldInfo = agMap[sv.varId];
      if (fieldInfo == null) continue;
      var extra = extras[sv.varId];
      for(var suv in sv.pairs){
        vars.add(VarKeyValue()..fieldInfo = fieldInfo..name = "${suv.key}"..value = suv.value..key = suv.key..group = "黑板表 $extra.${fieldInfo.getTypeShowString()}");
        // vars.add(VarKeyValue()..fieldInfo = fieldInfo..key = ssuv...value = suv.value..group = "黑板表 ${fieldInfo.name}");
      }

    }

    _varsRoot = DartCommon.buildTree(vars, (item){
      var sp = [(item as VarKeyValue).group];
      return sp;
    });
    // if (_nodeRoot == null || _nodeRootNR){
    //   var scripts = StateScriptProject.instance.nodeStructs;//.where((element) => false == element.isModule).toList();
    //   _nodeRoot = DartCommon.buildTree(scripts, (item){
    //     var sp = (item as VarKeyValue).group.split("/");
    //     return sp;
    //   });
    // }
    // _nodeRootNR = false;
    return _varsRoot;
  }
  // void forceBuildTree(){
  //   _nodeRootNR = true;
  // }
  VarKeyValue _selected;
  Widget getVarsTree() {
    var con = SearchableThemeTreeView(
      defaultExpanded: false,
      indent: 16,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getVarTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<VarKeyValue>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<VarKeyValue>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<VarKeyValue>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = ScriptVarView(data:(si as VarKeyValue));// Text((si as VarKeyValue).fieldInfo.getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
            color: _selected == si? CommonUtil.alphaColorD(Colors.blue,0.4):null,
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 32,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                // Visibility(
                //   visible: si.isModule??false,
                //   child: Icon(MaterialCommunityIcons.alpha_m_box_outline , color: Colors.brown,),
                // ),
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
          // var txt = Text(name??"",style: TextStyle( color:  nd.isExpand?Colors.black:Colors.grey));
          var txt = Text(nd.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
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
          // return txt;
        }
      },

      onFilter: (node){
        var ns  = node as ATreeNode<VarKeyValue>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.fieldInfo.name}`${n.fieldInfo.alias}";
        }
        return "";
      },

      // onSort: (aNode,bNode){
      //   var a = (aNode as ATreeNode<ScriptInfo>).data;
      //   var b = (bNode as ATreeNode<ScriptInfo>).data;
      //   return a.getShowStringAndName().compareTo(b.getShowStringAndName());
      // },

      onItemTap: (item){
          var si = (item as ATreeNode<VarKeyValue>).data;
          if (si != null) {
            setState(() {
              _selected = si;
            });

            // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }

      },

      actions: [
      ],
    );
    var block = ThemeCenter.block (
      headTitle: "实时变量列表",
      // width: 480,
      child: con,
    );
    return block;
  }
}