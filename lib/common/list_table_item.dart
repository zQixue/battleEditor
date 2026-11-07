//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/KeFrame/frame_separate_widget.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/list_table.dart';

import 'card_loading/card_loading.dart';

class ListTableItem extends StatefulWidget {
  final int index;
  final IndexedRowInfo onRowInfo;
  final dynamic onReorder;
  final bool useLineInterval;
  final double reorderCellWidth;
  final List<ListTableColumn> columns;
  final double itemHeight;
  final double tailWidth;
  final IndexedWidgetOnTap onTap;
  final bool seperateFrame ;
  final dynamic onPlaceHolder;
  ListTableItem({Key key,
    this.index,
    this.onRowInfo,
    this.onReorder,
    this.useLineInterval,
    this.reorderCellWidth,
    this.columns,
    this.itemHeight,
    this.tailWidth,
    this.onTap,
    this.seperateFrame,
    this.onPlaceHolder,
  }) : super(key: key);

  @override
  _ListTableItemState createState() => _ListTableItemState();
}
class DragData{
  String typeGuid;
  int index;
}
class _ListTableItemState extends State<ListTableItem> {
  @override
  Widget build(BuildContext context) {
    return OnBindItem(widget.index);
  }
  bool dragingOn = false;
  bool dragingStarted = false;
  bool dragingNode = false;

  Widget OnBindItem(int index) {
    List<Widget> cells = new List<Widget>();
    bool useBgColor= false;
    Color bgColor ;
    var colorBorder =  CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.2);

    Color baseColor = index % 2 == 1 ? CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) : null;
    bool withReoeder = widget.onReorder != null;
    if (withReoeder){
      if (dragingStarted){
        baseColor = CommonUtil.alphaColorD( Colors.green , 0.4);
      }
      else{
        if (dragingOn){
          baseColor = CommonUtil.alphaColorD( Colors.redAccent , 0.4);
        }
        // else{
        //   baseColor = index % 2 == 1 ? CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) : null;
        // }
      }
    }

    if (widget.onRowInfo != null){
      var info = widget.onRowInfo(index);
      useBgColor = info.forceColor;
      bgColor = info.bgColor;
    }


    if (withReoeder) {

      var e = InkWell(
        // hoverColor: Colors.green,
        // mouseCursor:SystemMouseCursors.,
          onHover: (v){
            setState(() {
              dragingNode = v;
            });
          },
          onTap: (){

          },
          child:SizedBox(
            child: Icon(MaterialCommunityIcons.drag,color: dragingOn ? Colors.redAccent : (dragingNode?Colors.green:Colors.grey)),
            width: 24, height: 24,
          )
      );

      var e2 = SizedBox(
        child: Icon(MaterialCommunityIcons.drag,color: Colors.green),
        width: 24, height: 24,
      );
      var e3 = SizedBox(
        child: Icon(MaterialCommunityIcons.sort,color: Colors.green),
        width: 24, height: 24,
      );

      Widget itm = Container(
        width: widget.reorderCellWidth,
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: widget.useLineInterval?Border(
            right: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            left: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
          ):Border(
            right: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            bottom: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            left: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
          ),
          color: baseColor,// useBgColor ?bgColor: (index % 2 == 1 ?widget.lineDiffColor??CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) :Color(0)),
        ),
        child: Draggable(
          child: e,
          feedback: e3,
          childWhenDragging: e2,
          // feedbackOffset: Offset(30.0,30.0),
          // ignoringFeedbackSemantics:false,
          data: DragData()..index = widget.index,
          onDragStarted:(){
            setState(() {
              dragingStarted = true;
            });
          },
          onDragEnd:(e){
            setState(() {
              dragingStarted = false;
              dragingNode = false;
            });
          },
          onDraggableCanceled: (e,b){
            setState(() {
              dragingStarted = false;
              dragingNode = false;
            });
          },
          onDragCompleted: (){
            setState(() {
              dragingStarted = false;
              dragingNode = false;
            });
          },
        ),

      );
      cells.add(itm);
    }
    var first = true;


    for(var c in widget.columns){
      Widget w ;

      bool bCombine = c.onGetCombineInfo != null;
      int iShowIndex = index;
      bool bShouldShow = true;
      CombineInfo cbInfo ;
      if (bCombine){
        cbInfo = c.onGetCombineInfo.call(index);
        if (cbInfo.startIndex != null && cbInfo.endIndex != null ){
          iShowIndex = ((cbInfo.startIndex + cbInfo.endIndex)/2).floor();
          bShouldShow = iShowIndex == index;
        }
      }
      if (!bCombine || bShouldShow){
        if (c.widgetBuilder!=null){
          var ih = c.widgetBuilder(context,index);
          w = ih.widget;
        }
        else{
          w = Text("" , style: TextStyle(fontSize: 12 , fontWeight:FontWeight.w600 ,color: Colors.black45),);
        }
      }
      else{
        w = Container();
      }
      var dcc = first == true?(
          BoxDecoration(
            border: widget.useLineInterval || (bCombine && index != cbInfo.endIndex)?Border(
              right: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
              left: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            ):Border(
              right: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
              bottom: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
              left: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            ),
          )
      ):
      (
          BoxDecoration(
            border: widget.useLineInterval || (bCombine && index != cbInfo.endIndex)?Border(
              right: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            ):Border(
              right: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
              bottom: Divider.createBorderSide(context, color: colorBorder, width: 0.5),
            ),
          )
      );
      first = false;
      cells.add(Container(
        padding: EdgeInsets.all(0),
        decoration: dcc,
        alignment :Alignment.center ,
        width: c.width,
        child: w,
        height: widget.itemHeight- (widget.useLineInterval?0.1:0),));
//      headers.add(colSeparatorWidget);
    }
//    cells.add(Expanded(child :Container()));
//    print("--- ${widget.forceWidth}");
    if (widget.tailWidth != null) {
      cells.add(
          Container(
            padding: EdgeInsets.all(0),
//                child: Text("---"),
            width: widget.tailWidth,
          ));
    }
    Widget row = Row(children: cells,);
//    return row;

    // List<Widget> clnChildren = [
    //   row,
    // ];
    // if (widget.useLineInterval){
    //   clnChildren.add(rowSeparatorWidget2);
    // }



    Widget itm = Container(
      padding: EdgeInsets.all(0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: baseColor,// useBgColor ?bgColor: (index % 2 == 1 ?widget.lineDiffColor??CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) :Color(0)),
      ),
      child: row,
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: clnChildren,
      // )
    );
    if (widget.onTap != null){
      itm = InkWell(
        key:UniqueKey(),
        child:itm ,
        onTap: (){
          if (widget.onTap!= null){
            widget.onTap(index);
          }
        },
      );
    }
    Widget dt;
    if (withReoeder){
      dt = DragTarget<DragData>(
        builder: (p1,p2,p3){
          return itm;
        },
        onMove: (details){
          if (!(details.data is DragData)) return ;
          setState(() {
            // selectTags.add(e.data);
            dragingOn = true;
          });
        },
        onLeave: (details){
          setState(() {
            // selectTags.add(e.data);
            dragingOn = false;
          });
        },
        onWillAccept: (e){return e is DragData;},
        onAcceptWithDetails: (e){
          var inIndex = e.data.index;
          var toIndex = widget.index;
          if (inIndex != toIndex) {
            // var vvv = lst.removeAt(inIndex);
            // lst.insert(toIndex, vvv);
            // onSubmitted?.call(lst);
            widget.onReorder?.call(inIndex , toIndex);
          }
          setState(() {
            // selectTags.add(e.data);
            dragingOn = false;
          });

        },
      );
    }
    else{
      dt = itm;
    }

    if (!widget.seperateFrame){
      return dt;
    }


    var ph = Container(
      padding: EdgeInsets.all(0),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: baseColor,// useBgColor ?bgColor: (index % 2 == 1 ?widget.lineDiffColor??CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) :Color(0)),
      ),
      child: widget.onPlaceHolder?.call(index)??Padding(
        padding: EdgeInsets.fromLTRB(widget.itemHeight/3, widget.itemHeight/3, widget.itemHeight/3, widget.itemHeight/3),
        // child: Center(child:Text("...")),
        child:Center(child:CardLoading(
          cardLoadingTheme: CardLoadingTheme(colorOne: Colors.green,colorTwo:Colors.grey),
          height: 2,
          animationDuration : const Duration(milliseconds: 1600),
          borderRadius: BorderRadius.all(Radius.circular(1)),
          // margin: EdgeInsets.all(value),
        )),
        // decoration: dc,
        // height: widget.itemExtent,
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: clnChildren,
      // )
    );
    return  FrameSeparateWidget(

      index: index,
      placeHolder: ph,
      child: dt,
    );
  }
}