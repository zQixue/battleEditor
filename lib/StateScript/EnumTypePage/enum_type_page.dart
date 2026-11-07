//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fswitch/fswitch.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeEnum.dart';
import 'package:battlepus/StateScript/Struct/SSEnumItem.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/checkbox_with_title.dart';
import 'package:battlepus/common/int_editor.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/common/text_editor.dart';
 
class EnumTypePage extends StatefulWidget {
  EnumTypePage({Key key}) : super(
      key: key);

  @override
  _EnumTypePageState createState() =>
      _EnumTypePageState(
      );
}

class _EnumTypePageState extends State<EnumTypePage> {

  SSEnumType _selected;
  TextEditingController _nameEditor ;
  TextEditingController _aliasEditor ;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameEditor?.dispose();
    _aliasEditor?.dispose();

    CBTypeEnum.buildAllEnumMaps();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initColumns();
    _selected = null;
    focusItem = null;
    _nameEditor = TextEditingController();
    _aliasEditor = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("枚举定义"),
        actions: [
          IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 36, color: Colors.white, tooltip:"保存",
            onPressed: (){
              StateScriptProject.instance.save();
            },
          ),
        ],
      ),
      body:Container(
        // padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(flex:2,child: getThemeStructTree()),
            // SizedBox(width: 8,),
            Expanded(flex:6,child:getDetail()),
          ],
        ),
      ),
    );
//    return Row(
//      children: [
//        getList(),
//        getDetail(),
//      ],
//    );
  }

  ATreeNode<SSEnumType> _enumRoot;
  bool _enumRootNR = false;
  ATreeNode<SSEnumType> getNodeTreeRoot(){
    // if (_enumRoot == null || _enumRootNR){
    {
      var scripts = StateScriptProject.instance.enums;//.where((element) => false == element.isModule).toList();
      _enumRoot = DartCommon.buildTree(scripts, (item){
        if ((item as SSEnumType).group == null){
          return const <String>[];
        }
        // return const <String>[];
        var sp = (item as SSEnumType).group.split("/");
        return sp;
      });
    }
    // _enumRootNR = false;
    return _enumRoot;
  }
  void forceBuildTree(){
    _enumRootNR = true;
  }

  Widget getThemeStructTree() {
    var con = SearchableThemeTreeView(
      defaultExpanded: true,
      // onExpandedFlagChanged: (map){
      //   SSUserData.instance.nodeStructListExpandedFlags = map;
      //   SSUserData.instance.save();
      // },
      indent: 16,
      // expandedFlags: SSUserData.instance.nodeStructListExpandedFlags,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getNodeTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<SSEnumType>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<SSEnumType>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<SSEnumType>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = Text((si as SSEnumType).getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
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
                Expanded(child : txt),
                Container(
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
                            StateScriptProject.instance.removeEnum(si);
                            StateScriptProject.instance.save();
                            if (si == _selected) _selected = null;
                            forceBuildTree();
//                          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                          });
                        });
                        // CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                        //   setState(() {
                        //     // StateScriptProject.instance.deleteNodeType(si);
                        //     // StateScriptProject.instance.refreshStructMap();
                        //     // StateScriptProject.instance.save();
                        //     // if (si == _selected) _selected = null;
                        //     // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(si));
                        //     forceBuildTree();
                        //   });
                        // });
                      },
                    )
                ),
                // Container(
                //     width: iconSize,
                //     height: iconSize,
                //     child:IconButton(
                //       padding: EdgeInsets.all(0),
                //       icon : Icon(MaterialCommunityIcons.shape_square_plus),
                //       color: Colors.lightBlueAccent,
                //       tooltip: "复制结点",
                //       iconSize: iconSize,
                //       onPressed: (){
                //
                //         setState(() {
                //           _selected = StateScriptProject.instance.cloneNodeStruct(si);
                //           EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                //           forceBuildTree();
                //           // _selectScript.group = astruct.group;
                //           // ScriptInfo.current = _selectScript;
                //         });
                //
                //       },
                //     )
                // ),

                // Draggable(
                //   child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blueGrey,),
                //   feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.lightBlueAccent,),
                //   childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.lightBlueAccent,),
                //   data:si,
                // ),
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

      onFilter: (node){
        var ns  = node as ATreeNode<SSEnumType>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.alias}";
        }
        return "";
      },

      // onSort: (aNode,bNode){
      //   var a = (aNode as ATreeNode<ScriptInfo>).data;
      //   var b = (bNode as ATreeNode<ScriptInfo>).data;
      //   return a.getShowStringAndName().compareTo(b.getShowStringAndName());
      // },

      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<SSEnumType>).data;
          if (si != null) {
            _selected = si;
            // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }
          // forceBuildTree();
        });

      },

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.indigo,
          iconSize: 32,
          onPressed: (){
            var newNode = StateScriptProject.instance.addEnum();
            StateScriptProject.instance.save();
            setState(() {
              _selected = newNode;
              forceBuildTree();
            });
            // var newNode = StateScriptProject.instance.addNewNodeType();
            // StateScriptProject.instance.refreshStructMap();
            // StateScriptProject.instance.save();
            // setState(() {
            //   _selected = newNode;
            //   _newNode = newNode;
            //   EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
            //   forceBuildTree();
            // });

          },
        ),

      ],
    );
    var block = ThemeCenter.block (
      headTitle: "枚举",
      // width: 480,
      child: con,
    );
    return block;
  }

  List<SSEnumType> sortedEnums;
  Widget getList(){

    sortedEnums = StateScriptProject.instance.enums;
    sortedEnums.sort((a,b)=>a.name.compareTo(b.name));
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
              }
              );
            },
          ),
        ),
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
                IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 48, color: _selected == null?Colors.grey:Colors.black, tooltip:"删除枚举",
                  onPressed: (){
                    if (_selected != null){
                      CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                        setState(() {
                          StateScriptProject.instance.removeEnum(_selected);
                          StateScriptProject.instance.save();
                          _selected = null;
//                          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                        });
                      });
                    }
                  },
                ),
                IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 48, color: Colors.black, tooltip:"添加新枚举",
                  onPressed: (){
                    var newNode = StateScriptProject.instance.addEnum();
                    StateScriptProject.instance.save();
                    setState(() {
                      _selected = newNode;
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

    var lst = ListView.builder(
      itemCount: sortedEnums.length,
      itemBuilder: onBuildEnum ,
    );
    return Scrollbar(
      child: lst,
    );

  }
  Widget onBuildEnum(BuildContext context, int index) {
    var item = sortedEnums[index];
    bool isSelected = _selected == item;
    return InkWell(
      onTap: (){
        setState(() {
          _selected = item;
        });
      },
      child: Container(
        padding: EdgeInsets.all(4),
        height: 58,
        color: isSelected?CommonUtil.alphaColor(Colors.indigo, 32):Colors.white,
        child: item.getTypeShowWidget(),
      ),
    );
  }


  Widget getDetail(){
    if (_selected == null){
      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请在左侧创建或选择一个枚举"  , style: TextStyle(fontSize: 48 , color: Colors.grey),),
        ],
      ));
    }



    var itemLst = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        var items = _selected.items;
        var lst = ListTable(
          forceWidth: constraints.maxWidth,
          columns:columns,
          itemCount: items.length,
          itemHeight: 48,
          useCard: false,
          onTap: (idx){
            setState(() {
              if(focusItem != items[idx]) {
                focusItem = items[idx];
              }
            });
          },
          onRowInfo: (idx){
            var info = RowInfoHolder();
            info.forceColor = focusItem == items[idx];
            info.bgColor = Color(0x220000dF);
            return info;
          },
        );
        // var dc = new BoxDecoration(
        //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
        // );
        return Container(
          // decoration: dc,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 6,),
              Container(
                height: 52,
//            color: CommonUtil.alphaColor(Colors.indigo, 24),
                child :Row(
                  children: [
                    IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 40, color: ThemeCenter.mainTextStepColor(8), tooltip:"添加",
                      onPressed: (){
                        setState(() {
                          focusItem = _selected.addItem();
                          CBTypeEnum.buildAllEnumMaps();
                        });
                      },
                    ),
                    if (focusItem != null) IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 40, color: Colors.redAccent, tooltip:"删除",
                      onPressed: (){
                        setState(() {
                          _selected.removeItem(focusItem);
                          focusItem = null;
                          CBTypeEnum.buildAllEnumMaps();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4,),
              Expanded(child :lst),
//          lst,
//          SizedBox(height: 4,),

              SizedBox(height: 4,),
            ],
          ),
        );
      },
    );


    return ThemeCenter.area(child:Column(
      children: [
        getInfoWidget(),
        SizedBox(height: 8,),
        Expanded(child:itemLst),
      ],
    ));
  }


  Widget getInfoWidget(){
    var interval = const SizedBox(height: 8,);
    var interval2= const SizedBox(width: 8,);
    _nameEditor.text = _selected.name;
    _aliasEditor.text = _selected.alias;
    var lst = ListView(
      children: [
        Row(
          children: [
            Expanded(child:TextEditor(
              // controller: _nameEditor,
              initValue: _selected.name??"",
              hint: "枚举名",
              // decoration: InputDecoration(
              //   labelText: "枚举名",
              // ),
              onChanged: (v){
                _selected.name = v;
              },
              onSubmitted: (v) {
                setState(() {
                  _selected.name = v;
                });

              },
            )),
            interval2,
            Expanded(child:TextEditor(
              // controller: _aliasEditor,
              initValue: _selected.alias??"",
              hint: "别名(优先显示)",
              // decoration: InputDecoration(
              //   labelText: "别名(优先显示)",
              // ),
              onChanged: (v){
                _selected.alias= v;
              },
              onSubmitted: (v) {
                setState(() {
                  _selected.alias = v;
                });

              },
            )),
          ],
        ),


        interval,

        Row(
          children: [
            Expanded(child:TextEditor(
              initValue: _selected.group??"",
              // decoration: InputDecoration(
              //   labelText: "分类",
              // ),
              hint: "分类",
              onChanged: (v){
                _selected.group= v;
              },
              onSubmitted: (v) {
                setState(() {
                  _selected.group = v;
                });

              },
            ),),
            interval2,
            Expanded(child:TextEditor(
              hint: "命名空间",
              initValue: _selected.namespace??"",
              onChanged: (v){
                _selected.namespace= v;
              },
              onSubmitted: (v) {
                setState(() {
                  _selected.namespace = v;
                });

              },
            ),),
          ],
        ),

        interval,
        Row(
          children: [
            Expanded(child:CheckboxWithTitle(
              title: "是否导出",
              value: _selected.needExport ?? false,
              onChanged: (v){
                setState(() {
                  _selected.needExport = v;
                });
              },
            )),
            interval2,
            Expanded(child:CheckboxWithTitle(
              title: "导出处理类",
              value: _selected.exportSolver ?? false,
              onChanged: (v){
                setState(() {
                  _selected.exportSolver = v;
                });
              },
            )),
          ],
        ),
        // Row(
        //   children: [
        //     Text("是否导出"),
        //     SizedBox(width: 4,),
        //     Checkbox(
        //       value: _selected.needExport ?? false,
        //       onChanged: (v){
        //         setState(() {
        //           _selected.needExport = v;
        //         });
        //       },
        //     ),
        //   ],
        // ),
        // interval,
        // Row(
        //   children: [
        //     Text("导出处理类"),
        //     SizedBox(width: 4,),
        //     Checkbox(
        //       value: _selected.exportSolver ?? false,
        //       onChanged: (v){
        //         setState(() {
        //           _selected.exportSolver = v;
        //         });
        //       },
        //     ),
        //   ],
        // ),
        Visibility(
          visible: _selected.exportSolver??false,
          child: Container(height : 60 , child:Row(
            children: [

              Expanded ( child : TextEditor(
                initValue : _selected.solveCompName??"",
                hint: "目标处理组件",
                onChanged: (v){
                  _selected.solveCompName= v;
                },
                onSubmitted: (v) {
                  setState(() {
                    _selected.solveCompName = v;
                  });

                },
              )),
              SizedBox(width: 4,),
              Expanded ( child :TextEditor(
                initValue : _selected.staticDataName??"",
                hint: "静态数据对象",
                onChanged: (v){
                  _selected.staticDataName= v;
                },
                onSubmitted: (v) {
                  setState(() {
                    _selected.staticDataName = v;
                  });

                },
              )),
            ],
          )),
        )
      ],
    );
    // var dc = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    // );
    return Container(
      padding: EdgeInsets.all(8),
      // decoration: dc,
      height: 280,
      child: Scrollbar(
          child:lst
      ),
    );
  }


  List<ListTableColumn> columns;

  SSEnumItem focusItem;
  void initColumns(){
    columns = new List<ListTableColumn>();
    ///
    var c = ListTableColumn();
    c.name = "项名";

    c.width = 200.0;
    c.widgetBuilder = (context , index) {
      var items = _selected.items;
      var res = new ItemHolder();
      res.widget = _getNameWidget(items[index]);
      return res;
    };

    c.headAlignment = Alignment.centerLeft;
    c.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c);

    ///
    var c1 = ListTableColumn();
    c1.name = "别名(优先显示)";

    c1.width = 200.0;
    c1.widgetBuilder = (context , index) {
      var items = _selected.items;
      var res = new ItemHolder();
      res.widget = _getAliasWidget(items[index]);
      return res;
    };
    c1.headAlignment = Alignment.centerLeft;
    c1.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c1);
    {
      var c1 = ListTableColumn();
      c1.name = "描述";

      c1.width = 300.0;
      c1.widgetBuilder = (context , index) {
        var items = _selected.items;
        var res = new ItemHolder();
        res.widget = _getHintWidget(items[index]);
        return res;
      };
      c1.headAlignment = Alignment.centerLeft;
      c1.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c1);
    }
    {
      var c1 = ListTableColumn();
      c1.name = "指定值";

      c1.width = 200.0;
      c1.widgetBuilder = (context , index) {
        var items = _selected.items;
        var res = new ItemHolder();
        res.widget = _getValueWidget(items[index]);
        return res;
      };
      c1.headAlignment = Alignment.centerLeft;
      c1.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c1);
    }

    var c2 = ListTableColumn();
    c2.name = "操作";

    c2.width = 200.0;
    c2.widgetBuilder = (context , index) {

      var res = new ItemHolder();
      res.widget = _getActionWidgets(index);
      return res;
    };
    c2.headAlignment = Alignment.centerLeft;
    c2.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c2);
  }
  Widget _getNameWidget(SSEnumItem item) {

    var str = item.name;
    if (str == null || str.isEmpty) str = "请输入名字";
    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.name,
          onChanged: (v){
            item.name = v;
          },
          onSubmitted: (v){
            item.name = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(str);
  }

  Widget _getAliasWidget(SSEnumItem item) {

    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.alias,

          onChanged: (v){
            item.alias = v;
          },
          onSubmitted : (v){
            item.alias = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.alias);
  }

  Widget _getHintWidget(SSEnumItem item) {

    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.hint??"",

          onChanged: (v){
            item.hint = v;
          },
          onSubmitted : (v){
            item.hint = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.hint);
  }

  Widget _getValueWidget(SSEnumItem item) {

    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = IntEditor(
          initValue: item.enumValue??0,
          onChanged: (v){
            item.enumValue = v;
          },
          onSubmitted : (v){
            item.enumValue = v;
          }
      );

      return Container(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [

            FSwitch(
              width: 40,
              open: item.enumValue != null,
              onChanged: (v){
                if (v){
                  if (item.enumValue == null) {
                    setState(() {
                      item.enumValue = 0;
                    });

                  }
                }
                else{
                  setState(() {
                    item.enumValue = null;
                  });
                }
              },
            ),
            if (item.enumValue!= null) SizedBox(width: 8,),
            if (item.enumValue!= null) Expanded(child:res),
          ],
        ),
      );
    }
    return Text(item.enumValue == null?"自动":"${item.enumValue}");
  }

  Widget _getActionWidgets(int index) {
    var items = _selected.items;
    var upCmd = IconButton(icon: Icon(MaterialCommunityIcons.arrow_up_bold_box_outline),iconSize: 30, color: Colors.indigo, tooltip:"上移",
      onPressed: (){
        setState(() {
          var item = items[index];
          items.remove(item);
          items.insert(index-1, item);
          focusItem = item;
        });
      },
    );
    var up = Container(
      width: 32,
//      height: 32,
      child: index>0?upCmd:Container(),
    );
    var dowmCmd = IconButton(icon: Icon(MaterialCommunityIcons.arrow_down_bold_box_outline),iconSize: 30, color: Colors.indigo, tooltip:"上移",
      onPressed: (){
        setState(() {
          var item = items[index];
          items.remove(item);
          items.insert(index+1, item);
          focusItem = item;
        });
      },
    );
    var down = Container(
      width: 32,
//      height: 32,
      child: index<items.length-1?dowmCmd:Container(),
    );
    return Container(
      child: Row(
        children: [
          up,
          down,
        ],
      ),
    );
  }
}