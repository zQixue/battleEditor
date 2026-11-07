//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';

import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class NodeDefineListView extends StatefulWidget {
  NodeDefineListView({Key key}) : super(
      key: key);

  @override
  _NodeDefineListViewState createState() =>
      _NodeDefineListViewState(
      );
}

class _NodeDefineListViewState extends State<NodeDefineListView> {
  StreamSubscription<NodeTypeChangeEvent> _lis;

  Map<String, List<NodeStructData>> groupNaps;
  List<String> groups;

  String _filter;

  NodeStructData _newNode;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<NodeTypeChangeEvent>().listen((event) {
      setState(() {
        forceBuildTree();
      });
    });
  }
  ATreeNode<NodeStructData> _nodeRoot;
  bool _nodeRootNR = false;
  ATreeNode<NodeStructData> getNodeTreeRoot(){
    if (_nodeRoot == null || _nodeRootNR){
      var scripts = StateScriptProject.instance.nodeStructs;//.where((element) => false == element.isModule).toList();
      _nodeRoot = DartCommon.buildTree(scripts, (item){
        var sp = (item as NodeStructData).group.split("/");
        return sp;
      });
    }
    _nodeRootNR = false;
    return _nodeRoot;
  }
  void forceBuildTree(){
    _nodeRootNR = true;
  }

  String _filterStr;
  int _sortTypeIndex = 0;
  List<String> _sortTypes = ["无", "参数入口-参数类型", "参数接口-参数类型"];

  Widget getThemeStructTree() {
    var con = SearchableThemeTreeView(
      defaultExpanded: false,
      onExpandedFlagChanged: (map){
        SSUserData.instance.nodeStructListExpandedFlags = map;
        SSUserData.instance.save();
      },
      indent: 16,
      expandedFlags: SSUserData.instance.nodeStructListExpandedFlags,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getNodeTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<NodeStructData>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<NodeStructData>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<NodeStructData>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = Text((si as NodeStructData).getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12 ) ,  );
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
                if (si.isSystemNode) Icon(MaterialCommunityIcons.lock , size: 16,color: Colors.redAccent,),
                if (si.isSystemNode) SizedBox(width: 4,),
                Expanded(child : txt),
                if (!si.isSystemNode)Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.minus_box_outline),
                      tooltip: "删除结点",
                      color: Colors.redAccent,
                      iconSize: iconSize,
                      onPressed: (){
                        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                          setState(() {
                            StateScriptProject.instance.deleteNodeType(si);
                            StateScriptProject.instance.refreshStructMap();
                            StateScriptProject.instance.save();
                            if (si == _selected) _selected = null;
                            EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(si));
                            forceBuildTree();
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
                      color: Colors.lightBlueAccent,
                      tooltip: "复制结点",
                      iconSize: iconSize,
                      onPressed: (){

                        setState(() {
                          _selected = StateScriptProject.instance.cloneNodeStruct(si);
                          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                          forceBuildTree();
                          // _selectScript.group = astruct.group;
                          // ScriptInfo.current = _selectScript;
                        });

                      },
                    )
                ),

                Draggable(
                  child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blueGrey,),
                  feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.lightBlueAccent,),
                  childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.lightBlueAccent,),
                  data:si,
                ),
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
                //         if(_selectScript != astruct) {
                //           _selectScript = astruct;
                //         }
                //         if (ScriptInfo.current != _selectScript){
                //           ScriptInfo.current = _selectScript;
                //           // HistoryManager.scriptHistory?.clear();
                //         }
                //         Navigator.pop(context);
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

      onFilterStringChanged:(v)
      {
        _filterStr = v;
      } ,

      sortTypeIndex:  _sortTypeIndex,

      onSortTypeClicked: (index, types){
        setState(() {
              _sortTypeIndex = index;
          });
      },

      onFilter: (node){
      var ns  = node as ATreeNode<NodeStructData>;
      if(ns ==  null) return "";
      var n = ns.data;
      if (n == null) return "";

      String matchStr = "";
      switch(_sortTypeIndex)
      {
        case 0:
          matchStr = "${n.name}`${n.group}`${n.alias}";
        break;

        case 1:
         if(n.inParams != null || n.inParams.length > 0)
          {
            for (var element in  n.inParams) {
                  if(element.paramType.toLowerCase().trim() == _filterStr.toLowerCase().trim())
              {
                  matchStr =  _filterStr;
                  break;
              }
            }
          } 
        break;
        case 2:
            if(n.outParams != null || n.outParams.length > 0)
            {
              for (var element in  n.outParams) {
                    if(element.paramType.toLowerCase().trim() == _filterStr.toLowerCase().trim())
                {
                    matchStr =  _filterStr;
                    break;
                }
              }
            } 
        break;
      }
        return matchStr;
      },

      // onSort: (aNode,bNode){
      //   var a = (aNode as ATreeNode<ScriptInfo>).data;
      //   var b = (bNode as ATreeNode<ScriptInfo>).data;
      //   return a.getShowStringAndName().compareTo(b.getShowStringAndName());
      // },

      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<NodeStructData>).data;
          if (si != null) {
            _selected = si;
            EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }
          // forceBuildTree();
        });

      },

      sortTypes: _sortTypes,

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.indigo,
          iconSize: 32,
          onPressed: (){

            var newNode = StateScriptProject.instance.addNewNodeType();
            StateScriptProject.instance.refreshStructMap();
            StateScriptProject.instance.save();
            setState(() {
              _selected = newNode;
              _newNode = newNode;
              EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
              forceBuildTree();
            });

          },
        ),

      ],
    );
    var block = ThemeCenter.block (
      headTitle: "结点列表",
      // width: 480,
      child: con,
    );
    return block;
  }




  // Widget getStructTree() {
  //   var dc = new BoxDecoration(
  //     boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
  //   );
  //
  //   var con = SearchableTreeView(
  //     defaultExpanded: false,
  //     onExpandedFlagChanged: (map){
  //       SSUserData.instance.nodeStructListExpandedFlags = map;
  //       SSUserData.instance.save();
  //     },
  //     indent: 16,
  //     expandedFlags: SSUserData.instance.nodeStructListExpandedFlags,
  //     // itemBaseWidth: 200,
  //     decoration: dc,
  //     items: StateScriptProject.instance.nodeStructs,
  //     onBuildDir: (name , nd){
  //       // var txt = Text(name??"",style: TextStyle( color:  nd.isExpand?Colors.black:Colors.grey));
  //       var txt = Text(name??"",style: TextStyle( color:  Colors.black));
  //       var con = Container(
  //         padding: EdgeInsets.fromLTRB(8,0,8,0),
  //         height: 36,
  //         color: CommonUtil.alphaColor(nd.isExpand ? Colors.green : Colors.grey , 50),
  //         // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
  //         child: Row(
  //           children: [
  //             !nd.isExpand ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,color: Colors.blueAccent,),
  //             SizedBox(width: 8,),
  //             Expanded(child : txt),
  //           ],
  //         ),
  //       );
  //       // return txt;
  //       return Container(
  //         padding: EdgeInsets.all(1),
  //         child: con,
  //       );
  //     },
  //     onBuildItem: (astruct,nd){
  //
  //       // return Text((nodeStruct as ScriptInfo).name , style: style,);
  //       var si = (astruct as NodeStructData);
  //       // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
  //
  //       var txt = Text((astruct as NodeStructData).getShowStringAndName()??"" ,style: TextStyle( color: Colors.black));
  //       var iconSize = 28.0;
  //       var con = Container(
  //         color: _selected == astruct? CommonUtil.scaleColor(Colors.blue,0.2):Colors.white,
  //         padding: EdgeInsets.fromLTRB(8,0,8,0),
  //         height: 32,
  //         // color: CommonUtil.scaleColor(Colors.grey, 0.15),
  //         // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
  //         child: Row(
  //           children: [
  //             // Visibility(
  //             //   visible: si.isModule??false,
  //             //   child: Icon(MaterialCommunityIcons.alpha_m_box_outline , color: Colors.brown,),
  //             // ),
  //             // cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
  //             SizedBox(width: 4,),
  //             Expanded(child : txt),
  //             Container(
  //                 width: iconSize,
  //                 height: iconSize,
  //                 child:IconButton(
  //                   padding: EdgeInsets.all(0),
  //                   icon : Icon(MaterialCommunityIcons.minus_box_outline),
  //                   tooltip: "删除结点",
  //                   color: Colors.redAccent,
  //                   iconSize: iconSize,
  //                   onPressed: (){
  //                     CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
  //                       setState(() {
  //                         StateScriptProject.instance.deleteNodeType(astruct);
  //                         StateScriptProject.instance.refreshStructMap();
  //                         StateScriptProject.instance.save();
  //                         if (astruct == _selected) _selected = null;
  //                         EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(astruct));
  //                       });
  //                     });
  //                   },
  //                 )
  //             ),
  //             Container(
  //                 width: iconSize,
  //                 height: iconSize,
  //                 child:IconButton(
  //                   padding: EdgeInsets.all(0),
  //                   icon : Icon(MaterialCommunityIcons.shape_square_plus),
  //                   color: Colors.indigo,
  //                   tooltip: "复制结点",
  //                   iconSize: iconSize,
  //                   onPressed: (){
  //
  //                     setState(() {
  //                       _selected = StateScriptProject.instance.cloneNodeStruct(astruct);
  //                       EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
  //                       // _selectScript.group = astruct.group;
  //                       // ScriptInfo.current = _selectScript;
  //                     });
  //
  //                   },
  //                 )
  //             ),
  //
  //             Draggable(
  //               child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.indigo,),
  //               feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.indigo,),
  //               childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.green,),
  //               data:si,
  //             ),
  //             // Container(
  //             //     width: iconSize,
  //             //     height: iconSize,
  //             //     child:IconButton(
  //             //       padding: EdgeInsets.all(0),
  //             //       icon : Icon(MaterialCommunityIcons.square_edit_outline),
  //             //       color: Colors.indigo,
  //             //       tooltip: "打开编辑脚本",
  //             //       iconSize: iconSize,
  //             //       onPressed: (){
  //             //         if(_selectScript != astruct) {
  //             //           _selectScript = astruct;
  //             //         }
  //             //         if (ScriptInfo.current != _selectScript){
  //             //           ScriptInfo.current = _selectScript;
  //             //           // HistoryManager.scriptHistory?.clear();
  //             //         }
  //             //         Navigator.pop(context);
  //             //       },
  //             //     )
  //             // ),
  //
  //
  //             // !nd.isExpand ? Icon(FontAwesome.folder_o , size: 20,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 20,)
  //           ],
  //         ),
  //       );
  //       // return txt;
  //       return Container(
  //
  //         padding: EdgeInsets.all(1),
  //         child: con,
  //       );
  //     },
  //     onGetTreePath: (nodeStruct){
  //       var g = (nodeStruct as NodeStructData).group;
  //       // if (DartCommon.isEmpty(g)) return ["_未分类_"];
  //       var sp = (nodeStruct as NodeStructData).group.split("/");
  //       // if (sp.length<=0) sp =["未分类"];
  //       return sp;
  //     },
  //     onFilter: (nodeStruct){
  //       var ns  = nodeStruct as NodeStructData;
  //       return "${ns.name}`${ns.group}`${ns.alias}";
  //     },
  //
  //     onSort: (a,b){
  //       return (a as NodeStructData).guid.compareTo((b as NodeStructData).guid);
  //     },
  //
  //     onItemTap: (item){
  //       setState(() {
  //         _selected = item;
  //         EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
  //       });
  //
  //     },
  //
  //     actions: [
  //
  //       IconButton(
  //         padding: EdgeInsets.all(0),
  //         icon : Icon(MaterialCommunityIcons.plus_box_outline),
  //         color: Colors.indigo,
  //         iconSize: 32,
  //         onPressed: (){
  //           var newNode = StateScriptProject.instance.addNewNodeType();
  //           StateScriptProject.instance.refreshStructMap();
  //           StateScriptProject.instance.save();
  //           setState(() {
  //             _selected = newNode;
  //             _newNode = newNode;
  //             EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
  //           });
  //         },
  //       ),
  //
  //     ],
  //   );
  //   return Container(
  //     width: 480,
  //     child: con,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (SSDefines.focusNodeType != null){
      var selectNT = SSDefines.focusNodeType;
      SSDefines.focusNodeType = null;
      Future.delayed(Duration(milliseconds: 30)).then((value) {
        _selected = StateScriptProject.instance.structMap[selectNT];
        if (_selected != null) {
          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
        }
      });

      // SSDefines.focusNodeType = null;
    }
    return getThemeStructTree();

    groupNaps = StateScriptProject.instance.getStructGroups();
    groups = groupNaps.keys.toList();
    groups.sort();
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    var filter = Row(
      children: [
        Icon(Icons.search , size: 24, color: Colors.black,),
        Expanded(
          child: TextField(
            autofocus: false,
            onChanged: (v) {
              setState(() {
                _filter = v.trim();
              }
              );
            },
          ),
        ),

        _newNode != null?IconButton(
          icon : Icon(MaterialCommunityIcons.new_box  ),
          iconSize: 24,
          color: Colors.red,
          onPressed: (){
            setState(() {
              _newNode = null;
              EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
            });
          },
        ):Container(),
      ],
    );

    return Container(
      width: 400,
//      decoration: dc,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: filter,
          ),
          SizedBox(height: 8,),
          Expanded (child :Container(
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: Container(
//              color :Colors.black12,
              child : getStructList(),
            ),


          )),

          SizedBox(height: 8,),
          Container(
            decoration: dc,
//            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
//                IconButton(icon: Icon(Ionicons.md_download),iconSize: 44, color: Colors.black, tooltip:"导入",
//                  onPressed: (){
//                    showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        var child = ImportNodePage();
//                        return Dialog(child: child);
//                      },
//                    );
//                  },
//                ),
                IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 48, color: _selected == null?Colors.grey:Colors.black, tooltip:"删除节点",
                  onPressed: (){
                    if (_selected != null){
                      CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                        setState(() {
                          StateScriptProject.instance.deleteNodeType(_selected);
                          StateScriptProject.instance.refreshStructMap();
                          StateScriptProject.instance.save();
                          _selected = null;
                          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                        });
                      });
                    }
                  },
                ),
                IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 48, color: Colors.black, tooltip:"添加新节点",
                  onPressed: (){
                    var newNode = StateScriptProject.instance.addNewNodeType();
                    StateScriptProject.instance.refreshStructMap();
                    StateScriptProject.instance.save();
                    setState(() {
                      _selected = newNode;
                      _newNode = newNode;
                      EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                    });
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getStructList() {
//    var groups = StateScriptProject.instance.getStructGroups();
    var items = List<Widget>();
    int index = 0;
    for(var g in groups){
      var gg = onBuildGroup(context,index++);
      if (gg != null){
        items.add(gg);
      }
    }

    var lst = ListView(
      children: items,
    );

    return Scrollbar(
      child: lst,
    );

  }
  Map<String,bool> _closed = Map<String,bool>();
  Widget onBuildGroup(BuildContext context, int index) {
//    var groupNaps = StateScriptProject.instance.getStructGroups();
//    var groups = groupNaps.keys.toList();
//    groups.sort();
    var name = groups[index];
    var showName = name;
    if (name == null || name.isEmpty){
      showName = "基本";
    }
    var items = List<Widget>();

//    var dc = BoxDecoration(
//      border:BoxBorder(
//
//      ),
////      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
//    );
    var groupBar = Container(
      padding: EdgeInsets.all(8),
//      decoration: dc,
      color  : Colors.black12,//_opend.containsKey(name)?CommonUtil.alphaColor(Colors.indigo , 32) :Colors.black12,
      height : 48,
      child: Row(

        children: [
          Icon(Icons.group_work , color: _closed.containsKey(name)?Colors.grey:Colors.indigo,),
          SizedBox(width: 16,),
          Text(showName),
        ],
      )
    );
    var inkwell = InkWell(
      onTap: (){
        setState(() {
          if (_closed.containsKey(name)) _closed.remove(name);
          else _closed[name] = true;
        });
      },
      child: groupBar,
    );

    var itemNodes = List<Widget>();
    if (!_closed.containsKey(name)){
      //打开
      for(var n in groupNaps[name]){

        if (isShown(n)){
          var nodeItem = getNodeItem(n);
          if (_newNode == null || _newNode == n) {
            itemNodes.add(nodeItem);
          }
        }
      }
    }
    // if (itemNodes.length <=0 && !DartCommon.isEmpty(_filter)) return null;
    if (DartCommon.isEmpty(_filter)&& _newNode==null) items.add(inkwell);
    items.addAll(itemNodes);
    return Column(
      children: items,
    );
  }

  bool isShown(NodeStructData nodeItem){
    if (_filter == null || _filter == "") return true;
    var lowCase = _filter.toLowerCase();
    if (nodeItem.name.toLowerCase().indexOf(lowCase)>=0 ||nodeItem.alias.toLowerCase().indexOf(lowCase)>=0){
      return true;
    }
    return false;
  }
  NodeStructData _selected ;
  Widget getNodeItem(NodeStructData n) {
    var name = n.name;
    var item = Container(
      padding: EdgeInsets.all(8),
        color  : _selected == n ?CommonUtil.alphaColor(Colors.red , 32) :Colors.white,
      height: 48,
        child: Row(
          children: [
            SizedBox(width: 32,),
            Icon(Icons.adjust , color: Colors.black,),
            SizedBox(width: 16,),
            Expanded(child:Text(n.getShowStringAndName() , maxLines: 1,)),

            Draggable(
              child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.indigo,),
              feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.indigo,),
              childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.green,),
              data:n,
            ),
          ],
        )
    );
    var inkwell = InkWell(
      onTap: (){
        setState(() {
          _selected = n;
          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
        });

      },
      child: item,
    );
    return inkwell;
  }
}