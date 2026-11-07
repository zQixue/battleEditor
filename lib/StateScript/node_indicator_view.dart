//@dart=2.11

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/NodeGroup.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/common/text_editor.dart';

class NodeIndicatorView extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onClose;
  NodeIndicatorView({Key key,this.width,  this.height , this.onClose}) : super(key: key);

  @override
  _NodeIndicatorViewState createState() => _NodeIndicatorViewState();
}

class _NodeIndicatorViewState extends State<NodeIndicatorView> {

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

    // groupNaps = StateScriptProject.instance.getStructGroups();
    // groups = groupNaps.keys.toList();
    // groups.sort();
    // double topSpace = 0;
    // if (_opend){
      var dc = new BoxDecoration(
        // color: CommonUtil.alphaColor(Colors.redAccent, 180),
        boxShadow: [ BoxShadow(color: CommonUtil.alphaColor(Colors.grey,128), offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: CommonUtil.alphaColor(Colors.white , 255))],
      );
      double paddingSize = 12;
      _w = widget.width;
      _h = widget.height;
      var c = Container(
        padding: EdgeInsets.all(paddingSize),
        width: _w,
        height: _h,
        child :Container(
          decoration: dc,
          child : getAllList(),
        ),
      );

      return c;
      // return Positioned(
      //   left: 0,
      //   top: 0,
      //   child: c,
      // );
    // };
    // return Row(
    //   children: [
    //     SizedBox(width: 50,),
    //     IconButton(icon: Icon(MaterialCommunityIcons.map_search_outline),iconSize: 44, color: Colors.indigo, tooltip:"查找列表",
    //       onPressed: (){
    //         setState(() {
    //           _opend = true;
    //         });
    //       },
    //     ),
    //   ],
    // );
  }

  List<StateScriptNode> _nodes = List<StateScriptNode>() ;
  // List<NodeGroup> _nodeGroups = List<NodeGroup>() ;
  Widget getAllList() {

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
                  //   _opend = false;
                  // });
                },
              ),
            ),
          ],
        )
    );

    List<Widget> ws = List<Widget>();
    var filterValue = _filter?.toLowerCase()?.trim();
    int iCount = 0;
    var groups = ScriptInfo.current.scriptData.nodeGroups;
    // _nodeGroups.clear();
    // _nodeGroups.addAll(groups);
    // _nodeGroups.sort((a,b){ return a??0 - b.backgroundColor??0; });

    var filterLst = buildFilter(filterValue);

    for(var g in groups){
      if (g.currentGroupRect == null){

        continue;
      }
      if (passFilter(g.name,filterLst)){
        // print("group : ${g.name}");
        ws.add(onBuildGroup(context , g, ++iCount));
      }
    }

    var nodes = ScriptInfo.current.scriptData.nodes;
    _nodes.clear();
    _nodes.addAll(nodes);
    //_nodes.sort((a,b){ return a.getNodeStructType().guid.hashCode - b.getNodeStructType().guid.hashCode; });
    _nodes.sort((a,b){return a.exportId - b.exportId;});

    List<StateScriptNode> filtered = List<StateScriptNode>();
    for(var i = 0 ; i< _nodes.length ; ++i) {
      var n = _nodes[i];
      var tp = n.getNodeStructType();
      var g = ScriptInfo.current.scriptData.getGroup(n.group);
      if (passFilter(tp.name,filterLst)|| passFilter(tp.alias,filterLst) ||
          passFilter(g?.name??"" , filterLst) ||passFilter(n.fullString()??"",filterLst)||passFilter("${n.exportId}??""" , filterLst) ||passFilter(n.description, filterLst) ){
        // ws.add(onBuildNode(context , n, ++iCount));
        filtered.add(n);
      }
      else{
        var funcFields = tp.getFieldsByTypeGuid("___agentfunction___");
        if (funcFields != null){
          for(var funcField in funcFields) {
            var afi = n.fieldValues[funcField.guid];
            if (afi == null) continue;
            var fv = afi?.value;
            if (fv != null) {
              var func = StateScriptProject.instance.getFunction(fv);
              if (func != null) {
                var code = func.getBlockBehavicCode();
                if (passFilter(code,filterLst)){
                  filtered.add(n);
                  break;
                }
              }
            }
          }
        }
      }
    }




    // for(var i = 0 ; i< groups.length ; ++i){
    //   ws.add(onBuildGroup(context , i));
    // }
    // groups.forEach((element) {
    //   wgroups.add(onBuildGroup(context , ))
    // });

    var nodeTypeLst = ListView.builder(
      controller: _semicircleController,
      // itemCount: groups.length,
      // itemBuilder: onBuildGroup ,
      itemBuilder:(context,index){
        return onBuildNode(context , filtered[index], index);
      },
      itemCount: filtered.length,
      // children: ws,
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
  List<String> buildFilter(String filterStr) {
    var res = filterStr.split(RegExp(r'\s+'));
    for(int  i = 0 ;i< res.length;++i){
      res[i] = res[i].trim().replaceAll("#32", " ");
    }
    print(res);
    return res;
  }
  bool passFilter(String targetStr , List<String> filterStr){

    if (filterStr == null || filterStr.length<=0) return true;

    // bool res = true;
    for(var sstr in filterStr){
      if (targetStr.toLowerCase().indexOf(sstr)<0) return false;
    }


    return true;
    // if (filterStr == null || filterStr.trim() =="") return true;
    // return targetStr.toLowerCase().indexOf(filterStr)>=0;
  }

  String _selectedId ;
  Widget onBuildNode(BuildContext context, StateScriptNode node, int iIndex) {
    var tp = node.getNodeStructType();
    var bgClr = CommonUtil.scaleColor(Color(tp.bgColor) , 0.5);
    var w = Container(
      height: 32,
      padding: EdgeInsets.all(4),
      color  : _selectedId == node.guid? CommonUtil.scaleColor(Colors.indigo , 0.2) : (iIndex %2 ==0 ? Colors.white : CommonUtil.scaleColor(Colors.grey , 0.10)),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: bgClr,
          ),
          SizedBox(width: 4,),
          Icon(MaterialCommunityIcons.card_bulleted , size: 20,color: Colors.indigo,),
          SizedBox(width: 8,),
          Expanded(child:Text(node.exportId.toString() + " " + tp.getTypeShowString() , style: TextStyle(color: Colors.black , fontSize: 13 , fontWeight: FontWeight.w400), overflow: TextOverflow.clip,maxLines: 1,)),
          _selectedId == node.guid?Icon(Entypo.location , size: 20,color: Colors.red,):Container(),
          SizedBox(width: 20,),
        ],
      ),
    );


    bool withDesc = node.description!= null&& node.description.trim() != "";
    return InkWell(
      child: withDesc?Tooltip(
        message: node.description,
        child: w,
      ):w,
      onTap: (){
        setState(() {
          _selectedId = node.guid;
          var n = node;
          ScriptInfo.current.unselectAll();
          n.selected = true;
          ZoomState.current.focusPosition(n.x,n.y);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        });
      },
    );
  }

  Widget onBuildGroup(BuildContext context, NodeGroup g, int iIndex) {

    var bgClr = CommonUtil.scaleColor(Color(g.backgroundColor??0) , 0.5);
    var w = Container(
      height: 32,
      padding: EdgeInsets.all(4),
      color  : _selectedId == g.guid? CommonUtil.scaleColor(Colors.indigo , 0.2) : (iIndex %2 ==0 ? Colors.white : CommonUtil.scaleColor(Colors.grey , 0.10)),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: bgClr,
          ),
          SizedBox(width: 4,),
          Icon(MaterialCommunityIcons.group , size: 20,color: Colors.indigo,),
          SizedBox(width: 8,),
          Expanded(child:Text(g.name , style: TextStyle(color: Colors.black , fontSize: 13 , fontWeight: FontWeight.w800), overflow: TextOverflow.clip,maxLines: 1,)),
          _selectedId == g.guid?Icon(Entypo.location , size: 20,color: Colors.red,):Container(),
          SizedBox(width: 20,),
        ],
      ),
    );



    return InkWell(
      child: w,
      onTap: (){
        setState(() {
          _selectedId = g.guid;
          ScriptInfo.current.unselectAll();
          // print(g.getNodes());
          ZoomState.current.focusPosition(g.currentGroupRect.left + g.currentGroupRect.width/2,g.currentGroupRect.top + g.currentGroupRect.height/2);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        });
      },
    );
  }
}