//@dart=2.11
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/KeFrame/frame_separate_widget.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/card_loading/card_loading.dart';
import 'package:battlepus/common/list_table_item.dart';
// import 'package:pluto_grid/pluto_grid.dart';

typedef IndexedWidgetBuilder = ItemHolder Function(BuildContext context, int index);
typedef HeaderWidgetBuilder = Widget Function(BuildContext context);
typedef SortCallback = Function(bool ascending);

typedef IndexedWidgetOnTap = Function(int index);
typedef PercentCallback = Function(double index);
typedef IndexedRowInfo = RowInfoHolder Function(int index);
typedef CombineInfoGetter = CombineInfo Function(int index);

class CombineInfo{
  int startIndex ; 
  int endIndex;
}

class ItemHolder{
  Widget widget;
}

class RowInfoHolder{
  bool forceColor = false;
  Color bgColor;
}

class ListTableColumn{
  String name;
  String key = "";
  double width;
  bool isFreeze = false;
  IndexedWidgetBuilder widgetBuilder;
  HeaderWidgetBuilder headerBuilder;
  AlignmentGeometry headAlignment = Alignment.center;
  SortCallback onSortCallback ;
  CombineInfoGetter onGetCombineInfo;
  bool ascending = true;
}

class HeaderTreeNode{
  String name;
  List<HeaderTreeNode> children = List<HeaderTreeNode>();
  ListTableColumn leafColumn;

  double getWidth() {
    if (leafColumn != null) return leafColumn.width;
    double fullWidth = 0;
    for(var n in children){
      fullWidth+= n.getWidth();
    }

    return fullWidth;
  }


}

typedef OnSortCallback = void Function(ListTableColumn column);

class ListTable extends StatefulWidget {
  final List<ListTableColumn> columns;
  final double headerHeight;
  final double itemHeight;
  final int itemCount;
  final IndexedWidgetOnTap onTap;
  final IndexedRowInfo onRowInfo;
  final double forceWidth;
  final bool scrollableBar;
  final bool useCard ;
  final bool useBoard;
  final ScrollController controller;
  final Map<String , Color> headerColors;
  final Color lineDiffColor;
  final bool useLineInterval;
  final int headMaxLevel;
  final OnSortCallback onSort;
  final ListTableColumn sortColumn;
  final bool seperateFrame ;
  final double cacheExtent;
  final bool stopScrollWhenDragEnd;
  final dynamic onPlaceHolder;

  final dynamic onReorder;
  ListTable(
      {Key key ,
        @required this.columns ,
        this.headerHeight = 32 ,
        this.itemHeight = 24,
        @required this.itemCount,
        this.onTap,
        this.onRowInfo,
        this.forceWidth = 0,
        this.scrollableBar = false,
        this.useCard = true,
        this.useBoard = true,
        this.controller,
        this.headerColors,
        this.lineDiffColor ,
        this.useLineInterval = true,
        this.headMaxLevel,
        this.onSort,
        this.sortColumn,
        this.seperateFrame = false,
        this.cacheExtent,
        this.stopScrollWhenDragEnd = true,
        this.onPlaceHolder,
        this.onReorder,
      }) : super(
      key: key);

  @override
  _ListTableState createState() =>
      _ListTableState(
      );
}

class _ListTableState extends State<ListTable> {

  ScrollController _scrollController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController?.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _sortOrder.clear();
//    _sortingColumn = null;
    _scrollController = widget.controller??new ScrollController();


//    _scrollController.addListener(() {
//      print (_scrollController.offset);
//    });
  }

  Widget rowSeparatorWidget = Divider(
    color: Colors.black38,
    height: 0.1,
    thickness: 0.6,
  );

  Widget rowSeparatorWidget2 = Divider(
    color: Colors.black38,
    height: 0.1,
    thickness: 0.5,
  );

  double getFullWidth(){
    double full = 0;
    for(var c in widget.columns){
      full += c.width;
    }

    bool withReoeder = widget.onReorder != null;
    if(withReoeder)full += reorderCellWidth + 2;
    return full;
  }
  final double rightPad = 8;
  final double reorderCellWidth = 32;
  double realFullWidth(){
    if ( widget.forceWidth<=0) return getFullWidth();

    return max(getFullWidth(),widget.forceWidth - rightPad );
  }
  @override
  Widget build(BuildContext context) {


    var header = getHeader();
    var c = Container(
        width: realFullWidth(),
//      child:SingleChildScrollView(
//        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            header,
            rowSeparatorWidget,
//            getContent(),
            Expanded(
              child: getContent(),
            ),
          ],
        ),
//      ),
    );

    var sv = SingleChildScrollView(
//      padding: EdgeInsets.all(0),
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: c,
    );
    Widget res;
    if (widget.useCard) {
      res = Card(
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(
                    0.0))),
        child: sv,
      );
    }
    else {
      res = ThemeCenter.area(
        child: sv,
      );
    }

    return res;
//    return sv;
////    return Container(
////      child: res,
////    );
  }
  Widget getContent(){
//    if (widget.sortColumn != null){
//      _sortingColumn = widget.sortColumn;
//    }
    if (widget.sortColumn  != null){
      widget.sortColumn .onSortCallback?.call(widget.sortColumn .ascending);
    }
    Widget  lv;
    // if (true){
    //   List<Widget> itms = List<Widget>();
    //   for(int i = 0 ; i < widget.itemCount ; ++i){
    //     var aitem = OnBindItem(context,i);//getItem(lst, i, innerType0, onChanged, onSubmitted, gci);
    //     itms.add(aitem);
    //   }
    //
    //   lv = SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //       // controller: _scrollController,
    //     child:ReorderableColumn(
    //
    //
    //       // crossAxisAlignment: CrossAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: itms,
    //       // needsLongPressDraggable:false,
    //       onReorder: (int oldIndex, int newIndex){
    //         setState(() {
    //           // Widget row = _rows.removeAt(oldIndex);
    //           // _rows.insert(newIndex, row);
    //           // var vvv = lst.removeAt(oldIndex);
    //           // lst.insert(newIndex, vvv);
    //           // initValue = lst;
    //         });
    //       },
    //     )
    //   ) ;
    //
    //   // lv = DragAndDropLists(
    //   //   scrollController: _scrollController,
    //   //   children: [
    //   //     DragAndDropList(
    //   //       // header: Text('Header $index'),
    //   //         children: itms),
    //   //   ],
    //   //   itemGhost: Container(
    //   //     height: 36,
    //   //     color: Colors.red,
    //   //     // child: OnBindItem(context,i),
    //   //   ),
    //   //   itemGhostOpacity: 0.6,
    //   //   onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex){
    //   //     setState(() {
    //   //       // Widget row = _rows.removeAt(oldIndex);
    //   //       // _rows.insert(newIndex, row);
    //   //       // var vvv = lst.removeAt(oldItemIndex);
    //   //       // lst.insert(newItemIndex, vvv);
    //   //       // initValue = lst;
    //   //     });
    //   //   },
    //   //   // onItemReorder: _onItemReorder,
    //   // );
    // }
    // else{
    //
    // }


    lv = ListView.builder(
      itemBuilder: OnBindItem,
      itemExtent:widget.itemHeight,
      cacheExtent: widget.cacheExtent,
      controller: _scrollController,
      itemCount: widget.itemCount,
    );

    // Widget sb ;
    // if (!widget.scrollableBar) {
    //   sb = Scrollbar(
    //     child: lv,
    //     controller: _scrollController,
    //   );
    //
    // }
    // else {
    //   sb = PlutoScrollbar(
    //     // stopScrollWhenDragEnd:widget.stopScrollWhenDragEnd,
    //     verticalController:_scrollController,
    //     horizontalController:null,
    //     isAlwaysShown: true,
    //     thickness: 8.0,
    //     thicknessWhileDragging: 10.0,
    //     child:lv,
    //     // radius: 3,
    //     // radiusWhileDragging: scrollbarConfig.scrollbarRadiusWhileDragging,
    //   );
    // }
    // return sb;
    return lv;

  }
  bool needTail(){
    return widget.forceWidth>0 && widget.forceWidth - getFullWidth() - rightPad>0;
  }
  double tailWidth(){
    return widget.forceWidth - getFullWidth() - rightPad;
  }

  HeaderTreeNode headerTreeRoot;
  int _headMaxLevel = 0;
  List<HeaderTreeNode> _nodePath;
  void _insertHeaderToTree(HeaderTreeNode node , List<String> path , ListTableColumn column , int index){
    var name = path[index];
    var subNode = _nodePath.length>index?_nodePath[index]:null;//node.children.firstWhere((element) => element.name == name , orElse: ()=>null);
    if (subNode == null || subNode.name != name){
      subNode = HeaderTreeNode();
      subNode.name = name;
      node.children.add(subNode);
    }
    if (_nodePath.length>index){
      _nodePath[index] = subNode;
    }
    else{
      _nodePath.add(subNode);
    }
    if (index >= path.length-1){
      subNode.leafColumn = column;
      return;
    }
    _insertHeaderToTree(subNode , path , column , ++index);
  }
  void _buildHeaderTree(){
    headerTreeRoot = HeaderTreeNode();
    _nodePath = List<HeaderTreeNode>();
    _headMaxLevel = widget.headMaxLevel??0;
    for(var c in widget.columns){
      var path = c.name.split('//');
      _headMaxLevel = max(_headMaxLevel , path.length);
      _insertHeaderToTree(headerTreeRoot , path , c , 0);
    }
  }

  Widget getHeaderWidget(HeaderTreeNode node, bool bFirst) {
    // return Container();
    if (node.leafColumn != null){
      var c = node.leafColumn;
      Widget w ;
      if (c.headerBuilder!=null){
        w = c.headerBuilder(context);
      }
      else{
        w = Text(c.name , style: TextStyle(fontSize: 12 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),);
      }
      // w = Text(c.name , style: TextStyle(fontSize: 12 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),);
      if (c.onSortCallback != null){
        bool bAscending = c.ascending == true;//_sortOrder[c.name] == true;
//        print("---" +_sortOrder.toString());
//        print(bAscending);
        var ib = IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(bAscending?MaterialCommunityIcons.sort_ascending:MaterialCommunityIcons.sort_descending),

          color: widget.sortColumn == c ? Colors.indigo : Colors.grey,
          onPressed: (){
//            print("---XXX " +_sortOrder.toString());
            setState(() {
              bool a = c.ascending == true;
//            print(bAscending);
              c.ascending = !a;
//            print(_sortOrder);
              c.onSortCallback.call(a);
//              widget.sortColumn  = c;

              widget.onSort?.call(c);
            });

          },
        );

        w = Row(
          children: [
            Expanded(child: w,),
            ib,
          ],
        );
      }

      var color = ThemeCenter.systemTheme.primaryColor;// CommonUtil.scaleColor(Colors.grey, 0.2);
      if (widget.headerColors != null){
        color = widget.headerColors[c.key]??Colors.white;
      }

      var dcc = bFirst?(
          BoxDecoration(
            color:color,
            border: Border(
              right: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
              left: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
            ),
          )
      ):(
          BoxDecoration(
            color:color,
            border: Border(
              right: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
            ),
          )
      );
      return Container(
        decoration: dcc,
        alignment : c.headAlignment,//Alignment.center ,
        width: c.width,
        child: w,
//        height: widget.headerHeight,
      );
    }

    List<Widget> subs = new List<Widget>();
    for(int i = 0 ;i< node.children.length ; ++i){
      var n = node.children[i];
      var w = getHeaderWidget(n,bFirst && i == 0);
      subs.add(w);
    }
    var color = CommonUtil.scaleColor(Colors.grey, 0.2);
    if (widget.headerColors != null){
      color = widget.headerColors[node.name]??Colors.white;
    }

    var dcc = bFirst?(
        BoxDecoration(
          color:color,
          border: Border(
            right: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
            bottom: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
            left: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
          ),
        )
    ):(
        BoxDecoration(
          color:color,
          border: Border(
            right: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
            bottom: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
          ),
        )
    );
    var selfHeader = Container(
      decoration: dcc,
      alignment : Alignment.center ,
      child: Text(node.name,style: TextStyle(fontSize: 12 , fontWeight:FontWeight.w600 ,color: Colors.black45),),
      width: node.getWidth(),
      height: widget.headerHeight,);

    return Column(
      children: [
        selfHeader,
        Expanded(child:Row(
          children: subs,
        )),
      ],
    );
  }

//  ListTableColumn _sortingColumn ;
  Widget getHeader(){

    _buildHeaderTree();

    List<Widget> headers = new List<Widget>();

    bool withReoeder = widget.onReorder != null;
    if (withReoeder) {
      var color = ThemeCenter.systemTheme.primaryColor;// CommonUtil.scaleColor(Colors.grey, 0.2);
      // if (widget.headerColors != null){
      //   color = widget.headerColors[c.key]??Colors.white;
      // }
      headers.add(Container(
        decoration:           BoxDecoration(
          color:color,
          border: Border(
            right: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
            left: Divider.createBorderSide(context, color: ThemeCenter.activeTheme.areaBorderColor, width: 1),
          ),
        ),
          height: _headMaxLevel * widget.headerHeight,
          child: SizedBox(width: reorderCellWidth,))
      );
    }

    var first = true;
    for(int i = 0 ;i< headerTreeRoot.children.length ; ++i){
      var n = headerTreeRoot.children[i];
      var w = getHeaderWidget(n , first);
      first = false;
      headers.add(Container(
        height: _headMaxLevel * widget.headerHeight,
          child : w)
        );
    }


//    for(var c in widget.columns){
//      Widget w ;
//      if (c.headerBuilder!=null){
//        w = c.headerBuilder(context);
//      }
//      else{
//        w = Text(c.name , style: TextStyle(fontSize: 12 , fontWeight:FontWeight.w600 ,color: Colors.black45),);
//      }
//
//      if (c.onSortCallback != null){
//        bool bAscending = c.ascending == true;//_sortOrder[c.name] == true;
////        print("---" +_sortOrder.toString());
////        print(bAscending);
//        var ib = IconButton(
//          padding: EdgeInsets.all(0),
//          icon: Icon(bAscending?MaterialCommunityIcons.sort_ascending:MaterialCommunityIcons.sort_descending),
//
//          color: _sortingColumn == c ? Colors.indigo : Colors.grey,
//          onPressed: (){
////            print("---XXX " +_sortOrder.toString());
//          setState(() {
//            bool a = c.ascending == true;
////            print(bAscending);
//            c.ascending = !a;
////            print(_sortOrder);
//            c.onSortCallback.call(a);
//            _sortingColumn = c;
//          });
//
//          },
//        );
//
//        w = Row(
//          children: [
//            Expanded(child: w,),
//            ib,
//          ],
//        );
//      }
//
//      headers.add(Container(
//        decoration: BoxDecoration(
//          border: Border(
//            right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
//          ),
//        ),
//        alignment : c.headAlignment,//Alignment.center ,
//        width: c.width,
//        child: w,
//        height: widget.headerHeight,));
////      headers.add(colSeparatorWidget);
//    }
    if (needTail()) {
      headers.add(
              Container(
                width: tailWidth(),
              ));
    }
    return Container(
//      width: getFullWidth(),
//        decoration: BoxDecoration(
//          border: Border(
//            left: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
//          ),
//        ),
        child :Row(children: headers,)
    );
  }

  Widget OnBindItem(BuildContext context, int index) {

    return ListTableItem(
      index: index,
      onRowInfo : widget.onRowInfo,
      onReorder : widget.onReorder,
      useLineInterval : widget.useLineInterval,
      reorderCellWidth : reorderCellWidth,
      columns : widget.columns,
      itemHeight : widget.itemHeight,
      tailWidth : needTail()?tailWidth():null,
      onTap : widget.onTap,
      seperateFrame : widget.seperateFrame,
      onPlaceHolder : widget.onPlaceHolder,
    );

    List<Widget> cells = new List<Widget>();
    bool useBgColor= false;
    Color bgColor ;
    var colorBorder =  CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.2);

    if (widget.onRowInfo != null){
      var info = widget.onRowInfo(index);
      useBgColor = info.forceColor;
      bgColor = info.bgColor;
    }

    bool withReoeder = widget.onReorder != null;
    if (withReoeder) {
      Widget itm = Container(
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
          color: index % 2 == 1 ? CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) : null,// useBgColor ?bgColor: (index % 2 == 1 ?widget.lineDiffColor??CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) :Color(0)),
        ),
        child: Container(width: reorderCellWidth,),

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
    if (needTail()) {
      cells.add(
              Container(
                padding: EdgeInsets.all(0),
//                child: Text("---"),
                width: tailWidth(),
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
      color: index % 2 == 1 ? CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) : null,// useBgColor ?bgColor: (index % 2 == 1 ?widget.lineDiffColor??CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) :Color(0)),
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

    if (!widget.seperateFrame){
      return itm;
    }
    var ph = Container(
      padding: EdgeInsets.all(0),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: index % 2 == 1 ? CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) : null,// useBgColor ?bgColor: (index % 2 == 1 ?widget.lineDiffColor??CommonUtil.alphaColorD(ThemeCenter.mainTextStepColor(9),0.02) :Color(0)),
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
      child: itm,
    );
  }
}