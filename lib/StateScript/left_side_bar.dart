//@dart=2.11
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/canvas_tool_bar.dart';
import 'package:battlepus/StateScript/node_indicator_view.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/CommonUtil.dart';

class LeftSideBar extends StatefulWidget {
  final double width;
  final double height;
  final SSCanvasViewState graph;
  LeftSideBar({Key key,this.width,  this.height , this.graph}) : super(key: key);

  @override
  _LeftSideBarState createState() => _LeftSideBarState();
}

class _LeftSideBarState extends State<LeftSideBar> {

  List<Icon> _icons = [
    Icon(MaterialCommunityIcons.plus_box_outline),
    Icon(MaterialCommunityIcons.map_search_outline),
    // Icon(MaterialCommunityIcons.atom_variant),
  ];

  List<String> _toolTips = [
    "添加结点",
    "脚本查找",
    // "变量视图",
  ];

  int _activeIndex ;
  @override
  Widget build(BuildContext context) {
    double _w = min(270, widget.width/2);
    double _h = widget.height;
    List<Widget> ws = List<Widget>();
    double topSpace = 42;
    for(int i = 1 ; i < _icons.length ;++i){
      // 节点风格按钮：深色半透明底 + 彩色边框框住文字（不带图标），选中时红色边框
      var btnColor = _activeIndex==i?Colors.redAccent:Colors.grey;
      ws.add(GestureDetector(
        onTap: (){
          setState(() {
            _activeIndex = i;
          });
        },
        child: Container(
          height: 34,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.fromLTRB(8, 4, 0, 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(160, 30, 30, 30),
            border: Border.all(color: CommonUtil.scaleColor(btnColor, 0.8), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(_toolTips[i], style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 228, 223, 223), fontWeight: FontWeight.w600)),
        ),
      ));
    }

    List<Widget> cols = List<Widget>();
    cols.add(Container(height:topSpace,child : Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: ws,)));

    if (_activeIndex==0)cols.add(CanvasToolBar(width : _w , height : max(1,_h-topSpace) , onClose: (){
      setState(() {
        _activeIndex = null;
      });

      },));
    if (_activeIndex==1)cols.add(NodeIndicatorView(width : _w , height : max(1,_h-topSpace-20), onClose: (){
      setState(() {
        _activeIndex = null;
      });
    
    },));

    var c = Container(
      width: _w,
      height :_h,
      child : Column(
        children: cols
      )
    );

    // 按钮与面板整体靠画布左上角显示、左对齐；顶部第一行让给主工具按钮行，本按钮与「锁定中心」同在第二行
    return Positioned(
      left: 0,
      top: 40,
      child: c,
    );
  }
}