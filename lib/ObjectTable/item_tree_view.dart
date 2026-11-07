//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:battlepus/ObjectTable/Struct/AObject.dart';

import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';

import 'package:battlepus/ObjectTable/a_object_tag.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

import 'package:battlepus/common/searchable_theme_tree_view.dart';

import 'dart:async';

import 'dart:convert';
import 'package:uuid/uuid.dart';

class ItemTreeView extends StatefulWidget {
  final ObjectClazz clazz;
  final dynamic onFocusChanged;
  ItemTreeView({Key key,
    this.clazz,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  _ItemTreeViewState createState() => _ItemTreeViewState();
}

class _ItemTreeViewState extends State<ItemTreeView> {
  StreamSubscription<ObjectTreeRefreshEvent> _lis;
  StreamSubscription<GlobalRefreshEvent> _lis1;
  StreamSubscription<AObjectTableCleared> _lis6;
  Map<String , bool> _isOpenMap = Map<String , bool>();
  List<AObject> filterdObjects = List<AObject>();
  ObjectClazz _selectClazz;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
    _lis1?.cancel();
    _lis6?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectClazz = widget.clazz;
    super.initState();
    _lis = EventCenter.eventBus.on<ObjectTreeRefreshEvent>().listen((event) {
      if (event.clazz != null){
        _selectClazz = event.clazz;
      }

      setState(() {
        forceBuildTree();
      });
    });
    _lis6 = EventCenter.eventBus.on<AObjectTableCleared>().listen((event) {
      setState(() {
        _selectClazz = null;
        focusItem = null;
        // _selectedLine = null;
      });
    });
    _lis1 = EventCenter.eventBus.on<GlobalRefreshEvent>().listen((event) {
      setState(() {
        forceBuildTree();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return getItemTree();
  }
  ATreeNode<AObject> _objectRoot;
  bool _objectRootNR = false;
  ATreeNode<AObject> getObjectTreeRoot(){

    if (_objectRoot == null || _objectRootNR){
      var scripts = _selectClazz.table.objects;//StateScriptProject.instance.scripts.where((element) => false == element.isModule).toList();
      // print("element count 2 : ${scripts.length}");
      _objectRoot = DartCommon.buildTree(scripts, (item){

        var id = (item as AObject).group ??"";
        var sp = id.split("/");
        if (sp.length>0) {
          return sp;
        }
        return [];
      });
    }
    _objectRootNR = false;
    return _objectRoot;
  }
  AObject focusItem;
  Widget getItemTree() {

    if (_selectClazz == null){
      return ThemeCenter.block(headTitle: "对象列表",child: Container());
    }
    int iCount = 0;
    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      itemExtent: 36,
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<AObject>).id;
      },
      indent: 16,
      root : getObjectTreeRoot(),
      intervalColor : CommonUtil.alphaColorD(Colors.blueGrey, 0.05),
      onBuildItem: (node,expanded , highlightPattern){
        // print(highlightPattern);
        var agent = node as ATreeNode<AObject>;
        if (agent.isLeaf) {

          var bgColor = iCount%2 ==0 ? ThemeCenter.systemTheme.scaffoldBackgroundColor:CommonUtil.alphaColorD(Colors.blueGrey, 0.05) ;
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<AObject>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = focusItem == si;//(_selectedStrings[si.guid] != null);
          var clz = ObjectClazz.getClazz(si.clazzGuid);
          // var txt = Text(si.getTag(), overflow: TextOverflow.ellipsis, maxLines: 1 , style: ThemeCenter.mainTextStyle(step: 8,fontSize: 14));
          var iconSize = 28.0;
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : null,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(4,4,10,4),
                  child: Row(
                    children: [
                      AObjectTag(obj: si, highlightPattern: highlightPattern,),
                      // Container(width:24 , height:24,child:IconButton(
                      //   padding: EdgeInsets.all(0),
                      //   icon: Icon(MaterialCommunityIcons.tab_plus),
                      //   color: Colors.blueAccent,
                      //   tooltip: "新标签页打开",
                      //   iconSize: 20,
                      //   onPressed: (){
                      //     setState(() {
                      //       OTGlobalBoard.appendFocusItem(si);
                      //       // forceBuildTree();
                      //     });
                      //
                      //   },
                      // )),
                      if (selected) Container(width:24 , height:24,child:IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(MaterialCommunityIcons.shape_square_plus),
                        color: Colors.green,
                        tooltip: "复制实例",
                        iconSize: 24,
                        onPressed: (){
                          setState(() {
                            var newItem = cloneObject(si);
                            clz.table.addExistObject(newItem);
                            _isOpenMap[newItem.guid] = true;
                            doFocusItem(newItem);
                            newItem.buildTag(clz.getAllTagFields());
                            forceBuildTree();
                          });
                        },
                      )),
                      if (selected) Container(width:24 , height:24,child:IconButton(
                        padding: EdgeInsets.fromLTRB(0,1.5,0,0),
                        icon: Icon(MaterialCommunityIcons.minus_box_outline),
                        color: Colors.redAccent,
                        tooltip: "删除实例",
                        iconSize: 24,
                        onPressed: (){
                          CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                            setState(() {
                              OTGlobalBoard.removeFocusItem(si);
                              // clz.table.objects.remove(si);
                              clz.table.deleteObject(si);
                              if (focusItem == si){
                                focusItem = null;
                                doFocusItem(null);
                              }

                              forceBuildTree();

                            });
                          });
                        },
                      )),
                      SizedBox(width: 4,)
                    ],
                  )
              )
          );
          // return txt;
          var con2 = Padding(
            padding: EdgeInsets.all(1),
            child: con,
          );
          // var te = Draggable(
          //   child: con,
          //   feedback: Material(child:con),
          //   childWhenDragging: con,
          //   data: si,
          // );

          return InkWell(
            onTap: (){
              setState(() {
                doFocusItem(si);
              });
            },
            child: con2,
          );// con;
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?5:2 ,fontSize: 12));
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
        return (node as ATreeNode<AObject>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<AObject>;
        if (ns != null) {

          if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return "${ns.data.getTypeShowString()}";
          // if (ns.isLeaf) return n.//return "${n.name}`${n.defaultValue}";
          // return "${ns.id}";
        }
        return "";
      },
      // onFilter: (nodeStruct){
      //   var ns  = nodeStruct as ATreeNode<AString>;
      //   return "${ns.data.content}`${ns.data.id}";
      // },

      // onSortLeaf: (a,b){
      //   return (a as ATreeNode<AObject>).data.guid.compareTo((b as ATreeNode<AObject>).data.guid);
      // },

      onItemTap: (item){
        // var a = item as ATreeNode<AObject>;
        // if (a != null && a.data != null) {
        //   setState(() {
        //     _selectClazz = a.data;
        //   });
        // }
      },

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(MaterialCommunityIcons.plus_box_outline),
          color : Colors.green,
          tooltip: "添加实例",
          iconSize: 28,
          onPressed: (){
            setState(() {

              var newItem = _selectClazz.table.addObject();
              _isOpenMap[newItem.guid] = true;
              doFocusItem(newItem);
              forceBuildTree();

            });

          },
        )
      ],
    );
    return ThemeCenter.block(headTitle: "对象列表",child: con,
      // actions: [
      //   ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_left_bold_box_outline,
      //     onPressed: (){
      //       setState(() {
      //         showList = false;
      //       });
      //     }
      //   )
      // ]
    );
  }

  AObject cloneObject(AObject obj) {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(obj);
    JsonDecoder dec = JsonDecoder();
    AObject data = AObject.fromJson(dec.convert(json));
    data.name = data.name + " [clone]";
    data.guid = Uuid().v4();
    return data;
  }
  ATreeNode<ObjectClazz> _clazzRoot;
  bool _clazzRootNR = false;
  void forceBuildTree(){
    _clazzRootNR = true;
    _objectRootNR = true;

    if (_selectClazz!= null) {
      filterdObjects = _selectClazz.table.objects;
    }
  }
  void doFocusItem(AObject item){
    if(focusItem != item) {
      focusItem = item;
      widget.onFocusChanged?.call(focusItem);

      if (focusItem != null) {
        TableUtiles.currentObject = focusItem;
        bool bRet = focusItem.flush2Unity();
        if (bRet){
          // BotToast.showText(text: "刷新完毕" , contentColor:  Colors.green);
        }
        var err = TableImporter.logger;
        ObjectTableProject.checkShowLog(err , context: context,);
      }

    }
    EventCenter.eventBus.fire(InspectorRefreshEvent()..object = focusItem);
    EventCenter.eventBus.fire(ObjectFocusEvent()..object = focusItem);
    if (item != null) {
      OTGlobalBoard.focusItem(focusItem);
    }

  }
}