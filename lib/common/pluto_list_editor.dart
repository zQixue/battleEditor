//@dart=2.11
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/ThemeCenter.dart';
// import 'package:pluto_grid/pluto_grid.dart';

// typedef List<Widget> FunctionBoolCallback(bool value);
class PlutoListEditor<T extends Object> extends StatefulWidget {
  final List<T> datas ;
  final dynamic creator;
  final dynamic builder ;
  final double itemExtent;
  final double cacheExtent;
  final double height;
  final double iconButtonSize;
  final bool verticalActionCommand;
  final dynamic onGetActions;
  final bool autoReorder ;
  final Color lineColor1;
  final Color lineColor2;
  final Color selectColor;
  final dynamic onGetDetailPanel;
  final int flexLeft;
  final int flexRight;


  final dynamic onSelectObject;

  PlutoListEditor({Key key,
    this.datas,
    this.builder,
    this.creator,
    this.itemExtent,
    this.cacheExtent,
    this.height,
    this.iconButtonSize = 32 ,
    this.verticalActionCommand = false,
    this.onGetActions,
    this.autoReorder = true,
    this.lineColor1,
    this.lineColor2 ,//= CommonUtil.alphaColorD(Colors.grey, 0.3),
    this.onSelectObject ,
    this.selectColor,
    this.onGetDetailPanel,
    this.flexLeft = 1,
    this.flexRight = 1,
  }) : super(key: key);

  @override
  _PlutoListEditorState createState() => _PlutoListEditorState();
}

class _PlutoListEditorState extends State<PlutoListEditor> {

  dynamic _selectObject ;
  ScrollController scrollController;
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget lst;
    if (!widget.autoReorder) {
      lst = ListView.builder(
        itemExtent: widget.itemExtent,
        cacheExtent: widget.cacheExtent,
        // cacheExtent: 500,
        controller: scrollController,
        itemBuilder: (context, i) {
          return getItem(i);
        },
        itemCount: widget.datas.length,
        // itemExtent: widget.it,
        scrollDirection: Axis.vertical,
      );
    }
    else{
      List<DragAndDropItem> itms = List<DragAndDropItem>();
      for(int i = 0 ; i < widget.datas.length ; ++i){
        var row = getItem(i);
        itms.add(DragAndDropItem(child:row));
      }
      lst = DragAndDropLists(
        children: [
          DragAndDropList(
            // header: Text('Header $index'),
              children: itms),
        ],
        onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex){
          setState(() {
            var vvv = widget.datas.removeAt(oldItemIndex);
            widget.datas.insert(newItemIndex, vvv);
          });
        },
        // onItemReorder: _onItemReorder,
      );
    }

    // var lv2 = PlutoScrollbar(
    //   verticalController:scrollController,
    //   horizontalController:null,
    //   isAlwaysShown: false,
    //   thickness: 8.0,
    //   thicknessWhileDragging: 10.0,
    //   child:lst,
    //   // radius: 3,
    //   // radiusWhileDragging: scrollbarConfig.scrollbarRadiusWhileDragging,
    // );
    var lv2 = lst;
    var left = Column(
      children: [
        Expanded(child : lv2),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2.0,color: CommonUtil.alphaColorD( Colors.grey , 0.35)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.creator != null) ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,color: Colors.green,
                  width: widget.iconButtonSize , height:widget.iconButtonSize,
                  tooltip: "添加",
                  onPressed: (){
                    setState(() {
                      var nObj = widget.creator?.call();
                      if (nObj != null){
                        widget.datas.add(nObj);
                      }
                    });
                  }
              ),
            ],
          ),
        ),
      ],
    );
    if (widget.onGetDetailPanel != null ){
      Widget right;

      if (_selectObject != null){
        right = widget.onGetDetailPanel.call(_selectObject);
      }
      else {
        right = Container(
          color: CommonUtil.alphaColorD(Colors.grey, 0.05),
          child: Center(
            child: Text("左侧选择一项显示、编辑详细信息" , style: TextStyle(color: Colors.grey , fontSize: 18),),
          ),
        );
      }
      return SizedBox(height : widget.height ,child:Row(
        children: [
          Expanded(child: left,flex: widget.flexLeft,),
          SizedBox(width: 8,),
          Expanded(child: Container(
            color: CommonUtil.alphaColorD(Colors.grey, 0.05),
            child: right,
          ),flex: widget.flexRight,),
        ],
      ));
    }
    return SizedBox(height : widget.height ,child:left);
  }
  Widget getItem(int iIndex){
    var con = widget.builder?.call(widget.datas[iIndex]);
    var actions = widget.onGetActions?.call(iIndex, widget.datas[iIndex]);
    var fullActions = getActions(iIndex, widget.verticalActionCommand, actions);
    var row = Row(
      crossAxisAlignment: widget.verticalActionCommand ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(child: con),
        fullActions,
        // SizedBox(width: 8,),
      ],
    );

    var con2 = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
      color: _selectObject == widget.datas[iIndex]? (widget.selectColor??CommonUtil.alphaColorD(Colors.lightBlue, 0.25)) : (iIndex %2 ==0 ? widget.lineColor1 :widget.lineColor2??CommonUtil.alphaColorD(Colors.grey, 0.05)),
      child : row,
    );
    if (widget.onSelectObject == null) return con2;
    else{
      return InkWell(
        child: con2,
        onTap: (){
          setState(() {
            _selectObject =  widget.datas[iIndex];
            widget.onSelectObject.call(iIndex , widget.datas[iIndex]);
          });
        },
      );
    }
  }
  Widget getActions(int iIndex , bool bVertical , List<Widget> actions){
    List<Widget> ws = List<Widget>();
    var remove = ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,color: Colors.redAccent,
        width: widget.iconButtonSize , height:widget.iconButtonSize,
        tooltip: "删除",
        onPressed: (){
          CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
            setState(() {
              if(_selectObject == widget.datas[iIndex]){
                _selectObject = null;
              }
              widget.datas.removeAt(iIndex);
            });
          });
        }
    );
    ws.add(remove);
    if (actions != null) {
      ws.addAll(actions);
    }
    if (bVertical){
      var res = Container(
        // decoration: BoxDecoration(
        //   border: Border(
        //     left: BorderSide(width: 2.0,color: CommonUtil.alphaColorD( Colors.grey , 0.35)),
        //   ),
        // ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: ws,
        ),
      );
      return res;
    }
    else{
      var res = Container(
        // decoration: BoxDecoration(
        //   border: Border(
        //     left: BorderSide(width: 2.0,color: CommonUtil.alphaColorD( Colors.grey , 0.35)),
        //   ),
        // ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: ws,
        ),
      );
      return res;
    }
  }
}