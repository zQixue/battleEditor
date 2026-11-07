//@dart=2.11
import 'dart:async';

// import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class OTGridCell extends StatefulWidget {
  final ObjectClazz clazz;
  final AObject object;
  final FieldInfo fieldInfo;
  final int index;
  OTGridCell({Key key , this.clazz , this.object , this.fieldInfo , this.index}) : super(key: key);

  @override
  _OTGridCellState createState() => _OTGridCellState();
}

class _OTGridCellState extends State<OTGridCell> {

  StreamSubscription<OTGridCellChange> _lis;


  @override
  void dispose() {
    _lis?.cancel();
    super.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lis = EventCenter.eventBus.on<OTGridCellChange>().listen((event) {
      if (widget.fieldInfo == null) return;
      if (!DartCommon.isEmpty(widget.fieldInfo.func) && widget.object == event.object){
        setState(() {
          calculateFuncs(widget.clazz , widget.object);
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var field = widget.fieldInfo;
    var obj = widget.object;
    int j = widget.index;

    if (field == null){
      if (j == 0){
        return Container(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Center(child:Text("${obj.guid.hashCode}" ,style: ThemeCenter.mainTextStyle(step: 6 , fontSize: 13))),
        );
      }
      if (j == 1){
        var fi = SSFieldType.getFieldType("___string___" ,fieldInfo: null);
        var gci = GridCellInfo()..isObjectTableMode = true..name = "";
        var edth = fi.getGridCellEditor(
          initValue: obj.name??"",
          onChanged: (v){
            // obj.setFieldValue(field.guid,v,field.getTypeShowString());
            obj.name = v;
          },
          onSubmitted: (v){
            setState(() {
              // obj.setFieldValue(field.guid,v,field.getTypeShowString());
              obj.name = v;
              // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
            });
          },
          gci : gci,
          // levelInfo : nowEi ,
          context:context,
        );
        // var oh = edth.height;
        var edt = edth.widget;
        return Container(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
            child:edt
        );
      }
    }
    var gci = GridCellInfo()..isObjectTableMode = true..name = field.getTypeShowString();


    // print(field.name);
    var fi = SSFieldType.getFieldType(field.typeGuid ,fieldInfo: field);
    if (fi == null){
      //可能枚举被删
      return  Container(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child:Center(child:Text("请检查是否丢失枚举" , style: TextStyle(color: Colors.red)))
      );
    }
    EditorHolder edth;
    if (DartCommon.isEmpty(field.func)) {
      edth = fi.getGridCellEditor(

        initValue: obj.getFieldValue(field.guid),
//        item.name,
        onChanged: (v) {
          obj.setFieldValue(field.guid, v, field.getTypeShowString());

          if (calculateFuncs(widget.clazz,obj)){

            EventCenter.eventBus.fire(OTGridCellChange()..clazz = widget.clazz..object = widget.object..fieldInfo = widget.fieldInfo..index = widget.index);
            setState(() {

            });
          }
        },
        onSubmitted: (v) {
          obj.setFieldValue(field.guid, v, field.getTypeShowString());

          if (calculateFuncs(widget.clazz,obj)){
            EventCenter.eventBus.fire(OTGridCellChange()..clazz = widget.clazz..object = widget.object..fieldInfo = widget.fieldInfo..index = widget.index);
            setState(() {

            });
          }

          //   obj.setFieldValue(field.guid, v, field.getTypeShowString());
          //   // EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
          // });
        },
        gci: gci,
        // levelInfo : nowEi ,
        context: context,
      );
    }
    else{
      edth = EditorHolder()..widget = Container(
        // padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
        // width: ei?.lineWidth,
        // height: ei?.lineHeight,
        child: Center(child:Text(fi.parseValue(obj.getFieldValue(field.guid)).toString(), style : TextStyle(color:Colors.yellowAccent))),
      );
    }

    // var oh = edth.height;
    var edt = edth.widget;

    // var con = Container(height : 44,);
    return Container(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child:edt
    );
  }

  bool calculateFuncs(ObjectClazz clz , AObject item){

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
}