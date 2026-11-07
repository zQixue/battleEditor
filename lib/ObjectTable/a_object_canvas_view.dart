//@dart=2.11
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ClassDecoration.dart';
import 'package:battlepus/ObjectTable/Struct/FieldLayout.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/ObjectTable/a_object_view.dart';
import 'package:battlepus/ObjectTable/plugins/TableImporter.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/common/ClipBoard.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart' as EVC;
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'package:uuid/uuid.dart';

class AObjectCanvasView extends StatefulWidget {
  final AObject rootObject;
  final CanvasHolder canvasHolder;
  final bool withItemList;
  const AObjectCanvasView({Key key , this.withItemList = true ,this.rootObject , this.canvasHolder}) : super(key: key);

  @override
  _AObjectCanvasViewState createState() => _AObjectCanvasViewState();
}

class _AObjectCanvasViewState extends State<AObjectCanvasView> {
  FocusNode _focusNode;
  StreamSubscription<EVC.FocusCanvasEvent> _lis5;
  StreamSubscription<EVC.KeyEvent> _lis4;
  // StreamSubscription<AObjectTableCleared> _lis6;

  CanvasHolder holder = CanvasHolder();

  void _handleKeyEvent(RawKeyEvent value) {
    // print("$value");
    KeyEventCenter.updateKeyState(value);
  }

  @override
  void dispose() {
    _lis5?.cancel();
    _lis4?.cancel();
    // _lis6?.cancel();
    _focusNode?.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  // FieldGroup crtFocusGroup ;

  @override
  void initState() {
    holder = widget.canvasHolder??CanvasHolder();
    FocusManager.instance.addListener(() {
      if (FocusManager.instance.primaryFocus is FocusScopeNode){
        _focusNode.requestFocus();
      }
    });
    // _lis6 = EventCenter.eventBus.on<AObjectTableCleared>().listen((event) {
    //   setState(() {
    //
    //   });
    // });

    _lis5 = EVC.EventCenter.eventBus.on<EVC.FocusCanvasEvent>().listen((event) {
      _focusNode.requestFocus();
    });
    _lis4 = EVC.EventCenter.eventBus.on<EVC.KeyEvent>().listen((event) {

      if (event.key == LogicalKeyboardKey.f11) {
        print("----------------- pageDown");
        if (widget.rootObject == null) return;
        var crtFocusGroup = OTDefines.crtFocusGroup;
        var groups = widget.rootObject?.getClazz()?.groups?.values?.toList();
        if (groups == null || groups.length <=0) return;
        var idx = 0;
        if (crtFocusGroup != null){
          idx = groups.indexOf(crtFocusGroup);
          if (idx < 0 ) idx = 0;
        }
        idx = (idx + 1)%groups.length;

        var fg = groups[idx];
        var rect = fg.getGroupRect(widget.rootObject?.getClazz());
        var old = OTDefines.crtFocusGroup;
        OTDefines.crtFocusGroup = fg;
        EVC.EventCenter.eventBus.fire(EVC.AGroupChanged()..group = old);
        EVC.EventCenter.eventBus.fire(EVC.AGroupChanged()..group = fg);
        holder.canvasState.focusPositionAtLeftTop(rect.left + OTDefines.canvasZeroX, rect.top + OTDefines.canvasZeroY , off : widget.withItemList?  Offset(64.0 + 380,64) : Offset(64,64));

        BotToast.showText(text: fg.name);

      }
      if (event.key == LogicalKeyboardKey.f12) {
        print("----------------- pageUp");
        if (widget.rootObject == null) return;
        var crtFocusGroup = OTDefines.crtFocusGroup;
        var groups = widget.rootObject?.getClazz()?.groups?.values?.toList();
        if (groups == null || groups.length <=0) return;
        var idx = 0;
        if (crtFocusGroup != null){
          idx = groups.indexOf(crtFocusGroup);
          if (idx < 0 ) idx = 0;
        }
        idx = (idx - 1 + groups.length)%groups.length;

        var fg = groups[idx];
        var rect = fg.getGroupRect(widget.rootObject?.getClazz());
        var old = OTDefines.crtFocusGroup;
        OTDefines.crtFocusGroup = fg;
        EVC.EventCenter.eventBus.fire(EVC.AGroupChanged()..group = old);
        EVC.EventCenter.eventBus.fire(EVC.AGroupChanged()..group = fg);
        holder.canvasState.focusPositionAtLeftTop(rect.left + OTDefines.canvasZeroX, rect.top + OTDefines.canvasZeroY , off : widget.withItemList?  Offset(64.0 + 380,64) : Offset(64,64));

        BotToast.showText(text: fg.name);
      }
      if (event.key == LogicalKeyboardKey.f9) {
        //向 Unity 发送
        if (widget.rootObject == null) return;
        TableUtiles.currentObject = widget.rootObject;
        bool bRet = widget.rootObject.flush2Unity();
        if (bRet){
          BotToast.showText(text: "刷新完毕" , contentColor:  Colors.green);
        }
        var err = TableImporter.logger;
        ObjectTableProject.checkShowLog(err , context: context,);
      }

      if (!OTDefines.editMode) return ;

      if (event.key == LogicalKeyboardKey.delete) {
//        print("del");
        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
          setState(() {
            // scriptHistory.appendHistory();
            delete();
            setState(() {

            });
            // EventCenter.eventBus.fire(AOb());
            // EventCenter.eventBus.fire(GlobalRefreshEvent());
          });
        });
        KeyEventCenter.clearKey(LogicalKeyboardKey.delete);
      }


      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyC)|| event.key == LogicalKeyboardKey.f3) {
        doCopy();
      }
      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyV)|| event.key == LogicalKeyboardKey.f4) {
        doPaste();
      }
      // if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyD)|| event.key == LogicalKeyboardKey.f7) {
      //   doCopy();
      //   doPaste();
      // }

      if (event.key == LogicalKeyboardKey.f5) {
        var focusItem = widget.rootObject;
        if (focusItem == null) return ;
        var clz = focusItem.getClazz();
        var map = clz.getFiled2GroupMap();
        clz.fieldsLayouts.forEach((key, value) {
          if (value.selected??false){
            if (event.event.isControlPressed){
              var g = map[key];
              if (g != null){
                var group = clz.groups[g];
                if (group != null){
                  group.showTitle = false;
                  EVC.EventCenter.eventBus.fire(EVC.AGroupChanged()..group =group );
                }
              }
            }
            else{
              value.showTitle = false;
              EVC.EventCenter.eventBus.fire(EVC.AFieldTransformChanged()..fieldGuid = key);
            }

          }
        });
      }
      if (event.key == LogicalKeyboardKey.f6) {
        var focusItem = widget.rootObject;
        if (focusItem == null) return ;
        var clz = focusItem.getClazz();
        var map = clz.getFiled2GroupMap();
        clz.fieldsLayouts.forEach((key, value) {
          if (value.selected??false){
            if (event.event.isControlPressed){
              var g = map[key];
              if (g != null){
                var group = clz.groups[g];
                if (group != null){
                  group.showTitle = true;
                  EVC.EventCenter.eventBus.fire(EVC.AGroupChanged()..group =group );
                }
              }
            }
            else{
              value.showTitle = true;
              EVC.EventCenter.eventBus.fire(EVC.AFieldTransformChanged()..fieldGuid = key);
            }

          }
        });
      }
    });




    _focusNode = FocusNode();
    _focusNode.requestFocus();
    // TODO: implement initState
    super.initState();
  }

  // List<AObject> getObjects(){
  //   var res = List<AObject>();
  //
  // }

  @override
  Widget build(BuildContext context) {

    holder.canvasState = null;
    OTDefines.mainCanvas = holder;

    // List<Widget> objs = List<Widget>();

    return LayoutBuilder(

      builder:(BuildContext context, BoxConstraints constraints){
//        print("build 2");
//         var minScale = ZoomState.current != null && ZoomState.current.getScale()<0.4;
        // checkTimelineMode();
        var zm = ZoomCanvas(
          holder: holder,
          onHover: (pos){
            // print(event);
            // hoverPos = pos;
          },
          zoomList: [0.2,0.3, 0.4, 0.5, 0.6 , 0.7 , 0.8  , 0.9 , 1.0 , 1.2 , 1.4 , 1.6 , 1.8,2.0,2.4,2.8,3.2,3.8 ,5],
          initZoomindex: 8,
          width: OTDefines.canvasWidth,
          height: OTDefines.canvasHeight,
          initPosX:OTDefines.canvasZeroX + constraints.maxWidth / 3 ,
          initPosY:OTDefines.canvasZeroY + constraints.maxHeight / 3 ,
          onPointDown: (off){
            // var offLocal = calcLocalPosition(off);
            // if (off.dy<=180) {
            //   TimelineCursorInfo.posX = (offLocal.dx - OTDefines.canvasZeroX).floorToDouble();
            // }
            // print("blueStoreSelect");
            // blueStoreSelect();
            if (widget.rootObject?.getClazz() == null) return ;
            widget.rootObject.getClazz().unSelectAll();
          },
          onBlueUpdate:  OTDefines.editMode?(rect){
            blueSelect(rect);
          }:null,
          onRightPointDown:(off){
            // if (ScriptInfo.current == null) return ;
            // bool bAppend = KeyEventCenter.isControlPressed();
            // if (!bAppend) {
            //   var count = ScriptInfo.current.unselectAll();
            //   EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = false);
            //   EventCenter.eventBus.fire(RefreshConnectCommandEvent()..openedPortConnection = null..openChanged = true);
            //   EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
            //   EventCenter.eventBus.fire(PortClickEvent()..node = null);
            // }
          },
          onRightPointUp: (pos){
            // var tmpPos = Offset(pos.dx , pos.dy);
            // tmpPos = calcLocalPosition(tmpPos);
            // tmpPos = fixPosition(tmpPos);
            // RenderBox getBox = context.findRenderObject();
            // var local = getBox.globalToLocal(pos);
            // EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx ..showListY = local.dy);
          },
          onScaleUpdate: (scale,zoom){
            // EventCenter.eventBus.fire(LocationFlagEvent()..scale = scale);
            // EventCenter.eventBus.fire(NodeTypeListRefreshEvent()..bShow = false);
            // EventCenter.eventBus.fire(TimelineCursorRefresh());
          },
          scrollWeight: 11.0,
          canvasColor: Colors.black,//(isStepping && !steppingFlash)?CommonUtil.changeColorLightness(Color(0xFF336633), 0.2): Colors.black,
          colorScrollBars: Colors.indigo,

          child:
          Center(child:Stack(
            children: [



              AObjectView(object: widget.rootObject, canvas : holder , editMode: OTDefines.editMode,),

              // RepaintBoundary(child:IgnorePointer(
              //   child: CanvasGrid(
              //     lineColor: Color.fromARGB(30, 200, 200, 200),
              //     axisColor: Color(0x1F66FF66),
              //     xStep: OTDefines.fixPowerX,yStep: OTDefines.fixPowerY,),
              // )),
              // CanvasGrid(
              // lineColor: Color.fromARGB(30, 200, 200, 200),
              // axisColor: Color(0x1F66FF66),
              // xStep: OTDefines.fixPowerX,yStep: OTDefines.fixPowerY,),

              // RepaintBoundary(child:dragTarget,),
              // RepaintBoundary(child:GroupFlagNamesView(script: ScriptInfo.current,scale : ZoomState.current?.getScale()??1),),
              // RepaintBoundary(child:IgnorePointer(
              //   child: ConnectLineView(),
              // )),
              // ConnectLineCommands(graph: this,),
              // RepaintBoundary(child:MultiDraggingView()),
              // if (StateScriptNode.withTimelineNode??false)IgnorePointer(child:TimelinesViewer(width : constraints.maxWidth , height :constraints.maxHeight)),
              // if (StateScriptNode.withTimelineNode??false)TimelineCursor(height: constraints.maxHeight,graph: this),
            ],
          )),
        );

        // steppingFlash = false;
        // var mc = Container(
        //   // padding: EdgeInsets.all(40),
        //   // color: Colors.blueAccent,
        //   child: zm,
        // );

        // return zm;//
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _handleKeyEvent,
          child:zm,
        );
      },
    );
  }

  Offset calcLocalPosition(Offset offset){
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(offset);
    var off = holder.canvasState.getOff();
    var scale = holder.canvasState.getScale();
    var x = (local.dx + off.dx)/scale;
    var y = (local.dy + off.dy)/scale;
    return Offset(x,y);
  }

  Map<String , bool> oriSelecteds = Map<String , bool>();

  void blueSelect(Rectangle<double> rect){
    if (widget.rootObject == null) return ;
    var clz = widget.rootObject.getClazz();
    var fields = clz.getAllFields();
    // bool bAppend = KeyEventCenter.isControlPressed();

    for(var f in fields){
      var fl = clz.getFieldLayout(f);
      var dp = Point(fl.x + OTDefines.canvasZeroX , fl.y + OTDefines.canvasZeroY);
      var old = fl.selected;
      fl.selected = (rect.containsPoint(dp)) ;//|| (bAppend && oriSelecteds[f.guid]??false));
      if (old!= fl.selected) EVC.EventCenter.eventBus.fire(EVC.AFieldTransformChanged()..fieldGuid = f.guid);
    }
    // EventCenter.eventBus.fire(RefreshConnectCommandEvent());
  }

  // void delete() {}

  void delete(){
//    print("delete");
    if (widget.rootObject == null) return ;
    var clz = widget.rootObject.getClazz();
    var allFields = clz.getAllFields();
    allFields.forEach((element) {
      var fl = clz.getFieldLayout(element);
      if (!fl.selected) return ;
      fl.selected = false;
      if (element is ClassDecoration){
        print("----------------- delete -------------------");
        clz.decorations.remove(element.guid);
      }
    });
    // clz.decorations.clear();
    clz.rebuildAllFields();
    EVC.EventCenter.eventBus.fire(EVC.AObjectForceChanged()..obj = widget.rootObject);

  }

  void doCopy(){
    //        setState(() {
    if (widget.rootObject == null) return ;
    var clz = widget.rootObject.getClazz();
    var allFields = clz.getAllFields();

    ClipBoard.clear();
    // copyScript = ScriptInfo.current.scriptData;
    for(var element in allFields){
      if (element is ClassDecoration){
        var fl = clz.getFieldLayout(element);
        if (fl.selected) {
          ClipBoard.copyJsonObj("decoration", element);
          ClipBoard.copyJsonObj("layout", fl..tag = element.guid);
        }
      }

    }
    BotToast.showText(text: "已复制" , contentColor: Colors.green);
  }

  void doPaste(){
    if (widget.rootObject == null) return ;
    var clz = widget.rootObject.getClazz();

    var nodeJsons = ClipBoard.getJsonObj("decoration");//ScriptInfo.current.scriptData.nodes;
//          ClipBoard.clear();
//       var nodeJsons = ClipBoard.getJsonObj("decoration");
    Map<String,FieldLayout> fls = Map<String,FieldLayout>();
    var layouts = ClipBoard.getJsonObj("layout");
    for(var l in layouts){
      Map userMap = jsonDecode(l);
      var fl = FieldLayout.fromJson(userMap);
      fls[fl.tag] = fl;
    }

    if (nodeJsons.length>=1){
      clz.unSelectAll();
    }
    // Map<String,StateScriptNode> ori2news = Map<String,StateScriptNode>();
    // Map<String,bool> oriGuids = Map<String,bool>();
    // Offset center = Offset(0,0);
    // StateScriptProject.cancelWatchProject();
    int iCount = 0 ;
    for(var n in nodeJsons){
//            ClipBoard.copyJsonObj("StateScriptNode", n.toJson());
      Map userMap = jsonDecode(n);
      var newn = ClassDecoration.fromJson(userMap);
      // if (newn is SSAgentFunction){
      //   newn.fieldValues.clear();
      // }
      var fl = fls[newn.guid];
      // var flData = layouts[iCount];
      // Map userMap2 = jsonDecode(flData);
      // var fl = FieldLayout.fromJson(userMap2);
      newn.guid = Uuid().v4();
      if (fl == null){
        fl = clz.getFieldLayout(newn);
      }
      var off = Offset(fl.x + 32,fl.y + 32);
      off =  OTDefines.fixPosition(off);
      // print("${off.dx} ${off.dy}");

      fl.x = off.dx;
      fl.y = off.dy;
      fl.selected = true;
      clz.decorations[newn.guid] = newn;
      clz.fieldsLayouts[newn.guid]=fl;//decorations[newn.guid] = newn;
      ++iCount;
    }
    clz.rebuildAllFields();
    EVC.EventCenter.eventBus.fire(EVC.AObjectForceChanged()..obj = widget.rootObject);
    setState(() {

    });
  }
}
