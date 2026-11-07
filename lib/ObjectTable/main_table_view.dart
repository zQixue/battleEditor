//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/ObjectTable/a_clazz_type_selector.dart';
import 'package:battlepus/ObjectTable/a_object_canvas_view.dart';
import 'package:battlepus/ObjectTable/a_object_tag.dart';
import 'package:battlepus/ObjectTable/item_tree_view.dart';
import 'package:battlepus/ObjectTable/o_t_grid_cell.dart';
import 'package:battlepus/ObjectTable/object_detail_view.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'package:battlepus/common/filter_bar.dart';
import 'package:battlepus/common/free_grid.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
// import 'package:show_up_animation/show_up_animation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
// import 'package:expressions/expressions.dart';

class MainTableView extends StatefulWidget {
  final bool gridMode;
  MainTableView({Key key , this.gridMode = false}) : super(key: key);

  @override
  _MainTableViewState createState() => _MainTableViewState();
}

class _MainTableViewState extends State<MainTableView> {

  StreamSubscription<ObjectTreeRefreshEvent> _lis;
  StreamSubscription<GlobalRefreshEvent> _lis1;
  StreamSubscription<AObjectTableCleared> _lis6;

  StreamSubscription<ObjectTableLoadedEvent> _lis7;

  Map<String , bool> _isOpenMap = Map<String , bool>();
  CanvasHolder holder = CanvasHolder();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
    _lis1?.cancel();
    _lis6?.cancel();
    _lis7?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _lis = EventCenter.eventBus.on<ObjectTreeRefreshEvent>().listen((event) {
    //   setState(() {
    //     forceBuildTree();
    //   });
    // });
    _lis6 = EventCenter.eventBus.on<AObjectTableCleared>().listen((event) {
      setState(() {
        _selectClazz = null;
        focusItem = null;
        _selectedLine = null;
      });
    });
    _lis1 = EventCenter.eventBus.on<GlobalRefreshEvent>().listen((event) {
      setState(() {
        forceBuildTree();
      });
    });

    _lis7 = EventCenter.eventBus.on<ObjectTableLoadedEvent>().listen((event) {
      setState(() {
        forceBuildTree();
        loadDefault();
      });
    });

    // Future.delayed(Duration(milliseconds: 20)).then((value) {
    //   //加载默认表格
    //   loadDefault();
    // });
  }


  void loadDefault() {

    var defaultClazz = ObjectTableProject.instance.clazzes.firstWhere((element){
      return element.isDefaultClazz;
    },orElse:()=>null);

    if (defaultClazz != null) {
      _selectClazz = defaultClazz;
      showList = true;
      // forceBuildTree();
      EventCenter.eventBus.fire(ObjectTreeRefreshEvent()..clazz = _selectClazz);
    }
  }

  bool showList = true;

  // bool _gridMode = false;
  @override
  Widget build(BuildContext context) {
    if (!widget.gridMode) {
      var bdWidth = 4.0;
      // print("build AObjectCanvasView $focusItem");
      var canvas = AObjectCanvasView(rootObject: focusItem,canvasHolder: holder,withItemList: showList,);

      var anim = Container(
          padding: EdgeInsets.fromLTRB(2, 4, 0, 4),
          width: 320,
          // height: b.maxHeight,
          child: getItemTree()
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showList) getClassTabs(),
          Expanded(child:LayoutBuilder(
            builder: (a,b) {
              return Stack(
                children: [
                  Container(width: b.maxWidth ,height: b.maxHeight, child:canvas),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showList)anim,
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                        width: 40,
                        child: getRightSideBar(),
                      ),
                    ],
                  ),

                ],
              );
            },
          )),
        ],
      );

      return Stack(
        children: [

          getClassTabs(),
          if (showList) LayoutBuilder(
            builder: (a,b){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: b.maxWidth ,height: b.maxHeight, child:canvas),
                  Expanded(child: Container(
                    padding: EdgeInsets.fromLTRB(2, 4, 4, 4),
                    width: 320,
                    // height: b.maxHeight,
                    child: getItemTree()),
                  )
                ]);
            },
          ),

          // if (showList)LayoutBuilder(
          //   builder: (a,b){
          //     return Container(
          //       width: b.maxWidth / 4,
          //       height: b.maxHeight,
          //       child: getItemTree(),
          //     );
          //   },
          // ),
          // if (showList)getItemTree(),
        ],
      );

      return Container(
          child:Column(
            crossAxisAlignment : CrossAxisAlignment.start,
            children: [
              getClassTabs(),
              Expanded(
                child:Padding(
                  padding: EdgeInsets.fromLTRB(2,2,2,2),
                  child: Row(
                    children: [
                      // Expanded(flex: 2 , child : getClassTree()),
                      _selectClazz != null ? Expanded(flex: 3 , child: Column(
                        children: [
                          getAClassShowTab(_selectClazz),
                          SizedBox(height: 2,),
                          Expanded(flex: 3 , child : getItemTree()),
                        ],
                      ),):Expanded(flex: 3 , child : getItemTree()),
                      if (focusItem != null) getRightSideBar(),
                      Expanded(flex: 16 , child : ThemeCenter.area(

                          leftBorderWidth:0,
                          rightBorderWidth:bdWidth,
                          topBorderWidth:bdWidth,
                          bottomBorderWidth:bdWidth,
                          // padding : EdgeInsets.all(bdWidth) ,
                          child:canvas)),

                    ],
                  ),
                ),

              )
            ],
          )
      );

      // return Container(
      //   child: Row(
      //     children: [
      //       Expanded(flex: 2 , child : getClassTree()),
      //       Expanded(flex: 16 , child : getGridPanel()),
      //     ],
      //   ),
      // );
      //
      // return AObjectCanvasView();
    }
    return Container(
      child:Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          getClassTabs(),
          Expanded(
            child:Padding(
              padding: EdgeInsets.fromLTRB(2,2,2,2),
              child: Row(
                children: [
                  // Expanded(flex: 2 , child : getClassTree()),
                  _selectClazz != null ? Expanded(flex: 3 , child: Column(
                    children: [
                      getAClassShowTab(_selectClazz),
                      SizedBox(height: 2,),
                      Expanded(flex: 3 , child : getItemTree()),
                    ],
                  ),):Expanded(flex: 3 , child : getItemTree()),

                  Expanded(flex: 16 , child : getDetailPanel()),
                ],
              ),
            ),

          )
        ],
      )
    );
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
    _objectRootNR = true;

    if (_selectClazz!= null) {
      filterdObjects = _selectClazz.table.objects;
    }
  }
  ObjectClazz _selectClazz ;

  Widget getClassTabs() {
    var clzs = ObjectTableProject.instance.clazzes;
    List<Widget> ws = List<Widget>();

    clzs.forEach((element) {
      if (element.showOnNavigatorBar||_selectClazz == element) {
        ws.add(getAClassTab(element));
      }
    });
    ws.add(AClazzTypeSelector(
      onChanged: (v){
        var clazz = ObjectTableProject.instance.clazzMap[v];
        if (clazz != null){
          _selectClazz = clazz;
          showList = true;
          doFocusItem(null);
          EventCenter.eventBus.fire(ObjectTreeRefreshEvent()..clazz = _selectClazz);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
      },
    ));
    return Padding( padding: EdgeInsets.fromLTRB(2,2,2,0), child: Wrap(children: ws,spacing:2));
    // return Container( height : 100,child:Wrap(children: ws,));
  }

  Widget getAClassShowTab(ObjectClazz clz){
    var color = CommonUtil.changeColorLightness(Color(clz.color),0.2);
    var colorBd = CommonUtil.changeColorLightness(color, 0.7);
    // var isSelect = _selectClazz == clz;
    // var styleSelect = TextStyle(color: Colors.cyanAccent , fontSize: 16, fontWeight:  FontWeight.w400);
    var aw = ThemeCenter.roundRect(
      child: Center(child:Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(MaterialCommunityIcons.ballot,color: CommonUtil.changeColorLightness(Color(clz.color),0.7),size: 35,),
          Text(clz.getTypeShowString() , style:  ThemeCenter.mainTextStyle(step: 8 ,fontSize: 24 , fontWeight: FontWeight.w600),),
        ],
      )),

      padding: EdgeInsets.fromLTRB(4,4,4,4),
      radius: 2,
      height: 52,
      bgColor: color,//CommonUtil.changeColorLightness(color,0.4),
      borderColor: colorBd,
      borderWidth: 4,
    );

    return aw;
  }
  Widget getAClassTab(ObjectClazz clz){
    var color = CommonUtil.changeColorLightness(Color(0xFF666666),0.2);//clz.color);

    var isSelect = _selectClazz == clz;
    if (isSelect) color = CommonUtil.changeColorLightness(Color(0xFF0099CC),0.2);
    var colorBd = CommonUtil.changeColorLightness(color, 0.5);
    var styleSelect = TextStyle(color: Colors.cyanAccent , fontSize: 16, fontWeight:  FontWeight.w400);
    var aw = ThemeCenter.roundRect(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(MaterialCommunityIcons.ballot,color: CommonUtil.changeColorLightness(Color(clz.color),0.7),size: 18,),
          Text(clz.getTypeShowString() , style: ThemeCenter.mainTextStyle(step: 8 ,fontSize: 16 ),),
        ],
      ),
      padding: EdgeInsets.fromLTRB(4,4,4,4),
      radius: 3,
      height: 36,
      bgColor: color,//CommonUtil.changeColorLightness(color,0.4),
      borderColor: colorBd,
      borderWidth: 2,
    );

    return InkWell(
      child: aw,
      onTap: (){
        setState(() {
          _selectClazz = clz;
          showList = true;
          // forceBuildTree();
          EventCenter.eventBus.fire(ObjectTreeRefreshEvent()..clazz =_selectClazz);
          // if (_selectClazz!= null) {
          //   filterdObjects = _selectClazz.table.objects;
          // }
        });
      },
    ) ;
  }

  Widget getClassTree() {
    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ObjectClazz>).id;
      },
      indent: 16,
      root : getClassTreeRoot(),
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<ObjectClazz>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<ObjectClazz>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = _selectClazz == si;//(_selectedStrings[si.guid] != null);

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
            forceBuildTree();
          });
        }
      },

      actions: [
      ],
    );
    return ThemeCenter.block(headTitle: "类型列表",child: con , headHeight: widget.gridMode ? 38:28);
    return con;//CommonUtil.standardContainer(child: con);
  }

  ATreeNode<AObject> _objectRoot;
  bool _objectRootNR = false;
  ATreeNode<AObject> getObjectTreeRoot(){
    if (_objectRoot == null || _objectRootNR){
      var scripts = _selectClazz.table.objects;//StateScriptProject.instance.scripts.where((element) => false == element.isModule).toList();
      // print("element count 2 : ${scripts.length}");
      _objectRoot = DartCommon.buildTree(scripts, (item){

        var id = (item as AObject).group ??"";
        var sp = id.split("/");
        if (sp.length>0) {
          return sp;
        }
        return [];
      });
    }
    _objectRootNR = false;
    return _objectRoot;
  }
  AObject focusItem;
  void doFocusItem(AObject item){
    if(focusItem != item) {
      focusItem = item;

    }
    EventCenter.eventBus.fire(InspectorRefreshEvent()..object = focusItem);
    EventCenter.eventBus.fire(ObjectFocusEvent()..object = focusItem);
    if (item != null) {
      OTGlobalBoard.focusItem(focusItem);
    }

  }
  Widget getItemTree() {

    return ItemTreeView(
      clazz: _selectClazz,
      onFocusChanged: (v){
        focusItem = v;
      },
    );

    if (_selectClazz == null){
      return ThemeCenter.block(headTitle: "对象列表",child: Container());
    }
    int iCount = 0;
    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      itemExtent: 36,
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<AObject>).id;
      },
      indent: 16,
      root : getObjectTreeRoot(),
      intervalColor : CommonUtil.alphaColorD(Colors.blueGrey, 0.05),
      onBuildItem: (node,expanded , highlightPattern){
        // print(highlightPattern);
        var agent = node as ATreeNode<AObject>;
        if (agent.isLeaf) {

          var bgColor = iCount%2 ==0 ? ThemeCenter.systemTheme.scaffoldBackgroundColor:CommonUtil.alphaColorD(Colors.blueGrey, 0.05) ;
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<AObject>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = focusItem == si;//(_selectedStrings[si.guid] != null);
          var clz = ObjectClazz.getClazz(si.clazzGuid);
          // var txt = Text(si.getTag(), overflow: TextOverflow.ellipsis, maxLines: 1 , style: ThemeCenter.mainTextStyle(step: 8,fontSize: 14));
          var iconSize = 28.0;
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : null,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(4,4,10,4),
                  child: Row(
                    children: [
                      AObjectTag(obj: si, highlightPattern: highlightPattern,),
                      // Container(width:24 , height:24,child:IconButton(
                      //   padding: EdgeInsets.all(0),
                      //   icon: Icon(MaterialCommunityIcons.tab_plus),
                      //   color: Colors.blueAccent,
                      //   tooltip: "新标签页打开",
                      //   iconSize: 20,
                      //   onPressed: (){
                      //     setState(() {
                      //       OTGlobalBoard.appendFocusItem(si);
                      //       // forceBuildTree();
                      //     });
                      //
                      //   },
                      // )),
                      if (selected) Container(width:24 , height:24,child:IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(MaterialCommunityIcons.shape_square_plus),
                        color: Colors.green,
                        tooltip: "复制实例",
                        iconSize: 24,
                        onPressed: (){
                          setState(() {
                            var newItem = cloneObject(si);
                            clz.table.addExistObject(newItem);
                            _isOpenMap[newItem.guid] = true;
                            doFocusItem(newItem);
                            newItem.buildTag(clz.getAllTagFields());
                            forceBuildTree();
                          });
                        },
                      )),
                      if (selected) Container(width:24 , height:24,child:IconButton(
                        padding: EdgeInsets.fromLTRB(0,1.5,0,0),
                        icon: Icon(MaterialCommunityIcons.minus_box_outline),
                        color: Colors.redAccent,
                        tooltip: "删除实例",
                        iconSize: 24,
                        onPressed: (){
                          CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                            setState(() {
                              OTGlobalBoard.removeFocusItem(si);
                              // clz.table.objects.remove(si);
                              clz.table.deleteObject(si);
                              if (focusItem == si){
                                focusItem = null;
                                doFocusItem(null);
                              }

                              forceBuildTree();

                            });
                          });
                        },
                      )),
                      SizedBox(width: 4,)
                    ],
                  )
              )
          );
          // return txt;
          var con2 = Padding(
            padding: EdgeInsets.all(1),
            child: con,
          );
          // var te = Draggable(
          //   child: con,
          //   feedback: Material(child:con),
          //   childWhenDragging: con,
          //   data: si,
          // );

          return InkWell(
            onTap: (){
              setState(() {
                doFocusItem(si);
              });
            },
            child: con2,
          );// con;
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?5:2 ,fontSize: 12));
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
        var ns  = node as ATreeNode<AObject>;
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

      // onSortLeaf: (a,b){
      //   return (a as ATreeNode<AObject>).data.guid.compareTo((b as ATreeNode<AObject>).data.guid);
      // },

      onItemTap: (item){
        // var a = item as ATreeNode<AObject>;
        // if (a != null && a.data != null) {
        //   setState(() {
        //     _selectClazz = a.data;
        //   });
        // }
      },

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(MaterialCommunityIcons.plus_box_outline),
          color : Colors.green,
          tooltip: "添加实例",
          iconSize: 28,
          onPressed: (){
            setState(() {

              var newItem = _selectClazz.table.addObject();
              _isOpenMap[newItem.guid] = true;
              doFocusItem(newItem);
              forceBuildTree();

            });

          },
        )
      ],
    );
    return ThemeCenter.block(headTitle: "对象列表",child: con,
      // actions: [
      //   ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_left_bold_box_outline,
      //     onPressed: (){
      //       setState(() {
      //         showList = false;
      //       });
      //     }
      //   )
      // ]
    );
  }

  AObject cloneObject(AObject obj) {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(obj);
    JsonDecoder dec = JsonDecoder();
    AObject data = AObject.fromJson(dec.convert(json));
    data.name = data.name + " [clone]";
    data.guid = Uuid().v4();
    return data;
  }


  Widget getDetailPanel() {
    return ObjectDetailView(focusItem : focusItem);
  }

  AObject _selectedLine;

  List<AObject> filterdObjects = List<AObject>();

  Widget getGridPanel() {
    if (_selectClazz == null){
      return Container();
    }

    var fieldWidths = _selectClazz.getAllGridWidths();
    fieldWidths.insert(0, 128);
    fieldWidths.insert(1, 256);
    var fieldNames = _selectClazz.getAllFieldNames();
    fieldNames.insert(0, "ID");
    fieldNames.insert(1, "标签");
    // print(fieldNames);
    var gridFields = _selectClazz.getAllFields();
    gridFields.insert(0, null);
    gridFields.insert(1, null);
    var actions = Row(

      children: [
        Container(
          width: 500,
          child: FilterBar<AObject>(
            inputObjects: _selectClazz.table.objects,
            onGetFilterTarget: (obj){
              print("`${obj.name}`${obj.guid.hashCode}");
              return "`${obj.name}`${obj.guid.hashCode}";
            },
            onFilterResult: (res){
              setState(() {
                filterdObjects = res;
                // print(filterdObjects);
              });
            },
          ),
        ),
        SizedBox(width:16),
        ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,
          width: 24, height :24,
          color : Colors.green,
          tooltip: "添加实例",
          onPressed: (){
            setState(() {
              example_1();
              var newItem = _selectClazz.table.addObject();
              _isOpenMap[newItem.guid] = true;
              doFocusItem(newItem);
              forceBuildTree();
            });

          },
        ),
        if (_selectedLine != null) ThemeCenter.iconBtn(MaterialCommunityIcons.shape_square_plus,
          width: 24, height :24,
          color : Colors.green,
          tooltip: "复制实例",
          onPressed: (){
            setState(() {
              var newItem = cloneObject(_selectedLine);
              _selectClazz.table.addExistObject(newItem);
              _isOpenMap[newItem.guid] = true;
              doFocusItem(newItem);
              forceBuildTree();
            });
          },
        ),
        if (_selectedLine != null) ThemeCenter.iconBtn(MaterialCommunityIcons.minus_box_outline,
          width: 24, height :24,
          color : Colors.redAccent,
          tooltip: "删除实例",
          onPressed: (){
            CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
              setState(() {
                OTGlobalBoard.removeFocusItem(_selectedLine);
                // _selectClazz.table.objects.remove(_selectedLine);
                _selectClazz.table.deleteObject(_selectedLine);

                // EventCenter.eventBus.fire(event)
                _selectedLine = null;
                forceBuildTree();

              });
            });

          },
        ),
      ],
    );
    var topBar = ThemeCenter.area(height: 38 , panelColor: ThemeCenter.systemTheme.primaryColor , child: actions , padding: EdgeInsets.fromLTRB(4,0,4,0));
    var grid = FreeGrid (
      // selectColor: Colors.green,
      onResizeColumn: (widths){
        // _selectedFile.file.segmentWidths = widths;
        for(var i = 0 ; i < widths.length ; ++i){
          var f = gridFields[i];
          if (f != null) {
            f.gridWidth = widths[i].toInt();
          }
        }
      },
      headerNames: fieldNames,
      // headResizable: false,
      headerWidthMin: 120,
      headerWidthMax: 3200,
      headerWidths: fieldWidths,
      headerHeight: 29,
      itemHeight: 36,
      itemCount: filterdObjects.length,
      onTap: (index){
        setState(() {
          _selectedLine = filterdObjects[index];
        });
      },
      onGetHeaderActions: (index){
        List<Widget> headerActions = [
        ];
        return headerActions;
      },
      onGetItemKey: (index){
        return filterdObjects[index].guid;
      },
      cellBorderColor:CommonUtil.alphaColorD(Colors.grey, 0.4),
      onGetBorder: (index){
        if (_selectedLine == filterdObjects[index]){
          return BoxDecoration(
              color : CommonUtil.alphaColorD(Colors.green,0.2),
              border : Border(
                bottom: BorderSide(width: 1.5,color: CommonUtil.alphaColorD(Colors.green,0.5)),
                top: BorderSide(width: 1.5,color: CommonUtil.alphaColorD(Colors.green,0.5)),
                left: BorderSide(width: 1.0,color: CommonUtil.alphaColorD(Colors.green,0.5)),
                right: BorderSide(width: 1.0,color: CommonUtil.alphaColorD(Colors.green,0.5)),
              )
            // border: new Border.all(
            //   width: 2.0,
            //   color: CommonUtil.scaleColor(Colors.indigo,0.3),
            // ),
            // boxShadow: [ BoxShadow(color: Color(0xd5dcea), offset:Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
          );
        }
        return null;
      },
      onItemBuilder:(i,j){
        // var con = SegmentView(
        //   segment: _selectedFile.file.lines[i].segments[j],
        //   deleteMode: deleteMode,
        //   copyMode: copyMode,
        // );
        var nowEi = EditorLevelInfo()..level = 0;
        nowEi.openedMap = {};
        nowEi.lineWidth = fieldWidths[j];
        nowEi.isObjectTableMode = true;
        // nowEi.lineHeight = _objectLineHeight;
        // nowEi.spaceStep = _hearWidth ;

        var obj = filterdObjects[i];
        var field = gridFields[j];
        return OTGridCell(
          clazz: _selectClazz,
          object: obj,
          fieldInfo: field,
          index: j,
        );
//         if (field == null){
//           if (j == 0){
//             return Container(
//                 padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
//                 child: Center(child:Text("${obj.guid.hashCode}" ,style: ThemeCenter.mainTextStyle(step: 6 , fontSize: 13))),
//             );
//           }
//           if (j == 1){
//             var fi = SSFieldType.getFieldType("___string___" ,fieldInfo: null);
//             var gci = GridCellInfo()..isObjectTableMode = true..name = "";
//             var edth = fi.getGridCellEditor(
//               initValue: obj.name??"",
//               onChanged: (v){
//                 // obj.setFieldValue(field.guid,v,field.getTypeShowString());
//                 obj.name = v;
//               },
//               onSubmitted: (v){
//                 setState(() {
//                   // obj.setFieldValue(field.guid,v,field.getTypeShowString());
//                   obj.name = v;
//                   // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
//                 });
//               },
//               gci : gci,
//               // levelInfo : nowEi ,
//               context:context,
//             );
//             // var oh = edth.height;
//             var edt = edth.widget;
//             return Container(
//                 padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
//                 child:edt
//             );
//           }
//         }
//         var gci = GridCellInfo()..isObjectTableMode = true..name = field.getTypeShowString();
//
//
//         // print(field.name);
//         var fi = SSFieldType.getFieldType(field.typeGuid ,fieldInfo: field);
//         if (fi == null){
//           //可能枚举被删
//           return  Container(
//               padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
//               child:Center(child:Text("请检查是否丢失枚举" , style: TextStyle(color: Colors.red)))
//           );
//         }
//         EditorHolder edth;
//         if (DartCommon.isEmpty(field.func)) {
//           edth = fi.getGridCellEditor(
//
//             initValue: obj.getFieldValue(field.guid),
// //        item.name,
//             onChanged: (v) {
//               obj.setFieldValue(field.guid, v, field.getTypeShowString());
//
//               if (calculateFuncs(_selectClazz,obj)){
//                 // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
//               }
//             },
//             onSubmitted: (v) {
//               // setState(() {
//               //   obj.setFieldValue(field.guid, v, field.getTypeShowString());
//               //   // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
//               // });
//             },
//             gci: gci,
//             // levelInfo : nowEi ,
//             context: context,
//           );
//         }
//         else{
//           edth = EditorHolder()..widget = Container(
//             // padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
//             // width: ei?.lineWidth,
//             // height: ei?.lineHeight,
//             child: Center(child:Text(fi.parseValue(obj.getFieldValue(field.guid)).toString(), style : TextStyle(color:Colors.yellowAccent))),
//         );
//         }
//
//         // var oh = edth.height;
//         var edt = edth.widget;
//
//         // var con = Container(height : 44,);
//         return Container(
//           padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
//           child:edt
//         );
      },

      onReorder: (iOld , iNew){
        // setState(() {
        //
        // });
        // var v = _selectedFile.file.lines.removeAt(iOld);
        // _selectedFile.file.lines.insert(iNew, v);
      },
    );

    return Column(
      crossAxisAlignment : CrossAxisAlignment.start,
      children: [
        topBar,
        Expanded(child:grid),
      ],
    );
  }
  bool calculateFuncs(ObjectClazz clz , AObject item){

    // bool res = false;
    // Map<String,dynamic> context = {'clz': clz.name,};
    // for (var field in clz.fields){
    //   var fv = item.getFieldValue(field.guid);
    //   print(field.name);
    //   var fi = SSFieldType.getFieldType(field.typeGuid ,fieldInfo: field);
    //   if (fi == null){
    //     continue ;
    //   }
    //   context[field.name] = fi.parseValue(fv);
    // }
    //
    // for (var field in clz.fields){
    //   if (DartCommon.isEmpty(field.func)) continue;
    //   var expression = Expression.parse(field.func);
    //   // print("exp = $expression");
    //   final evaluator = const ExpressionEvaluator();
    //   var r = evaluator.eval(expression, context);
    //   // print("result = $r");
    //   item.setFieldValue(field.guid, r ,field.getTypeShowString());
    //   // context[field.name] = fi.parseValue(fv);
    //   res = true;
    // }

    // return res;
  }
  // Example 1: evaluate expression with default evaluator
  void example_1() {
    // // // Parse expression:
    // // var expression = Expression.parse('cos(x)*cos(x)+sin(x)*sin(x)==1');
    // //
    // // // Create context containing all the variables and functions used in the expression
    // // var context = {'x': pi / 5, 'cos': cos, 'sin': sin};
    // // Parse expression:
    // var expression = Expression.parse('haha + nana');
    //
    // // Create context containing all the variables and functions used in the expression
    // var context = {'haha': "721", 'nana': '你好'};
    //
    // // Evaluate expression
    // final evaluator = const ExpressionEvaluator();
    // var r = evaluator.eval(expression, context);
    //
    // print("result : $r"); // = true
  }

  Widget getRightSideBar() {
    var mode = ThemeCenter.iconBtn(MaterialCommunityIcons.layers_outline,
        width: 32, height :32,
        color: OTDefines.editMode?Colors.blue:Colors.white,
        tooltip: OTDefines.editMode?"布局模式":"编辑模式",
        onPressed: (){
          setState(() {
            OTDefines.editMode = !OTDefines.editMode;
            EventCenter.eventBus.fire(AObjectForceChanged()..obj = focusItem);
          });

        }
    );

    var lstBtn = ThemeCenter.iconBtn( showList? MaterialCommunityIcons.arrow_left_bold_box_outline:MaterialCommunityIcons.arrow_right_bold_box_outline,
        width: 32, height :32,
        color: showList?Colors.redAccent:Colors.white,
        tooltip: showList?"关闭对象列表":"打开对象列表",
        onPressed: (){
          setState(() {
            showList = !showList;
          });

        }
    );

    if (!OTDefines.editMode){
      return ThemeCenter.area(
          leftBorderWidth: 2, topBorderWidth: 4, bottomBorderWidth: 4,
          // padding: EdgeInsets.fromLTRB(4, 8, 8, 4),
          width: 48,
          child: Column(
            children: [
              lstBtn,
              mode
            ],
          )
      );
    }


    return ThemeCenter.area(
      leftBorderWidth: 2, topBorderWidth: 4, bottomBorderWidth: 4,
      // padding: EdgeInsets.fromLTRB(4, 8, 8, 4),
      width: 48,
      child: Column(
        children: [
          lstBtn,
          mode,
          ThemeCenter.iconBtn(MaterialCommunityIcons.group,
            width: 32, height :32,
            tooltip: "合并组",
            onPressed: (){
              if (focusItem == null) return ;
              List<String> fields = List<String>();
              var clz = focusItem.getClazz();
              clz.fieldsLayouts.forEach((key, value) {
                if (value.selected??false){
                  fields.add(key);
                }
              });
              if (fields.length <=0){
                BotToast.showText(text: "请选中字段",contentColor: Colors.redAccent);
                return ;
              }
              clz.combineGroup(fields);

              EventCenter.eventBus.fire(AObjectForceChanged()..obj = focusItem);
            }
          ),
          ThemeCenter.iconBtn(MaterialCommunityIcons.ungroup,
              width: 32, height :32,
              tooltip: "从组拆分",
              onPressed: (){
                if (focusItem == null) return ;
                List<String> fields = List<String>();
                var clz = focusItem.getClazz();
                clz.fieldsLayouts.forEach((key, value) {
                  if (value.selected??false){
                    fields.add(key);
                  }
                });
                if (fields.length <=0){
                  BotToast.showText(text: "请选中字段",contentColor: Colors.redAccent);
                  return ;
                }
                clz.uncombineGroup(fields);
                EventCenter.eventBus.fire(AObjectForceChanged()..obj = focusItem);
              }
          ),
          ThemeCenter.iconBtn(MaterialCommunityIcons.subtitles,
              width: 32, height :32,
              tooltip: "关闭 title",
              onPressed: (){
                if (focusItem == null) return ;
                // List<String> fields = List<String>();
                var clz = focusItem.getClazz();
                clz.fieldsLayouts.forEach((key, value) {
                  if (value.selected??false){
                    value.showTitle = false;
                    EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = key);
                  }
                });
              }
          ),
          ThemeCenter.iconBtn(MaterialCommunityIcons.subtitles_outline,
              width: 32, height :32,
              tooltip: "打开 title",
              onPressed: (){
                if (focusItem == null) return ;
                // List<String> fields = List<String>();
                var clz = focusItem.getClazz();
                clz.fieldsLayouts.forEach((key, value) {
                  if (value.selected??false){
                    value.showTitle = true;
                    EventCenter.eventBus.fire(AFieldTransformChanged()..fieldGuid = key);
                  }
                });
              }
          ),

          ThemeCenter.iconBtn(MaterialCommunityIcons.text_shadow,
              width: 32, height :32,
              tooltip: "添加文本",
              onPressed: (){
                if (focusItem == null) return ;
                var clz = focusItem.getClazz();
                var d = clz.addDecoration();
                var centerPos = holder.canvasState.currentCenterPosition();
                var pos = Offset(centerPos.dx - OTDefines.canvasZeroX,centerPos.dy - OTDefines.canvasZeroY);
                pos = OTDefines.fixPosition(pos);
                var fl = clz.getFieldLayout(d);
                fl.x = pos.dx;
                fl.y = pos.dy;
                EventCenter.eventBus.fire(AObjectChanged()..obj = focusItem);
                EventCenter.eventBus.fire(AObjectForceChanged()..obj = focusItem);
                BotToast.showText(text: "文本已添加",contentColor: Colors.green);
                clz.rebuildAllFields();
              }
          ),
          ThemeCenter.iconBtn(MaterialCommunityIcons.content_copy,
              width: 32, height :32,
              tooltip: "复制布局",
              onPressed: (){
                if (focusItem == null) return ;
                var clz = focusItem.getClazz();
                OTDefines.copyObjectClazz = clz;
                BotToast.showText(text: "布局已复制",contentColor: Colors.green);
              }
          ),

          ThemeCenter.iconBtn(MaterialCommunityIcons.content_paste,
              width: 32, height :32,
              tooltip: "黏贴布局",
              onPressed: (){
                if (OTDefines.copyObjectClazz == null) return ;
                if (focusItem == null) return ;
                var clz = focusItem.getClazz();
                clz.cloneLayout(OTDefines.copyObjectClazz);
                // OTDefines.copyObjectClazz = clz;
                EventCenter.eventBus.fire(AObjectForceChanged()..obj = focusItem);
                BotToast.showText(text: "布局已黏贴",contentColor: Colors.green);
              }
          ),
        ],
      )
    );
  }
}
