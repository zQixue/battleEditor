import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class TreeSelector extends StatefulWidget {
  final List<dynamic> datas;
  final bool Function(dynamic)? onCheckSelected;
  final void Function(dynamic)? onChanged;
  final List<String> Function(dynamic) onGetGroup;
  final Widget Function(dynamic)? onItemBuilder;
  final Widget Function(ATreeNode<dynamic>)? onGroupBuilder;
  final String Function(dynamic)? onGetFilter;
  final double size;
  final IconData iconData;
  final void Function()? onClear;
  final List<Widget>? actions;
  TreeSelector({Key? key,
    required this.datas,
    this.onCheckSelected,
    this.onChanged,
    required this.onGetGroup,
    this.onItemBuilder,
    this.onGroupBuilder,
    this.onClear,
    this.size = 18,
    this.iconData = Icons.menu,
    this.onGetFilter,
    this.actions,
  }) : super(key: key);

  @override
  _TreeSelectorState createState() => _TreeSelectorState();
}

class _TreeSelectorState extends State<TreeSelector> {
  @override
  Widget build(BuildContext context) {
    return ThemeCenter.iconBtn(widget.iconData ,
        width: widget.size,
        height: widget.size,
        onPressed: (){
          showDialog(
            context: context,
            barrierColor:Colors.black87,
            // barrierDismissible: false,
            builder: (BuildContext context) {
              // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
              return Dialog(child: Container(
                color:  Color(0xff2f2f2f),
                width: 400,
                height: 800,
                child: getSearchBox(),
              ), );
            },
          );
        }
    );
  }

  Widget getSearchBox(){

    ATreeNode<dynamic> _compRoot = DartCommon.buildTree<dynamic>(widget.datas, widget.onGetGroup);

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<dynamic>).id;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<dynamic>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent).data;

          bool selected = widget.onCheckSelected?.call(si)??false;//  widget.initialValue?.indexOf(si.guid)==0;//(_selectedStrings[si.guid] != null);

          var tagEdt = widget.onItemBuilder?.call(si) ?? Text(si.toString());//  si.getTypeShowWidget();
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : null,

              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      SizedBox(width : 4),
                      Expanded(child : tagEdt),
                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            padding: EdgeInsets.all(1),
            child: InkWell(
              child: con,
              onTap: (){
                if (si != null ) {
                  widget.onChanged?.call(si);
                  // controller?.hideMenu();
                  Navigator.pop(context, si);
                }
              },
            ),
          );
          // var te = Draggable(
          //   child: con,
          //   feedback: Material(child:con),
          //   childWhenDragging: con,
          //   data: si,
          // );

          return con;
        }
        else{
          if (widget.onGroupBuilder!= null){
            return widget.onGroupBuilder?.call(agent);
          }
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
          var con = widget.onItemBuilder?.call(agent) ??  Container(
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
        return (node as ATreeNode<dynamic>).children;
      },
      onFilter: (node){
        // if (widget.onFilter != null){
        //   var ns  = node as ATreeNode<SSFieldType>;
        //   return widget.onFilter(ns);
        // }

        var ns  = node as ATreeNode<dynamic>;
        if (ns != null) {
          // if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          if (widget.onGetFilter != null){
            return widget.onGetFilter?.call(n);
          }
        }

        return "";
      },

      // onSortLeaf: (a,b){
      //   return (a as ATreeNode<AObject>).data.name.compareTo((b as ATreeNode<AObject>).data.name);
      // },

      onItemTap: (item){
        // var a = item as ATreeNode<AObject>;
        // if (a != null && a.data != null) {
        //   widget.onChanged?.call(a.data.guid);
        //   Navigator.pop(context, a.data.guid);
        // }
      },

      actions: [
        if (widget.actions != null) ...widget.actions!,
        // SSDefines.IBC(child :IconButton(
        //   padding: EdgeInsets.all(0),
        //   icon : Icon(MaterialCommunityIcons.close_box_outline , color: Colors.redAccent,),
        //   iconSize: SSDefines.iconButtonSize,
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        //   tooltip: "关闭",
        // ))
        if (widget.onClear != null) ElevatedButton(onPressed:(){
          widget.onClear?.call();
          Navigator.pop(context);
        } , child: Text("清空")),
        if (widget.onClear != null) const SizedBox(width: 4,),
        ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text("关闭")),
        // ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline, color: Colors.redAccent,
        //   width: 24,height :24,
        //   onPressed: (){
        //     Navigator.pop(context);
        //     // controller?.hideMenu();
        //   },
        //   tooltip: "关闭",
        // ),
      ],
    );

    return con;
  }
}