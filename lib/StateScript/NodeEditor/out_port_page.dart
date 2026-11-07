//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/cell_text_field.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/EventCenter.dart';
class OutPortPage extends StatefulWidget {
  final NodeStructData nodeType;
  final double fullSize;
  OutPortPage({Key key,  this.nodeType , this.fullSize}) : super(key: key);

  @override
  _OutPortPageState createState() => _OutPortPageState();
}

class _OutPortPageState extends State<OutPortPage> {

  List<ListTableColumn> columns;

  OutPort focusItem;
  void initColumns(){
    columns = new List<ListTableColumn>();
    ///
    var c = ListTableColumn();
    c.name = "输出名";

    c.width = 380.0;
    c.widgetBuilder = (context , index) {
      var items = widget.nodeType.outPorts;
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
      var items = widget.nodeType.outPorts;
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
    var items = widget.nodeType.outPorts;
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
                      focusItem = widget.nodeType.newOutPort();
                    });
                  },
                ),
                if (focusItem != null) IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 40, color: Colors.redAccent, tooltip:"删除",
                  onPressed: (){
                    setState(() {
                      widget.nodeType.removeOutPort(focusItem);
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

  Widget _getNameWidget(OutPort item) {

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

  Widget _getAliasWidget(OutPort item) {

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
    var items = widget.nodeType.outPorts;
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