//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/Tagger/ATag.dart';
import 'package:battlepus/common/Tagger/TagCamp.dart';
import 'package:battlepus/common/Tagger/TagSet.dart';
import 'package:battlepus/common/Tagger/tag_manager_view.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:theme_provider/theme_provider.dart';

class TagEditView extends StatefulWidget {
  final TagSet tagSet;
  final TagCamp camp;
  TagEditView({Key key,
    this.tagSet,
    this.camp,
  }) : super(key: key);

  @override
  _TagEditViewState createState() => _TagEditViewState();
}

class _TagEditViewState extends State<TagEditView> {
  bool bManager = false;

  @override
  Widget build(BuildContext context) {

    if (widget.tagSet.tagGuids == null){
      widget.tagSet.tagGuids = List<String>();
    }
    return ThemeCenter.block(
        headTitle: "编辑标签",
        expanded: true,
        child: Row(
          children: [
            Expanded(child : buildList()),
            // if (_selected != null) Container(width: 1,color: CommonUtil.alphaColor(Colors.grey,80),),
            // if (_selected != null) Expanded(child : Container(
            //   padding: EdgeInsets.all(4),
            //   child: Column(
            //     children: [
            //       TextEditor(
            //         initValue: _selected.name??"",
            //         hint: "标签名字",
            //         onChanged: (v){
            //           _selected.name = v;
            //         },
            //       ),
            //       Container(height: 8,),
            //       TextEditor(
            //         initValue: _selected.alias??"",
            //         hint: "别名",
            //         onChanged: (v){
            //           _selected.alias = v;
            //         },
            //       ),
            //     ],
            //   ),
            // )),
          ],
        ),
      actions: [

        ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline,
          width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"编辑",
          onPressed: (){
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                var child = ThemeCenter.area(width:800 ,height:600, child: TagManagerView(camp: StateScriptProject.instance.tagCamp,));
                return ThemeConsumer(child:Dialog(child: child));
              },
            ).then((value){
              setState(() {

              });
            });;
          },
        ),

        ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
          width: 20 , height : 20 , color: Colors.red, tooltip:"关闭",
          onPressed: (){
            Navigator.pop(context);
          },
        ),



        Container(width: 4,),
      ]
    );
  }

  ATreeNode<ATag> _clazzRoot;
  ATag _selected;
  ATreeNode<ATag> getClassTreeRoot(){
    // if (_clazzRoot == null || _clazzRootNR){
    {
      var scripts = widget.camp.tags.values.toList();//StateScriptProject.instance.scripts.where((element) => false == element.isModule).toList();
      // print("element count 2 : ${scripts.length}");
      _clazzRoot = DartCommon.buildTree(scripts, (item){

        // var id = (item as SSEnumType).group;
        // var sp = id.split("/");
        // if (sp.length>0) {
        //   return sp;
        // }
        return <String>[];
      });
    }

    return _clazzRoot;
  }

  Widget buildList(){
    var con = SearchableThemeTreeView(
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ATag>).id;
      },
      indent: 16,
      root : getClassTreeRoot(),
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<ATag>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<ATag>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = _selected == si;//(_selectedStrings[si.guid] != null);

          var txt = Text(si.getTypeShowString(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : ThemeCenter.systemTheme.scaffoldBackgroundColor,
              // padding: EdgeInsets.fromLTRB(8,0,8,0),
              // height: 32,
              // color: CommonUtil.scaleColor(Colors.grey, 0.15),
              // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color:  ThemeCenter.activeTheme.areaBorderColor),
                      )
                  ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      SizedBox(width : 8),
                      Checkbox(
                        value: widget.tagSet.tagGuids.contains(si.guid),
                        onChanged: (v){
                          setState(() {
                            if (v){
                              if (!widget.tagSet.tagGuids.contains(si.guid)) {
                                widget.tagSet.tagGuids.add(si.guid);
                              }
                            }
                            else{
                              widget.tagSet.tagGuids.remove(si.guid);
                            }
                          });
                        },
                      ),
                      Icon(MaterialCommunityIcons.tag , size: 18, color: Colors.lightGreenAccent,),
                      SizedBox(width : 8),
                      highlightPattern == null?Expanded(child : txt):
                      Expanded(child : ParsedText(
                        text: si.getTypeShowString(),
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
                      )),




                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            padding: EdgeInsets.all(1),
            child: con,
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
        return (node as ATreeNode<ATag>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<ATag>;
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

      onSortLeaf: (a,b){
        return (a as ATreeNode<ATag>).data.guid.compareTo((b as ATreeNode<ATag>).data.guid);
      },

      onItemTap: (item){
        var a = item as ATreeNode<ATag>;
        if (a != null && a.data != null) {
          setState(() {
            _selected = a.data;
          });
        }
      },

      actions: [
        // ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,width: 32,height: 32, color: Colors.lightBlueAccent, tooltip:"添加",
        //   onPressed: (){
        //     // var newNode = ObjectTableProject.instance.addClazz();
        //     // ObjectTableProject.instance.refreshClazzMap();
        //     // ObjectTableProject.instance.save();
        //     // setState(() {
        //     //   _selected = newNode;
        //     //   forceBuildTree();
        //     //   EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
        //     // });
        //     if (widget.camp.tags.length>=30){
        //       BotToast.showText(text: "目前最多支持30个标签,请省着点用",contentColor: Colors.redAccent);
        //       return;
        //     }
        //     var newNode = widget.camp.addTag();
        //     // ObjectTableProject.instance.save();
        //     StateScriptProject.instance.save();
        //     setState(() {
        //       _selected = newNode;
        //     });
        //   },
        // ),
      ],
    );


    return con;
  }
}