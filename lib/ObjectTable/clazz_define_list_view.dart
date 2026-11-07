//@dart=2.11
import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class ClazzDefineListView extends StatefulWidget {
  ClazzDefineListView({Key key}) : super(
      key: key);

  @override
  _ClazzDefineListViewState createState() =>
      _ClazzDefineListViewState(
      );
}

class _ClazzDefineListViewState extends State<ClazzDefineListView> {

  Map<String, List<ObjectClazz>> groupMaps;
  List<String> groups;

  StreamSubscription<ClazzChangeEvent> _lis;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<ClazzChangeEvent>().listen((event) {
      setState(() {

      });
    });
  }

  ATreeNode<ObjectClazz> _clazzRoot;
  bool _clazzRootNR = false;
  ATreeNode<ObjectClazz> getClassTreeRoot(){
    if (_clazzRoot == null || _clazzRootNR){
      var scripts = ObjectTableProject.instance.clazzes;//StateScriptProject.instance.scripts.where((element) => false == element.isModule).toList();
      // print("element count 2 : ${scripts.length}");
      _clazzRoot = DartCommon.buildTree(scripts, (item){

        var id = (item as ObjectClazz).group;
        var sp = id.split("/");
        if (sp.length>0) {
          return sp;
        }
        return [];
      });
    }
    _clazzRootNR = false;
    return _clazzRoot;
  }
  void forceBuildTree(){
    _clazzRootNR = true;
  }
  ObjectClazz _selectClazz ;

  @override
  Widget build(BuildContext context) {
    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ObjectClazz>).id;
      },
      indent: 16,
      intervalColor : CommonUtil.alphaColorD(Colors.blueGrey, 0.05),
      root : getClassTreeRoot(),
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<ObjectClazz>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<ObjectClazz>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = _selectClazz == si;//(_selectedStrings[si.guid] != null);

          var txt = Text(si.getTypeShowString(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 14));
          var iconSize = 28.0;
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) :null,
              // padding: EdgeInsets.fromLTRB(8,0,8,0),
              // height: 32,
              // color: CommonUtil.scaleColor(Colors.grey, 0.15),
              // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
              child: Container(
                  // decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(width: 1, color:  ThemeCenter.activeTheme.areaBorderColor),
                  //     )
                  // ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      SizedBox(width : 8),
                      Icon(EvilIcons.sc_instagram , color: Color(si.color)),
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
                          if (_selectClazz != null){
                            CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                              setState(() {
                                ObjectTableProject.instance.deleteClazz(_selectClazz);
                                ObjectTableProject.instance.refreshClazzMap();
                                ObjectTableProject.instance.save();
                                _selectClazz = null;
                                forceBuildTree();
                                EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
                              });
                            });
                          }
                        },
                      ),

                      Draggable(
                        child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blue,),
                        feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blue,),
                        childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.green,),
                        data:si,
                      ),

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
        return (node as ATreeNode<ObjectClazz>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<ObjectClazz>;
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
        return (a as ATreeNode<ObjectClazz>).data.guid.compareTo((b as ATreeNode<ObjectClazz>).data.guid);
      },

      onItemTap: (item){
        var a = item as ATreeNode<ObjectClazz>;
        if (a != null && a.data != null) {
          setState(() {
            _selectClazz = a.data;
            EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
            forceBuildTree();
          });
        }
      },

      actions: [
        ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,width: 32,height: 32, color: Colors.lightBlueAccent, tooltip:"添加新类型(表)",
          onPressed: (){
            var newNode = ObjectTableProject.instance.addClazz();
            ObjectTableProject.instance.refreshClazzMap();
            ObjectTableProject.instance.save();
            setState(() {
              _selectClazz = newNode;
              forceBuildTree();
              EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selectClazz));
            });
          },
        ),
      ],
    );
    return ThemeCenter.area(child: con);
  }
  Widget build2(BuildContext context) {

    groupMaps = ObjectTableProject.instance.getClazzGroups();
    groups = groupMaps.keys.toList();
    groups.sort();
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
                IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 48, color: _selected == null?Colors.grey:Colors.black, tooltip:"删除类",
                  onPressed: (){
                    if (_selected != null){
                      CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                        setState(() {
                          ObjectTableProject.instance.deleteClazz(_selected);
                          ObjectTableProject.instance.refreshClazzMap();
                          ObjectTableProject.instance.save();
                          _selected = null;
                          EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selected));
                        });
                      });
                    }
                  },
                ),
                IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 48, color: Colors.black, tooltip:"添加新类型(表)",
                  onPressed: (){
                    var newNode = ObjectTableProject.instance.addClazz();
                    ObjectTableProject.instance.refreshClazzMap();
                    ObjectTableProject.instance.save();
                    setState(() {
                      _selected = newNode;
                      EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selected));
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
      itemCount: groups.length,
      itemBuilder: onBuildGroup ,
    );

    return Scrollbar(
      child: lst,
    );

  }
  Map<String,bool> _closed = Map<String,bool>();
  Widget onBuildGroup(BuildContext context, int index) {
//    var groupNaps = StateScriptProject.instance.getStructGroups();
//    var groups = groupNaps.keys.toList();
//    groups.sort();
    var name = groups[index];
    var showName = name;
    if (name == null || name.isEmpty){
      showName = "基本";
    }
    var items = List<Widget>();

//    var dc = BoxDecoration(
//      border:BoxBorder(
//
//      ),
////      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
//    );
    var groupBar = Container(
        padding: EdgeInsets.all(8),
//      decoration: dc,
        color  : Colors.black12,//_opend.containsKey(name)?CommonUtil.alphaColor(Colors.indigo , 32) :Colors.black12,
        height : 48,
        child: Row(

          children: [
            Icon(Icons.group_work , color: _closed.containsKey(name)?Colors.grey:Colors.indigo,),
            SizedBox(width: 16,),
            Text(showName),
          ],
        )
    );
    var inkwell = InkWell(
      onTap: (){
        setState(() {
          if (_closed.containsKey(name)) _closed.remove(name);
          else _closed[name] = true;
        });
      },
      child: groupBar,
    );
    items.add(inkwell);

    if (!_closed.containsKey(name)){
      //打开
      for(var n in groupMaps[name]){
        var nodeItem = getNodeItem(n);
        items.add(nodeItem);
      }
    }

    return Column(
      children: items,
    );
  }
  ObjectClazz _selected ;
  Widget getNodeItem(ObjectClazz n) {
    var name = n.name;
    var item = Container(
        padding: EdgeInsets.all(8),
        color  : _selected == n ?CommonUtil.alphaColor(Colors.red , 32) :Colors.white,
        height: 48,
        child: Row(
          children: [
            SizedBox(width: 32,),
            Icon(Icons.adjust , color: Colors.black,),
            SizedBox(width: 16,),
            Expanded(child:Text(n.getShowStringAndName() , maxLines: 1,)),

//            Draggable(
//              child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.indigo,),
//              feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.indigo,),
//              childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.green,),
//              data:n,
//            ),
          ],
        )
    );
    var inkwell = InkWell(
      onTap: (){
        setState(() {
          _selected = n;
          EventCenter.eventBus.fire(ClazzSelectionChangeEvent(_selected));
        });

      },
      child: item,
    );
    return inkwell;
  }
}