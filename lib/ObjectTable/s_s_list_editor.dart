//@dart=2.11
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/s_s_list_item.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/ThemeCenter.dart';
// import 'package:pluto_grid/pluto_grid.dart';

class SelectorHolder{
  int selectValue;
}
class SSListEditor extends StatefulWidget {
  final dynamic initValue ;
  final dynamic onChanged ;
  final dynamic onSubmitted;
  final double itemExtent;
  final double cacheExtent;
  final bool separateFrame;
  final bool useBuilder;
  final GridCellInfo gci;
  final SSFieldType innerType0;
  final String name;
  final bool noContent;
  // final SelectorHolder selectorValue;
  // final Color selectColor ;
  SSListEditor({Key key ,this.noContent = false , this.useBuilder = true, this.cacheExtent ,this.separateFrame = false,this.itemExtent, this.name, this.gci,this.innerType0 , this.initValue , this.onChanged , this.onSubmitted
    // , this.selectorValue , this.selectColor
  }) : super(key: key);

  @override
  _SSListEditorState createState() => _SSListEditorState();
}

class _SSListEditorState extends State<SSListEditor> {

  dynamic initValue;
  bool _operateMode = false ;
  ScrollController scrollController;
  // Map<int , bool> expandeds = Map<int , bool>();
  bool expandedMode = false;
  @override
  void dispose() {
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    initValue = widget.initValue;
    scrollController = ScrollController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // var initValue = widget.initValue;
    var onChanged = widget.onChanged;
    var onSubmitted = widget.onSubmitted;
    var innerType0 = widget.innerType0;

    var gci = widget.gci;
    List<dynamic> lst = [];
    if (initValue is List<dynamic> ){
      lst = initValue;
    }
    Widget finalList;

    if (widget.useBuilder??false) {
      finalList = ListView.builder(
        itemExtent: widget.itemExtent,
        cacheExtent: widget.cacheExtent,
        // cacheExtent: 500,
        controller: scrollController,
        itemBuilder: (context, i) {
          return SSListItem(key : ValueKey(lst[i]),separateFrame : widget.separateFrame, itemExtent: widget.itemExtent, lst:lst, index:i, innerType0:innerType0,
              // expanded: expandedMode??false,
              // onExpandedChanged: (idx,ex){
              //   expandeds[idx] = ex;
              // },
              onChanged:(v){
                onChanged?.call(v);
                setState(() {
                  initValue = v;
                });
              },
              onSubmitted:(v){
                onSubmitted?.call(v);
                setState(() {
                  initValue = v;
                });
              },
              gci:gci);
        },
        itemCount:(widget.noContent)? min(1,lst.length):lst.length,
        // itemExtent: widget.it,
        scrollDirection: Axis.vertical,
      );
    }
    else{
      List<Widget> itms = List<Widget>();
      for(int i = 0 ; i < lst.length ; ++i){
        if (widget.noContent && i>0){
          break;
        }
        var aitem = SSListItem(key : ValueKey(lst[i]),separateFrame : widget.separateFrame,itemExtent: widget.itemExtent , lst:lst, index:i, innerType0:innerType0,
            onChanged:(v){
              onChanged?.call(v);
              setState(() {
                initValue = v;
              });
            },
            onSubmitted:(v){
              onSubmitted?.call(v);
              setState(() {
                initValue = v;
              });
            },
            gci:gci);
        itms.add(aitem);
        // itms.add(DragAndDropItem(child:aitem));

      }
      finalList = ListView(
        itemExtent: widget.itemExtent,
        cacheExtent: widget.cacheExtent,
        // cacheExtent: 500,
        controller: scrollController,
        children: itms,
        scrollDirection: Axis.vertical,
      );
      // List<DragAndDropItem> itms = List<DragAndDropItem>();
      // for(int i = 0 ; i < lst.length ; ++i){
      //   var aitem = getItem(lst, i, innerType0, onChanged, onSubmitted, gci);
      //   // itms.add(aitem);
      //   itms.add(DragAndDropItem(child:aitem));
      // }
      // finalList = DragAndDropLists(
      //   children: [
      //     DragAndDropList(
      //       // header: Text('Header $index'),
      //         children: itms),
      //   ],
      //   onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex){
      //     setState(() {
      //       // Widget row = _rows.removeAt(oldIndex);
      //       // _rows.insert(newIndex, row);
      //       var vvv = lst.removeAt(oldItemIndex);
      //       lst.insert(newItemIndex, vvv);
      //       initValue = lst;
      //     });
      //   },
      //   // onItemReorder: _onItemReorder,
      // );
    }



      // var lv2 = PlutoScrollbar(
      //   verticalController:scrollController,
      //   horizontalController:null,
      //   isAlwaysShown: false,
      //   thickness: 8.0,
      //   thicknessWhileDragging: 10.0,
      //   child:finalList,
      //   // radius: 3,
      //   // radiusWhileDragging: scrollbarConfig.scrollbarRadiusWhileDragging,
      // );
    var lv2 = finalList;
      // radius: 3,
      // radiusWhileDragging: scrollbarConfig.scrollbarRadiusWhileDragging,

      var edtCon = Container(
        // width: 600,
        // padding: EdgeInsets.fromLTRB(0, 0, 8, 0),

        // color:maincolor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child : lv2),
            // Expanded(
            //   child: DragAndDropLists(
            //     children: [
            //       DragAndDropList(
            //         // header: Text('Header $index'),
            //         children: ddis),
            //     ],
            //     onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex){
            //       setState(() {
            //         // Widget row = _rows.removeAt(oldIndex);
            //         // _rows.insert(newIndex, row);
            //         var vvv = lst.removeAt(oldItemIndex);
            //         lst.insert(newItemIndex, vvv);
            //         initValue = lst;
            //       });
            //     },
            //     // onItemReorder: _onItemReorder,
            //   ),
            // ),

            Container(
              // width: 340,
              height:32,
//            height: levelInfo.lineHeight,
//            width: levelInfo.lineWidth + (bOpen?levelInfo.spaceStep+2:0.0),
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              decoration : BoxDecoration(
                // border: new Border.all(color: colorBd, width: 1),
                color :Color(0xff2c323e),
                //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
                // boxShadow: [ BoxShadow(color: colorBd, offset:Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 0.0) , BoxShadow(color: colorBd)],
                borderRadius: new BorderRadius.circular((5)),
              ),

              child:Row(
                children: [

                  // ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,color: Colors.green,
                  //     width: 24 , height:24,
                  //     tooltip: "添加",
                  //     onPressed: (){
                  //       setState(() {
                  //
                  //         expandedMode = !expandedMode;
                  //
                  //       });
                  //     }
                  // ),

                  Expanded(child: SizedBox(),),
                  ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,color: Colors.green,
                      width: 24 , height:24,
                      tooltip: "添加",
                      onPressed: (){
                        setState(() {

                          var guid = innerType0.createObject();
                          if (guid != null){
                            var df = innerType0.parseValue(guid);
                            lst.add(df);
                          }
                          else{
                            var df = innerType0.parseValue(null);
                            lst.add(df);
                          }
                          onSubmitted?.call(lst);
                          setState(() {
                            initValue = lst;
                          });

                        });
                      }
                  ),
                  if (innerType0.useComment())ThemeCenter.iconBtn(MaterialCommunityIcons.comment_plus_outline,color: Colors.white,
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                      width: 24 , height:24,
                      tooltip: "添加注释",
                      onPressed: (){
                        setState(() {

                          setState(() {

                            var guid = innerType0.createObject(para: "comment");
                            if (guid != null){
                              var df = innerType0.parseValue(guid);
                              lst.add(df);
                            }
                            else{
                              var df = innerType0.parseValue(null);
                              lst.add(df);
                            }

                            onSubmitted?.call(lst);
                            setState(() {
                              initValue = lst;
                            });

                          });

                        });
                      }
                  ),
                  // ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,color: Colors.brown,
                  //     width: 24 , height:24,
                  //     tooltip: "添加注释",
                  //     onPressed: (){
                  //       setState(() {
                  //
                  //         var guid = innerType0.createObject();
                  //         if (guid != null){
                  //           var df = innerType0.parseValue(guid);
                  //           lst.add(df);
                  //         }
                  //         else{
                  //           var df = innerType0.parseValue(null);
                  //           lst.add(df);
                  //         }
                  //         onSubmitted?.call(lst);
                  //         setState(() {
                  //           initValue = lst;
                  //         });
                  //
                  //       });
                  //     }
                  // ),
                  // Expanded(child : Text(widget.name??"")),
                  // ThemeCenter.iconBtn(MaterialCommunityIcons.drag_variant,
                  //     width: 24 , height:24,
                  //     tooltip: "排序模式",
                  //     color: _isReorder?Colors.lightBlue:Colors.grey,
                  //     onPressed: (){
                  //       setState(() {
                  //         _isReorder = !_isReorder;
                  //
                  //       });
                  //     }
                  // ),
                  // SizedBox()
                ],
              ),
            ),
          ],
        ),
      );

      return edtCon;

  }

  // Widget getItem(lst,i,innerType0,onChanged,onSubmitted,gci){
  //   var crt = lst[i];
  //   crt = innerType0.parseValue(crt);
  //   var w = innerType0.getGridCellEditor(initValue:crt,
  //     onChanged:(v){
  //       setState(() {
  //         lst[i] = v;
  //         onChanged?.call(lst);
  //       });
  //
  //     },
  //     onSubmitted:(v){
  //       setState(() {
  //         lst[i] = v;
  //         onChanged?.call(lst);
  //       });
  //     },
  //     gci: gci,
  //     context: context,
  //
  //   );
  //   var color = (i%2 ==1) ? Color(0x6F242730) : Color(0xfF242730);
  //
  //   var dc = new BoxDecoration(
  //       color :color,
  //       borderRadius: new BorderRadius.circular((4))
  //   );
  //   var rowitem = Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         width: 32, height: 32,
  //         child:ThemeCenter.iconBtn(Icons.menu , color: Colors.grey,
  //           width: 20 , height :20 ,
  //           tooltip: "操作",
  //           onPressed: (){
  //
  //             // lst.removeAt(i);
  //             // onSubmitted?.call(lst);
  //             // setState(() {
  //             //   initValue = lst;
  //             // });
  //           },
  //         ),
  //       ),
  //       Expanded(child:w.widget),
  //       SizedBox(width: 12,),
  //     ],
  //   );
  //   if (!widget.separateFrame){
  //     var itm = Container(
  //       key: ValueKey(i),
  //       decoration: dc,
  //       child: rowitem,
  //     );
  //     return itm;
  //   }
  //
  //   var fsw = FrameSeparateWidget(
  //     index: i,
  //     placeHolder: Padding(
  //       padding: EdgeInsets.fromLTRB(widget.itemExtent/3, widget.itemExtent/3, widget.itemExtent/3, widget.itemExtent/3),
  //       // child: Center(child:Text("...")),
  //       child:Center(child:CardLoading(
  //         cardLoadingTheme: CardLoadingTheme(colorOne: Colors.green,colorTwo:Colors.grey),
  //         height: 2,
  //         animationDuration : const Duration(milliseconds: 1600),
  //         borderRadius: BorderRadius.all(Radius.circular(1)),
  //         // margin: EdgeInsets.all(value),
  //       )),
  //       // decoration: dc,
  //       // height: widget.itemExtent,
  //     ),
  //     child: rowitem,
  //   );
  //   // return rowitem;
  //
  //   return  Container(
  //     key: ValueKey(i),
  //     decoration: dc,
  //     child: fsw,
  //   );
  //
  // }
}