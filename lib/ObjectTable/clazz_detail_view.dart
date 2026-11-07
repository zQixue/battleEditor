//@dart=2.11
import 'dart:async';
 
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/clazz_base_info.dart';
import 'package:battlepus/ObjectTable/clazz_field_page.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class ClazzDetailView extends StatefulWidget {
  ClazzDetailView({Key key}) : super(
      key: key);

  @override
  _ClazzDetailViewState createState() =>
      _ClazzDetailViewState(
      );
}

class _ClazzDetailViewState extends State<ClazzDetailView> {
  StreamSubscription<ClazzSelectionChangeEvent> _lis;
  StreamSubscription<GlobalRefreshEvent> _lis1;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
    _lis1?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<ClazzSelectionChangeEvent>().listen((event) {
      setState(() {
        crtNode = event.clazz;
      });
    });

    _lis1 = EventCenter.eventBus.on<GlobalRefreshEvent>().listen((event) {
      setState(() {

      });
    });
  }
  ObjectClazz crtNode;

  @override
  Widget build(BuildContext context) {
    if (crtNode == null){
      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("请在左侧选择一个结点"  , style: TextStyle(fontSize: 48 , color: Colors.grey),),
        ],
      ));

    };
    // var dc = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],
    // );
    var bgClr = const Color.fromARGB(8, 0, 0, 0);
    var padding = EdgeInsets.all(4);
//     var tabViews = TabBarView(
//       children: [
//         Container(padding: padding,color : bgClr,child :ClazzBaseInfo(clazz : crtNode)),
//         Container(color : bgClr,
//           child : LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints){
//               return ClazzFieldPage(clazz : crtNode , fullSize: constraints.maxWidth,);
//             },
//           ),
//         ),
// //        Container(color : bgClr,
// //          child : LayoutBuilder(
// //            builder: (BuildContext context, BoxConstraints constraints){
// //              return InPortPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
// //            },
// //          ),
// //        ),
// //        Container(color : bgClr,
// //          child : LayoutBuilder(
// //            builder: (BuildContext context, BoxConstraints constraints){
// //              return OutPortPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
// //            },
// //          ),
// //        ),
// //        Container(color : bgClr,
// //          child : LayoutBuilder(
// //            builder: (BuildContext context, BoxConstraints constraints){
// //              return InParamPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
// //            },
// //          ),
// //        ),
// //        Container(color : bgClr,
// //          child : LayoutBuilder(
// //            builder: (BuildContext context, BoxConstraints constraints){
// //              return OutParamPage(nodeType : crtNode , fullSize: constraints.maxWidth,);
// //            },
// //          ),
// //        ),
// //        Container(color : bgClr,
// //          child : LayoutBuilder(
// //            builder: (BuildContext context, BoxConstraints constraints){
// //              return SyncStatePage(nodeType : crtNode , fullSize: constraints.maxWidth,);
// //            },
// //          ),
// //        ),
//
// //        Container(padding: padding,color : bgClr,child :InPortPage(nodeType : crtNode)),
//       ],
//     );
    // var textStyle = TextStyle(
    //   color:ThemeCenter.mainTextStepColor(7),
    //
    // );
    // var sb = const SizedBox(
    //   width: 20,
    // );
//     var tabBars = TabBar(
// //      controller: TabController(),
//       tabs: [
//         Tab(child: Row( children:[ Icon(MaterialCommunityIcons.credit_card_multiple,color:Colors.blue) ,sb, Expanded(child:Text("基本信息",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
//         Tab(child: Row( children:[ Icon(MaterialCommunityIcons.focus_field,color:Colors.blue),sb,Expanded(child:Text("属性",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
//
// //        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.arrow_collapse_right,color:Colors.blue),sb,Expanded(child:Text("输入",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
// //        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.arrow_expand_right,color:Colors.blue),sb,Expanded(child:Text("输出",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
// //
// //        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.transfer_right,color:Colors.blue),sb,Expanded(child:Text("参数入口",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
// //        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.function_variant,color:Colors.blue),sb,Expanded(child:Text("参数接口",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
// //        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.cloud_sync,color:Colors.blue),sb,Expanded(child:Text("同步",style: textStyle,maxLines: 1,overflow: TextOverflow.clip))])),
//
// //        Tab(child: Row( children:[ Icon(MaterialCommunityIcons.arrow_collapse_right,color:Colors.blue),sb,Text("输出",style: textStyle)])),
//       ],
//     );

//     var dtc = DefaultTabController(
//         length: 2,
//         child:Column(
//           children: [
//             Container(
//               height: 52,
//               child : tabBars,
//             ),
//             Expanded(
//                 child: Container(
// //                  color :Color.fromARGB(4, 0, 0, 0),
//                     child: tabViews
//                 )
//             ),
//           ],
//         )
//     );

    var bars = ConvexAppBar(
      // 该页自行用 pageIndex 管理页签，没有 DefaultTabController 祖先
      disableDefaultTabController: true,
      height: 42,
      style : TabStyle.textIn,
      // curveSize: 20,
      backgroundColor: ThemeCenter.systemTheme.bottomAppBarColor,
      items: [
        TabItem(icon: MaterialCommunityIcons.code_array, title: '基本信息' ,),
        TabItem(icon: MaterialCommunityIcons.focus_field, title: '字段定义'),
      ],
      initialActiveIndex: pageIndex,//optional, default as 0
      onTap: (int i) {
        setState(() {
          pageIndex = i;
        });
      },
    );

    var pages = [
      Container(color : bgClr,child :ClazzBaseInfo(clazz : crtNode)),
      Container(color : bgClr,
        child : LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints){
            return ClazzFieldPage(clazz : crtNode , fullSize: constraints.maxWidth,);
          },
        ),
      ),
    ];
    return ThemeCenter.area(
      // decoration:dc,
      child:Column(
        children: [
          Expanded(child:pages[pageIndex] ),
          SizedBox(height: 16,),
          bars,

        ],
      )
      // child: bars,
    );
  }
  int pageIndex = 0;

}