//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class XmlTypesTreeView extends StatefulWidget {
  final Map types;
  XmlTypesTreeView({Key key,
    this.types,
  }) : super(key: key);

  @override
  _XmlTypesTreeViewState createState() => _XmlTypesTreeViewState();
}

class _XmlTypesTreeViewState extends State<XmlTypesTreeView> {
  @override
  Widget build(BuildContext context) {
    return getSearchBox();
  }
  Map<String ,bool> checkes = Map<String ,bool>();
  Widget getSearchBox(){
    var lst = widget.types.values.toList().where((element){
      return (element as ClazzInfo).childTypes.length<=0;
    });

    ATreeNode<ClazzInfo> _compRoot = DartCommon.buildTree<ClazzInfo>(lst.toList(), (item){
      return item.group;
    });

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ClazzInfo>).id;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<ClazzInfo>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<ClazzInfo>).data as ClazzInfo;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          // bool selected = crtClz == si;//(_selectedStrings[si.guid] != null);

          // var txt = HoverCursor(
          //   cursor: Cursor.crosshair,
          //   child: Text(si.getTag(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)),
          // );
          var tagEdt = highlightPattern == null?Text(si.name, style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)) :
          ParsedText(
            text: si.name,
            style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12),
            parse: <MatchText>[
              MatchText(
                pattern: highlightPattern, // a custom pattern to match
                regexOptions: RegexOptions(
                    multiLine : true,
                    caseSensitive : false,
                    unicode : true,
                    dotAll : true
                ),
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ), // custom style to be applied to this matched text
              )
            ],
          );
          var con = Container(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // SizedBox(width : 8),
                      Checkbox(
                        value: checkes[si.name]??false,
                        onChanged: (v){
                          setState(() {
                            checkes[si.name] = v;
                          });
                        },
                      ),
                      SizedBox(width : 4),
                      Expanded(child : tagEdt),
                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            height: 36,
            padding: EdgeInsets.all(1),
            child: con,
            // child: InkWell(
            //   child: con,
            //   onTap: (){
            //
            //     if (si != null ) {
            //       // widget.onChanged?.call(si.guid);
            //       // Navigator.pop(context, si.guid);
            //     }
            //   },
            // ),
          );

          return con;
        }
        else{
          // var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
          var tagEdt = highlightPattern == null?Text(agent.name??"", style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)) :
          ParsedText(
            text: agent.name??"",
            style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12),
            parse: <MatchText>[
              MatchText(
                pattern: highlightPattern, // a custom pattern to match
                regexOptions: RegexOptions(
                    multiLine : true,
                    caseSensitive : false,
                    unicode : true,
                    dotAll : true
                ),
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ), // custom style to be applied to this matched text
              )
            ],
          );
          var con = Container(
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // SizedBox(width : 8),
                      Checkbox(
                        value: checkes[agent.name??""]??false,
                        onChanged: (v){
                          setState(() {
                            checkes[agent.name??""] = v;
                          });
                        },
                      ),
                      SizedBox(width : 4),
                      Expanded(child : tagEdt),
                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            height: 36,
            padding: EdgeInsets.all(1),
            child: con,
            // child: InkWell(
            //   child: con,
            //   onTap: (){
            //
            //     if (si != null ) {
            //       // widget.onChanged?.call(si.guid);
            //       // Navigator.pop(context, si.guid);
            //     }
            //   },
            // ),
          );

          return con;
        }
      },
      onGetChildren: (node){
        return (node as ATreeNode<ClazzInfo>).children;
      },
      onFilter: (node){
        // if (widget.onFilter != null){
        //   var ns  = node as ATreeNode<ClazzInfo>;
        //   return widget.onFilter(ns);
        // }

        var ns  = node as ATreeNode<ClazzInfo>;
        if (ns != null) {
          // if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return n.name;
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
          },
          tooltip: "关闭",
        ),
        ThemeCenter.iconBtn(MaterialCommunityIcons.import, color: Colors.greenAccent,
          width: 24,height :24,
          onPressed: (){
            // Navigator.pop(context);
            Navigator.pop(context,[checkes]);
          },
          tooltip: "导入",
        ),
      ],
    );

    return con;
  }
}