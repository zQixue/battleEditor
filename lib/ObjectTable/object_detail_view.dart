//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/a_object_tag.dart';
import 'package:battlepus/ObjectTable/object_editor.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:theme_provider/theme_provider.dart';

class ObjectDetailView extends StatefulWidget {
  final AObject focusItem;
  final bool allItemCloseThenPop;
  final bool objectTableViewEntry ;
  ObjectDetailView( {Key key , this.focusItem ,this.allItemCloseThenPop = false, this.objectTableViewEntry = false }) : super(key: key);

  @override
  _ObjectDetailViewState createState() => _ObjectDetailViewState();
}

class _ObjectDetailViewState extends State<ObjectDetailView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamSubscription<ObjectFocusEvent> _lis;
  StreamSubscription<GlobalRefreshEvent> _lis2;
  StreamSubscription<ObjectTreeRefreshEvent> _lis3;

  @override
  void dispose() {
    // TODO: implement dispose
    _lis?.cancel();
    _lis2?.cancel();
    _lis3?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<ObjectFocusEvent>().listen((event) {
      var index = OTGlobalBoard.currentObjects.indexOf(event.object);
      // var d = Duration(milliseconds: 10);
      if (index>=0) {
        DefaultTabController.of(_scaffoldKey.currentContext).animateTo(index);
      }
      _currentSelectObject = event.object;
      var d3 = Duration(milliseconds: 320);
      Future.delayed(d3).then((value){
        setState(() {
          EventCenter.eventBus.fire(InspectorRefreshEvent()..object = _currentSelectObject) ;
        });
      });

    });
    // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
    _lis3 = EventCenter.eventBus.on<ObjectTreeRefreshEvent>().listen((event) {
      setState(() {
      });
    });
    _lis2 = EventCenter.eventBus.on<GlobalRefreshEvent>().listen((event) {
      setState(() {

      });

    });
  }

  AObject _currentSelectObject ;
  @override
  Widget build(BuildContext context) {
    // var dc = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    // );
//    var bgClr = const Color.fromARGB(8, 0, 0, 0);
//    var padding = EdgeInsets.all(16);

    var objs = OTGlobalBoard.currentObjects;

    List<Widget> objViews = List<Widget>();
    List<Widget> objTabs = List<Widget>();
    var initIdx = 0;
    int iIndex = 0;

    if (_currentSelectObject == null){
      if (OTGlobalBoard.currentObjects.length>0) {
        _currentSelectObject = OTGlobalBoard.currentObjects[0];
      }
    }
    objs.forEach((obj) {
      if (_currentSelectObject == null){
        _currentSelectObject = obj;
      }
      if (_currentSelectObject == obj){
        initIdx = iIndex;
      }
      iIndex ++;
      var clz = ObjectClazz.getClazz(obj.clazzGuid);
//
//      var dc = new BoxDecoration(
//        border: Border(
// //        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
// //          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
// //          bottom: Divider.createBorderSide(context, color: Colors.indigo, width: 2),
//          top: Divider.createBorderSide(context, color: Colors.indigo, width: 4),
//        ),
// //        color: Colors.indigo, // 底色
//      ); // 圆角度
      bool isFocus = false;//_currentSelectObject == obj;
      var tab = Tab(
//        decoration: initIdx == iIndex ? dc,
//        width: 200,
          child: Row(
              children:[
//                Icon(MaterialCommunityIcons.credit_card_multiple,color:Colors.blue) ,
                Icon(EvilIcons.tag , color: Color(clz.color)),
                // Expanded(child:Text("${obj.getTag()}",style: TextStyle(color: isFocus?ThemeCenter.systemTheme.accentColor:Colors.grey , fontWeight: FontWeight.bold) , maxLines: 1,overflow: TextOverflow.clip)),
                AObjectTag(obj:obj, highlightPattern: null,),
                // Expanded(child:),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(MaterialCommunityIcons.close_box_outline),
                  color: Colors.red,
                  tooltip: "关闭",
                  iconSize: 26,
                  onPressed: (){
                    setState(() {
                      OTGlobalBoard.removeFocusItem(obj);

                      if (widget.allItemCloseThenPop && OTGlobalBoard.currentObjects.length<=0){
                        Navigator.pop(context);
                      }
                    });

                  },
                ),
              ]
          )
      );
//      var ink = InkWell(
//        child: tab,
//        onTap: (){
//          setState(() {
//            _currentSelectObject = obj;
//          });
//        },
//      );
      objTabs.add(tab);
//      dynamic _dc = new BoxDecoration(
//        boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 0.5, spreadRadius: 0.5) , BoxShadow(color: Colors.white)],
//      );

      var scsv = SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          // height: 10240,
          child: ObjectEditor(targetObject: obj,),
        ),
      );

      var tabView = Container(
//          decoration: _dc,
          child  :ListView(
              // physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,

              children:[
//                ObjectEditor(targetObject: obj,)
                scsv,
               SizedBox(height: 300,)
              ]
          )
      );


      objViews.add(tabView);
    });

    var tabViews = TabBarView(
      children: objViews,
    );
//    var textStyle = const TextStyle(
//      color:Colors.black,
//    );
//    var sb = const SizedBox(
//      width: 20,
//    );
    var tabBars = TabBar(
//      controller: TabController(),
      tabs: objTabs
    );

    var dtc = DefaultTabController(
        length: objs.length,
      initialIndex:initIdx,
        child : ThemeConsumer(child :Scaffold(

          // backgroundColor: ThemeCenter.systemTheme.scaffoldBackgroundColor,
          key :_scaffoldKey,
            body:Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        child : tabBars,
                      ),
                    ),
                    widget.objectTableViewEntry?IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(MaterialCommunityIcons.table_edit),
                      color: Colors.indigo,
                      tooltip: "打开对象表",
                      iconSize: 30,
                      onPressed: (){
                        setState(() {
                          Navigator.pop(context);
                          // OTGlobalBoard.appendFocusItem(widget.focusItem);
                          // EventCenter.eventBus.fire(InspectorRefreshEvent()..object = widget.focusItem);
                          Navigator.pushNamed(context, "/ObjectTableMain");
                        });

                      },
                    ):SizedBox(width: 0,),
                  ],
                ),

                Expanded(
                    child: Container(
//                  color :Color.fromARGB(4, 0, 0, 0),
                        child: tabViews
                    )
                ),
              ],
            )
        )

    ));

    return ThemeCenter.block(
      headTitle: "详细",
      // decoration: dc,
      padding: EdgeInsets.all(4),
      child: dtc,
    );
  }
}