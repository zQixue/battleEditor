//@dart=2.11
//import 'package:flutter/material.dart';
//
//class EnumDefinePage extends StatefulWidget {
//  EnumDefinePage({Key key}) : super(key: key);
//
//  @override
//  _EnumDefinePageState createState() => _EnumDefinePageState();
//}
//
//class _EnumDefinePageState extends State<EnumDefinePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:fswitch/fswitch.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeEnum.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/StateScript/Struct/SSEnumItem.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
//import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/int_editor.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/common/text_editor.dart';

class EnumDefinePage extends StatefulWidget {
  EnumDefinePage({Key key}) : super(
      key: key);

  @override
  _EnumDefinePageState createState() =>
      _EnumDefinePageState(
      );
}

class _EnumDefinePageState extends State<EnumDefinePage> {

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
              ObjectTableProject.instance.save();
            },
          ),
        ],
      ),
      body:Container(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(flex : 2 ,child: getList()),
            // SizedBox(width : 8,),
            Expanded(flex : 6 ,child:getDetail()),
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

  ATreeNode<SSEnumType> _clazzRoot;
  bool _clazzRootNR = false;
  ATreeNode<SSEnumType> getClassTreeRoot(){
    if (_clazzRoot == null || _clazzRootNR){
      var scripts = ObjectTableProject.instance.enums;//StateScriptProject.instance.scripts.where((element) => false == element.isModule).toList();
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
    _clazzRootNR = false;
    return _clazzRoot;
  }
  void forceBuildTree(){
    _clazzRootNR = true;
  }
  // SSEnumType _selectClazz ;



  List<SSEnumType> sortedEnums;
  Widget getList(){

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<SSEnumType>).id;
      },
      indent: 16,
      root : getClassTreeRoot(),
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<SSEnumType>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<SSEnumType>).data;
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
                      Icon(MaterialCommunityIcons.alpha_e_circle_outline , size: 18, ),
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

                      ThemeCenter.iconBtn(MaterialCommunityIcons.minus_box_outline,width: 20,height: 20, color: Colors.redAccent, tooltip:"删除类",
                        onPressed: (){
                          if (_selected != null){
                            CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                              setState(() {
                                setState(() {
                                  ObjectTableProject.instance.removeEnum(si);
                                  ObjectTableProject.instance.save();
                                  if (_selected == si) _selected = null;
//                          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                                });
                                // ObjectTableProject.instance.delete(_selectClazz);
                                // ObjectTableProject.instance.refreshClazzMap();
                                // ObjectTableProject.instance.save();
                                // _selectClazz = null;
                                // forceBuildTree();
                                // EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
                              });
                            });
                          }
                        },
                      ),

                      // Draggable(
                      //   child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blue,),
                      //   feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blue,),
                      //   childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.green,),
                      //   data:si,
                      // ),

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
        return (node as ATreeNode<SSEnumType>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<SSEnumType>;
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
        return (a as ATreeNode<SSEnumType>).data.guid.compareTo((b as ATreeNode<SSEnumType>).data.guid);
      },

      onItemTap: (item){
        var a = item as ATreeNode<SSEnumType>;
        if (a != null && a.data != null) {
          setState(() {
            _selected = a.data;
            // EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
            forceBuildTree();
          });
        }
      },

      actions: [
        ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,width: 32,height: 32, color: Colors.lightBlueAccent, tooltip:"添加",
          onPressed: (){
            // var newNode = ObjectTableProject.instance.addClazz();
            // ObjectTableProject.instance.refreshClazzMap();
            // ObjectTableProject.instance.save();
            // setState(() {
            //   _selected = newNode;
            //   forceBuildTree();
            //   EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
            // });
            var newNode = ObjectTableProject.instance.addEnum();
            ObjectTableProject.instance.save();
            setState(() {
              _selected = newNode;
            });
          },
        ),
      ],
    );
    return ThemeCenter.area(child: con);

    sortedEnums = ObjectTableProject.instance.enums;
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
                          ObjectTableProject.instance.removeEnum(_selected);
                          ObjectTableProject.instance.save();
                          _selected = null;
//                          EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                        });
                      });
                    }
                  },
                ),
                IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 48, color: Colors.black, tooltip:"添加新枚举",
                  onPressed: (){
                    var newNode = ObjectTableProject.instance.addEnum();
                    ObjectTableProject.instance.save();
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
        return ThemeCenter.block(
          headTitle: "枚举项列表",
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
                    IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 40, tooltip:"添加",
                      onPressed: (){
                        setState(() {
                          focusItem = _selected.addItem();
                          CBTypeEnum.buildAllEnumMaps();
                        });
                      },
                    ),
                    if (focusItem != null)IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 40, tooltip:"删除",
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


    return Column(
      children: [
        getInfoWidget(),
        // SizedBox(height: 8,),

        Expanded(child:Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child:itemLst,
        )),
      ],
    );
  }


  Widget getInfoWidget(){
    var interval = const SizedBox(height: 8,);
    _nameEditor.text = _selected.name;
    _aliasEditor.text = _selected.alias;
    var lst = ListView(
      children: [
        TextField(
          controller: _nameEditor,
          decoration: InputDecoration(
            labelText: "枚举名",
          ),
          onChanged: (v){
            _selected.name = v;
          },
          onSubmitted: (v) {
            setState(() {
              _selected.name = v;
            });

          },
        ),
        interval,
        TextField(
          controller: _aliasEditor,
          decoration: InputDecoration(
            labelText: "别名(优先显示)",
          ),
          onChanged: (v){
            _selected.alias= v;
          },
          onSubmitted: (v) {
            setState(() {
              _selected.alias = v;
            });

          },
        ),
      ],
    );
    // var dc = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],
    // );
    return ThemeCenter.area(
      padding: EdgeInsets.all(8),
      // decoration: dc,
      height: 146,
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

    c.width = 300.0;
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