//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/behavic_agent_picker.dart';
import 'package:battlepus/StateScript/script_module_selecter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Tagger/tag_set_view.dart';
import 'package:battlepus/common/line_container.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:battlepus/common/Tagger/TagSet.dart';

class ScriptListView extends StatefulWidget {
  ScriptListView({Key key}) : super(key: key);

  @override
  _ScriptListViewState createState() => _ScriptListViewState();
}

class _DragScript{
  ScriptInfo script;
}
class _DragScriptTemplate{
  ScriptInfo template;
}
class _ScriptListViewState extends State<ScriptListView> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (ScriptInfo.nextListScript != null){
      _selectScript = ScriptInfo.nextListScript;
      ScriptInfo.nextListScript = null;//
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 36,
        title: Text("选择脚本"),
          elevation:0.0,
        actions: [
          IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 24, color: Colors.greenAccent, tooltip:"保存",
            onPressed: (){
              StateScriptProject.instance.save();
              BotToast.showText(text: "已保存" , contentColor: Colors.green);
            },
          ),
        ],
      ),
      body:Container(
        // padding: EdgeInsets.all(4),
        child: Row(
          children: [
            // ScriptList(),
            // Expanded(flex : 3 ,child:Column(
            //   children: [
            //     Expanded(flex : 3 ,child:getStructTree()),
            //     Expanded(flex : 3 ,child:getStructTree(bModule: true)),
            //   ],
            // )),
            Expanded(flex : 3 ,child:getStructTree()),
            // getStructTree(),
//            NodeDefineListView(),
//             SizedBox(width: 8,),

            // Expanded(flex : 4 ,child:buildDetail()),
            Expanded(flex : 4 ,child: Column(
              children: [
                Expanded(flex : 4 ,child:buildDetail()),
                Expanded(flex : 4 ,child:getTemplateStructTree())
              ],
            )),

            // SizedBox(width: 8,),
            Expanded(flex : 3 ,child:getStructTree(bModule: true)),
          ],
        ),
      ),
    );
  }
  ScriptInfo _selectScript ;
  var style = TextStyle();

  ATreeNode<ScriptInfo> _scriptRoot;
  bool _scriptRootNR = false;
  ATreeNode<ScriptInfo> getScriptTreeRoot(){
    if (_scriptRoot == null || _scriptRootNR){
      var scripts = StateScriptProject.instance.scripts.where((element) => false == element.isModule).toList();
      scripts = scripts.where((scr) {
        var rk = StateScriptProject.instance.scriptModules.containsKey(scr.moduleGuid)?scr.moduleGuid:"";
        return (StateScriptProject.currentSelectedModule == rk);
      }).toList();


      _scriptRoot = DartCommon.buildTree(scripts, (item){
        var sp = (item as ScriptInfo).group.split("/");
        return sp;
      });
    }
    _scriptRootNR = false;
    return _scriptRoot;
  }

  ATreeNode<ScriptInfo> _moduleRoot;
  bool _moduleRootNR = false;
  ATreeNode<ScriptInfo> getModuleTreeRoot(){
    if (_moduleRoot == null || _moduleRootNR){
      var scripts = StateScriptProject.instance.scripts.where((element) => true == element.isModule).toList();
      scripts = scripts.where((scr) {
        var rk = StateScriptProject.instance.scriptModules.containsKey(scr.moduleGuid)?scr.moduleGuid:"";
        return (StateScriptProject.currentSelectedModule == rk);
      }).toList();

      _moduleRoot = DartCommon.buildTree(scripts, (item){
        var sp = (item as ScriptInfo).group.split("/");
        return sp;
      });
    }
    _moduleRootNR = false;
    return _moduleRoot;
  }

  ATreeNode<ScriptInfo> _templateRoot;
  bool _templateRootNR = false;
  ATreeNode<ScriptInfo> getTemplateTreeRoot(){
    if (_templateRoot == null || _templateRootNR){
      var scripts = StateScriptProject.instance.scriptTemplates;
      scripts = scripts.where((scr) {
        var rk = StateScriptProject.instance.scriptModules.containsKey(scr.moduleGuid)?scr.moduleGuid:"";
        return (StateScriptProject.currentSelectedModule == rk);
      }).toList();

      _templateRoot = DartCommon.buildTree(scripts, (item){
        var sp = (item as ScriptInfo).group.split("/");
        return sp;
      });
    }
    _templateRootNR = false;
    return _templateRoot;
  }

  void forceBuildTree(){
    _moduleRootNR = true;
    _scriptRootNR = true;
    _templateRootNR = true;
  }

  Widget getTemplateStructTree() {

    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColorD(Colors.yellow, 0.1),
    // );

    var con = SearchableThemeTreeView(
      defaultExpanded: false,
      onExpandedFlagChanged: (map){
        SSUserData.instance.templateListExpandedFlags = map;
        SSUserData.instance.save();
      },
      indent: 16,
      expandedFlags: SSUserData.instance.templateListExpandedFlags,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getTemplateTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<ScriptInfo>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<ScriptInfo>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<ScriptInfo>;
        if (nd.isLeaf){

          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          // var si = (ascript as ScriptInfo);
          var si = nd.data;
          var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = Text((si).getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12));
          var cateIcon = cate.length>0?Icon(cate[0].icon , color : cate[0].color , size: 20,):Icon(FontAwesome.question, color : Colors.black);
          // var mainCon = ThemeCenter.area(
          //   child: Row(
          //     children: [
          //       cateIcon,
          //       SizedBox(width: 4,),
          //       Expanded(child : txt),
          //     ],
          //   )
          // );
          var mainCon = ThemeCenter.roundRect(
            padding: EdgeInsets.fromLTRB(4,0,4,0),
            radius:2,
            height: 30,
            bgColor: ThemeCenter.systemTheme.scaffoldBackgroundColor,
            // leftBorderWidth: 4,
            // rightBorderWidth: 4,
            // topBorderWidth: 4,
            // bottomBorderWidth: 4,
            // color : ThemeCenter.systemTheme.accentColor,
            child: Row(
              children: [
                cateIcon,
                SizedBox(width: 4,),
                txt
              ],
            ),
          );
          var te = Draggable(
            child: mainCon,
            feedback: Material(child:mainCon),
            childWhenDragging: Opacity(child: mainCon,opacity: 0.5) ,
            data: _DragScriptTemplate()..template = si,
          );
          var iconSize = 28.0;
          var con = Container(
            color: _selectScript == si? CommonUtil.alphaColorD(Colors.red,0.2):ThemeCenter.systemTheme.scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 36,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                // Visibility(
                //   visible: si.isModule??false,
                //   child: Icon(MaterialCommunityIcons.alpha_m_box_outline , color: Colors.brown,),
                // ),
                // Expanded(child :te),
                te,
                // cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
                // SizedBox(width: 4,),
                Expanded(child : Container()),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.minus_box_outline),
                      tooltip: "删除模板",
                      color: Colors.redAccent,
                      iconSize: iconSize,
                      onPressed: (){
                        CommonUtil.confirm(context, "确定要删除模板吗?",onOk: (){
                          setState(() {
                            StateScriptProject.instance.deleteTemplate(si);
                            // StateScriptProject.instance.save();
                            if(_selectScript == si) _selectScript = null;
                            forceBuildTree();
                            // EventCenter.eventBus.fire(ScriptSelectionChangeEvent(_selected));
                          });
                        });
                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.shape_square_plus),
                      color: Colors.blueAccent,
                      tooltip: "复制模板",
                      iconSize: iconSize,
                      onPressed: (){

                        setState(() {
                          _selectScript = StateScriptProject.instance.cloneTemplate(si);
                          _selectScript.group = si.group;
                          // ScriptInfo.current = _selectScript;
                          forceBuildTree();
                        });

                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.square_edit_outline),
                      color: Colors.blueAccent,
                      tooltip: "打开编辑模板",
                      iconSize: iconSize,
                      onPressed: (){
                        if(_selectScript != si) {
                          _selectScript = si;
                        }
                        if (ScriptInfo.current != _selectScript){
                          ScriptInfo.current = _selectScript;
                          // HistoryManager.scriptHistory?.clear();
                        }
                        Navigator.pop(context);
                      },
                    )
                ),


                // !nd.isExpand ? Icon(FontAwesome.folder_o , size: 20,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 20,)
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
        var ns  = node as ATreeNode<ScriptInfo>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.group}`${n.alias}";
        }
        return "";
      },

      // onSort: (aNode,bNode){
      //   var a = (aNode as ATreeNode<ScriptInfo>).data;
      //   var b = (bNode as ATreeNode<ScriptInfo>).data;
      //   return a.getShowStringAndName().compareTo(b.getShowStringAndName());
      // },

      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<ScriptInfo>).data;
          if (si != null) {
            _selectScript = si;
          }
        });

      },

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.indigo,
          iconSize: 32,
          onPressed: (){
            var newScript = StateScriptProject.instance.addTemplate();
            StateScriptProject.instance.save();
            setState(() {
              _selectScript = newScript;
              forceBuildTree();
              // ScriptInfo.current = _selectScript;
              // EventCenter.eventBus.fire(ScriptSelectionChangeEvent(_selected));
            });
          },
        ),

      ],
    );
    var block = ThemeCenter.block (
      headTitle: "模板",
      // width: 480,
      child: con,
    );
    return block;
    // var tagTarget = DragTarget<_DragScript>(
    //   builder: (p1,p2,p3){
    //     return block;
    //   },
    //   onWillAccept: (e)=>e is _DragScript,
    //   onMove: (d){
    //     setState(() {
    //       _onInTemplateArea = true;
    //     });
    //   },
    //   onLeave: (e){
    //     setState(() {
    //       _onInTemplateArea = false;
    //     });
    //   },
    //   onAcceptWithDetails: (e){
    //     setState(() {
    //     });
    //   },
    // );
    // return tagTarget;
  }
  bool _onInScriptArea = false;
  bool _onInModuleArea = false;

  int iSortType = BattlePusGlobal.prefs.getInt("sl_sort_type") ?? 0;
  List<String> sortTips = ["名字升序" ,"名字降序" , "别名升序" ,"别名降序" ,];

  int _sortTypeIndex = 0;
  List<String> _sortTypes = ["默认", "节点类型"];

  Map<String,ScriptInfo> _selectedScriptInfos = {};
  Widget getStructTree({bool bModule = false}) {

    bool bWithColor = bModule && _onInModuleArea || !bModule && _onInScriptArea;
    var dc = new BoxDecoration(
      color: CommonUtil.alphaColorD(Colors.indigoAccent, 0.1),
    );

    var con = SearchableThemeTreeView(
      defaultExpanded: false,
      onExpandedFlagChanged: (map){
        if (bModule) {
          SSUserData.instance.moduleListExpandedFlags = map;
        }
        else{
          SSUserData.instance.scriptListExpandedFlags = map;
        }
        SSUserData.instance.save();
      },
      indent: 16,
      expandedFlags: bModule?SSUserData.instance.moduleListExpandedFlags:SSUserData.instance.scriptListExpandedFlags,
      // itemBaseWidth: 200,
      decoration: bWithColor?dc:null,
      root:bModule?getModuleTreeRoot():getScriptTreeRoot(),

        expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<ScriptInfo>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<ScriptInfo>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<ScriptInfo>;
        if (nd.isLeaf){

          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          // var si = (ascript as ScriptInfo);
          var si = nd.data;
          var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = Text((si).getTypeShowString()??"" ,style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
            color: _selectScript == si? CommonUtil.alphaColorD(Colors.red,0.2):ThemeCenter.systemTheme.scaffoldBackgroundColor,
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
                cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
                SizedBox(width: 4,),
                if (StateScriptProject.instance.showScriptId??false) Text("[${si.exportId??""}] " ,style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12)),
                Expanded(child : Tooltip(
                  child: txt,
                  message: "[${si.exportId??""}] ${si.name}",
                )),
                // Expanded(child : Container()),
                // if (StateScriptProject.instance.showScriptNameAtLast??false) Text(si.name??"" ,style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12)),
                // Text("${si.name??""}"),
                // Text("[${si.exportId??""}] "),
                Checkbox(
                  activeColor: Colors.green,
                  value: _selectedScriptInfos.containsKey(si.guid),
                  onChanged: (v){
                  setState(() {
                    if (v){
                      _selectedScriptInfos[si.guid] = si;
                    }
                    else{
                      _selectedScriptInfos.remove(si.guid);
                    }
                  });
                }),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.minus_box_outline),
                      tooltip: "删除脚本",
                      color: Colors.redAccent,
                      iconSize: iconSize,
                      onPressed: (){
                        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                          setState(() {
                            StateScriptProject.instance.deleteScript(si);
                            // StateScriptProject.instance.save();
                            if(_selectScript == si) _selectScript = null;
                            forceBuildTree();
                            // EventCenter.eventBus.fire(ScriptSelectionChangeEvent(_selected));
                          });
                        });
                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.shape_square_plus),
                      color: Colors.blueAccent,
                      tooltip: "复制脚本",
                      iconSize: iconSize,
                      onPressed: (){

                        setState(() {
                          _selectScript = StateScriptProject.instance.cloneScript(si);
                          _selectScript.group = si.group;

                          ScriptInfo.current = _selectScript;
                          forceBuildTree();
                        });

                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.square_edit_outline),
                      color: Colors.blueAccent,
                      tooltip: "打开编辑脚本",
                      iconSize: iconSize,
                      onPressed: (){

                        if (_selectedScriptInfos.length>0){
                          _selectedScriptInfos[si.guid] = si;
                          Navigator.pop(context,_selectedScriptInfos.values.toList());
                          return;
                        }

                        if(_selectScript != si) {
                          _selectScript = si;
                        }
                        if (ScriptInfo.current != _selectScript){
                          ScriptInfo.current = _selectScript;
                          // HistoryManager.scriptHistory?.clear();
                        }
                        Navigator.pop(context);
                      },
                    )
                ),


                // !nd.isExpand ? Icon(FontAwesome.folder_o , size: 20,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 20,)
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

      sortTypeIndex:  _sortTypeIndex,

      onSortTypeClicked: (index, types){
        setState(() {
              _sortTypeIndex = index;
          });
      },


      onFilter: (node){
        var ns  = node as ATreeNode<ScriptInfo>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.group}`${n.alias}";
        }
        return "";
      },

      doAFilterOverride: (str, fs, data) {
        if(_sortTypeIndex == 0)
        {
          for(var s in fs){
            if (s.trim() == "") continue;
            if (str.indexOf(s) >= 0){
              return true;
            }
          }
        }
        else{
          var ns = data as ATreeNode<ScriptInfo>;
          if(ns?.data!= null)
          {
            var scriptData = ns.data.scriptData ;
            if(scriptData != null){
              for (var node in scriptData.nodes) {
                var tp = node.getNodeStructType();
                for(var s in fs){
                if (s.trim() == "") continue;
                  //print(tp.getTypeShowString() + "---" + tp.name);
                  var tpstr = "${tp.name.toLowerCase()}`${tp.alias.toLowerCase()}";
                  if (tpstr.indexOf(s) >= 0){
                    return true;
                  }
                }
              }
            }
          }
        }
        return false;
    },

      onSortClicked: (){
        setState(() {
          iSortType = (iSortType + 1)% sortTips.length;
          BattlePusGlobal.prefs.setInt("sl_sort_type", iSortType);
          BotToast.showText(text: sortTips[iSortType] , contentColor: Colors.lightBlueAccent);
        });

      },
      sortTip: sortTips[iSortType],
      onSortDir: (aNode,bNode){
        var a = aNode as ATreeNode<ScriptInfo>;
        var b = bNode as ATreeNode<ScriptInfo>;
        switch(iSortType){
          case 0:
            return (a.name??"").compareTo(b.name??"");
          case 1:
            return (b.name??"").compareTo(a.name??"");
          case 2:
            return (a.name??"").compareTo(b.name??"");
          case 3:
            return (b.name??"").compareTo(a.name??"");
        }
        return a.name??"".compareTo(b.name??"");
      },
      onSortLeaf: (aNode,bNode){
        var a = (aNode as ATreeNode<ScriptInfo>).data;
        var b = (bNode as ATreeNode<ScriptInfo>).data;
        switch(iSortType){
          case 0:
            return (a.name??"").compareTo(b.name??"");
          case 1:
            return (b.name??"").compareTo(a.name??"");
          case 2:
            return (a.alias??"").compareTo(b.alias??"");
          case 3:
            return (b.alias??"").compareTo(a.alias??"");
        }
        return a.name??"".compareTo(b.name??"");
      },

      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<ScriptInfo>).data;
          if (si != null) {
            _selectScript = si;
          }
        });

      },

      sortTypes: _sortTypes,

      actions: [

        if(!bModule)
        IconButton(padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.minus_box_outline  ),
          color: _selectedScriptInfos.length > 0 ? Colors.red:Colors.grey,
          tooltip: "删除所有选中脚本",
          iconSize: 32,
          onPressed: (){
            if(!(_selectedScriptInfos.length > 0)) return;
            CommonUtil.confirm(context, "确定要删除所有选中脚本吗?",onOk: (){
                setState(() {
                  for (var key in _selectedScriptInfos.keys) {
                    var si = _selectedScriptInfos[key];
                    if(si != null)
                    {
                      StateScriptProject.instance.deleteScript(si);
                      if(_selectScript == si) _selectScript = null;
                    }
             
                  }
                  _selectedScriptInfos.clear();
                  forceBuildTree();
                });
              });
          }
        ),
        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.indigo,
          tooltip: bModule ?"添加模块":"添加脚本",
          iconSize: 32,
          onPressed: (){
            var newScript = StateScriptProject.instance.addScript();
            newScript.moduleGuid = StateScriptProject.currentSelectedModule??"";
            StateScriptProject.instance.save();
            setState(() {
              _selectScript = newScript;
              _selectScript.isModule = bModule;
              forceBuildTree();
              // ScriptInfo.current = _selectScript;
              // EventCenter.eventBus.fire(ScriptSelectionChangeEvent(_selected));
            });
          },
        ),

      ],
    );
    var block = ThemeCenter.block (
      headTitle: bModule ?"模块列表":"脚本列表",
      // width: 480,
      child: con,
    );

    var tagTarget = DragTarget<_DragScriptTemplate>(
      builder: (p1,p2,p3){
        return block;
      },
      onWillAccept: (e)=>e is _DragScriptTemplate,
      onMove: (d){

        if (bModule){
          if (_onInModuleArea == false){
            setState(() {
              _onInModuleArea = true;
            });
          }
        }
        else{
          if (_onInScriptArea == false){
            setState(() {
              _onInScriptArea = true;
            });
          }
        }
      },
      onLeave: (e){
        if (bModule){
          if (_onInModuleArea == true){
            setState(() {
              _onInModuleArea = false;
            });
          }
        }
        else{
          if (_onInScriptArea == true){
            setState(() {
              _onInScriptArea = false;
            });
          }
        }
      },
      onAcceptWithDetails: (e){
        setState(() {

          if (bModule){

            setState(() {
              _selectScript = StateScriptProject.instance.cloneScript(e.data.template);
              _selectScript.isModule = true;
              _selectScript.isTemplate = false;
              // _selectScript.group = si.group;
              // ScriptInfo.current = _selectScript;
              forceBuildTree();
            });

            if (_onInModuleArea == true){
              setState(() {
                _onInModuleArea = false;
              });
            }
          }
          else{

            _selectScript = StateScriptProject.instance.cloneScript(e.data.template);
            _selectScript.isModule = false;
            _selectScript.isTemplate = false;
            // _selectScript.group = si.group;
            // ScriptInfo.current = _selectScript;
            forceBuildTree();

            if (_onInScriptArea == true){
              setState(() {
                _onInScriptArea = false;
              });
            }
          }

        });
      },
    );
    return tagTarget;
  }

  ATreeNode<String> getPathsTreeRoot(){
    var scripts  = StateScriptProject.instance.scripts;
    List<String> paths = List<String>();
    scripts.forEach((element) {
      if (!DartCommon.isEmpty(element.specialExportPath) && !paths.contains(element.specialExportPath)){
        paths.add(element.specialExportPath);
      }
    });
    var res = DartCommon.buildTree(paths, (item){
      return const <String>[];
      // var sp = (item as ScriptInfo)..split("/");
      // return sp;
    });
    return res;
  }
  String _selected;
  void getThemePathsPanel(ScriptInfo crt) {
    _selected = crt?.specialExportPath??null;
    var con = SearchableThemeTreeView(
      defaultExpanded: false,
      indent: 16,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getPathsTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<String>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<String>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<String>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = Text((si as String)??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
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
        var ns  = node as ATreeNode<String>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return n;
        }
        return "";
      },


      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<String>).data;
          if (si != null) {
            _selected = si;
            crt.specialExportPath = si;
            Navigator.pop(context);
            // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }
          // forceBuildTree();
        });

      },

      actions: [
      ],
    );
    var block = ThemeCenter.block (
      headTitle: "路径",
      // width: 480,
      child: con,
    );
    // return block;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        var ch = block;
        return Dialog(child: ch);
      },
    );
  }

  Widget buildDetail() {

    if (_selectScript == null){
      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请选择一个脚本"  , style: TextStyle(fontSize: 48 , color: Colors.grey),),
        ],
      ));

    }
    if (_selectScript.tagSet == null) _selectScript.tagSet = TagSet();
    var interval = const SizedBox(height: 8,);

    var cates = List<Widget>();
    for (var c in SSCategory.categories){
      var clr = _selectScript.category == c.id? c.color : Colors.grey;
      var wc = CommonUtil.roundRect(
        padding: _selectScript.category == c.id?EdgeInsets.fromLTRB(4, 2, 4, 0):EdgeInsets.fromLTRB(4, 5, 4, 0),
        borderWidth: _selectScript.category == c.id? 4 : 0.5,
        height: 36,
        radius: 4,
        borderColor: clr,
        bgColor: ThemeCenter.systemTheme.scaffoldBackgroundColor,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          // spacing:6,
          // runSpacing:6,
          children: [
            Icon(c.icon , color: clr,),
            SizedBox(width: 4,),
            Text(c.name , style: TextStyle(color: clr),),
          ],
        ),
      );
      cates.add(InkWell(

        child: Container(child: wc , padding: EdgeInsets.all(4),),
        onTap: (){
          setState(() {
            _selectScript.category = c.id;
          });

        },
      ));
      // cates.add(SizedBox(width: 4,));
    }
    var lst = ListView(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      children: [
        TextEditor(
          initValue: _selectScript.name,
          hint: "名字",
          onChanged: (v){
            setState(() {
              _selectScript.name = v;
            });

          },
          // onSubmitted: (v) {
          //   _selectScript.name = v;
          //   // EventCenter.eventBus.fire(ScriptChangeEvent(_selectSI));
          // },
        ),
        interval,
        TextEditor(
          initValue: _selectScript.alias,
          hint: "别名(优先显示)",

          onChanged: (v){
            setState(() {
              _selectScript.alias = v;
            });

          },
          // onSubmitted: (v) {
          //   _selectScript.alias = v;
          //   // EventCenter.eventBus.fire(ScriptChangeEvent(_selectSI));
          // },
        ),
        interval,
        TextEditor(
          initValue: _selectScript.group,
          hint: "分组路径",
          onChanged: (v){
            setState(() {
              _selectScript.group = v;
              SSUserData.instance.scriptListExpandedFlags["/$v"] = true;
              SSUserData.instance.save();
              // EventCenter.eventBus.fire(ScriptChangeEvent(_selectScript));
            });

          },
          onSubmitted: (v) {
            _selectScript.group = v;
            // EventCenter.eventBus.fire(ScriptChangeEvent(_selectScript));
            setState(() {
              forceBuildTree();
            });
          },
        ),
        interval,
        LineContainer(
          title: "脚本分类模块",
          height: 60,
          child: ScriptModuleSelecter(moduleGuid: _selectScript.moduleGuid??"",
            callback: (v){
              setState(() {
                _selectScript.moduleGuid = v;
              });
            },
            actions: [
              ThemeCenter.iconBtn(MaterialCommunityIcons.ballot_outline,
                width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"从根组全部设置脚本模块",
                onPressed: (){
                  var gss = _selectScript.group.split("/");
                  if (gss.length>0){
                    var rootGroup = gss[0];
                    StateScriptProject.instance.scripts.forEach((element) {
                      if (_selectScript != element && element.group.startsWith("$rootGroup/")){
                        element.moduleGuid = _selectScript.moduleGuid;
                      }
                    });
                  }
                  BotToast.showText(text: "从根组全部设置脚本模块完成");
                },
              ),
            ],
          ),
        ),
        interval,
        LineContainer(
          title: "标签",
          height: 60,
          child: TagSetView(tagSet: _selectScript.tagSet , tagCamp: StateScriptProject.instance.tagCamp,
            actions: [
              ThemeCenter.iconBtn(MaterialCommunityIcons.ballot_outline,
                width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"全组设置",
                onPressed: (){
                  StateScriptProject.instance.scripts.forEach((element) {
                    if (_selectScript != element && element.group == _selectScript.group){
                      element.tagSet = _selectScript.tagSet.clone();
                    }
                  });

                  BotToast.showText(text: "全组设置标签完成");
                },
              ),
            ],
          ),
        ),
        LineContainer(
          title: "导出路径",
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(_selectScript.specialExportPath??""),
              ),
              ThemeCenter.iconBtn(MaterialCommunityIcons.folder_open_outline,
                width: 20 , height : 20 , color: Colors.blue, tooltip:"选择文件夹",
                onPressed: () async{
                  var path = await FileUtils.pickPath();
                  if (path != null) {
                    setState(() {
                      var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
                      _selectScript.specialExportPath = PathUtil.relative(path, from: rp);
                      StateScriptProject.instance.save();
                    });
                  }
                },
              ),
              ThemeCenter.iconBtn(MaterialCommunityIcons.menu,
                width: 20 , height : 20 , color: Colors.blue, tooltip:"从列表选择文件夹",
                onPressed: (){
                  getThemePathsPanel(_selectScript);
                },
              ),
              if (!DartCommon.isEmpty(_selectScript.specialExportPath))ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
                width: 20 , height : 20 , color: Colors.redAccent, tooltip:"清除",
                onPressed: (){
                  setState(() {
                    _selectScript.specialExportPath = null;
                  });
                },
              ),
            ],
          ),
        ),
        // TextEditor(
        //   initValue: _selectScript.specialExportPath??"",
        //   hint: "导出子路径",
        //   onChanged: (v) async {
        //
        //
        //
        //   },
        // ),
        interval,
        LineContainer(
            title: "是否模块",
            height: 52,
            child: Checkbox(
              value: _selectScript.isModule??false,
              onChanged: (v){
                setState(() {
                  _selectScript.isModule = v;
                  forceBuildTree();
                });
              },
            )
        ),
        interval,
        LineContainer(
          padding: EdgeInsets.all(4),
            title: "脚本类型(逻辑或显示)",
            height: 52,
            child: Row(
              children: [
                Checkbox(
                  value: _selectScript.logicOrView??true,
                  onChanged: (v){
                    setState(() {
                      _selectScript.logicOrView = v;
                    });
                  },
                ),
                Text("逻辑"),
                Checkbox(
                  value: !(_selectScript.logicOrView??true),
                  onChanged: (v){
                    setState(() {
                      _selectScript.logicOrView = !v;
                    });
                  },
                ),
                Text("显示"),
                // RaisedButton(
                //   child: Text("逻辑"),
                // ),
                // Container(width: 4,),
                // RaisedButton(
                //   child: Text("显示"),
                // ),
              ],
            )
        ),
        LineContainer(
            title: "behavic agent",
            height: 52,
            child: BehavicAgentPicker(
              agentGuid: _selectScript.behavicAgentGuid??"",
              onClear: (){
                setState(() {
                  _selectScript.behavicAgentGuid = "";
                });
              },
              onChanged: (clz){
                if (clz == null) return ;
                setState(() {
                  _selectScript.behavicAgentGuid = clz.guid;
                });
              },
            ),
        ),
        interval,
        LineContainer(
            height: 130,
            title: "分类",

            // singleLine: false,
            // height: 80,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: cates
            ),
        ),
        interval,
        if (!(_selectScript.isTemplate??false)) LineContainer(
          height: 58,
          padding: EdgeInsets.all(4),
          title: "操作",
          // singleLine: false,
          // height: 80,
          child: ElevatedButton(

            child: Text("创建模板"),
            onPressed: (){
              setState(() {
                var newScript = StateScriptProject.instance.scriptToTemplate(_selectScript);
                newScript.group = _selectScript.group;
                _selectScript = newScript;
                // ScriptInfo.current = _selectScript;
                forceBuildTree();
              });

              BotToast.showText(text: "模板已创建");
            },
          )
        ),
      ],
    );

    // var sb = Scrollbar(
    //     child:lst
    // );
//    var bgClr = const Color.fromARGB(8, 0, 0, 0);
    var padding = EdgeInsets.all(4);
    // var dc = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    // );
    return  ThemeCenter.block(
      headTitle: "详细信息",
      padding: padding,
      // decoration:dc,
      child: lst,
    );
  }


}

