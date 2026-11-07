//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/cell_text_field.dart';
import 'package:battlepus/common/list_table.dart';

class InParamPage extends StatefulWidget {
  final NodeStructData nodeType;
  final double fullSize;
  InParamPage({Key key,  this.nodeType , this.fullSize}) : super(key: key);
  @override
  _InParamPageState createState() =>
      _InParamPageState(
      );
}

class _InParamPageState extends State<InParamPage> {

  List<ListTableColumn> columns;

  InParam focusItem;
  void initColumns(){
    columns = new List<ListTableColumn>();
    ///
    var c = ListTableColumn();
    c.name = "参数入口名";

    c.width = 380.0;
    c.widgetBuilder = (context , index) {
      var items = widget.nodeType.inParams;
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

    c1.width = 380.0;
    c1.widgetBuilder = (context , index) {
      var items = widget.nodeType.inParams;
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

    var c3 = ListTableColumn();
    c3.name = "参数类型";

    c3.width = 380.0;
    c3.widgetBuilder = (context , index) {
      var items = widget.nodeType.inParams;
      var res = new ItemHolder();
      res.widget = _getTypeWidgets(items[index]);
      return res;
    };
    c3.headAlignment = Alignment.centerLeft;
    c3.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c3);
    {
      var c3 = ListTableColumn();
      c3.name = "绑定属性";

      c3.width = 280.0;
      c3.widgetBuilder = (context , index) {
        var items = widget.nodeType.inParams;
        var res = new ItemHolder();
        res.widget = _getBindFieldWidget(items[index]);
        return res;
      };
      c3.headAlignment = Alignment.centerLeft;
      c3.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c3);
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
  StreamSubscription<NodeTypeSelectionChangeEvent> _lis;
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
    focusItem = null;
    initColumns();

    _lis = EventCenter.eventBus.on<NodeTypeSelectionChangeEvent>().listen((event) {
      setState(() {
        focusItem = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // initColumns();
    var items = widget.nodeType.inParams;
    var lst = ListTable(
      forceWidth: widget.fullSize,
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

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 6,),
          Container(
            height: 52,
//            color: CommonUtil.alphaColor(Colors.indigo, 24),
            child :Row(
              children: [
                IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 40, color: ThemeCenter.mainTextStepColor(8), tooltip:"添加新输出",
                  onPressed: (){
                    setState(() {
                      focusItem = widget.nodeType.newInParam();
                    });
                  },
                ),
                if (focusItem != null)IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 40, color: Colors.redAccent, tooltip:"删除",
                  onPressed: (){
                    setState(() {
                      widget.nodeType.removeInParam(focusItem);
                      focusItem = null;
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
  }

  Widget _getNameWidget(InParam item) {

    var str = item.name;
    if (str == null || str.isEmpty) str = "请输入名字";
    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = CellTextField(
          initText: item.name,
          onDone: (v){
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

  Widget _getAliasWidget(InParam item) {

    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = CellTextField(
          initText: item.alias,
          onDone: (v){
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

  Widget _getActionWidgets(int index) {
    var items = widget.nodeType.inParams;
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

  Widget _getTypeWidgets(InParam item) {
   var types = SSFieldType.getTypeMap(includeFlag: SSFieldType.FIELD_FLAG_PARAM);
   List<PopupMenuEntry<String>> itemWidgets = [];
   for(var type in types){
    var item = PopupMenuItem<String>(
      value: type.cname,
      child: Text(type.cname),
    );
    itemWidgets.add(item);
   }

   var res = PopupMenuButton<String>(
    icon : Icon(MaterialCommunityIcons.menu),
    initialValue: item.paramType,
    onSelected: (String v){
      setState(() {
          item.paramType = v;
      });
    },
    itemBuilder: (context) => itemWidgets,

   );

    return Container(
      padding: EdgeInsets.fromLTRB(4,0,4,0),
      child: Row(children: [
        Expanded(
            child: _getInParamTypeName(item),
          ),
          res
      ]),
    );
  }

  Widget _getInParamTypeName(InParam item){
     var bIsEdit = focusItem == item;
     if (bIsEdit){
      var res = CellTextField(
          initText: item.paramType,

          onDone: (v){
            item.paramType = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.paramType);
  }


  Widget _getBindFieldWidget(InParam inParam) {
    //
    var fields = widget.nodeType.fields;
    Map<String , FieldInfo> fieldsMap =  Map<String , FieldInfo>();
    List<PopupMenuEntry<String>> itemWidgets = new  List<PopupMenuEntry<String>>();
    var crtField ;
    for(var i in fields){
      // print(i.getFullType());
      // if (i.getFullType() != inParam.paramType){
      //   continue;
      // }
      if (i.guid == inParam.bindFieldGuid){
        crtField = i;
      }
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: getTypeAndName(i),
      );

      fieldsMap[i.guid] = i;
      itemWidgets.add(item);
    }
    var none = PopupMenuItem<String>(
      value: "",
      child: Text("不绑定"),
    );
    itemWidgets.add(none);
    // return Container();
    var res = PopupMenuButton<String>(
      icon : Icon(MaterialCommunityIcons.menu),
      initialValue: inParam.bindFieldGuid,
      onSelected: (String v) {
        setState(() {
          inParam.bindFieldGuid = v;
          inParam.paramType = fieldsMap[v]?.getFullType()??"";
          inParam.name = fieldsMap[v]?.name??"";
          inParam.alias = fieldsMap[v]?.alias??"";
          widget.nodeType.buildInParamMap();
        });
      },
      itemBuilder: (BuildContext context) => itemWidgets,
    );
    if (crtField == null){
      inParam.bindFieldGuid = "";
      widget.nodeType.buildInParamMap();
    }
    return Container(
      padding: EdgeInsets.fromLTRB(4,0,4,0),
      child: Row(
        children: [
          Expanded(
            child: getTypeAndName(crtField),
          ),
          res
        ],
      ),
    );
  }

  Widget getTypeAndName(FieldInfo ii){
    if (ii == null) return Center(child : Text("未绑定"));
    var fi = SSFieldType.getFieldType(ii.typeGuid,fieldInfo: ii);
    var tpw = fi.getTypeShowWidget();
    return Row(
      children: [
        Expanded(child:tpw),
        Expanded(child :Text(ii.getTypeShowString())),
      ],
    );
  }
}