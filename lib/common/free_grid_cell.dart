//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battlepus/common/EventCenter.dart';

class FreeGridCell extends StatefulWidget {
  final dynamic onItemBuilder;
  final double x1;
  final double x2;
  final int row;
  final int col;
  final double rx1;
  final double rx2;
  FreeGridCell({Key key , this.onItemBuilder , this.x1 , this.x2 ,this.rx1 , this.rx2 , this.row,this.col}) : super(key: key);

  @override
  _FreeGridCellState createState() => _FreeGridCellState();
}

class _FreeGridCellState extends State<FreeGridCell> {
  double rangeX1 ;
  double rangeX2 ;
  StreamSubscription<GridRefreshRange> _lis2;
  @override
  void dispose() {
    _lis2?.cancel();
    // TODO: implement dispose
    super.dispose();

  }
  @override
  void initState() {
    rangeX1 = widget.rx1;
    rangeX2 = widget.rx2;
    _lis2 = EventCenter.eventBus.on<GridRefreshRange>().listen((event) {
      rangeX1 = event.x1;
      rangeX2 = event.x2;
      if (!isShown){

        if (!(widget.x1 > rangeX2 || widget.x2 < rangeX1)) {
          setState(() {
          });
        }
      }

    });
    super.initState();
  }
  bool isShown = false;
  @override
  Widget build(BuildContext context) {
    if (rangeX1 == null || rangeX2 == null){
      isShown = true;
      return widget.onItemBuilder.call(widget.row , widget.col);
    }
    if (widget.x1 > rangeX2 || widget.x2 < rangeX1) {
      isShown = false;
      return Container();
    }
    isShown = true;
    return widget.onItemBuilder.call(widget.row , widget.col);
  }
}