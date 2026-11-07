//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';

typedef void FunctionClazzCallback(ObjectClazz clz);

class SelectTableView extends StatefulWidget {
  final FunctionClazzCallback onSelected ;

  final VoidCallback onClose;
  SelectTableView({Key key , this.onSelected , this.onClose}) : super(
      key: key);

  @override
  _SelectTableViewState createState() =>
      _SelectTableViewState(
      );
}

class _SelectTableViewState extends State<SelectTableView> {

  Map<String , List<ObjectClazz> > groups;
  Map<String , bool> closeFlags = Map<String , bool>();
  List<String> groupNames;
  @override
  Widget build(BuildContext context) {

    groups = ObjectTableProject.instance.getClazzGroups();
    groupNames = groups.keys.toList();
    var header = Container(
      height: 48,
      color: CommonUtil.alphaColor(Colors.indigo , 180),
      child: Row(
        children: [
          SizedBox(width: 8,),
          Expanded(child :Text("选择表" , style: TextStyle(color: Colors.white, fontSize: 16 , fontWeight: FontWeight.w400),)),
          widget.onClose == null?SizedBox(width: 0,):
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(MaterialCommunityIcons.close_box),
            iconSize: 40,
            color: Colors.black,
            onPressed: (){
              widget.onClose?.call();
            },
          )
        ],
      ),
    );

    var tableLst = ListView.builder(
      itemCount: groupNames.length,
      itemBuilder: onBuildGroup ,
    );
    return Column(
      children: [
        header,
        SizedBox(height: 1,),
        Expanded(
          child: Scrollbar(
            child: tableLst,
          ),
        ),
      ],
    );
  }

  Widget onBuildGroup(BuildContext context, int index) {
    var groupName = groupNames[index];
    var group = groups[groupName];
    var showName = groupName;
    if (showName == null || showName.isEmpty){
      showName = "基本";
    }
    bool closed = closeFlags[groupName] == true;
    var header = Container(
      height: 38,
      color: CommonUtil.alphaColor(Colors.indigo , 120),
      child: Row(
        children: [
          SizedBox(width: 8,),
          Expanded(child : Text(showName)),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(closed?MaterialCommunityIcons.chevron_up:MaterialCommunityIcons.chevron_down),
            iconSize: 32,
            onPressed: (){
              setState(() {
                closeFlags[groupName] = !closed;
              });

            },
          ),
        ],
      ),
    );

    return Container(
//      height: 400,
      child: Column(
        children: [
          header,
          closed?Container():LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return getGroupView(constraints.maxWidth , group);
            },
          ),
//          Expanded(child :getGroupView()),
          SizedBox(height: 2,),
        ],
      ),
    );
  }

  Widget getGroupView(double width, List<ObjectClazz> group ) {
    var itemSize = 220;
    var ratio = 2.0;
    var count = (width / itemSize).ceil();
    var cellWidth = width / count;
    var cellHeight = cellWidth / ratio;

    var lines = (group.length.toDouble() / count).ceil();
    var allHeight = cellHeight * lines;

    var items = List<Widget>();
    for (var clz in group){

      var item = Container(
        padding: EdgeInsets.all(4),
        child: getItem(clz)
      );
      items.add(item);
    }

    var g = GridView.count(
      crossAxisCount: count,
      childAspectRatio: ratio,
      padding: EdgeInsets.zero,
//      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//          maxCrossAxisExtent: cellWidth,
//          childAspectRatio: ratio //宽高比为2
//      ),
      children: items
    );

    return Container(
//      color: Colors.red,
      height: allHeight,
      child: g,
    );
  }

  Widget getItem(ObjectClazz clz){
    var dc = new BoxDecoration(
      color: CommonUtil.alphaColor(Color(clz.color) , 30),
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    );

    var header = Container(
      height: 28,
      child: Row(
        children: [
          SizedBox(width: 8,),
          Expanded(child:Text(clz.getShowStringAndName(),style: TextStyle( fontSize: 16 , fontWeight: FontWeight.w800),)),
        ],
      ),
    );
    return InkWell(
      onTap: (){
//        OTGlobalBoard.currentObjectClazz = clz;
        OTGlobalBoard.push(clz);
        EventCenter.eventBus.fire(GlobalRefreshEvent());
//        Navigator.pop(context);
        widget.onSelected?.call(clz);
      },
      child: Container(
        decoration: dc,
        child: Column(
          children: [
            header,
          ],
        ),
      ),
    );

  }


}