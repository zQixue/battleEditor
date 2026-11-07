//@dart=2.11

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/text_editor.dart';

class CanvasToolBar extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onClose;

  CanvasToolBar({Key key,  this.width,  this.height , this.onClose}) : super(key: key);

  @override
  _CanvasToolBarState createState() => _CanvasToolBarState();
}

class _CanvasToolBarState extends State<CanvasToolBar> {


  ScrollController _semicircleController ;//= ScrollController();


  Map<String, List<NodeStructData>> groupNaps;
  List<String> groups;
  bool _opend = false;

  double _w;
  double _h;

  String _filter = "";

  @override
  void dispose() {
    // TODO: implement dispose
    _semicircleController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    _semicircleController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    groupNaps = StateScriptProject.instance.getStructGroups();
    groups = groupNaps.keys.toList();
    groups.sort();

    // if (_opend){
      var dc = new BoxDecoration(
        // color: CommonUtil.alphaColor(Colors.redAccent, 180),
        boxShadow: [ BoxShadow(color: CommonUtil.alphaColor(Colors.grey,128), offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: CommonUtil.alphaColor(Colors.white , 255))],
      );
      double paddingSize = 12;
      _w = widget.width;//min(260, widget.width/2);
      _h = widget.height;
      var c = Container(
        padding: EdgeInsets.all(paddingSize),
        width: _w,
        height: _h,
        child :Container(
          decoration: dc,
          child : getNodeTypeList(),
        ),
      );

      return c;//
      // return Positioned(
      //   left: 0,
      //   top: 0,
      //   child: c,
      // );
    // };
    // return Row(
    //   children: [
    //     IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 44, color: Colors.indigo, tooltip:"添加结点",
    //       onPressed: (){
    //         setState(() {
    //           _opend = true;
    //         });
    //       },
    //     ),
    //   ],
    // );
  }

  Widget getNodeTypeList() {

    var top = Container(
      color: CommonUtil.alphaColor(Colors.indigo, 160),
      padding: EdgeInsets.fromLTRB(4,0,0,0),
      height: 36,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0,0,6,3),
            child: Icon(MaterialCommunityIcons.feature_search , color : Colors.white ,size: 22,),
          ),
          Expanded(child : TextEditor(
            initValue: _filter ,
            textStyle : TextStyle(color: Colors.white , fontSize: 16),
            forceRebuild:false,
            onChanged: (v){
              setState(() {
                _filter = v;
              });
            },
            // onSubmitted: (v){
            //   setState(() {
            //     _filter = v;
            //   });
            // },
          )),
          Container(
            width: 28,
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(MaterialCommunityIcons.close_box_outline),iconSize: 24, color: Colors.white, tooltip:"关闭",
              onPressed: (){
                widget.onClose?.call();
                // setState(() {
                //   // _opend = false;
                // });
              },
            ),
          ),
        ],
      )
    );

    List<Widget> wgroups = List<Widget>();

    for(var i = 0 ; i< groups.length ; ++i){
      var gg = onBuildGroup(context , i);
      if (gg != null) wgroups.add(gg);
    }
    // groups.forEach((element) {
    //   wgroups.add(onBuildGroup(context , ))
    // });

    var nodeTypeLst = ListView(
      controller: _semicircleController,
      // itemCount: groups.length,
      // itemBuilder: onBuildGroup ,
      children: wgroups,
    );


    var ds = DraggableScrollbar.rrect(
      backgroundColor: CommonUtil.alphaColor(Colors.indigo, 180),
      alwaysVisibleScrollThumb: true,
      controller: _semicircleController,
      child: nodeTypeLst,
    );
    return Column(
      children: [
        top,
        Expanded(
          child: ds
        ),
      ],
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
        padding: EdgeInsets.fromLTRB(8, 0 ,0 ,0),
//      decoration: dc,
        color  : CommonUtil.scaleColor(Colors.grey , 0.6),//_opend.containsKey(name)?CommonUtil.alphaColor(Colors.indigo , 32) :Colors.black12,
        height : 36,
        child: Row(

          children: [
            Icon(Icons.group_work , color: _closed.containsKey(name)?Colors.grey:Colors.indigo,),
            SizedBox(width: 16,),
//            Text(showName),
            Expanded(child:Text(showName , overflow: TextOverflow.clip,)),

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
    // items.add(inkwell);
    var filterString = _filter.trim().toLowerCase();
    bool bFilterValid = filterString != null && filterString.trim() != "";

    var nodeItems = List<Widget>();
    if (!_closed.containsKey(name) || bFilterValid){
      //打开
      int iCount = 0;
      for(var n in groupNaps[name]){
        if (bFilterValid){
          if (n.name.toLowerCase().indexOf(filterString)<0 && n.alias.toLowerCase().indexOf(filterString)<0 ){
            continue;
          }
        }
        var nodeItem = getNodeItem(n,iCount++);
        nodeItems.add(nodeItem);
      }
    }
    // if (items.length>0){
    //   items.insert(0, inkwell);
    // }
    // if (nodeItems.length <=0) return null;
    if(DartCommon.isEmpty(_filter)) {
      items.add(inkwell);
    }
    items.addAll(nodeItems);
    return Column(
      children: items,
    );
  }

  NodeStructData _selected ;
  Widget getNodeItem(NodeStructData n , int iIndex) {
    var dcHeader = new BoxDecoration(
        border: new Border.all(color: CommonUtil.scaleColor(Colors.black , 0.5), width: 0.1),
        color: CommonUtil.scaleColor(Colors.indigo , 0.5),//Color(widget.node.getNodeStructType().bgColor),
        borderRadius: new BorderRadius.circular((5.0))
    );
    var w = Container(
      // decoration: dc,
      width: 100,
      height: 36,
      child: Row(
        children: [
          Container(width: 16,height: 16, color: CommonUtil.scaleColor(Color(n.bgColor??0), 0.5),),
          SizedBox(width: 4,),
          Expanded(child:Text(n.getTypeShowString() , style: TextStyle(color: Colors.black , fontSize: 13 , fontWeight: FontWeight.w300), overflow: TextOverflow.clip,maxLines: 1,)),
          Container(
            width: 22,
            child:IconButton(padding:EdgeInsets.all(0),icon: Icon(MaterialCommunityIcons.information,), iconSize: 20,color: Colors.green, tooltip:"结点描述",
              onPressed: (){

                // showDialog(
                //   context: context,
                //   barrierDismissible: true,
                //   builder: (BuildContext context) {
                //     var ch = NodeInfoView(nodeType: n,);
                //     return Dialog(child: ch);
                //   },
                // );
              },
            ),
          ),
        ],
      ),
    );
    var w1 = Container(
      decoration: dcHeader,
      padding: EdgeInsets.fromLTRB(8,0,2,0),
      width: 100,
      height: 42,
      child: Row(
        children: [
          Container(width: 16,height: 16, color: CommonUtil.scaleColor(Color(n.bgColor??0), 0.5),),
          SizedBox(width: 4,),
          Expanded(child:Text(n.getTypeShowString() , style: TextStyle(color: Colors.white , fontSize: 14 , fontWeight: FontWeight.w600 ), overflow: TextOverflow.clip,maxLines: 1,)),
        ],
      ),
    );
    var w3 = Container(
      // decoration: dc,
      width: 100,
      height: 36,
      child: Row(
        children: [
          Container(width: 16,height: 16, color: CommonUtil.scaleColor(Color(n.bgColor??0), 0.5),),
          SizedBox(width: 4,),
          Expanded(child:Text(n.getTypeShowString() , style: TextStyle(color: Colors.red , fontSize: 14 , fontWeight: FontWeight.w300), overflow: TextOverflow.clip,maxLines: 1,)),
        ],
      ),
    );
    var dn = Draggable(
        child: w,//Icon(MaterialCommunityIcons.drawing_box , color: Colors.black45, size: 32,),
        feedback: Material(child:w1),//Icon(MaterialCommunityIcons.drawing_box , color: Colors.indigoAccent,size: 32) ,
        childWhenDragging: w3,//Icon(MaterialCommunityIcons.drawing_box , color: Colors.black45,size: 32),
        data:n
    );
    var item = Container(
        padding: EdgeInsets.fromLTRB(24,0,2,0),
        color  : iIndex %2 ==0 ? Colors.white : CommonUtil.scaleColor(Colors.grey , 0.10),//_selected == n ?CommonUtil.alphaColor(Colors.red , 32) :Colors.white,
        height: 36,
        width: _w,
        child: dn
    );

    return item;
  }
}