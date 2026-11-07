//@dart=2.11
import 'dart:async';
import 'dart:math';

// import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSList.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/ThemeCenter.dart';
// import 'package:stacked_card_carousel/stacked_card_carousel.dart';
class ObjectEditor extends StatefulWidget {
  final AObject targetObject;
  final EditorLevelInfo levelInfo ;
  ObjectEditor({Key key , this.targetObject , this.levelInfo}) : super(
      key: key);

  @override
  _ObjectEditorState createState() =>
      _ObjectEditorState(
      );
}

class _ObjectEditorState extends State<ObjectEditor> {

  StreamSubscription<InspectorRefreshEvent> _lis;
  StreamSubscription<AObjectChanged> _lis2;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
    _lis2?.cancel();
  }
  bool _forceRebuild = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<InspectorRefreshEvent>().listen((event) {
      setState(() {
        _forceRebuild = true;
      });
    });

    _lis2 = EventCenter.eventBus.on<AObjectChanged>().listen((event) {
      if(event.obj == widget.targetObject){
        setState(() {
          _forceRebuild = true;
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> fancyCards = [
    //   FancyCard(
    //     // image: Image.asset("assets/pluto-done.png"),
    //     title: "Say hello to planets!",
    //   ),
    //   FancyCard(
    //     // image: Image.asset("assets/pluto-fatal-error.png"),
    //     title: "Don't be sad!",
    //   ),
    //   FancyCard(
    //     // image: Image.asset("assets/pluto-coming-soon.png"),
    //     title: "Go for a walk!",
    //   ),
    //   FancyCard(
    //     // image: Image.asset("assets/pluto-sign-up.png"),
    //     title: "Try teleportation!",
    //   ),
    //   FancyCard(
    //     // image: Image.asset("assets/pluto-waiting.png"),
    //     title: "Enjoy your coffee!",
    //   ),
    //   FancyCard(
    //     // image: Image.asset("assets/pluto-welcome.png"),
    //     title: "Play with your cat!",
    //   ),
    // ];
    //
    // return Container(width:400,height: 400,child:StackedCardCarousel(
    //   items: fancyCards,
    // ));
    return _createObjectEditor();
  }
  // dynamic _dc = new BoxDecoration(
  //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 0.5, spreadRadius: 0.5) , BoxShadow(color: Colors.white)],
  // );
  double _objectFullWidth = 640;

  double _objectLineWidth = 640;
  double _objectLineHeight = 40;
  double _hearWidth = 160;

  static Map<String , bool> _openedMap = Map<String , bool>();
  static Map<String , int> _levelMap = Map<String , int>();
//  static List<String> _circleStack = List<String>();

  static Map<String , bool> _circleCheck = Map<String , bool>();
  static Map<String , bool> _cc = Map<String , bool>();
  static void buildCircle(AObject aObj) {
    if (aObj == null){
      return ;
    }

    var clzGuid = aObj.clazzGuid;

    var clz = ObjectClazz.getClazz(clzGuid);


    for (var field in clz.fields) {

      String openGuid = (aObj.guid + field.guid).toString();
//      bool opened = _openedMap[openGuid] ?? false;
      var fi = SSFieldType.getFieldType(field.typeGuid, fieldInfo: field);
//      print(fi.guid);
      if (fi is FTObjectReference) {
        var refGuid = aObj.getFieldValue(field.guid);
        bool bCircle = _cc[refGuid]??false;
        _circleCheck[openGuid] = bCircle;
        _cc[refGuid] = true;

        if (!bCircle){
          var objGuid = aObj.getFieldValue(field.guid) as String;
          if (objGuid != null) {
            var innerObj = ObjectClazz.allObjects[objGuid];
            if (innerObj != null) {
              buildCircle(innerObj);
            }
          }
        }

        _cc.remove(refGuid);
      }





    }
  }

  static int buildLevel(AObject aObj , {int iLevel = 0}){
    if (aObj == null){
      return 0;
    }

    if (_levelMap["${aObj.guid}"] != null) return _levelMap["${aObj.guid}"];

    var clzGuid = aObj.clazzGuid;

    var clz = ObjectClazz.getClazz(clzGuid);

//    int iLevel = 0;
    int iMaxLevel = iLevel;
    Map<String , bool> _cc = Map<String , bool>();
    for (var field in clz.fields) {

      String openGuid = (aObj.guid + field.guid).toString();
      bool opened = _openedMap[openGuid] ?? false;
      var fi = SSFieldType.getFieldType(field.typeGuid, fieldInfo: field);

      if (fi is FTObjectReference && opened) {
        var objGuid = aObj.getFieldValue(field.guid) as String;
        if (objGuid != null) {
          var innerObj = ObjectClazz.allObjects[objGuid];
          if (innerObj != null) {
//            print("innerObj");
            iMaxLevel = max(iMaxLevel , buildLevel(innerObj , iLevel : iLevel + 1));
          }
        }
      }
      if (fi is SSList && opened) {
        var fi2 = SSFieldType.getFieldTypeByFullGuid(fi.innerTypeGuid0);
        if (fi2 is FTObjectReference) {
          var objGuids = aObj.getFieldValue(field.guid);
          for(var i = 0 ; i < objGuids.length ; ++i) {
            var objGuid = objGuids[i];
            if (objGuid != null) {
              var openGuid2 = "${openGuid}_${i}_$objGuid";
              bool opened2 = _openedMap[openGuid2] ?? false;
              if (opened2) {
                var innerObj = ObjectClazz.allObjects[objGuid.toString()];
                if (innerObj != null) {
                  iMaxLevel = max(iMaxLevel, buildLevel(innerObj, iLevel: iLevel + 1));
                }
                break;
              }
            }
          }
        }
      }


    }
//    print("set ${aObj.guid} " + iMaxLevel.toString());
    _levelMap["${aObj.guid}"] = iMaxLevel - iLevel;
    return iMaxLevel;
  }

  Widget _createObjectEditor(){
//    if (widget.levelInfo == null || widget.levelInfo.level == 0){
//      _levelMap.clear();
//      _circleCheck.clear();
//      _cc.clear();
//      buildLevel(widget.targetObject);
//      buildCircle(widget.targetObject);
//    }

    var item = widget.targetObject;
    if (item == null){
      return Container(
      );
    }


//    print("${widget.targetObject.name}");
    EditorLevelInfo ei = widget.levelInfo;

    if (ei == null) {
      ei = EditorLevelInfo();
//      ei.circleStack = _circleStack;
      ei.openedMap = _openedMap;
      ei.lineWidth = _objectLineWidth;
      ei.spaceStep = _hearWidth ;
      ei.spaceStep = _hearWidth ;
      ei.isObjectTableMode = true;

    }
    ei.circleStack[item.guid] = true;


    List<Widget> lines = List<Widget>();

    var clzGuid = item.clazzGuid;
    var iLevel =  _levelMap["${item.guid}"]??0;

    var clz = ObjectClazz.getClazz(clzGuid);
    lines.add(getNameEditor(widget.targetObject,iLevel));
    _circleBuild.clear();
    buildByClazz(clz,item,lines , ei);

    var res =  Container(
//      width: _objectFullWidth-14,
//      decoration: _dc,
//      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines,
      ),
    );
//    var bline = LayoutBuilder(
//      builder: (a,size) {
//        return Container(
//          width: 4,
//          height: size.maxHeight,
//          color: Colors.indigo,
//        );
//      }
//    );
//    var dc = new BoxDecoration(
//        border: Border(
////        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
////          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
////          bottom: Divider.createBorderSide(context, color: Colors.indigo, width: 2),
//          left: Divider.createBorderSide(context, color: Colors.indigo, width: 4),
////          right: Divider.createBorderSide(context, color: Colors.indigo, width: 4),
//        ),
////        color: Colors.indigo, // 底色
//        ); // 圆角度

    var withLine = Container(
//      decoration: dc,
//      padding: EdgeInsets.all(4),
      child: res,
    );

    var returnRes = Container(
      child: withLine,
////        decoration: _dc,
//      child:SingleChildScrollView(
//        physics: BouncingScrollPhysics(),
//        scrollDirection: Axis.horizontal,
//        child: withLine,
//      )
    );

    return returnRes;
  }
  bool calculateFuncs(ObjectClazz clz , AObject item){
    //
    // bool res = false;
    // Map<String,dynamic> context = {'clz': clz.name,};
    // for (var field in clz.fields){
    //   var fv = item.getFieldValue(field.guid);
    //   print(field.name);
    //   var fi = SSFieldType.getFieldType(field.typeGuid ,fieldInfo: field);
    //   if (fi == null){
    //     continue ;
    //   }
    //   context[field.name] = fi.parseValue(fv);
    // }
    //
    // for (var field in clz.fields){
    //   if (DartCommon.isEmpty(field.func)) continue;
    //   var expression = Expression.parse(field.func);
    //   // print("exp = $expression");
    //   final evaluator = const ExpressionEvaluator();
    //   var r = evaluator.eval(expression, context);
    //   // print("result = $r");
    //   item.setFieldValue(field.guid, r ,field.getTypeShowString());
    //   // context[field.name] = fi.parseValue(fv);
    //   res = true;
    // }
    //
    // return res;
  }

  Map<String,bool> _circleBuild = Map<String,bool>();
  void buildByClazz(ObjectClazz clz , AObject item, List<Widget> lines ,  EditorLevelInfo ei){
    if (_circleBuild.containsKey(clz.guid)){
      return;
    }
    _circleBuild[clz.guid] = true;
    var baseClz = ObjectClazz.getClazz(clz.baseClazz);
    if (baseClz != null){
      buildByClazz(baseClz,item,lines,ei);
    }
    calculateFuncs(clz,item);
    lines.add(SizedBox(height: 16,));
    int iCount = 0;
//    double fullHeight = 43.0 + 16;
    var nowEi = EditorLevelInfo()..level = ei.level;
    nowEi.circleStack.addAll(ei.circleStack);
    nowEi.openedMap = _openedMap;
//    nowEi.circleStack = _circleStack;

//    nowEi.levelMap = _levelMap;
//    nowEi.circleCheck = _circleCheck;
    for (var field in clz.fields){
      nowEi.level = ei.level;
      nowEi.isObjectTableMode = ei.isObjectTableMode;
      nowEi.lineWidth = _objectLineWidth;
      nowEi.lineHeight = _objectLineHeight;
      nowEi.spaceStep = _hearWidth ;
//      nowEi.isCircle = false;
//      var iLevel =  _levelMap["${item.guid}"]??0;
//      nowEi.deltaLevel = iLevel;

      var openGuid = item.guid+field.guid;
      nowEi.openGuid = openGuid;
      bool opened = _openedMap[openGuid]??false;
      var fi = SSFieldType.getFieldType(field.typeGuid ,fieldInfo: field);
      if (fi == null){
        return ;
      }
      nowEi.isCircle = _circleCheck[openGuid]??false;

      EditorHolder edth;
      if (DartCommon.isEmpty(field.func)){
        edth = fi.getEditWidget(

          item.getFieldValue(field.guid),
  //        item.name,
          (v){
            print("set v : $v");
            item.setFieldValue(field.guid,v,field.getTypeShowString());
            var hasFunc = calculateFuncs(clz,item);
            if (hasFunc){
              EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
            }
            item.buildTag(clz.getAllTagFields());
            // if (clz.containTag(field.guid)){
            //
            //   EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
            // }
          },
          (v){
            setState(() {
              item.setFieldValue(field.guid,v,field.getTypeShowString());
              var hasFunc = calculateFuncs(clz,item);

              item.buildTag(clz.getAllTagFields());
              // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
              // if (clz.containTag(field.guid)){
              //
              // }
            });
          },

          bOpen: opened,
          onVisible: (b){
            setState(() {
              // EventCenter.eventBus.fire(GlobalRefreshEvent());
              _openedMap[openGuid] = ! opened;
            });

          },
          levelInfo : nowEi ,
          context:context,
        );
      }
      else{
        edth = EditorHolder()..widget = Container(
          padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
          width: ei?.lineWidth,
          height: ei?.lineHeight,
          child: Text(fi.parseValue(item.getFieldValue(field.guid)).toString(), style : TextStyle(color:Colors.yellowAccent)),
        );
      }
      // var oh = edth.height;
      var edt = edth.widget;
//      print("[${nowEi.guid}] nowEi.fullHeight = ${nowEi.fullHeight}");
//      fullHeight += nowEi.fullHeight;
      var line = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 8,),
          Container(
            width: _hearWidth-8,
//            color: CommonUtil.scaleColor(Colors.indigo, 0.1),
//             height: oh,
            alignment: Alignment.centerLeft,

            child :Text(field.getTypeShowString() , style :TextStyle(color: Colors.grey , fontWeight: FontWeight.w600),overflow:TextOverflow.clip ,maxLines: 1,),
          ),
//          Container(
//            child: Row(
//              children: [
//                isOpendObjRef?Container(width :_objectFullWidth +(iLevel) * (_hearWidth) ,child : edt):
//                Container(width :_objectFullWidth,child : edt),
//                isOpendObjRef?Container(width : 0):
//                Container(width :(iLevel) * (_hearWidth)),
//              ],
//            ),
//          ),
          Container(child : edt),
//          Container(color: Colors.red, width :(iLevel) * _hearWidth ,height: 2,),
//          Container
        ],
      );
      var d1 = BoxDecoration(
        color: (iCount++) %2 ==0?CommonUtil.alphaColorD(Colors.white, 0.04):ThemeCenter.systemTheme.scaffoldBackgroundColor,
      );
      var lineContainer = Container(
//        width: _objectFullWidth,
        decoration: d1,
        padding: EdgeInsets.fromLTRB(0,0,0,0),
        child: line,
      );
      var row = Row(
        children: [
//          Container(width: widget.iLevel * _hearWidth,),

          lineContainer,
        ],
      );
//      if (fi is FTObjectReference) {
//        var refGuid = item.getFieldValue(field.guid);
//        _circleCheck.remove(refGuid);// = true;
//      }
      lines.add(row);
      lines.add(SizedBox(height: 2,));

//      fullHeight += 43 +4;
    }

    ei.circleStack.remove(item.guid);

  }

  Widget getNameEditor(AObject targetObject,int iLevel) {
    var clz = ObjectClazz.getClazz(targetObject.clazzGuid);
    var line = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 8,),
        Container(
          width: _hearWidth-8,
//            color: CommonUtil.scaleColor(Colors.indigo, 0.1),
          height: _objectLineHeight,
          alignment: Alignment.centerLeft,

          child :Text("标签" , style :TextStyle(color: Colors.grey , fontWeight: FontWeight.w600),overflow:TextOverflow.clip ,maxLines: 1,),
        ),

        Container(width :_objectLineWidth - (clz.syncTransform?28:0),//_objectFullWidth + (iLevel) * (_hearWidth + 2),
            child : Row(
              children: [
                Expanded(
                  child: TextEditor(
                    initValue: targetObject.name,
                    forceRebuild: false,
                    onChanged: (v){
                      targetObject.name = v;
                      EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
                    },
                  ),
                ),
                SizedBox(width: 4,),
                Expanded(
                  child: TextEditor(
                    initValue: clz.tagFormat??"",
                    forceRebuild: false,
                    onSubmitted: (v){
                      clz.tagFormat = v;
                      clz.reorderTags();
                    },
                  ),
                ),
              ],
            ),
        ),

        // clz.syncTransform?Container(
        //   width: 28,
        //   child:IconButton(padding:EdgeInsets.all(0),icon: Icon(MaterialCommunityIcons.unity,), color: Colors.indigo, tooltip:"unity中定位",
        //     onPressed: (){
        //       ObjInfo info = targetObject.getTransformInfo(null);
        //       PackSolver.registerTransitionObject(targetObject);
        //       Transport.instance.sendUdpData(OPackType.O2U_SigleObject, info);
        //       BotToast.showText(text: "已发送");
        //     },
        //   ),
        // ):Container(width: 0,),

      ],
    );
    _forceRebuild = false;

    return line;
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({
    Key key,
    this.image,
    this.title,
  }) : super(key: key);

  final Image image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Container(
            //   width: 250,
            //   height: 250,
            //   child: image,
            // ),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5,
            ),
            ElevatedButton(
              child: const Text("Learn more"),
              onPressed: () => print("Button was tapped"),
            ),
          ],
        ),
      ),
    );
  }
}