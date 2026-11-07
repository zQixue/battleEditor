//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/a_object_view.dart';
import 'package:battlepus/ObjectTable/object_tag_view.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:theme_provider/theme_provider.dart';

class AObjectSelector extends StatefulWidget {
  final ObjectClazz clz;
  final String currentObjectGuid;
  final Color bgColor;
  final dynamic onChanged;
  final EdgeInsets padding;
  final FunctionFilterCallback onFilter;
  final bool nodeRef ;
  final Color borderColor;
  final bool spaceRange;
  final bool withCreateButton ;
  final bool forceRefable ;
  final bool withEditButton ;
  AObjectSelector({Key key,
    this.clz,
    this.currentObjectGuid,
    this.bgColor ,//= Colors.black,
    this.onChanged,
    this.padding,
    this.onFilter,
    this.nodeRef = false,
    this.borderColor,
    this.spaceRange = false,
    this.withCreateButton = true,
    this.forceRefable = false,
    this.withEditButton = true,
  }) : super(key: key);

  @override
  _AObjectSelectorState createState() => _AObjectSelectorState();
}

class _AObjectSelectorState extends State<AObjectSelector> {
  @override
  Widget build(BuildContext context) {
    var crtObj = widget.clz.table.getObjectByGuid(widget.currentObjectGuid);
    print("_AObjectSelectorState : $crtObj");
    var tag = ObjectTagView(
        object:crtObj,
    );
    var dc = new BoxDecoration(
      border : Border(
        bottom: BorderSide(width: 1.2,color: widget.borderColor??Colors.grey),
      ),// .all(color: colorBd, width: 1),
      color :widget.bgColor,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
        // borderRadius: new BorderRadius.circular((8))
    );
    var btnSize = 20.0;
    if (widget.nodeRef) btnSize = SSDefines.portSize;
    var con = Container(
      // padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
        height: 24 - 3.5,

      color: widget.bgColor,
      decoration: dc,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Tooltip(
            message: "点击查找引用",
              child:InkWell(child: tag,
              onTap: () async {
                if (!(widget.clz?.refable??false) && !widget.forceRefable){
                  BotToast.showText(text: "类型 ${widget.clz.name} 已设定为不可引用，请直接新建对象" , contentColor: Colors.redAccent);
                  return;
                }

                var searBox = await getSearchBox();
                if (searBox == null){
                  // BotToast.showText(text: "对象表当前空间无效" , contentColor: Colors.redAccent);
                  return ;
                }
                showDialog(
                  context: context,
                    barrierColor:Colors.black87,
                  // barrierDismissible: false,
                  builder: (BuildContext context) {
                    // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
                    return Dialog(child: Container(
                      color:  Color(0xff2f2f2f),
                      width: 600,
                      height: 600,
                      child: searBox,
                    ), );
                  },
                );
              },
          ))),
          if (crtObj != null) ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
            color: widget.nodeRef?Colors.redAccent:null,
            width: btnSize,height :btnSize,
            onPressed: (){
              widget.onChanged?.call("");
              // var aObj = widget.clz.table.addObject();
              // widget.onSubmitted?.call(aObj.guid);
            },
            tooltip: "清除引用",
          ),
          // ThemeCenter.iconBtn(MaterialCommunityIcons.format_list_bulleted_type,
          //   width: 24,height :24,
          //   onPressed: (){
          //     showDialog(
          //       context: context,
          //       // barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
          //         return Dialog(child: Container(width: 600, height: 600,));
          //       },
          //     );
          //   },
          //   tooltip: "查找引用",
          // ),

          if (widget.withCreateButton) ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,
            color: widget.nodeRef?Colors.white:null,
            width: btnSize,height :btnSize,
            onPressed: (){
              var aObj = widget.clz.table.addObject();
              widget.onChanged?.call(aObj.guid);
            },
            tooltip: "新建",
          ),
          if (widget.nodeRef && crtObj != null && widget.withEditButton) ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline,
              color: widget.nodeRef?Colors.white:null,
              width: btnSize,height :btnSize,
              onPressed: (){
                var r = crtObj.getClazz().getObjectRect();
                var content = AObjectView(
                  key:ValueKey("${crtObj?.guid??""}"),
                  object: crtObj,
                  // clazz: widget.clz,
                  // isPublic: true ,//levelInfo?.fi?.isPublic??true,
                  // isStatic: true ,//levelInfo?.fi?.isStatic??false,
                  // fieldInfo : null,//levelInfo?.fi,
                  // editMode: false ,//OTDefines.editMode,
                  // onSubmitted: (v) async{
                  //   setState(() {
                  //
                  //   });
                  // },
                );
                showDialog(
                  context: context,
                  barrierColor:Colors.black87,
                  // barrierDismissible: false,
                  builder: (BuildContext context) {
                    // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
                    return Dialog(child: ThemeCenter.block(
                      headTitle: "对象编辑",
                      padding: EdgeInsets.all(8),
                      // color:  Color(0xff2f2f2f),
                      width: r.width,
                      height: r.height + 50,
                      child: ThemeConsumer(child:content),
                    ), );

                  },
                );
              },
              tooltip: "编辑",
            ),

        ],
      ),
    );

    return Padding(
      padding: widget.padding??EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: con,
    );
  }

  Future<Widget> getSearchBox() async {

    ATreeNode<AObject> _compRoot ;
    if (widget.spaceRange){
      var space = await BattlePusGlobal.getObjectSpace();
      if (DartCommon.isEmpty(space)){
        BotToast.showText(text: "对象表当前空间无效，请打开对象表，并打开对应的空间对象" , contentColor: Colors.redAccent);
        return null;
      }

      var rootObj = ObjectClazz.allObjects[space];
      if (rootObj == null){
        BotToast.showText(text: "对象空间 ${space} 不存在，请重新打开战斗编辑器刷新后重试" , contentColor: Colors.redAccent);
        return null;
      }

      var mp = rootObj.spaceObjectMap[widget.clz.guid];
      if (mp == null){
        print(rootObj.spaceObjectMap);
        BotToast.showText(text: "对象空间 ${space} 下不存在 ${widget.clz.name} 类型的对象" , contentColor: Colors.redAccent);
        return null;
      }
      List<AObject> objs = [];
      mp.forEach((element,key) {
        if (key >= 2) return ;
        var aObj = ObjectClazz.allObjects[element];

        if (aObj != null && !aObj.isComment){
          objs.add(aObj);
        }
      });

      _compRoot = DartCommon.buildTree<AObject>(objs, (item){
        return <String>[];
      });

    }
    else{
      _compRoot = DartCommon.buildTree<AObject>(widget.clz.table.objects, (item){
        return <String>[];
      });
    }

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<AObject>).data;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<AObject>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<AObject>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          // bool selected = crtClz == si;//(_selectedStrings[si.guid] != null);

          // var txt = HoverCursor(
          //   cursor: Cursor.crosshair,
          //   child: Text(si.getTag(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)),
          // );
          var tagEdt = highlightPattern == null?Text(si.getTag(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12)) :
          ParsedText(
            text: si.getTag(),
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
              // color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : ThemeCenter.systemTheme.scaffoldBackgroundColor,
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
                      Icon(Icons.web , color: Colors.greenAccent , size: 16,),
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
        return (node as ATreeNode<AObject>).children;
      },
      onFilter: (node){
        if (widget.onFilter != null){
          var ns  = node as ATreeNode<AObject>;
          return widget.onFilter(ns);
        }

        var ns  = node as ATreeNode<AObject>;
        if (ns != null) {
          // if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return n.getTag();
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
      ],
    );

    return con;
  }
}