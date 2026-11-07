//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class PopupTreeMenu<T> extends StatefulWidget {
  final List<T> datas;
  final dynamic onBuidItem;
  final dynamic onBuidGroup;
  final dynamic onSelect;
  final String title;
  final List<Widget> actions;
  final bool selectButton ;
  PopupTreeMenu({
    Key key,
    this.datas,
    this.onBuidItem,
    this.onBuidGroup,
    this.title,
    this.actions,
    this.selectButton = true,
    this.onSelect,
  }) : super(key: key){
    // print("PopupTreeMenu-----");
  }

  @override
  _PopupTreeMenuState<T> createState() {
    // print("createState-----");
    return _PopupTreeMenuState<T>();
  }
}

class _PopupTreeMenuState<T> extends State<PopupTreeMenu<T>> {

  @override
  void initState() {
    // print("init-----");
    // _selected = null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // print("build-----");
    var con = getThemeStructTree();
    return con;
    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    //     var child = con;
    //     return Dialog(child: child);
    //   },
    // );
  }


  T _selected ;
  ATreeNode<T> _nodeRoot;
  // bool _nodeRootNR = false;
  ATreeNode<T> getNodeTreeRoot(){
    // if (_nodeRoot == null || _nodeRootNR){
      var scripts = widget.datas;//.where((element) => false == element.isModule).toList();
      _nodeRoot = DartCommon.buildTree(scripts, (item){
        var sp = item?.group?.split("/")??<String>[];
        return sp;
      });
    // }
    // _nodeRootNR = false;
    return _nodeRoot;
  }
  // void forceBuildTree(){
  //   // _nodeRootNR = true;
  // }

  Widget getThemeStructTree() {
    var con = SearchableThemeTreeView(
      defaultExpanded: true,
      indent: 16,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getNodeTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<T>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<T>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<T>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          var con = widget.onBuidItem?.call(si);
          return Container(
            color: _selected == si? CommonUtil.alphaColorD(Colors.greenAccent,0.1):null,
            padding: EdgeInsets.all(1),
            child: Row(
              children: [
                Expanded(child:con),
                if (widget.selectButton) ElevatedButton(
                  child: Text("选择"),
                  onPressed: (){
                    Navigator.pop(context , si);
                  },
                )
                // ThemeCenter.iconBtn(MaterialCommunityIcons.checkbox_marked_outline,
                //   tooltip: "选择",
                //   onPressed: (){
                //     Navigator.pop(context , si);
                //   }
                // )
              ],
            ),
          );
        }
        else{
          Widget con = widget.onBuidGroup?.call(nd , expanded);
          if(con == null){
            con = Row(
              children: [
                SizedBox(width: 4,),
                !expanded ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,color: Colors.blueAccent,),
                SizedBox(width: 4,),
                Text(nd.name , style: TextStyle( fontSize: 12 , color: expanded?Colors.white:Colors.grey), ),
              ],
            );
          }
          return Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
          // return txt;
        }
      },

      onFilter: (node){
        var ns  = node as ATreeNode<T>;
        if (ns != null) {
          var n = ns.data as dynamic;
          if (n == null) return "";
          return "${n.name??""}`${n.group??""}`${n.alias}??""";
        }
        return "";
      },


      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<T>).data;
          if (si != null) {
            _selected = si;
            widget.onSelect?.call(si);
            // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }
          // forceBuildTree();
        });

      },

      actions: widget.actions
    );
    var block = ThemeCenter.block (
      headTitle: widget.title??"",
      // width: 480,
      child: con,
    );
    return block;
  }

}