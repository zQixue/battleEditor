//@dart=2.11
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';

typedef Widget FunctionBuildItemCallback(dynamic value ,  nd);
typedef Widget FunctionBuildDirCallback(String dirName ,  nd);
typedef String FunctionFilterCallback(dynamic value);
typedef List<String> FunctionGetTreePathCallback(dynamic value);
typedef void ItemTapCallback(dynamic item);
typedef void SelectedChanged(dynamic items);
typedef int ItemSortCallback(dynamic a,dynamic b);
typedef void ExpanadedFlagChanged(Map<String , bool> value);

class SearchableTreeView extends StatefulWidget {
  final FunctionBuildItemCallback onBuildItem;
  final FunctionBuildDirCallback onBuildDir;
  final FunctionFilterCallback onFilter;
  final FunctionGetTreePathCallback onGetTreePath;
  final List items;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final double indent;
  final double itemBaseWidth;
  final List<Widget> actions;
  final ItemTapCallback onItemTap;
  final ItemSortCallback onSort;
  final Map<String , bool> expandedFlags;//叶子结点是否打开的属性
  final bool defaultExpanded;
  final ExpanadedFlagChanged onExpandedFlagChanged;
  final SelectedChanged onSelectedChanged;
  final bool useListView;
  SearchableTreeView({Key key , this.useListView = true,this.onExpandedFlagChanged , this.onSelectedChanged ,this.onSort,this.defaultExpanded = true, this.expandedFlags, this.onItemTap , this.actions , this.indent = 16.0,this.onBuildItem , this.onBuildDir, this.onFilter , this.onGetTreePath , this.items , this.decoration , this.padding , this.itemBaseWidth}) : super(key: key);

  @override
  _SearchableTreeViewState createState() => _SearchableTreeViewState();
}

class TreeNode {
  String id ;
  Map<String , TreeNode> subDirs = Map<String , TreeNode>();
  List<TreeNode> subFiles = List<TreeNode>();
  int level=0;
  static dynamic onBuild;

  void buildWidget(Map<String , bool> expandedFlags,{bool ignoreSelf = false , ItemSortCallback onSort, bool defaultExpanded, bool withFilter}){
    if (!ignoreSelf) {
      onBuild(this);
    }
    bool ef = expandedFlags==null?false : expandedFlags[id]??false;
    // bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
    if (!withFilter) {
      if (!ignoreSelf && ((defaultExpanded && ef) || (!defaultExpanded && !ef))) return;
    }
    var values = subDirs.values.toList();
    values.sort((a,b)=>(a as TreeDir).name.compareTo((b as TreeDir).name));
    for(var s in values){
      s.buildWidget(expandedFlags ,defaultExpanded:defaultExpanded, onSort:onSort , withFilter  :withFilter);
    }
    // subFiles.sort((a,b)=>((a as TreeLeaf).item as ScriptInfo). .compareTo((b as TreeDir).name));
    if (onSort != null){
      subFiles.sort((a,b)=>onSort((a as TreeLeaf).item,(b as TreeLeaf).item));
    }
    for(var s in subFiles){
      s.buildWidget(expandedFlags ,defaultExpanded:defaultExpanded, onSort:onSort,withFilter  :withFilter);
    }
  }
}

class TreeDir extends TreeNode{
  String name ;

  bool isExpand;
  // @override
  // Widget onBuildWidget(SearchableTreeView widget , _SearchableTreeViewState state , Map<String , bool> isUnexpandeds ,List<Widget> lst ) {
  //   var item = this;
  //   double offsetX = item.level * 16.0;
  //   // if (item is TreeDir) {
  //     item.isExpand = !isUnexpandeds.containsKey(id);
  //     var adir = widget.onBuildDir(item.name, item);
  //     var r = Row(
  //       children: [
  //         SizedBox(width: offsetX,),
  //         Expanded(child: adir),
  //         // item.isExpand?Icon(MaterialIcons.expand_less):Icon(MaterialIcons.expand_more)
  //         // Visibility(
  //         //   visible: item.isExpand,
  //         //   child: Icon(MaterialIcons.expand_less),
  //         // )
  //       ],
  //     );
  //
  //     return InkWell(
  //       child: r,
  //       onTap: (){
  //         state.setState(() {
  //           if (item.isExpand){
  //             isUnexpandeds.remove(id);
  //
  //           }
  //           else{
  //             isUnexpandeds[id] = true;
  //           }
  //         });
  //
  //       },
  //     );
  //   }
  // // }
}

class TreeLeaf extends TreeNode{
  dynamic item ;

  // @override
  // Widget onBuildWidget(SearchableTreeView widget , _SearchableTreeViewState state , Map<String , bool> isUnexpandeds ,List<Widget> lst) {
  //   var item = this;
  //   double offsetX = item.level * 16.0;
  //   var aleap = widget.onBuildItem(item.item, item);
  //   return Row(
  //     children: [
  //       SizedBox(width: offsetX,),
  //       Expanded(child : aleap),
  //     ],
  //   );
  // }
}

class _SearchableTreeViewState extends State<SearchableTreeView> {
  // TreeViewController _controller;

  String _filterStr;
  @override
  void initState() {
    // TODO: implement initState
    expandedFlags = widget.expandedFlags??Map<String , bool>();
    super.initState();
    // _controller = TreeViewController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    buildTree();
    return buildTreeView();
  }
  Map<String , bool> expandedFlags ;//= Map<String , bool>();



  Widget buildTreeView(){

    List<Widget> ws = List<Widget>();

    TreeNode.onBuild = (item) {
      double offsetX = item.level * widget.indent;
      if (item is TreeDir) {
        if (widget.defaultExpanded) {
          item.isExpand = !expandedFlags.containsKey(item.id);
        }
        else{
          item.isExpand = expandedFlags.containsKey(item.id);
        }
        var adir = widget.onBuildDir(item.name, item);
        var r = Row(
          children: [
            SizedBox(width: offsetX,),
            Expanded(child: adir),
          ],
        );

        var ink = GestureDetector(
          child: r,
          onTap: () {
            setState(() {
              if (widget.defaultExpanded) {
                if (item.isExpand) {
                  expandedFlags[item.id] = true;
                }
                else {
                  expandedFlags.remove(item.id);
                }
              }
              else{
                if (item.isExpand) {
                  expandedFlags.remove(item.id);
                }
                else {
                  expandedFlags[item.id] = true;
                }
              }

              widget.onExpandedFlagChanged?.call(expandedFlags);
            });
          },
        );

        ws.add(ink);
      }
      else{
        double offsetX = item.level * widget.indent;
        var aleap = widget.onBuildItem(item.item, item);
        var r = Row(
          children: [
            SizedBox(width: offsetX,),
            Expanded(child : aleap),
          ],
        );
        if (widget.onItemTap == null) {
          ws.add(r);
          return ;
        }

        var ink = GestureDetector(
          child: r,
          onTap: () {
            setState(() {
              widget.onItemTap(item.item);
            });
          },
        );

        ws.add(ink);
      }

    };
    bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
    _root.buildWidget(expandedFlags, defaultExpanded : widget.defaultExpanded , ignoreSelf: true , onSort: widget.onSort , withFilter : withFilter);


    var lv2 = widget.useListView?ListView(

      shrinkWrap: false,
      padding: EdgeInsets.all(0),
      children: ws,
    ):
    Column(children: ws,);

    var filter = Row(
      children: [
        Icon(Icons.search , size: 20, color: ThemeCenter.mainTextStepColor(6),),
        Expanded(
          child: TextEditor(
            decoration: InputDecoration(
                isDense: true,
              border: InputBorder.none,
            ),
            initValue: _filterStr,
            onChanged: (v) {
              setState(() {
               _filterStr = v;//.toLowerCase();
              }
              );
            },
          ),
        ),
      ],
    );
    var fcon = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, color: ThemeCenter.mainTextStepColor(2), width: 1.0),
        ),
      ),
      child: filter,
    );

    var con = Container(
      width: widget.itemBaseWidth != null?widget.itemBaseWidth + maxLevel * widget.indent:null,
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
          widget.useListView?Expanded(child: lv2,):lv2,
          Visibility(
            visible: widget.actions != null,
            child: SizedBox(height: 4,),
          ),
          Visibility(
            visible: widget.actions != null,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: Divider.createBorderSide(context, color: ThemeCenter.mainTextStepColor(2), width: 1.0),
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
    if (widget.itemBaseWidth == null) return con;



    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: con,
    );

    // return Scrollbar(
    //     thumbVisibility: true,
    //     trackVisibility:true,
    //     child:scv
    // );
  }


  bool doFilter(item , List<String> fs){
    if (fs == null || fs.length <=0) return true;
    var str = widget.onFilter(item).toLowerCase();

    for(var s in fs){
      if (s.trim() == "") continue;
      if (str.indexOf(s) < 0){
        // print("$str $s");
        return false;
      }
    }
    return true;
  }

  TreeDir _root;
  int maxLevel = 1;
  void buildTree(){
    _root = TreeDir();

    bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
    var filters = withFilter?_filterStr.toLowerCase().split(RegExp(r"\s+")):[];
    // print(filters);
    var items = widget.items;
    // print(items);
    List<dynamic> lst = List<dynamic>();
    maxLevel = 0;
    for(var item in items) {
      // print(item);
      if (withFilter && !doFilter(item , filters)) continue;
      List<String> path = widget.onGetTreePath?.call(item);
      lst.add(item);
      if (path == null || path.length<=0){
        path = [];
      }
      // print(path);
      var tgtPath = _root;
      var fullPath = "";
      int iLevelCount = 0;
      for(int i = 0 ; i < path.length ; ++i){
        var dir  = path [i].trim();

        if (dir.trim() == ""){
          // print(dir);
          continue;
        }
        // print(dir);
        fullPath = "$fullPath/$dir";
        var subDir = tgtPath.subDirs[dir];
        // print(subDir);

        if (subDir == null){
          // print(fullPath);
          subDir = TreeDir()..name = dir .. id =fullPath ;
          // tgtPath.subDirs[dir] = subDir;
          tgtPath.subDirs[dir] = subDir;
          // print("add $dir");
        }


        tgtPath = subDir..level = iLevelCount++;
      }

      tgtPath.subFiles.add(TreeLeaf()..item = item..level = iLevelCount++);
      maxLevel = max(maxLevel , iLevelCount);
      // print("add leaf $item");
    }

    widget.onSelectedChanged?.call(lst);
  }
}