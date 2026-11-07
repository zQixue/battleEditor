//@dart=2.11
 
import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ClassDecoration.dart';
import 'package:battlepus/ObjectTable/Struct/FieldGroup.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/a_field_view.dart';
import 'package:battlepus/ObjectTable/a_group_frame.dart';
import 'package:battlepus/ObjectTable/a_object_frame_view.dart';
import 'package:battlepus/ObjectTable/decoration_view.dart';
import 'package:battlepus/ObjectTable/select_table_view.dart';
import 'package:battlepus/common/ZoomCanvas.dart';

class OTUtils {
  static Future<ObjectClazz> selectTable(BuildContext context) async{
    ObjectClazz res = await showDialog<ObjectClazz>(
      context: context,
      builder: (BuildContext context) {
        var child = SelectTableView(
          onSelected: (v){
            Navigator.of(context).pop(v);
          },
          onClose: (){
            Navigator.of(context).pop(null);
          },
        );
        //return AlertDialog(content: child);
        return Dialog(child: child);
      },
    );

    return res;
  }
  static List<String> inValids = List<String>();
  static List<Widget> getCanvasObjectView(AObject object,{bool withFrame = false , CanvasHolder canvas, bool editMode = false}){
    var fieldWidgets = List<Widget>();
    if (object == null) return fieldWidgets;
    // print("??????????????????????2");



    var clz = object.getClazz();
    if(clz == null) return fieldWidgets;
    // print("??????????????????????3");

    if (withFrame) {
      fieldWidgets.add(AObjectFrameView(object: object,canvas: canvas , editMode: editMode,));
    }
    Map<String , FieldGroup> fieldGuidToGroup = {};
    inValids.clear();
    clz.groups.forEach((key, value) {
      value.clean(clz);

      value.fieldGuids.forEach((element) {
        fieldGuidToGroup[element] = value;
      });

      if (!value.getGroupValid(clz)) {
        inValids.add(key);
        return ;
      }
      fieldWidgets.add(AGroupFrame(object: object,group: value,canvas: canvas, editMode: editMode,));
    });
    inValids.forEach((element) {
      clz.groups.remove(element);
    });

    int iCount = 0 ;
    var fields = clz.getAllFields();
    fields.forEach((element) {
      if (element is ClassDecoration){
        // print("----------------------------------- decoration ----------------------------------");
        var fv = DecorationView(clazz: clz,object: object, decoration: element , canvas : canvas,editMode: editMode);
        fieldWidgets.add(fv);
      }
      else{
        var fv = AFieldView(clazz: clz,object: object, field: element,index:iCount ,canvas : canvas,editMode: editMode , group: fieldGuidToGroup[element.guid],);
        fieldWidgets.add(fv);
      }
      ++iCount;
    });
    return fieldWidgets;
  }
}