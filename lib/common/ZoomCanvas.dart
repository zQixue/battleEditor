//@dart=2.11
library zoom_widget;

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:zoom_widget/MultiTouchGestureRecognizer.dart';

class CanvasHolder{
  _ZoomCanvasState canvasState;
}
class ZoomCanvas extends StatefulWidget {
  final CanvasHolder holder;
  final double width, height;
  final double initPosX, initPosY;
  final Widget child;
  final Color backgroundColor;
  final Color canvasColor;
  final void Function(Offset) onRightPointDown;
  final void Function(Offset) onPointDown;
  final void Function(Offset) onRightPointUp;
  final void Function(Rectangle<double>) onBlueUpdate;
  final void Function(Offset) onPositionUpdate;
  final void Function(double, double) onScaleUpdate;
  final void Function(int, int) onScaleIndexUpdate;
  final double scrollWeight;
  final double opacityScrollBars;
  final Color colorScrollBars;
  final bool centerOnScale;
  // final double initZoom;
  final bool enableScroll;
  final double zoomSensibility;
  final bool doubleTapZoom;
  final List<double> zoomList;
  final int initZoomindex;
  final dynamic onHover;

  ZoomCanvas(
      {Key key,
        this.holder,
        this.width,
        this.height,
        this.initPosX,
        this.initPosY,
        this.onHover,
        this.child,
        this.onPositionUpdate,
        this.onBlueUpdate,
        this.onScaleUpdate,
        this.zoomList,
        this.initZoomindex,
        this.onScaleIndexUpdate,
        this.onRightPointUp,
        this.onPointDown,
        this.onRightPointDown,
        this.backgroundColor = Colors.grey,
        this.canvasColor = Colors.white,
        this.scrollWeight = 7.0,
        this.opacityScrollBars = 0.5,
        this.colorScrollBars = Colors.black,
        this.centerOnScale = true,
        // this.initZoom = 1.0,
        this.enableScroll = true,
        this.zoomSensibility = 1.0,
        this.doubleTapZoom = true})
      : super(key: key);

  _ZoomCanvasState createState() {
    return _ZoomCanvasState();
  }
}

class _ZoomCanvasState extends State<ZoomCanvas> with TickerProviderStateMixin {
  double localTop = 0.0;
  double changeTop = 0.0;
  double auxTop = 0.0;
  double centerTop = 0.0;
  double scaleTop = 0.0;
  double downTouchTop = 0.0;
  double localLeft = 0.0;
  double changeLeft = 0.0;
  double auxLeft = 0.0;
  double centerLeft = 0.0;
  double downTouchLeft = 0.0;
  double scaleLeft = 0.0;
  double scale = 1.0;
  double changeScale = 0.0;
  double zoom = 0.0;
  Offset midlePoint = Offset(0.0, 0.0);
  Offset relativeMidlePoint = Offset(0.0, 0.0);
  bool initOrientation = false;
  bool portrait;
  AnimationController scaleAnimation;
  bool doubleTapDown;
  double doubleTapScale = 0.0;
  BoxConstraints globalConstraints;

  int _crtButton = 0;
  bool withDrag = false;
  List<int> blueButtons = [1];
  double _blueStartX = 0;
  double _blueStartY = 0;
  double _blueEndX = 0;
  double _blueEndY = 0;
  bool _inBlue = false;
  bool _inBlueEnd = false;
  double initZoom = 1.0;

  bool isBlueShown(){
    return _inBlue && _inBlueEnd && _blueStartX != null &&_blueStartY!= null && _blueEndX != null && _blueEndY != null;
  }

  var _dc = new BoxDecoration(
    border: new Border.all(color: CommonUtil.alphaColor(Colors.blueAccent,120), width: 2), // 边色与边宽度
    color: CommonUtil.alphaColor(Colors.blueAccent,60),
  ); // 圆角度

  Widget getBlueRect(){
    // return Container();
    var startX = min(_blueStartX , _blueEndX);
    var endX = max(_blueStartX , _blueEndX);

    var startY = min(_blueStartY , _blueEndY);
    var endY = max(_blueStartY , _blueEndY);
    return Positioned(
      top:startY,
      left : startX,
      child:Container(
        // color: CommonUtil.alphaColor(Colors.blueAccent,80),
        decoration: _dc,
        width: endX - startX,
        height : endY - startY,
      ),
    );
  }


  Offset calcLocalPosition(Offset local){
    // RenderBox getBox = context.findRenderObject();
    var off = getOff();
    var scale = getScale();
    var x = (local.dx + off.dx)/scale;
    var y = (local.dy + off.dy)/scale;
    return Offset(x,y);
  }

  Rectangle<double> getBlueRectValue(){
    var startX = min(_blueStartX , _blueEndX);
    var endX = max(_blueStartX , _blueEndX);
    var startY = min(_blueStartY , _blueEndY);
    var endY = max(_blueStartY , _blueEndY);

    var start = calcLocalPosition(Offset(startX,startY));
    var end = calcLocalPosition(Offset(endX,endY));
    var s = end - start;

    return Rectangle<double>(start.dx , start.dy , s.dx , s.dy);
  }

  // static _ZoomCanvasState current ;
  Offset getOff(){
//    print("auxLeft $auxLeft localLeft $localLeft centerLeft $centerLeft scaleLeft $scaleLeft");
    return Offset(
        (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
        (auxTop + localTop + centerTop + scaleTop) * -1);
  }

  Map<String ,dynamic> getValues(){
    return {
      "auxLeft" :auxLeft,
      "auxTop" :auxTop,
      "localLeft" :localLeft,
      "localTop" :localTop,
      "centerLeft" :centerLeft,
      "centerTop" :centerTop,
      "scaleLeft" : scaleLeft,
      "scaleTop" : scaleTop,
      "scale" : scale,
      "_crtScaleIndex" : _crtScaleIndex,
    };
  }

  void setValues(Map<String ,dynamic> vals){
    setState(() {
      auxLeft = vals["auxLeft"];
      auxTop = vals["auxTop"];
      localLeft = vals["localLeft" ];
      localTop = vals["localTop"];
      centerLeft = vals["centerLeft"];
      centerTop = vals["centerTop"];
      scaleLeft = vals["scaleLeft"];
      scaleTop = vals["scaleTop"];
      scale = vals["scale"];
      _crtScaleIndex = vals["_crtScaleIndex"];
    });
  }

  double getScale(){
    return scale;
  }
  List<double> _defaultScaleList = [0.14,0.55, 0.75,1, 1.2  , 1.4 , 1.8 , 2 , 2.4 , 2.8 , 3.2];
  List<double> _scaleList = [0.14,0.55, 0.75,1, 1.2  , 1.4 , 1.8 , 2 , 2.4 , 2.8 , 3.2];
  int _crtScaleIndex = 3;
  int getScaleIndex(){
    return _crtScaleIndex;
  }
  void downScale(){
    var old = _crtScaleIndex;
    _crtScaleIndex = max(_crtScaleIndex - 1 ,0);
    widget.onScaleIndexUpdate?.call(old,_crtScaleIndex);
  }
  void upScale(){
    var old = _crtScaleIndex;
    _crtScaleIndex = min(_crtScaleIndex + 1 , _scaleList.length-1);
    widget.onScaleIndexUpdate?.call(old,_crtScaleIndex);
  }

  void doDoubleTapScale(Offset pos){
    upScale();
  }

  @override
  void initState() {

    _scaleList = widget.zoomList??_defaultScaleList;
    _crtScaleIndex = widget.initZoomindex;
    if (_crtScaleIndex == null) {
      for (int i = 0; i < _scaleList.length; ++i) {
        if (_scaleList[i] >= 1) {
          _crtScaleIndex = i;
          return;
        }
      }
    }

    initZoom = _scaleList[_crtScaleIndex];
    if (widget.holder!= null){
      widget.holder.canvasState = this;
    }
    // current = this ;
    scaleAnimation = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 80));
    scaleAnimation.addListener(() {
      setState(() {
        scale = map(scaleAnimation.value, 0.0, 1.0, doubleTapScale, _scaleList[_crtScaleIndex]);
//        if (doubleTapDown) {
//          scale = map(scaleAnimation.value, 0.0, 1.0, doubleTapScale, 1.0);
//        } else {
//          scale = map(
//              scaleAnimation.value,
//              0.0,
//              1.0,
//              doubleTapScale,
////              0.5,
//              (globalConstraints.maxHeight > globalConstraints.maxWidth)
//                  ? globalConstraints.maxWidth / widget.width
//                  : globalConstraints.maxHeight / widget.height
//          );
//        }

        scaleProcess(globalConstraints);
        scaleFixPosition(globalConstraints);
      });
      if (scaleAnimation.value == 1.0) {
        if(widget.onScaleUpdate!=null){
          widget.onScaleUpdate(scale, zoom);
        }
        if( widget.onPositionUpdate!=null){
          widget.onPositionUpdate(Offset(
              (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
              (auxTop + localTop + centerTop + scaleTop) * -1));
        }

        endEscale(globalConstraints);
      }
    });


    // focusPosition(widget.initPosX, widget.initPosY);

    super.initState();
  }

  void centered(){
    auxLeft =- widget.initPosX* scale + globalConstraints.maxWidth  / 2;
    auxTop =- widget.initPosY* scale  + globalConstraints.maxHeight / 2;
  }

  void focusPosition(double x , double y){
    auxLeft =- x* scale + (globalConstraints.maxWidth)  / 2;
    auxTop =- y* scale + (globalConstraints.maxHeight) / 2;
    setState(() {

    });
  }

  void focusPositionAtLeftTop(double x , double y , {Offset off}){
    auxLeft =- x* scale + off?.dx??0;
    auxTop =- y* scale + off?.dy??0;
    setState(() {

    });
  }

  void focusOffAtLeftTop(double x , double y , {Offset off}){
    auxLeft += x* scale ;
    auxTop += y* scale ;
    setState(() {

    });
  }

  Offset currentCenterPosition(){
    var x = -auxLeft + (globalConstraints.maxWidth)  / 2;
    var y = -auxTop + (globalConstraints.maxHeight) / 2;
    return Offset(x,y) / scale;
  }

  Offset currentDynamicCenterPosition(){
    var x = -(auxLeft + localLeft + scaleLeft) + (globalConstraints.maxWidth)  / 2;
    var y = -(auxTop + localTop + scaleTop) + (globalConstraints.maxHeight) / 2;
    return Offset(x,y) / scale;
  }

  bool _initCentered = false;
  void initCentered(){
    if (_initCentered) return;
    auxLeft =- (widget.initPosX-globalConstraints.maxWidth/2);
    auxTop =- (widget.initPosY-globalConstraints.maxHeight/2);
    //
    // auxLeft =- (widget.width/2-widget.initPosX);
    // auxTop =- (widget.height/2-widget.initPosY);

    _initCentered = true;
  }

  @override
  void dispose() {
    scaleAnimation.dispose();
    super.dispose();
  }

  double map(
      double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  void scaleFixPosition(constraints) {
    if (((widget.height * scale) > constraints.maxHeight) &&
        ((auxTop + localTop + centerTop + scaleTop) + (widget.height * scale)) <
            constraints.maxHeight) {
      localTop += constraints.maxHeight -
          ((auxTop + localTop + centerTop + scaleTop) + widget.height * scale);
    }

    if (((widget.width * scale) > constraints.maxWidth) &&
        ((auxLeft + localLeft + centerLeft + scaleLeft) +
            (widget.width * scale)) <
            constraints.maxWidth) {
      localLeft += constraints.maxWidth -
          ((auxLeft + localLeft + centerLeft + scaleLeft) +
              widget.width * scale);
    }

    if ((widget.height * scale) < constraints.maxHeight) {
      if (widget.centerOnScale) {
        centerTop = (constraints.maxHeight - widget.height * scale) / 2;
      }
    } else
      centerTop = 0.0;

    if ((widget.width * scale) < constraints.maxWidth) {
      if (widget.centerOnScale) {
        centerLeft = (constraints.maxWidth - widget.width * scale) / 2;
      }
    } else
      centerLeft = 0.0;

    zoom = map(
        scale,
        1.0,
        (constraints.maxHeight > constraints.maxWidth)
            ? constraints.maxWidth / widget.width
            : constraints.maxHeight / widget.height,
        1.0,
        0.0);
  }

  void scaleProcess(constraints) {
    Offset currentMidlePoint = Offset(
        ((auxLeft + localLeft + centerLeft) * -1 + midlePoint.dx) *
            (1 / scale) -
            localLeft,
        ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) * (1 / scale));

    if (currentMidlePoint.dx > relativeMidlePoint.dx) {
      double preScaleLeft =
          (currentMidlePoint.dx - relativeMidlePoint.dx) * scale;
      if (auxLeft + localLeft + preScaleLeft < 0) {
        scaleLeft = preScaleLeft;
      }
    } else {
      double preScaleLeft =
          (relativeMidlePoint.dx - currentMidlePoint.dx) * -scale;
      if ((auxLeft + localLeft + preScaleLeft) >
          -((widget.width * scale) - constraints.maxWidth * scale))
        scaleLeft = preScaleLeft;
    }

    if (currentMidlePoint.dy > relativeMidlePoint.dy) {
      double preScaleTop =
          (currentMidlePoint.dy - relativeMidlePoint.dy) * scale;
      if (auxTop + localTop + preScaleTop < 0) {
        scaleTop = preScaleTop;
      }
    } else {
      double preScaleTop =
          (relativeMidlePoint.dy - currentMidlePoint.dy) * -scale;
      if ((auxTop + localTop + preScaleTop) >
          -((widget.height * scale) - constraints.maxHeight * scale))
        scaleTop = preScaleTop;
    }
  }

  void endEscale(constraints) {
    auxTop += localTop + scaleTop;
    auxLeft += localLeft + scaleLeft;
    scaleLeft = 0;
    scaleTop = 0;
    localTop = 0;
    localLeft = 0;
    downTouchLeft = 0;
    downTouchTop = 0;
    if (auxLeft > 0) auxLeft = 0;
    if (auxTop > 0) auxTop = 0;

    if (widget.height * scale < constraints.maxHeight && auxTop < 0) {
      auxTop = 0;
    }

    if (widget.width * scale < constraints.maxWidth && auxLeft < 0) {
      auxLeft = 0;
    }

    if (widget.centerOnScale) {
      if (portrait) {
        if (widget.height * scale < constraints.maxHeight) {
          centerTop = (constraints.maxHeight - widget.height * scale) / 2;
        }
      } else {
        if (widget.width * scale < constraints.maxWidth) {
          centerLeft = (constraints.maxWidth - widget.width * scale) / 2;
        }
      }
    }

    if (constraints.maxHeight > constraints.maxWidth &&
        widget.width * scale < constraints.maxWidth) {
      setState(() {
        scale = constraints.maxWidth / widget.width;
      });
    }

    if (constraints.maxWidth > constraints.maxHeight &&
        widget.height * scale < constraints.maxHeight) {
      setState(() {
        scale = constraints.maxHeight / widget.height;
      });
    }
  }
  DateTime _lastPressedAdt; //上次点击时间 初始化的时候是空，下面会做判断
  @override
  Widget build(BuildContext context) {
    if (widget.holder!= null){
      widget.holder.canvasState = this;
    }
//    return rightBar();
//     print("zoom build");
    return LayoutBuilder(

      builder: (BuildContext context, BoxConstraints constraints) {

        globalConstraints = constraints;
        initCentered();
        if (!initOrientation) {
          scale = map(
              initZoom,
              1.0,
              0.0,
              1.0,
              (constraints.maxHeight > constraints.maxWidth)
                  ? constraints.maxWidth / widget.width
                  : constraints.maxHeight / widget.height);
          initOrientation = true;
          portrait =
          (constraints.maxHeight > constraints.maxWidth) ? true : false;

          if (widget.centerOnScale) {
            if (portrait) {
              if (widget.height * scale < constraints.maxHeight) {
                centerTop = (constraints.maxHeight - widget.height * scale) / 2;
              }
            } else {
              if (widget.width * scale < constraints.maxWidth) {
                centerLeft = (constraints.maxWidth - widget.width * scale) / 2;
              }
            }
          }
          if(widget.onScaleUpdate!=null){
            widget.onScaleUpdate(scale, initZoom);
          }

          if(widget.onPositionUpdate!=null){
            widget.onPositionUpdate(Offset(
                (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
                (auxTop + localTop + centerTop + scaleTop) * -1));
          }

        }

        if (!portrait && constraints.maxHeight > constraints.maxWidth) {
          portrait = true;
          centerTop = 0;
          centerLeft = 0;
          scale = 1.0;
        } else if (portrait && constraints.maxHeight <= constraints.maxWidth) {
          portrait = false;
          centerTop = 0;
          centerLeft = 0;
          scale = 1.0;
        }

        var root = RawGestureDetector(
          gestures: {
            MultiTouchGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                MultiTouchGestureRecognizer>(
                  () => MultiTouchGestureRecognizer(),
                  (MultiTouchGestureRecognizer instance) {
                instance.onSingleTap = (point) {
                  if (widget.doubleTapZoom && !scaleAnimation.isAnimating) {
                    midlePoint = point;
                    relativeMidlePoint = Offset(
                        ((auxLeft + localLeft + centerLeft) * -1 +
                            midlePoint.dx) *
                            (1 / scale),
                        ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                            (1 / scale));
                  }
                };
                instance.onMultiTap = (firstPoint, secondPoint) {
                  midlePoint = Offset((firstPoint.dx + secondPoint.dx) / 2.0,
                      (firstPoint.dy + secondPoint.dy) / 2.0);

                  relativeMidlePoint = Offset(
                      ((auxLeft + localLeft + centerLeft) * -1 +
                          midlePoint.dx) *
                          (1 / scale),
                      ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                          (1 / scale));
                };
              },
            ),
          },
          child: Container(
            color: Colors.transparent,
            child: Container(
//              onDoubleTap: () {
//                if (widget.doubleTapZoom) {
//                  if (!scaleAnimation.isAnimating){
//                    doubleTapScale = scale;
//                    doDoubleTapScale(midlePoint);
//                    scaleAnimation.forward(from: 0.0);
//                  }
//                }
//              },
              child: GestureDetector(
                dragStartBehavior : DragStartBehavior.down,


//                onTapDown: (e){
//                  if(_lastPressedAdt != null && DateTime.now().difference(_lastPressedAdt) < Duration(milliseconds: 300)){
//                    //双击
//                    if (widget.doubleTapZoom) {
//                      if (!scaleAnimation.isAnimating){
//                        doubleTapScale = scale;
//                        doDoubleTapScale(midlePoint);
//                        scaleAnimation.forward(from: 0.0);
//                      }
//                    }
//                  }
//                  _lastPressedAdt = DateTime.now();
//                },

//                onDoubleTap: (){
//                  if (widget.doubleTapZoom) {
//                    if (!scaleAnimation.isAnimating){
//                      doubleTapScale = scale;
//                      doDoubleTapScale(midlePoint);
//                      scaleAnimation.forward(from: 0.0);
//                    }
//                  }
//                },
//               onTapDown: (details){
//
//               },
                onTapDown: (e){

                },
                onTapUp: (e){
                  // print("A");
                  if (blueButtons.contains(_crtButton)) {
                    widget.onRightPointDown?.call(e.globalPosition);
                    widget.onPointDown?.call(e.globalPosition);
                  }
                  else{
                    // widget.onLeftPointDown?.call(e.globalPosition);
                    // print("C");

                  }
                  _crtButton = 0;

                },
                onScaleStart: (details) {
                  print("onScaleStart");
                  withDrag = true;
                  // if (_crtButton == 2) {
                  if (blueButtons.contains(_crtButton)) {
                    // _inBlue = true;
                    // RenderBox getBox = context.findRenderObject();
                    // var tmp = getBox.globalToLocal(details.focalPoint);
                    // _blueStartX = tmp.dx;
                    // _blueStartY = tmp.dy;

                    return ;
                  }
                  downTouchLeft = details.focalPoint.dx * (1 / scale);
                  downTouchTop = details.focalPoint.dy * (1 / scale);

                  changeScale = 1.0;
                  scaleLeft = 0;
                  changeTop = details.focalPoint.dy;
                  changeLeft = details.focalPoint.dx;

                },

                onScaleUpdate: (details) {
                  withDrag = true;
                  if (blueButtons.contains(_crtButton)) {// if (_crtButton == 2) {
                    RenderBox getBox = context.findRenderObject();
                    var tmp = getBox.globalToLocal(details.focalPoint);
                    _blueEndX = tmp.dx;
                    _blueEndY = tmp.dy;
                    _inBlueEnd = true;

                    widget.onBlueUpdate?.call(getBlueRectValue());

                    setState(() {

                    });
                    return ;
                  }
                  double up = details.focalPoint.dy - changeTop;
                  double down = (changeTop - details.focalPoint.dy) * -1;
                  double left = details.focalPoint.dx - changeLeft;
                  double right = (changeLeft - details.focalPoint.dx) * -1;

                  setState(() {
                    if (details.scale != 1.0) {
                      if (details.scale > changeScale) {
                        double preScale = scale +
                            (details.scale - changeScale) / widget.zoomSensibility;
                        if (preScale < 1.0) {
                          scale = preScale;
                        }
                      } else if (changeScale > details.scale &&
                          (widget.width * scale > constraints.maxWidth ||
                              widget.height * scale > constraints.maxHeight)) {
                        double preScale = scale -
                            (changeScale - details.scale) / widget.zoomSensibility;

                        if (portrait) {
                          if (preScale > (constraints.maxWidth / widget.width)) {
                            scale = preScale;
                          }
                        } else {
                          if (preScale > (constraints.maxHeight / widget.height)) {
                            scale = preScale;
                          }
                        }
                      }

                      scaleProcess(constraints);
                      scaleFixPosition(constraints);




                      changeScale = details.scale;
                    } else {
                      if (details.focalPoint.dy > changeTop &&
                          (auxTop + up) < 0 &&
                          (auxTop + up) >
                              -((widget.height) * scale - constraints.maxHeight)) {
                        localTop = up;
                      } else if (changeTop > details.focalPoint.dy &&
                          (auxTop + down) < 0 &&
                          (auxTop + down) >
                              -((widget.height) * scale - constraints.maxHeight)) {
                        localTop = down;
                      }
                      if (details.focalPoint.dx > changeLeft &&
                          (auxLeft + right) < 0 &&
                          (auxLeft + right) >
                              -((widget.width * scale) - constraints.maxWidth)) {
                        localLeft = right;
                      } else if (changeLeft > details.focalPoint.dx &&
                          (auxLeft + left) < 0 &&
                          (auxLeft + left) >
                              -((widget.width * scale) - constraints.maxWidth)) {
                        localLeft = left;
                      }
                    }

                    if( widget.onScaleUpdate!=null){
                      widget.onScaleUpdate(scale, zoom);
                    }
                  });

                  if(widget.onPositionUpdate!=null){
                    widget.onPositionUpdate(Offset(
                        (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
                        (auxTop + localTop + centerTop + scaleTop) * -1));
                  }
                },
                onScaleEnd: (details) {

                  endEscale(constraints);
                },
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: widget.backgroundColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: auxTop + localTop + centerTop + scaleTop,
                        left: auxLeft + localLeft + centerLeft + scaleLeft,
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.canvasColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius:
                                    20.0, // has the effect of softening the shadow
                                    spreadRadius:
                                    5.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      10.0, // horizontal, move right 10
                                      10.0, // vertical, move down 10
                                    ),
                                  )
                                ]),
                            width: widget.width,
                            height: widget.height,
                            child: widget.child,
                          ),
                        ),
                      ),
                      Positioned(
                        top: constraints.maxHeight - widget.scrollWeight,
                        left: -(auxLeft + localLeft + centerLeft + scaleLeft) /
                            ((widget.width * scale) / constraints.maxWidth),
                        child: Opacity(
                          opacity: (widget.width * scale <= constraints.maxWidth ||
                              !widget.enableScroll)
                              ? 0
                              : widget.opacityScrollBars,
                          child: Container(
                            height: widget.scrollWeight,
                            width: constraints.maxWidth /
                                ((widget.width * scale) / constraints.maxWidth),
                            color: widget.colorScrollBars,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -(auxTop + localTop + centerTop + scaleTop) /
                            ((widget.height * scale) / constraints.maxHeight),
                        left: constraints.maxWidth - widget.scrollWeight,
                        child: Opacity(
                          opacity:
                          (widget.height * scale <= constraints.maxHeight ||
                              !widget.enableScroll)
                              ? 0
                              : widget.opacityScrollBars,
                          child: Container(
                            width: widget.scrollWeight,
                            height: constraints.maxHeight /
                                ((widget.height * scale) / constraints.maxHeight),
                            color: widget.colorScrollBars,
                          ),
                        ),
                      ),
                      isBlueShown()?getBlueRect():Container(),
                      rightBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        return MouseRegion(
          onHover: (PointerHoverEvent event){
            widget.onHover?.call(event.position);
          },

          child: Listener(

            onPointerDown: (PointerDownEvent event){
              // print ("onPointerDown");
              _crtButton = event.buttons;
              withDrag = false;
              // print("_crtButton = $_crtButton");
              // if (_crtButton == 2) {
              if (blueButtons.contains(_crtButton)) {
                _inBlue = true;
                RenderBox getBox = context.findRenderObject();
                var tmp = getBox.globalToLocal(event.position);
                _blueStartX = tmp.dx;
                _blueStartY = tmp.dy;
                // widget.onRightPointDown?.call();
                return ;
              }
              else{

              }
            },
            onPointerUp: (PointerUpEvent event){
              if (!withDrag){
                // print("tap up $_crtButton");
                if (_crtButton == 2) {
                  RenderBox getBox = context.findRenderObject();
                  // var tmp = getBox.globalToLocal(event.position);
                  widget.onRightPointUp?.call(event.position);
                }
              }

              _inBlue = false;
              _inBlueEnd = false;
              setState(() {

              });

              // _crtButton = 0;
            },
            onPointerSignal: (PointerSignalEvent event) {

              if (event is PointerScrollEvent) {
//                print('x: ${event.position.dx}, y: ${event.position.dy}');
//                print('scroll delta: ${event.scrollDelta}');

                if (!scaleAnimation.isAnimating){
//                  if (widget.doubleTapZoom && !scaleAnimation.isAnimating) {
                  RenderBox getBox = context.findRenderObject();
//    var local = getBox.globalToLocal(details.offset);

                  midlePoint = getBox.globalToLocal(event.position);
                  relativeMidlePoint = Offset(
                      ((auxLeft + localLeft + centerLeft) * -1 +
                          midlePoint.dx) *
                          (1 / scale),
                      ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                          (1 / scale));
//                  }
                  doubleTapScale = scale;
//                  doDoubleTapScale(midlePoint);
                  if (event.scrollDelta.dy<0) upScale();
                  else downScale();
                  scaleAnimation.forward(from: 0.0);
                }
              }
            },
            child: root,
          ),
        );
      },
    );
  }

  Widget rightBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(icon: Icon(Icons.center_focus_weak),iconSize: 44, color: Colors.indigo, tooltip:"回到原点",
          onPressed: (){
//          print("---- center");
            setState(() {
              centered();
              // focusPosition(SSDefines.canvasZeroX,SSDefines.canvasZeroY);
            });
          },
        ),
      ],
    );
  }

  Offset global2LocalDelta(Offset offset){
    var scale = getScale();
    return offset / scale;
  }

  // Offset fixPosition(Offset off) {
  //   var x = ((off.dx - SSDefines.canvasZeroX) / SSDefines.fixPosX).floor() * SSDefines.fixPosX + SSDefines.canvasZeroX;//- BTDefines.nodeWidth/2 * viewZoom;
  //   var y  = ((off.dy - SSDefines.canvasZeroY)/ SSDefines.fixPosY ).floor()* SSDefines.fixPosY + SSDefines.canvasZeroY;//- BTDefines.nodeHeight/2 * viewZoom;
  //   return Offset(x,y);
  // }
}
