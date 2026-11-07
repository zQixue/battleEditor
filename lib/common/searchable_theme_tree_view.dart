//@dart=2.11
import 'dart:math';

import 'package:edit_distance/edit_distance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/KeFrame/frame_separate_widget.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';
// import 'package:pluto_grid/pluto_grid.dart';

typedef Widget FunctionBuildItemCallback(dynamic value ,bool expanded , String highlightPatern);
typedef dynamic FunctionGetItemIDCallback(dynamic value );
typedef List FunctionGetChildrenCallback(dynamic value);
typedef Widget FunctionBuildDirCallback(String dirName ,  nd);
typedef String FunctionFilterCallback(dynamic value);
typedef List<String> FunctionGetTreePathCallback(dynamic value);
typedef void ItemTapCallback(dynamic item);
typedef void FilterChanged(dynamic items);
typedef int ItemSortCallback(dynamic a,dynamic b);
typedef void SetLeafIndexCallback(dynamic a,int iIndex);
typedef void ExpanadedFlagChanged(Map<String , bool> value);
typedef void SortTypeChanged(int index, List<String> types);
typedef bool DoAFilterOverride(String str, List<String> fs, dynamic data);

class SearchableThemeTreeView extends StatefulWidget {
  final FunctionBuildItemCallback onBuildItem;
  final FunctionGetItemIDCallback onGetID;
  final FunctionGetChildrenCallback onGetChildren;

  final FunctionFilterCallback onFilter;
  // final List items;
  final dynamic root;
  final Color intervalColor;
  final Color expandButtonColor;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final double indent;
  final double itemExtent;
  final double itemBaseWidth;
  final List<Widget> actions;
  final ItemTapCallback onItemTap;
  final SetLeafIndexCallback onSetLeafIndex;
  final ItemSortCallback onSortLeaf;
  final ItemSortCallback onSortDir;
  final dynamic onSortClicked;
  
  int sortTypeIndex;
  final List<String> sortTypes;//做自定义类型的筛选  类似于Unity的类型过滤
  final SortTypeChanged onSortTypeClicked;

  final String sortTip;

  final Map<String , bool> expandedFlags;//叶子结点是否打开的属性
  final bool defaultExpanded;
  final ExpanadedFlagChanged onExpandedFlagChanged;
  final FilterChanged onFilterChanged;
  final dynamic selectedItem;
  // final bool useListView;
  final bool reverse;
  final bool separateFrame;
  final bool hideRoot;
  final Color dirBgColor;
  final bool withExpandedButton;

  final String filterString;
  final dynamic onFilterStringChanged;

  final double initPosition;
  final dynamic onScrollPosition;
  final DoAFilterOverride doAFilterOverride;  //重写的过滤方法,有的仅仅实现OnFilter是不够的

  SearchableThemeTreeView({Key key , this.sortTip ,this.onSortClicked , this.onSortTypeClicked, this.separateFrame = false ,this.itemExtent,this.intervalColor, this.initPosition,this.onScrollPosition, this.filterString,this.onFilterStringChanged,this
      .withExpandedButton = true, this
      .onSetLeafIndex, this.onSortDir,this
      .dirBgColor ,  this.sortTypeIndex = 0, this.sortTypes,
      this.hideRoot = true, this.reverse = false, this.doAFilterOverride,this
      .selectedItem , this
      .expandButtonColor = Colors.white , this.onGetID, this.onGetChildren, this.root ,this.onExpandedFlagChanged  ,this.onSortLeaf,this.defaultExpanded = true, this.expandedFlags, this.onItemTap , this.actions , this.indent = 16.0,this.onBuildItem , this.onFilterChanged, this.onFilter  , this.decoration , this.padding , this.itemBaseWidth})
      : assert(onGetChildren!= null),assert(onGetID!= null),super(key: key);


  @override
  _SearchableThemeTreeViewState createState() => _SearchableThemeTreeViewState();
}
class ListNode{
  dynamic data;
  int level;
  bool withChild;
}
class _SearchableThemeTreeViewState extends State<SearchableThemeTreeView> {
  // TreeViewController _controller;

  String _filterStr;
  ScrollController _semicircleController ;//= ScrollController();
  // dynamic _selectItem ;
  @override
  void initState() {
    // TODO: implement initState
    expandedFlags = widget.expandedFlags??Map<dynamic , bool>();
    _semicircleController = ScrollController();


    _semicircleController.addListener(() {
      // print("---------- position : ${_semicircleController.offset}");
      widget.onScrollPosition?.call(_semicircleController.offset);
    });
    _filterStr = widget.filterString;
    super.initState();
    // _controller = TreeViewController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller?.dispose();
    _semicircleController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {



    return buildTreeView();
  }
  Map<dynamic , bool> expandedFlags ;//= Map<String , bool>();

  void buildNodeList( dynamic nodeData ,  List<dynamic> nodes , int iLevel){

    if (_filterCache[nodeData] == null) return ;
    var children = widget.onGetChildren?.call(nodeData);
    bool withChild = (children != null && children.length>0);
    // double offsetX = iLevel * widget.indent;
    var id = widget.onGetID?.call(nodeData);
    //
    // print("check id expanded : $id");
    bool expanded = expandedFlags.containsKey(id);
    if (widget.defaultExpanded){
      expanded = !expanded;
    }
    if (_filters!= null && _filters.length>0) expanded = true;
    // var w = widget.onBuildItem?.call(nodeData , expanded);
    //
    // var row = Row(
    //   children: [
    //     SizedBox(width: offsetX,),
    //     Expanded(child : w),
    //     if (withChild) Container(
    //       height: 26,
    //       width: 26,
    //       child: IconButton(
    //         padding: EdgeInsets.all(0),
    //         icon: Icon(!expanded?MaterialCommunityIcons.chevron_down : MaterialCommunityIcons.chevron_up),
    //         iconSize: 26,
    //         color: !expanded?Colors.grey : widget.expandButtonColor,
    //         onPressed: (){
    //           setState(() {
    //             if (expandedFlags.containsKey(id)) {
    //               expandedFlags.remove(id);
    //             }
    //             else {
    //               expandedFlags[id] = true;
    //             }
    //
    //             widget.onExpandedFlagChanged?.call(expandedFlags);
    //           });
    //
    //         },
    //       ),
    //     )
    //   ],
    // );
    // // nodes.add(Container(
    // //   color : _selectItem == nodeData? ThemeCenter.systemTheme.primaryColorDark:null,
    // //   child: row,
    // // ));
    //
    // var con = Container(
    //   decoration: BoxDecoration(
    //       color : withChild?(widget.dirBgColor??ThemeCenter.systemTheme.scaffoldBackgroundColor):ThemeCenter.systemTheme.scaffoldBackgroundColor,
    //       border : Border(
    //         bottom: BorderSide(width: 0.5,color: CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(1) ,0.04)),
    //       )),
    //   // color : widget.selectedItem == nodeData? ThemeCenter.systemTheme.primaryColorDark:ThemeCenter.systemTheme.scaffoldBackgroundColor,
    //   child: row,
    // );
    //
    // var ink = GestureDetector(
    //   child: con,
    //   onTap: () {
    //     widget.onItemTap?.call(nodeData);
    //     // if (_selectItem != nodeData){
    //     //   setState(() {
    //     //     _selectItem = nodeData;
    //     //   });
    //     // }
    //
    //   },
    // );
    bool bIsSkipRoot = false;
    if (nodeData == widget.root && widget.hideRoot){
      //do nothing
      bIsSkipRoot = true;
    }
    else {
      nodes.add(ListNode()..data = nodeData..level = iLevel..withChild = withChild);
    }
    if (nodeData == widget.root) expanded = true;
    // var children = widget.onGetChildren?.call(nodeData);



    if (withChild && expanded){
      var dirs = children.where((element) => !(element.isLeaf??false)).toList();
      if (_filters != null && _filters.length>0){
        dirs.sort((a,b){
          var fa = _filterCache[a]??0;
          var fb = _filterCache[b]??0;
          return fa-fb;
        });
      }
      else if (widget.onSortDir != null){
        dirs.sort(widget.onSortDir);
      }

      var leafs = children.where((element) => (element.isLeaf??true)).toList();
      if (_filters != null && _filters.length>0){
        leafs.sort((a,b){
          var fa = _filterCache[a]??0;
          var fb = _filterCache[b]??0;
          return fa-fb;
        });
      }
      else if (widget.onSortLeaf != null){
        leafs.sort(widget.onSortLeaf);
      }
      if (widget.onSetLeafIndex!= null) {
        for (int i = 0; i < leafs.length; ++i) {
          widget.onSetLeafIndex?.call(leafs[i], i*8);
        }
      }

      if (widget.reverse){
        for(var i = dirs.length - 1 ; i >=0 ; --i){
          var c = children[i];
          buildNodeList(c, nodes, iLevel + (bIsSkipRoot?0:1));
        }
      }
      else {
        for (var c in dirs) {
          buildNodeList(c, nodes, iLevel + (bIsSkipRoot?0:1));
        }
      }

      if (widget.reverse){
        for(var i = leafs.length - 1 ; i >=0 ; --i){
          var c = children[i];
          buildNodeList(c, nodes, iLevel + (bIsSkipRoot?0:1));
        }
      }
      else {
        for (var c in leafs) {
          buildNodeList(c, nodes, iLevel + (bIsSkipRoot?0:1));
        }
      }
    }
  }

  void allExpanded(dynamic nodeData){
    if (nodeData == null) return ;
    var children = widget.onGetChildren?.call(nodeData);
    bool withChild = (children != null && children.length>0);
    if (withChild){
      var id = widget.onGetID?.call(nodeData);

      if (!widget.defaultExpanded) {
        expandedFlags[id] = true;
      }
      else{
        expandedFlags.remove(id);
      }
      for(var ch in children){
        allExpanded(ch);
      }
      // widget.onExpandedFlagChanged?.call(expandedFlags);
    }

  }

  void allUnexpanded(dynamic nodeData){
    if (nodeData == null) return ;
    var children = widget.onGetChildren?.call(nodeData);
    bool withChild = (children != null && children.length>0);
    // var id = widget.onGetID?.call(nodeData);
    if (withChild){
      var id = widget.onGetID?.call(nodeData);

      if (widget.defaultExpanded) {
        expandedFlags[id] = true;
      }
      else{
        expandedFlags.remove(id);
      }
      for(var ch in children){
        allUnexpanded(ch);
      }
      // widget.onExpandedFlagChanged?.call(expandedFlags);
    }

  }

  Widget buildANode( ListNode n, int index ){
    var nodeData = n.data;
    int iLevel = n.level;
    bool withChild = n.withChild;
    double offsetX = iLevel * widget.indent;
    var id = widget.onGetID?.call(nodeData);

    bool expanded = expandedFlags.containsKey(id);
    if (widget.defaultExpanded){
      expanded = !expanded;
    }
    if (_filters!= null && _filters.length>0) expanded = true;
    var itm = widget.onBuildItem?.call(nodeData , expanded , _highlightPattern);
    // var w = widget.onBuildItem?.call(nodeData , expanded);
    // Expanded(child : w),
    // var tagTarget ;
    // bool useDT = false;
    // if (useDT && nodeData.isLeaf) {
    //   var te = Draggable(
    //     child: itm,
    //     feedback: Material(child: itm),
    //     childWhenDragging: Opacity(child: itm, opacity: 0.5),
    //     data: nodeData,
    //   );
    //
    //   tagTarget = DragTarget<dynamic>(
    //     builder: (p1, p2, p3) {
    //       return te;
    //     },
    //     onWillAccept: (e) => e.path == nodeData.path && e != nodeData,
    //     onAcceptWithDetails: (e) {
    //       setState(() {});
    //     },
    //   );
    // }

    var row = Row(
      children: [
        SizedBox(width: offsetX,),
        Expanded(child : itm),
        // w,
        // useDT && nodeData.isLeaf?tagTarget:Expanded(child : itm),
        // tagTarget,
        if (withChild) Container(

          height: 26,
          width: 26,
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(!expanded?MaterialCommunityIcons.chevron_down : MaterialCommunityIcons.chevron_up),
            iconSize: 26,
            color: !expanded?Colors.grey : widget.expandButtonColor,
            onPressed: (){
              setState(() {
                if (expandedFlags.containsKey(id)) {
                  expandedFlags.remove(id);
                }
                else {
                  expandedFlags[id] = true;
                }

                widget.onExpandedFlagChanged?.call(expandedFlags);
              });

            },
          ),
        )
      ],
    );
    // nodes.add(Container(
    //   color : _selectItem == nodeData? ThemeCenter.systemTheme.primaryColorDark:null,
    //   child: row,
    // ));
    var clr = index%2==0?null:widget.intervalColor;
    var con = Container(
      decoration: BoxDecoration(
          color : withChild?(widget.dirBgColor??ThemeCenter.systemTheme.scaffoldBackgroundColor):clr,
          border : Border(
            bottom: BorderSide(width: 1.0,color: CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(1) ,0.04)),
          )),
      // color : widget.selectedItem == nodeData? ThemeCenter.systemTheme.primaryColorDark:ThemeCenter.systemTheme.scaffoldBackgroundColor,
      child: row,
    );

    var ink = GestureDetector(
      child: con,
      onDoubleTap: withChild?(){
        setState(() {
          if (expandedFlags.containsKey(id)) {
            expandedFlags.remove(id);
          }
          else {
            expandedFlags[id] = true;
          }

          widget.onExpandedFlagChanged?.call(expandedFlags);
        });
      }:null,
      onTap: () {
        widget.onItemTap?.call(nodeData);
        // if (_selectItem != nodeData){
        //   setState(() {
        //     _selectItem = nodeData;
        //   });
        // }

      },
    );
    bool bIsSkipRoot = false;
    if (nodeData == widget.root && widget.hideRoot){
      //do nothing
      return null;//bIsSkipRoot = true;
    }
    else {
      return ink;//nodes.add(ink);
    }
  }


  void buildNode( dynamic nodeData ,  List<Widget> nodes , int iLevel){

    if (_filterCache[nodeData] == null) return ;



    var children = widget.onGetChildren?.call(nodeData);
    bool withChild = (children != null && children.length>0);
    double offsetX = iLevel * widget.indent;
    var id = widget.onGetID?.call(nodeData);

    bool expanded = !expandedFlags.containsKey(id);
    var w = widget.onBuildItem?.call(nodeData , expanded , _highlightPattern);

    var row = Row(
      children: [
        SizedBox(width: offsetX,),
        Expanded(child : w),
        if (withChild) Container(
          height: 26,
          width: 26,
          child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(!expanded?MaterialCommunityIcons.chevron_down : MaterialCommunityIcons.chevron_up),
            iconSize: 26,
            color: !expanded?Colors.grey : widget.expandButtonColor,
            onPressed: (){
              setState(() {
                if (expandedFlags.containsKey(id)) {
                  expandedFlags.remove(id);
                }
                else {
                  expandedFlags[id] = true;
                }

                widget.onExpandedFlagChanged?.call(expandedFlags);
              });

            },
          ),
        )
      ],
    );
    // nodes.add(Container(
    //   color : _selectItem == nodeData? ThemeCenter.systemTheme.primaryColorDark:null,
    //   child: row,
    // ));

    var con = Container(
      decoration: BoxDecoration(
          color : withChild?(widget.dirBgColor??ThemeCenter.systemTheme.scaffoldBackgroundColor):ThemeCenter.systemTheme.scaffoldBackgroundColor,
          border : Border(
            bottom: BorderSide(width: 0.5,color: CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(1) ,0.04)),
          )),
      // color : widget.selectedItem == nodeData? ThemeCenter.systemTheme.primaryColorDark:ThemeCenter.systemTheme.scaffoldBackgroundColor,
      child: row,
    );

    var ink = GestureDetector(
      child: con,
      onTap: () {
        widget.onItemTap?.call(nodeData);
        // if (_selectItem != nodeData){
        //   setState(() {
        //     _selectItem = nodeData;
        //   });
        // }

      },
    );
    bool bIsSkipRoot = false;
    if (nodeData == widget.root && widget.hideRoot){
      //do nothing
      bIsSkipRoot = true;
    }
    else {
      nodes.add(ink);
    }
    // var children = widget.onGetChildren?.call(nodeData);
    if (withChild && expanded){
      if (widget.reverse){
        for(var i = children.length - 1 ; i >=0 ; --i){
          var c = children[i];
          buildNode(c, nodes, iLevel + (bIsSkipRoot?0:1));
        }
      }
      else {
        for (var c in children) {
          buildNode(c, nodes, iLevel + (bIsSkipRoot?0:1));
        }
      }
    }
    // for(var c in )
    // return row;
  }

  void updateFilter(){
    _filterCache.clear();
    bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
    _filters = withFilter?_filterStr.toLowerCase().split(RegExp(r"\s+")):null;

    doCacheFilter(widget.root , _filters);
    _highlightPattern = null;
    if (_filters!= null && _filters.length>0){
      StringBuffer sb = StringBuffer();
      sb.write("");
      for(int i = 0 ; i < _filters.length ; ++i){
        var astr = RegExp.escape(_filters[i].toLowerCase());
        // var astr = _filters[i].toLowerCase().replaceAll("{", "\{").replaceAll("}", "\}").replaceAll("[", "\[").replaceAll("]", "\]").replaceAll("\\", "\\\\");
        sb.write("$astr${i<_filters.length-1?"|":""}");
      }
      sb.write("");
      _highlightPattern = sb.toString();
    }
    if(widget.sortTypes != null && widget.sortTypes.length > 0 )
      _selectSortType = widget.sortTypes[widget.sortTypeIndex];

    widget.onFilterChanged?.call(_filterCache.keys.toList());

  }
  String _selectSortType;
  String _highlightPattern ;
  List<String> _filters;
  List<ListNode> lstNodes = List<ListNode>();
  Widget buildTreeView(){
    updateFilter();
    // List<Widget> ws = List<Widget>();
    // buildNode(widget.root , ws , 0);
    lstNodes.clear();
    buildNodeList(widget.root ,lstNodes,0);
    // print("node count : ${lstNodes.length}");

    // var lv2 = widget.useListView? SingleChildScrollView(
    //   physics: BouncingScrollPhysics(),
    //   // shrinkWrap: false,
    //   padding: EdgeInsets.all(0),
    //   child: Column(children: ws,),
    // ):
    // Column(children: ws,);
    // var splv = ListView.builder(
    //     controller: _semicircleController,
    //     cacheExtent: 500,
    //     itemCount: lstNodes.length,
    //     itemBuilder: (c, i) => FrameSeparateWidget(
    //       index: i,
    //       placeHolder: Container(
    //         // color: i % 2 == 0 ? Colors.red : Colors.blue,
    //         height: 40,
    //       ),
    //       child: buildANode(lstNodes[i] , i),
    //     ),
    // );
    // var lv2 = splv;
    // var lv2 = DraggableScrollbar.rrect(
    //
    //     backgroundColor: CommonUtil.alphaColor(Colors.grey, 100),
    //     alwaysVisibleScrollThumb: true,
    //     heightScrollThumb: 48,
    //     controller: _semicircleController,
    //
    //   child:ListView.builder(
    //     itemExtent: widget.itemExtent,
    //     // cacheExtent: 500,
    //     controller: _semicircleController,
    //     itemBuilder: (context , index){
    //       return buildANode(lstNodes[index] , index);
    //     },
    //     itemCount: lstNodes.length,
    //     // itemExtent: widget.it,
    //     scrollDirection: Axis.vertical,
    //   )
    //   //   child:splv,
    // ) ;

    var finalList = ListView.builder(
      // dragStartBehavior: DragStartBehavior.start,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          itemExtent: widget.itemExtent,
          // cacheExtent: 500,
          controller: _semicircleController,
          itemBuilder: (context , index){
            var itm = buildANode(lstNodes[index] , index);
            if (!(widget.separateFrame??false)){
              return itm;
            }
            // return itm;
            return FrameSeparateWidget(
              index: index,
              placeHolder: Container(
                color:index%2==0?null:widget.intervalColor,
                // child: Center(child:Text("...")),
                // decoration: dc,
                height: widget.itemExtent,
              ),
              child: itm,
            );
          },
          itemCount: lstNodes.length,
          // itemExtent: widget.it,
          scrollDirection: Axis.vertical,
        );
    var lv2 = Scrollbar(

        controller: _semicircleController,
        thumbVisibility: true,
        // isAlwaysShown: true,
        // trackVisibility:true,
        child:finalList
    );
    var filter = Row(
      children: [
        Icon(Icons.search , size: 20, color: ThemeCenter.mainTextStepColor(6),),
        Expanded(
          child: TextEditor(

            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
            ),
            textStyle: ThemeCenter.mainTextStyle(step: 6 , fontSize: 13),
            initValue: _filterStr,
            
            onChanged: (v) {
              setState(() {
                _filterStr = v;//.toLowerCase();
                widget.onFilterStringChanged?.call(_filterStr);
                // updateFilter();
              }
              );
            },
          ),
        ),
        if (!DartCommon.isEmpty(_filterStr)) Container(
          height: 20,
          width: 22,
          child: ThemeCenter.iconBtn(Icons.clear,
            // padding: EdgeInsets.all(0),
            // icon: Icon(Icons.clear),
            tooltip: "清除",
            // iconSize: 18,
            width: 20,height:20,
            color: Colors.redAccent,
            onPressed: (){
              setState(() {
                _filterStr = "";
                widget.onFilterStringChanged?.call(_filterStr);
              });
            },
          ),
        ),
        const SizedBox(width: 4,),
        if(widget.withExpandedButton)ThemeCenter.iconBtn(MaterialCommunityIcons.folder_open_outline,
          // padding: EdgeInsets.all(0),
          // icon: Icon(MaterialCommunityIcons.folder_open_outline),
          // iconSize: 18,
          width: 20,height:20,
          color: ThemeCenter.mainTextStepColor(6),
          tooltip: "全部展开",
          onPressed: (){
            setState(() {
              allExpanded(widget.root);
              widget.onExpandedFlagChanged?.call(expandedFlags);
            });
          },
        ),
        const SizedBox(width: 4,),
        if (widget.withExpandedButton)ThemeCenter.iconBtn(MaterialCommunityIcons.folder,
          // padding: EdgeInsets.all(0),
          // icon: Icon(MaterialCommunityIcons.folder),
          // iconSize: 18,
          width: 20,height:20,
          tooltip: "全部合拢",
          color: ThemeCenter.mainTextStepColor(6),
          onPressed: (){
            setState(() {
              allUnexpanded(widget.root);
              widget.onExpandedFlagChanged?.call(expandedFlags);
            });
          },
        ),
        const SizedBox(width: 4,),
        if (widget.onSortClicked != null)ThemeCenter.iconBtn(MaterialCommunityIcons.sort,
          width: 20,height:20,
          tooltip: widget.sortTip,
          color: ThemeCenter.mainTextStepColor(6),
          onPressed: (){
            setState(() {
              widget.onSortClicked();
            });
          },
        ),

        const SizedBox(width: 4,),
        if(widget.sortTypes != null && widget.sortTypes.length > 0)
           Container(
            width: 20,
            height:20,
            child: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              itemBuilder: (context) {
                List<PopupMenuEntry<int>> items = [];
                for(int i = 0; i < widget.sortTypes.length; i++){
                  items.add(PopupMenuItem(child: Text(widget.sortTypes[i]), value: i));
                }
                return items;
              },
              initialValue: widget.sortTypeIndex,
              onSelected: (index){
                 widget.onSortTypeClicked?.call(index, widget.sortTypes);
              },
              tooltip: "筛选类型 : " + _selectSortType,
              icon: Icon(MaterialCommunityIcons.dropbox , size: 20,color: ThemeCenter.mainTextStepColor(6)),
            ),
        ),

        // ThemeCenter.iconBtn(MaterialCommunityIcons.dropbox,
        //   width: 20,height:20,
        //   tooltip: "筛选类型 : " + _selectSortType,
        //   color: ThemeCenter.mainTextStepColor(6),
        //   onPressed: (){
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text("筛选类型选择"),
        //         content: DropdownButton<String>(
        //           value: _selectSortType,
        //           onChanged: (newValue) {
        //             setState(() {
        //               var index =  widget.sortTypes.indexOf(newValue);
        //               if(index !=  widget.sortTypeIndex)
        //               {
        //                 widget.sortTypeIndex =index;
        //                 _selectSortType = newValue;
        //                 widget.onSortTypeClicked?.call(index, widget.sortTypes);
        //               }
                  
        //               Navigator.of(context).pop();
        //             });
        //           },
        //           items: widget.sortTypes.map<DropdownMenuItem<String>>((String value) {
        //             return DropdownMenuItem<String>(
        //               value: value,
        //               child: Text(value),
        //             );
        //           }).toList(),
        //         ),
        //       );
        //     },
        //   );
        //   },
        // )
        
      ],
    );
    var fcon = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, color: ThemeCenter.mainTextStepColor(1), width: 1.9),
        ),
      ),
      child: filter,
    );

    var con = Container(
        // width: widget.itemBaseWidth != null?widget.itemBaseWidth + maxLevel * widget.indent:null,
        padding: widget.padding??EdgeInsets.all(4),
        decoration: widget.decoration,
        child:Column(
          children: [
            Visibility(
              visible: widget.onFilter != null,
              child: fcon,
            ),
            Visibility(
              visible: widget.onFilter != null,
              child: SizedBox(height: 4,),
            ),
            // widget.useListView?Expanded(child: lv2,):lv2,
            Expanded(child: lv2,),
            Visibility(
              visible: widget.actions != null && widget.actions.length>0,
              child: SizedBox(height: 4,),
            ),
            Visibility(
              visible: widget.actions != null && widget.actions.length>0,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    top: Divider.createBorderSide(context, color:ThemeCenter.mainTextStepColor(1), width: 1.9),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.actions??[],
                ),
              ),
            ),
          ],
        )
    );

    if (widget.initPosition != null){
      SchedulerBinding.instance.addPostFrameCallback((_) { //build完成后的回调
        _semicircleController.jumpTo(widget.initPosition);
      });
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   _semicircleController.jumpTo(widget.initPosition);
      // });
      // SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      //   _semicircleController.jumpTo(widget.initPosition);
      // });
    }


    if (widget.itemBaseWidth == null) return con;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: con,
    );
  }

  // Widget buildTreeView(){
  //
  //   List<Widget> ws = List<Widget>();
  //
  //   TreeNode.onBuild = (item) {
  //     double offsetX = item.level * widget.indent;
  //     if (item is TreeDir) {
  //       if (widget.defaultExpanded) {
  //         item.isExpand = !expandedFlags.containsKey(item.id);
  //       }
  //       else{
  //         item.isExpand = expandedFlags.containsKey(item.id);
  //       }
  //       var adir = widget.onBuildDir(item.name, item);
  //       var r = Row(
  //         children: [
  //           SizedBox(width: offsetX,),
  //           Expanded(child: adir),
  //         ],
  //       );
  //
  //       var ink = GestureDetector(
  //         child: r,
  //         onTap: () {
  //           setState(() {
  //             if (widget.defaultExpanded) {
  //               if (item.isExpand) {
  //                 expandedFlags[item.id] = true;
  //               }
  //               else {
  //                 expandedFlags.remove(item.id);
  //               }
  //             }
  //             else{
  //               if (item.isExpand) {
  //                 expandedFlags.remove(item.id);
  //               }
  //               else {
  //                 expandedFlags[item.id] = true;
  //               }
  //             }
  //
  //             widget.onExpandedFlagChanged?.call(expandedFlags);
  //           });
  //         },
  //       );
  //
  //       ws.add(ink);
  //     }
  //     else{
  //       double offsetX = item.level * widget.indent;
  //       var aleap = widget.onBuildItem(item.item, item);
  //       var r = Row(
  //         children: [
  //           SizedBox(width: offsetX,),
  //           Expanded(child : aleap),
  //         ],
  //       );
  //       if (widget.onItemTap == null) {
  //         ws.add(r);
  //         return ;
  //       }
  //
  //       var ink = GestureDetector(
  //         child: r,
  //         onTap: () {
  //           setState(() {
  //             widget.onItemTap(item.item);
  //           });
  //         },
  //       );
  //
  //       ws.add(ink);
  //     }
  //
  //   };
  //   bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
  //   _root.buildWidget(expandedFlags, defaultExpanded : widget.defaultExpanded , ignoreSelf: true , onSort: widget.onSort , withFilter : withFilter);
  //
  //
  //   var lv2 = widget.useListView?ListView(
  //     shrinkWrap: false,
  //     padding: EdgeInsets.all(0),
  //     children: ws,
  //   ):
  //   Column(children: ws,);
  //
  //   var filter = Row(
  //     children: [
  //       Icon(Icons.search , size: 20, color: Colors.black,),
  //       Expanded(
  //         child: TextEditor(
  //           decoration: InputDecoration(
  //             isDense: true,
  //             border: InputBorder.none,
  //           ),
  //           initValue: _filterStr,
  //           onChanged: (v) {
  //             setState(() {
  //               _filterStr = v;//.toLowerCase();
  //             }
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  //   var fcon = Container(
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: Divider.createBorderSide(context, color: CommonUtil.scaleColor(Colors.grey , 0.6), width: 1.9),
  //       ),
  //     ),
  //     child: filter,
  //   );
  //
  //   var con = Container(
  //       width: widget.itemBaseWidth != null?widget.itemBaseWidth + maxLevel * widget.indent:null,
  //       padding: widget.padding??EdgeInsets.all(4),
  //       decoration: widget.decoration,
  //       child:Column(
  //         children: [
  //           Visibility(
  //             visible: widget.onFilter != null,
  //             child: fcon,
  //           ),
  //           Visibility(
  //             visible: widget.onFilter != null,
  //             child: SizedBox(height: 4,),
  //           ),
  //           widget.useListView?Expanded(child: lv2,):lv2,
  //           Visibility(
  //             visible: widget.actions != null,
  //             child: SizedBox(height: 4,),
  //           ),
  //           Visibility(
  //             visible: widget.actions != null,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 border: Border(
  //                   top: Divider.createBorderSide(context, color: CommonUtil.scaleColor(Colors.grey , 0.6), width: 1.9),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: widget.actions??[],
  //               ),
  //             ),
  //           ),
  //         ],
  //       )
  //   );
  //   if (widget.itemBaseWidth == null) return con;
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: con,
  //   );
  // }
  Levenshtein d = new Levenshtein();
  Map<dynamic , int> _filterCache = Map<dynamic , int>();
  void doCacheFilter(dynamic item , List<String> fs){
    bool bingo = false;
    var children = widget.onGetChildren?.call(item);
    if (children != null && children.length>0){

      for(var c in children){
        doCacheFilter(c , fs);
        if (_filterCache[c] != null){
          bingo = true;
        }
      }
    }

    if (bingo) {
      if (fs == null || fs.length <=0) {
        _filterCache[item] = 1;
        return;
      }
      var dis = 102400000;
      if (doAFilter(item.id.toString() , fs,item)) d.distance(item.id.toString(), _filterStr);
      // _filterCache[item] = dis;
      for(var c in children){
        if (_filterCache[c] != null){
          dis = min(dis , _filterCache[c]);
        }
      }
      _filterCache[item] = dis;
      // // if (doAFilter(item.id , fs)) {
      //   var dis = d.distance(item.id, _filterStr);
      //   _filterCache[item] = dis;
      // // }
      // // else{
      // //   _filterCache[item] = 10240000000;
      // // }

      return;
    }

      if (fs == null || fs.length <=0) {
        _filterCache[item] = 1;
        return;
      }

    var str = widget.onFilter(item).toLowerCase();
    if (doAFilter(str , fs, item)){
      var dis = d.distance(str, _filterStr);
      _filterCache[item] = 20000 + dis;
      // print(_filterCache);
      return;
    }
    // for(var s in fs){
    //   if (s.trim() == "") continue;
    //   if (str.indexOf(s) >= 0){
    //     var dis = d.distance(str, _filterStr);
    //     _filterCache[item] = 20000 + dis;
    //     // print(_filterCache);
    //     return;
    //   }
    // }
  }

  bool doAFilter(String str , List<String> fs, dynamic data){
    if(widget.doAFilterOverride != null){
      return widget.doAFilterOverride.call(str, fs, data);
    }
    for(var s in fs){
      if (s.trim() == "") continue;
      if (str.indexOf(s) >= 0){
        return true;
      }
    }
    return false;
  }

  // bool doFilter(item , List<String> fs){
  //   if (fs == null || fs.length <=0) return true;
  //   var str = widget.onFilter(item).toLowerCase();
  //
  //   for(var s in fs){
  //     if (s.trim() == "") continue;
  //     if (str.indexOf(s) < 0){
  //       // print("$str $s");
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  // TreeDir _root;
  // int maxLevel = 1;
  // void buildTree(){
  //   _root = TreeDir();
  //
  //   bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
  //   var filters = withFilter?_filterStr.toLowerCase().split(RegExp(r"\s+")):[];
  //   // print(filters);
  //   var items = widget.items;
  //   // print(items);
  //   List<dynamic> lst = List<dynamic>();
  //   maxLevel = 0;
  //   for(var item in items) {
  //     // print(item);
  //     if (withFilter && !doFilter(item , filters)) continue;
  //     List<String> path = widget.onGetTreePath?.call(item);
  //     lst.add(item);
  //     if (path == null || path.length<=0){
  //       path = [];
  //     }
  //     // print(path);
  //     var tgtPath = _root;
  //     var fullPath = "";
  //     int iLevelCount = 0;
  //     for(int i = 0 ; i < path.length ; ++i){
  //       var dir  = path [i].trim();
  //
  //       if (dir.trim() == ""){
  //         // print(dir);
  //         continue;
  //       }
  //       // print(dir);
  //       fullPath = "$fullPath/$dir";
  //       var subDir = tgtPath.subDirs[dir];
  //       // print(subDir);
  //
  //       if (subDir == null){
  //         // print(fullPath);
  //         subDir = TreeDir()..name = dir .. id =fullPath ;
  //         // tgtPath.subDirs[dir] = subDir;
  //         tgtPath.subDirs[dir] = subDir;
  //         // print("add $dir");
  //       }
  //
  //
  //       tgtPath = subDir..level = iLevelCount++;
  //     }
  //
  //     tgtPath.subFiles.add(TreeLeaf()..item = item..level = iLevelCount++);
  //     maxLevel = max(maxLevel , iLevelCount);
  //     // print("add leaf $item");
  //   }
  //
  //   widget.onSelectedChanged?.call(lst);
  // }
}