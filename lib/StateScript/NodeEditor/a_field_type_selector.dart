//@dart=2.11
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class AFieldTypeSelector extends StatefulWidget {
  final List<SSFieldType> types;
  // final FieldInfo field;
  final dynamic onChanged;
  final String initialValue;
  AFieldTypeSelector({Key key,
    this.types,
    // this.field,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _AFieldTypeSelectorState createState() => _AFieldTypeSelectorState();
}

class _AFieldTypeSelectorState extends State<AFieldTypeSelector> {

  CustomPopupMenuController controller;

  @override
  void initState() {
    controller = CustomPopupMenuController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var popMnu = CustomPopupMenu(
    //   controller: controller,
    //   child: Icon(MaterialCommunityIcons.palette,size: 20, color: Colors.deepPurpleAccent,),
    //   menuBuilder:   () {
    //     return ThemeCenter.area(
    //       // color:  Color(0xff2f2f2f),
    //       width: 300,
    //       height: 800,
    //       child: getSearchBox(),
    //     );
    //   },
    //   // verticalMargin : -,
    //   barrierColor: Color(0x3f000000),//Colors.transparent,
    //   pressType: PressType.singleClick,
    //   // horizontalMargin: -5,
    //   verticalMargin: 0,
    // );
    //
    // return popMnu;

    return ThemeCenter.iconBtn(Icons.menu ,
      width: 40,
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

    ATreeNode<SSFieldType> _compRoot = DartCommon.buildTree<SSFieldType>(widget.types, (item){
      var sp = ((item as SSFieldType)?.typeGroup??"").split("/");
      return sp;
    });

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<SSFieldType>).id;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<SSFieldType>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<SSFieldType>).data;

          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = widget.initialValue?.indexOf(si.guid)==0;//(_selectedStrings[si.guid] != null);
          // print("------- type select : ${widget.initialValue } ${si.guid}");
          // var txt = HoverCursor(
          //   cursor: Cursor.crosshair,
          //   child: Text(si.getTag(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)),
          // );
          // var txt = si.getTypeShowString();
          var tagEdt = si.getTypeShowWidget();
          // var tagEdt = highlightPattern == null?Text(txt, style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)) :
          // ParsedText(
          //   text: si.getTag(),
          //   style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12),
          //   parse: <MatchText>[
          //     MatchText(
          //       pattern: highlightPattern, // a custom pattern to match
          //       regexOptions: RegexOptions(
          //           multiLine : true,
          //           caseSensitive : false,
          //           unicode : true,
          //           dotAll : true
          //       ),
          //       style: TextStyle(
          //         color: Colors.redAccent,
          //         fontSize: 12,
          //       ), // custom style to be applied to this matched text
          //     )
          //   ],
          // );
          // var txt = InkWell(
          //   child:tagEdt,
          //   onTap: (){
          //
          //     if (si != null ) {
          //       widget.onChanged?.call(si.guid);
          //       Navigator.pop(context, si.guid);
          //     }
          //   },
          // );
          // var iconSize = 28.0;
          var con = Container(
            color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : null,
            // padding: EdgeInsets.fromLTRB(8,0,8,0),
            // height: 32,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
              child: Padding(
                // height: 32,
                // decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(width: 1, color:  ThemeCenter.activeTheme.areaBorderColor),
                //     )
                // ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // SizedBox(width : 8),
                      // Icon(Icons.web , color: Colors.greenAccent , size: 16,),
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
                  widget.onChanged?.call(si.guid);
                  // controller?.hideMenu();
                  Navigator.pop(context, si.guid);
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
        return (node as ATreeNode<SSFieldType>).children;
      },
      onFilter: (node){
        // if (widget.onFilter != null){
        //   var ns  = node as ATreeNode<SSFieldType>;
        //   return widget.onFilter(ns);
        // }

        var ns  = node as ATreeNode<SSFieldType>;
        if (ns != null) {
          // if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return n.getShowStringAndName();
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
        // SSDefines.IBC(child :IconButton(
        //   padding: EdgeInsets.all(0),
        //   icon : Icon(MaterialCommunityIcons.close_box_outline , color: Colors.redAccent,),
        //   iconSize: SSDefines.iconButtonSize,
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        //   tooltip: "关闭",
        // ))
        ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline, color: Colors.redAccent,
          width: 24,height :24,
          onPressed: (){
            Navigator.pop(context);
            // controller?.hideMenu();
          },
          tooltip: "关闭",
        ),
      ],
    );

    return con;
  }
}