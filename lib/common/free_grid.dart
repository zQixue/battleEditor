//@dart=2.11
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/free_grid_cell.dart';
// import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class FreeGrid extends StatefulWidget {
  final List<double> headerWidths;
  final List<String> headerNames;
  final double headerWidthMax;
  final double headerWidthMin;
  final double headerHeight;
  final dynamic onGetBorder;
  final double itemHeight;
  final dynamic onItemBuilder;
  final dynamic onGetItemKey;
  final dynamic onReorder;
  final dynamic onTap;
  final Widget topToolBar;
  final Widget bottomToolBar;
  final List<Widget> actions;
  final dynamic onGetHeaderActions;
  final int itemCount;
  final Color selectColor;
  final Color cellBorderColor;
  final dynamic onResizeColumn;
  final bool headResizable ;
  final bool withScrollbar;
  FreeGrid({Key key ,this.withScrollbar, this.cellBorderColor , this.headerNames , this.headResizable = true, this.headerWidths , this.onTap , this.selectColor = Colors.indigoAccent, this.onGetHeaderActions, this.onGetBorder, this.topToolBar, this.bottomToolBar, this.onGetItemKey , this.onReorder, this.itemHeight = 20, this.headerWidthMax = 600,this.headerWidthMin = 80, this.headerHeight, this.onItemBuilder , this.itemCount = 0 , this.onResizeColumn, this.actions}) : super(key: key);

  @override
  _FreeGridState createState() => _FreeGridState();
}

class _FreeGridState extends State<FreeGrid> {

  // List<double> _headerSizes = new List<double>();
  ScrollController _sc;
  ScrollController _leftList;
  ScrollController _scList;
  double rx1 ;
  double rx2 ;
  @override
  void initState() {
    // TODO: implement initState
    // _headerSizes.clear();
    // _headerSizes.addAll(widget.headerWidths);
    _sc = ScrollController ();
    _sc.addListener(() {
      // print("view port dim : ${_sc.position}");
      rx1 = _sc.offset;
      rx2 =  _sc.offset +_sc.position.viewportDimension;
      EventCenter.eventBus.fire(GridRefreshRange()..x1 =_sc.offset..x2 = _sc.offset + _sc.position.viewportDimension );
      print("view port dim : $rx1 $rx2");
    });
    _scList = ScrollController ();
    _leftList = ScrollController();

    // var jumpSender ;
    // _scList.addListener(() {
    //   if (jumpSender == _scList) return ;
    //   jumpSender = _scList;
    //   _leftList.jumpTo(_scList.offset);
    // });
    // _leftList.addListener(() {
    //   if (jumpSender == _leftList) return ;
    //   jumpSender = _leftList;
    //   _scList.jumpTo(_leftList.offset);
    // });
    super.initState();
  }
  bool inSyncScrolling = false;
  dynamic jumppingSender ;

  Widget _getScrollColumn(Widget child, ScrollController scrollController , {bool withVScrollbar = false}) {

    // var c = VsScrollbar(
    //   // showTrackOnHover: true,// default false
    //   controller: _leftList,
    //   allowDrag: true,
    //   isAlwaysShown: true, // default false
    //   // scrollbarFadeDuration: Duration(milliseconds: 500), // default : Duration(milliseconds: 300)
    //   // scrollbarTimeToFade: Duration(milliseconds: 800),// default : Duration(milliseconds: 600)
    //   // style: VsScrollbarStyle(
    //   //   hoverThickness: 10.0, // default 12.0
    //   //   radius: Radius.circular(10), // default Radius.circular(8.0)
    //   //   thickness: 10.0, // [ default 8.0 ]
    //   //   color: Colors.purple.shade900, // default ColorScheme Theme
    //   // ),
    //   child: child,
    // );
    if ((widget.withScrollbar??false)&&withVScrollbar){
      child = DraggableScrollbar.semicircle(
        backgroundColor: CommonUtil.alphaColor(ThemeCenter.mainTextStepColor(3), 100),
        alwaysVisibleScrollThumb: true,
        controller: scrollController,
        child: child,
      );
    }

    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (ScrollNotification scrollInfo) {

        if (inSyncScrolling && jumppingSender != scrollController) return false;

        if (scrollInfo is ScrollStartNotification && !inSyncScrolling){
          jumppingSender = scrollController;
          inSyncScrolling = true;
          return false;
        }
        if (scrollInfo is ScrollEndNotification && inSyncScrolling){
          jumppingSender = null;
          inSyncScrolling = false;
          return false;
        }

        if (scrollInfo is ScrollUpdateNotification) {
          syncScroll(scrollController.offset);
        }
        // print("view port dim : ${_scList.position.viewportDimension}");
        return false;
      },
    );
  }

  void syncScroll(offset){

    if (!identical(_scList , jumppingSender) && _scList.hasClients){
      _scList.jumpTo(offset);
    }
    if (!identical(_leftList , jumppingSender)&& _leftList.hasClients){
      _leftList.jumpTo(offset);
    }
  }

  dynamic _moveToTarget ;
  dynamic _selfKey ;
  int _crtIndex;

  @override
  void dispose() {
    // TODO: implement dispose
    _sc?.dispose();
    _scList?.dispose();
    _leftList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = 0;
    widget.headerWidths.forEach((element) { fullWidth += element;});
    // List<Widget> items = List<Widget>();
    // for(int i = 0 ; i < widget.itemCount ; ++i){
    //
    //   List<Widget> row = List<Widget>();
    //   for(int j = 0 ; j < _headerSizes.length; ++j){
    //     var w = widget.onItemBuilder?.call(i , j);
    //
    //     var width = _headerSizes[j];
    //
    //     var cell = getCell(
    //       width: width,
    //       height: w==null?widget.itemMinHeight:null,
    //       child: w,
    //     );
    //
    //     row.add(cell);
    //   }
    //
    //   items.add(Row(children: row,));
    //
    // }

    var lb = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        double dragExt = 16;
        double rowInfoWidth = 48;
        var leftBar = Container(width : rowInfoWidth,height : constraints.maxHeight,
            child :Column(
              children: [
                head(width: rowInfoWidth , height: widget.headerHeight),
                Expanded( child :_getScrollColumn(ListView.builder(
                  controller: _leftList,
                  itemCount: widget.itemCount + (widget.bottomToolBar!= null ?1:0),
                  itemExtent: widget.itemHeight,
                  itemBuilder: (context , index){
                    return head(width: rowInfoWidth , height: widget.itemHeight ,
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Container( alignment: Alignment.centerRight , child : Text("${index+1}" , style: TextStyle(color: CommonUtil.scaleColor(Colors.grey , 0.4)),)) ,

                    );
                  },
                ),_leftList ,withVScrollbar: true)),
                Visibility(
                  visible: widget.actions != null,
                  child: SizedBox(height: 4,),
                ),
                Visibility(
                  visible: widget.actions != null,
                  child: head(width: rowInfoWidth , height: widget.itemHeight),
                ),
              ],

            ));


        var con = Container(
          width: fullWidth + dragExt,
          height : constraints.maxHeight,
          child: Row(
            children: [

              Expanded(child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.topToolBar != null) Row(children : [Expanded(child:widget.topToolBar) , SizedBox(width:dragExt)]),
                  getHeaders(),
                  Expanded( child : _getScrollColumn( ListView.builder(
                    controller: _scList,
                    // physics: AlwaysScrollableScrollPhysics(),
                    itemCount: widget.itemCount + (widget.bottomToolBar!= null ?1:0),
                    // shrinkWrap: true,
                    itemExtent: widget.itemHeight,
                    itemBuilder: (context , index){
                      // return Container();
                      if (index >= widget.itemCount){
                        return Row(children : [ Expanded(child : widget.bottomToolBar) , SizedBox(width:dragExt)]);
                      }
                      List<Widget> row = List<Widget>();

                      ValueKey inputItemKey = ValueKey(widget.onGetItemKey.call(index));
                      if (inputItemKey == _selfKey){
                        row.add(SizedBox(width: dragExt,));
                      }
                      double crtX = 0;
                      for(int j = 0 ; j < widget.headerWidths.length; ++j){
                        var width = widget.headerWidths[j];
                        // var w = widget.onItemBuilder.call(index , j);
                        var w = FreeGridCell(
                          onItemBuilder:widget.onItemBuilder,
                          row : index ,
                          col : j ,
                          rx1:rx1??0,
                          rx2:rx2??constraints.maxWidth,
                          x1 : crtX,
                          x2 : crtX + width,
                        );
                        crtX += width;
                        // if (w != null){
                        //   inputItemKey = (w as Widget).key;
                        // }

                        var dc = widget.onGetBorder?.call(index)??null;
                        var cell = getCell(
                          decoration : dc,
                          bgColor: (_selfKey == inputItemKey) ? CommonUtil.scaleColor(widget.selectColor,0.4): index %2 ==1 ?CommonUtil.alphaColorD(Colors.grey, 0.05):null,
                          width: width,
                          height: (_selfKey == inputItemKey) ? widget.itemHeight * 0.95: widget.itemHeight,
                          child: w??Text("$index"),
                        );

                        if (widget.onTap != null){
                          var ink = GestureDetector(
                            onTap: (){
                              widget.onTap.call(index);
                            },
                            child: cell,
                          );
                          row.add(ink);

                          // row.add(cell);
                        }
                        else{
                          row.add(cell);
                        }


                      }
                      if (_selfKey == inputItemKey){

                      }
                      var tagTarget = DragTarget<int>(
                        builder: (p1,p2,p3){
                          var rowcon = Row(children: row,);

                          // if (_selfKey == k) con = Opacity(child: rowcon, opacity: 0.5);
                          var con = (_selfKey == inputItemKey)?Opacity(child: rowcon, opacity: 0.5,) : rowcon;
                          var bIndex = index;
                          var d = LongPressDraggable(
                            axis:Axis.vertical,
                            child: con,
                            onDragCompleted:(){
                              _moveToTarget = null;
                              _crtIndex = null;
                              _selfKey = null;
                            },
                            onDraggableCanceled: (Velocity velocity, Offset offset){
                              _moveToTarget = null;
                              _crtIndex = null;
                              _selfKey = null;
                            },

                            onDragStarted: (){
                              _moveToTarget = null;
                              _crtIndex = null;
                              _selfKey = inputItemKey;
                              setState(() {

                              });
                            },
                            ignoringFeedbackSemantics: false,
                              dragAnchorStrategy: childDragAnchorStrategy,
                            // dragAnchor: DragAnchor.child,
                            // feedbackOffset: Offset(50.0,50.0),
                            //feedback:Container(alignment: Alignment.bottomRight, height:widget.itemHeight + widget.itemHeight/2 , width : fullWidth +9,child:  Material(child:con)),//  Material(child:con) ),

                            feedback: Material(color : CommonUtil.alphaColor(Colors.white, 0) , child:Icon(MaterialCommunityIcons.arrow_up_down_bold ,color: Colors.indigo,)),
                            childWhenDragging: con , //Opacity(child: con, opacity: 0.5) ,
                            data: bIndex,
                          );

                          return Container (
                              padding: EdgeInsets.fromLTRB(0,0,0,0),
                              child:d
                          );
                        },
                        onMove: (details){
                          if (inputItemKey != _selfKey) {
                            setState(() {
                              // print(_crtIndex);
                              widget.onReorder?.call(_crtIndex??(details.data as int), index);
                              _crtIndex = index;
                              _moveToTarget = inputItemKey;
                            });
                          }

                        },
                        onLeave: (details){

                        },
                        onWillAccept: (e)=>e is int,
                        onAcceptWithDetails: (e){
                          setState(() {
                          });
                        },
                      );

                      return tagTarget ;
                    },
                    // children: items,
                  ),_scList)),

                  Visibility(
                    visible: widget.actions != null,
                    child: SizedBox(height: 4,),
                  ),
                  Visibility(
                    visible: widget.actions != null,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: Divider.createBorderSide(context, color: CommonUtil.scaleColor(Colors.grey , 0.6), width: 1.9),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.actions??[],
                      ),
                    ),
                  ),
                ],
              )),
            ],
          )
        );

        var sv = Scrollbar(
          // showTrackOnHover: true,// default false
          controller: _sc,
          // radius:80,

          // scrollDirection: Axis.horizontal,

          // scrollbarFadeDuration: Duration(milliseconds: 500), // default : Duration(milliseconds: 300)
          // scrollbarTimeToFade: Duration(milliseconds: 800),// default : Duration(milliseconds: 600)
          // style: VsScrollbarStyle(
          //   hoverThickness: 10.0, // default 12.0
          //   radius: Radius.circular(10), // default Radius.circular(8.0)
          //   thickness: 10.0, // [ default 8.0 ]
          //   color: Colors.purple.shade900, // default ColorScheme Theme
          // ),
          child: SingleChildScrollView(
              controller: _sc,
              // physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: con
          ),
        );
        // var tv = SingleChildScrollView(
        //     controller: _sc,
        //     // physics: BouncingScrollPhysics(),
        //     scrollDirection: Axis.horizontal,
        //     child: con
        // );
        // var sv = DraggableScrollbar.rrect(
        //   backgroundColor: CommonUtil.alphaColor(Colors.indigo, 180),
        //   alwaysVisibleScrollThumb: true,
        //   controller: _sc,
        //   child: ListView(
        //       controller: _sc,
        //       scrollDirection: Axis.horizontal,
        //       physics: BouncingScrollPhysics(),
        //       // scrollDirection: Axis.horizontal,
        //       children: [
        //         con
        //       ],
        //   ),
        // );

        return Container(
          width: fullWidth + dragExt + rowInfoWidth,
          height : constraints.maxHeight,
          // child:sv
          child: Row(
            children: [
              leftBar,
              Expanded(child:sv),
            ],
          ),
        );
      },
    );

    return lb;
    // var stck = Stack(
    //   children: [
    //     // HoverCursor(cursor: Cursor.move, child:con),
    //     Positioned(left:0,top:0, child: con,),
    //     // getHeaderResizer(),
    //   ],
    // );
    // return stck;
    // return SingleChildScrollView(
    //     controller: _sc,
    //   physics: BouncingScrollPhysics(),
    //   scrollDirection: Axis.horizontal,
    //   child: lb
    // );
  }
  Widget getCell({double width , double height , Widget child , Color bgColor = Colors.white, BoxDecoration decoration }){
    var standardDc2 = decoration ?? new BoxDecoration(
      color : bgColor,
        border : Border(
          bottom: BorderSide(width: 1,color: widget.cellBorderColor?? CommonUtil.alphaColorD(Colors.grey,0.1)),
          top: BorderSide(width: 1,color: widget.cellBorderColor??CommonUtil.alphaColorD(Colors.grey,0.1)),
          left: BorderSide(width: 0.5,color: widget.cellBorderColor??CommonUtil.alphaColorD(Colors.grey,0.1)),
          right: BorderSide(width: 0.5,color: widget.cellBorderColor??CommonUtil.alphaColorD(Colors.grey,0.1)),
        )

      // border: new Border.all(
      //   width:1.0,
      //   color: CommonUtil.scaleColor(Colors.grey,0.1),
      // ),
      // boxShadow: [ BoxShadow(color: Color(0xd5dcea), offset:Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    );
    var con = Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: standardDc2,
        child: child,
      ),
    );

    return con;
  }
  Widget head({double width , double height , Widget child , EdgeInsetsGeometry padding}){
    var standardDc2 = new BoxDecoration(
      // color : CommonUtil.scaleColor(Colors.lightGreen,0.08),
      color: ThemeCenter.systemTheme.primaryColor,
      border : Border(
        bottom: BorderSide(width: 1,color: ThemeCenter.activeTheme.areaBorderColor),
        top: BorderSide(width: 1,color: ThemeCenter.activeTheme.areaBorderColor),
        left: BorderSide(width: 0.5,color: ThemeCenter.activeTheme.areaBorderColor),
        right: BorderSide(width: 0.5,color: ThemeCenter.activeTheme.areaBorderColor),
      )
      // border: new Border.all(
      //     width:1.0,
      //     color: CommonUtil.scaleColor(Colors.lightGreen,0.4),
      // ),
      // boxShadow: [ BoxShadow(color: Color(0xd5dcea), offset:Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    );
    return Container(
      padding: padding,
      decoration: standardDc2,
      width: width,
      height: height,
      // padding: EdgeInsets.all(0),
      child: Container(

        child: child,
      ),
    );
  }

  Widget getHeaders(){
    List<Widget> headers = List<Widget>();
    var iCount = 0;
    for (var w in widget.headerWidths){
      int index = iCount;
      iCount++;
      var fieldName = (widget.headerNames != null && widget.headerNames.length>index)?widget.headerNames[index]:null;
      var txt = Center(child: Text("${fieldName??iCount}" , style : TextStyle(color: CommonUtil.scaleColor(Colors.grey,0.8))));
      List<Widget> ws = List<Widget>();
      if (widget.headResizable)ws.add(index >0?GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragUpdate : (e){
          setState(() {
            widget.headerWidths[index-1] += e.delta.dx;
            if (widget.headerWidths[index-1] < widget.headerWidthMin) widget.headerWidths[index-1] = widget.headerWidthMin;
            if (widget.headerWidths[index-1] > widget.headerWidthMax) widget.headerWidths[index-1] = widget.headerWidthMax;
            widget.onResizeColumn?.call(widget.headerWidths);
          });
        },
        child: Icon( MaterialIcons.keyboard_arrow_right , color: ThemeCenter.mainTextStepColor(1),),
      ):SizedBox(width: 8,));
      ws.add(Expanded(child: txt,));
      var actions = widget.onGetHeaderActions?.call(index);
      if (actions != null){
        ws.addAll(actions);
      }
      if (widget.headResizable)ws.add(GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragUpdate : (e){
          setState(() {
            widget.headerWidths[index] += e.delta.dx;
            if (widget.headerWidths[index] < widget.headerWidthMin) widget.headerWidths[index] = widget.headerWidthMin;
            if (widget.headerWidths[index] > widget.headerWidthMax) widget.headerWidths[index] = widget.headerWidthMax;

            widget.onResizeColumn?.call(widget.headerWidths);
          });
        },
        child: Icon(MaterialIcons.keyboard_arrow_left , color: ThemeCenter.mainTextStepColor(1),),
      ));


      var wdg = head(width: w, height: widget.headerHeight,
        child: Row(children: ws,),
      );
      headers.add(wdg);
    }

    return Row(children: headers,);
  }

}