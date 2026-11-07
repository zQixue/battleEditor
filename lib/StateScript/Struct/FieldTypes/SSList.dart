//@dart=2.11

import 'package:flutter/cupertino.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTDynamicObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/s_s_list_editor.dart';
import 'package:battlepus/StateScript/NodeEditor/a_field_type_selector.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSWidgetCommon.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class ListDragData{
  dynamic list;
  int index;
}
class SSList extends SSFieldType{

  SSList(){
    exportId = 32;
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){

    if (fieldType == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.view_list , color: Colors.indigoAccent,),
          SizedBox(width: 8,),
          Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
          // Expanded(child:Text("" , overflow: TextOverflow.clip,maxLines: 1,)),
//          Row(
//            children: [
//              Text(getTypeShowString()),
//            ],
//          ),
        ],
      );
    }

    var innerType = SSFieldType.getFieldType(fieldType.innerTypeGuid0);
    var subInnerType = SSFieldType.getFieldType(fieldType.innerTypeGuid0);
    if (onChange == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.view_list , color: Colors.blue),
          SizedBox(width: 16,),
          Expanded(child : Container(
            color: CommonUtil.alphaColor( Colors.blue , 30),
            alignment: Alignment.center,
//                width: 200,
            child: innerType != null ? innerType.getTypeShowWidget(fieldType: subInnerType) : Text("未选择"),
          )),
//          Expanded(flex : 2 ,child : innerType != null ? innerType.getTypeShowWidget() : Text("未选择")),
        ],
      );
    }

    var lst = SSFieldType.getTypeMap(excludeFlag: SSFieldType.FIELD_FLAG_CONTAINER);
    lst.sort((a,b)=>a.priority-b.priority);

    // List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    // for(var i in lst){
    //   // var subInnerType = SSFieldType.getFieldType(i.guid);
    //   var item = PopupMenuItem<String>(
    //     value: i.guid,
    //     child: i.getTypeShowWidget(),
    //   );
    //   items.add(item);
    // }
//     var res = PopupMenuButton<String>(
//       padding: EdgeInsets.all(0),
//       icon: Icon(MaterialCommunityIcons.menu , size: 20,),
//       initialValue:fieldType.innerTypeGuid0,
//
//       onSelected: (String v) {
//         // fieldInfo.innerTypeGuid0 = v;
// //        print(v);
//         var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid ,v , fieldType.innerTypeGuid1);
//         print(newFT.guid);
//         onChange?.call(newFT.guid);
//       },
//       itemBuilder: (BuildContext context) => items,
//     );
//     );


    var res = AFieldTypeSelector(
      types: lst,
      initialValue: fieldType.innerTypeGuid0,
      // field: null,
      onChanged: (v){
        var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid ,v , fieldType.innerTypeGuid1);
        print(newFT.guid);
        onChange?.call(newFT.guid);
      },
    );

    return Container(
//        padding: EdgeInsets.all(4),

        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(MaterialCommunityIcons.view_list , color: Colors.blue,),
              SizedBox(width: 4,),
              Expanded(child : Container(
                // color: CommonUtil.alphaColor( Colors.blue , 30),
                alignment: Alignment.center,
//                width: 200,
                child: innerType != null ? innerType.getTypeShowWidget( fieldType: subInnerType ,onChange: (v){
//                  print ("inner "+v);
                  fieldType.innerTypeGuid0 = v;
                  onChange?.call(fieldType.guid);
                }) : Text("未选择"),
              )),
              Container(
                // color: CommonUtil.alphaColor( Colors.indigo , 30),
                width: 20,
                child: res,
              ),
//            res,
            ]
        )

    );
    return Row(
      children: [
        Icon(MaterialCommunityIcons.format_list_bulleted_type , color: Colors.indigoAccent,),
        SizedBox(width: 8,),
        Row(
          children: [
            Text(getTypeShowString()),
          ],
        ),
      ],
    );
  }
  @override
  EditorHolder getCellEditWidget(initValue , onChanged , onSubmitted ,{ Widget showInfo,FunctionDynamicCallback onExtraEdit}){
    return EditorHolder()..widget=Container(
      child: Row(
        children: [
          Expanded(child:Text("list")),
          IconButton(
            padding: EdgeInsets.all(0),
            icon:Icon(MaterialCommunityIcons.square_edit_outline),
            onPressed: (){
              onExtraEdit?.call(null);
            },
          ),
        ],
      ),
    );
  }
  var fieldHeaderStyle = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    List<dynamic> lst = [];
    if (initValue is List<dynamic> ){
      lst = initValue;
    }

    // baseHeight = 23.0;
    var node = levelInfo.node;
    var fi = levelInfo.fi;

    // var maincolor = CommonUtil.scaleColor(Colors.redAccent, 0.16);
    bool withDynamicOutPort = fi.withDynamicOutPort();
    Map<String , OutPort> dynamicOutPorts ;
    if (withDynamicOutPort){
      dynamicOutPorts = node.dynamicFieldOutPorts[fi.guid];
      if (dynamicOutPorts == null){
        dynamicOutPorts = node.dynamicFieldOutPorts[fi.guid] = Map<String , OutPort> ();
      }
    }
    else{
      node.dynamicFieldOutPorts.remove(fi.guid);
    }

    bool withDynamicInParam= fi.withDynamicInParam();
    Map<String , InParam> dynamicInParams ;
    if (withDynamicInParam){
      dynamicInParams = node.dynamicFieldInParams[fi.guid];
      if (dynamicInParams == null){
        dynamicInParams = node.dynamicFieldInParams[fi.guid] = Map<String , InParam>();
      }
    }
    else{
      node.dynamicFieldInParams.remove(fi.guid);
    }


    List<Widget> ws = new List<Widget>();
    if (innerType0 == null){
      return EditorHolder()..widget = Container(
//      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//      color:maincolor,
          height: baseHeight,
          child: Text("数组内部类型错误"),
      );
    }
    double fullHeight = 0;
    bool withDn = withDynamicOutPort || withDynamicInParam;
    String dtId ;
    String dtName ;
    for(int i = 0 ; i < lst.length ; ++i){
      var crt = lst[i];
      //动态触发信息 key
      // var dtk = "${fi.guid}_$i";
      if (withDn) {
        var dtInfo = node.fieldValues[fi.guid].getOrCreateDynamicTriggerInfo(i);
        dtId = dtInfo?.id;
        dtName = dtInfo?.name;
      }

      crt = innerType0.parseValue(crt);
//       var openGuid = "${levelInfo.openGuid}_${i}_$crt";
//       bool bIsObjRef =  (innerType0 is FTObjectReference);
// //      bool opened = levelInfo.openedMap[openGuid]??false;
//       bool isObjRef = innerType0 is FTObjectReference;
//      var old = levelInfo.lineWidth;
//      if (!isObjRef){
//        levelInfo.lineWidth -= 76;
//      }
      var w = innerType0.getThinEditWidget(crt,
              (v){
            lst[i] = v;
            onChanged?.call(lst);
          },
              (v){
            lst[i] = v;
            onSubmitted?.call(lst);
          },
        baseHeight,
          levelInfo: levelInfo,

          bOpen: true,
//          onVisible: bIsObjRef?(v){
//            EventCenter.eventBus.fire(GlobalRefreshEvent());
//            levelInfo.openedMap[openGuid] = v;
//          }:null
      context: context,
      );
//      levelInfo.lineWidth = old;
      OutPort op ;
      Widget dop ;
      if (withDynamicOutPort) {
        op = dynamicOutPorts[dtId];
        if (op == null){
          op = dynamicOutPorts[dtId] = OutPort();
          // dynamicOutPorts.add(op);
          node.getDynamicOutPortMap()[op.guid ] = op;
          node.buildDynamicOutPortId();
        }
        // if (i < dynamicOutPorts.length) {
        //   op = dynamicOutPorts.elementAt(i);
        // }
        // else {
        //   op = OutPort();
        //   dynamicOutPorts.add(op);
        //   node.getDynamicOutPortMap()[op.guid ] = op;
        //   node.buildDynamicOutPortId();
        // }
        // op.exportId = i;
        dop = SSWidgetCommon.getOutPortWidget(node.getNodeStructType(), node, op, levelInfo.graph, fullHeight , fi);
      }
      InParam ip ;
      Widget dip ;
      if (withDynamicInParam){
        ip = dynamicInParams[dtId];
        if (ip == null){
          ip = dynamicInParams[dtId] = InParam();
          node.getDynamicInParamsMap()[ip.guid ] = ip;
          node.buildDynamicInParamId();
        }
          // if (i < dynamicInParams.length) {
          //   ip = dynamicInParams.elementAt(i);
          // }
          // else {
          //   ip = InParam();
          //
          //   dynamicInParams.add(ip);
          //   node.getDynamicInParamsMap()[ip.guid ] = ip;
          //   node.buildDynamicInParamId();
          // }
          // op.exportId = i;
          ip.fieldId = fi.guid;
          dip = SSWidgetCommon.getInParamWidget(node.getNodeStructType(), node, ip, levelInfo.graph , fullHeight , fi);

      }
      fullHeight += w.height + 2;
      var color = (i % 2 ==1) ? Color.fromARGB(255, 40, 40, 40) : Color.fromARGB(255, 35, 35, 35);//CommonUtil.scaleColor(Colors.grey, 0.2);
      var indexWdg = Material(
        color: Colors.transparent,
        child: Padding(padding: EdgeInsets.fromLTRB(1,3,1,4), child:Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.3),
          ),
          width: 12,
          // height: 16,
          child: Center(
            child: Text("${i+1}" , style: TextStyle(fontSize: 6 , color: Colors.grey),),
          ),
        ),
      ));
      // var dnKey = "${fi.name}_${crt}";
      var dName = dtName ;//node.dynamicTriggerNames[dnKey];
      var rowitem = Container(
        height: w.height + 2,
        color: color,
        child : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (withDynamicInParam) Padding(
              child: dip,
              padding: EdgeInsets.fromLTRB(0,0,0,2),
            ) ,
            Draggable(
              child: indexWdg,//Icon(MaterialCommunityIcons.drag ,size: SSDefines.iconButtonSize,),
              feedback: Icon(MaterialCommunityIcons.drag,color:Colors.red , size: 32,),
              childWhenDragging:indexWdg,//Icon(MaterialCommunityIcons.drag,color:Colors.green),
              data: ListDragData()..list = lst ..index = i,
            ),
            const SizedBox(width: 2,),
            Expanded(flex: 1 , child :w.widget),
            SSDefines.IBC(child :IconButton(
              padding: EdgeInsets.all(0),
              iconSize: SSDefines.iconButtonSize,
              icon:Icon(MaterialCommunityIcons.minus_box_outline , color: Colors.red,),
              tooltip: "删除",
              onPressed: (){
                lst.removeAt(i);
                if (withDn){
                  node.fieldValues[fi.guid].removeDynamicTriggerInfo(i);
                }
                if (withDynamicOutPort){
                  dynamicOutPorts?.remove(dtId);
                  node.getDynamicOutPortMap().remove(op.guid);
                }

                if (withDynamicInParam){
                  dynamicInParams?.remove(dtId);
                  node.getDynamicInParamsMap().remove(ip.guid);
                }
                onSubmitted?.call(lst);
              },
            )),
            if (withDn && !DartCommon.isEmpty(dName)) Expanded(flex: 1 ,
                child :Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    dName , style: fieldHeaderStyle,
                  ),
                ),
                ),
            if (withDynamicOutPort) Padding(
              child: dop,
              padding: EdgeInsets.fromLTRB(0,0,0,2),
            ) ,

//            Expanded(child: w.widget,),


          ],
        ),
      );
      var dragItem = rowitem;//
//      var dragItem = Draggable(
//        child: rowitem,
//        feedback: Icon(MaterialCommunityIcons.drag , color:Colors.red),
//        childWhenDragging:Container(height: SSDefines.nodeFieldRowHeight,),
//        data: ListDragData()..list = lst ..index = i,
//      );
      var dragTarget = DragTarget<ListDragData>(
        onAcceptWithDetails: (e){
          if (e.data.list != lst) return;
          var oldI = e.data.index;
          var newI = i;
          if (oldI != newI){
            var val = lst.removeAt(oldI);
            lst.insert(newI, val);

            if (withDn){
              node.fieldValues[fi.guid].reorderDynamicTriggerInfo(oldI , newI);
            }
            // if (withDynamicOutPort){
            //   var opval = dynamicOutPorts.removeAt(oldI);
            //   dynamicOutPorts.insert(newI, opval);
            // }
            //
            // if (withDynamicInParam){
            //   var opval = dynamicInParams.removeAt(oldI);
            //   dynamicInParams.insert(newI, opval);
            // }

            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
            onSubmitted?.call(lst);
          }
        },
        onWillAccept: (e)=> true,
        builder: (context, candidateData, rejectedData){
          return dragItem;
        },
      );
      ws.add(dragTarget);
    }


    //var fullWidth = levelInfo.lineWidth - 8 ;//+ (bOpen?63.5:0.0) ;//+ ((bOpen && isObjRef)?levelInfo.spaceStep+2:0);
    var dc =  BoxDecoration(
        border : Border(
          bottom: BorderSide(width: 1,color: Colors.black),
//          top: BorderSide(width: 1,color: Colors.grey),
        ));
//    var leftPadding = EdgeInsets.fromLTRB(4, 0, 0, 0);
    return EditorHolder()..widget = Container(
//      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//      color:maincolor,
    height: fullHeight + baseHeight,
      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//          Container(
////            width: fullWidth,
//            height: baseHeight,
////            padding: leftPadding,
//            color: maincolor,
//            child:Row(
//              children: [
//                onVisible!= null?IconButton(
//                  icon:Icon(bOpen?MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.square_edit_outline , color: bOpen?Colors.redAccent : Colors.indigoAccent),
//                  onPressed: (){
//                    onVisible?.call(!bOpen);
//                  },
//                ):SizedBox(width: 0,),
//
//                Expanded(child : showInfo??Text(getTypeShowString())),
//              ],
//            ),
//          ),
          Container(
//            padding: leftPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ws,
            ),
          ),
//          SizedBox(height : bOpen?2:0),
          Container(
            decoration: dc,
//            width: fullWidth,
            height:baseHeight,
//            color: maincolor,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              SSDefines.IBC(child :IconButton(
                  icon:Icon(MaterialCommunityIcons.plus_box_outline , color: Colors.green),
                  iconSize: SSDefines.iconButtonSize,
                  padding: EdgeInsets.all(0),
                  tooltip: "添加",
                  onPressed: (){
                    var df = innerType0.parseValue(null);
                    lst.add(df);
                    onSubmitted?.call(lst);
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    )..height = fullHeight + baseHeight;

  }
//  static Map<String , bool> _openedMap = Map<String , bool>();
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false , FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context} ){
    List<dynamic> lst = [];
    if (initValue is List<dynamic> ){
      lst = initValue;
    }


    var maincolor = CommonUtil.alphaColorD(Colors.redAccent, 0.06);
    List<Widget> ws = new List<Widget>();
    for(int i = 0 ; i < lst.length ; ++i){

      var crt = lst[i];
      crt = innerType0.parseValue(crt);
      var openGuid = "${levelInfo.openGuid}_${i}_$crt";
      bool bIsObjRef =  (innerType0 is FTObjectReference || innerType0 is FTDynamicObjectReference );
      bool opened = levelInfo.openedMap[openGuid]??false;
      bool isObjRef = innerType0 is FTObjectReference || innerType0 is FTDynamicObjectReference;
      var old = levelInfo.lineWidth;
      if (!isObjRef){
        levelInfo.lineWidth -= 76;
      }
      var w = innerType0.getEditWidget(crt,
          (v){
            lst[i] = v;
            onChanged?.call(lst);
          },
          (v){
            lst[i] = v;
            onSubmitted?.call(lst);
          },
        levelInfo: levelInfo,
          context:context,
        bOpen: opened,
        onVisible: bIsObjRef?(v){
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          levelInfo.openedMap[openGuid] = v;
        }:null
      );
      levelInfo.lineWidth = old;

      var color = (i%2 ==1) ? CommonUtil.alphaColorD(Colors.deepPurpleAccent, 0.05) : CommonUtil.alphaColorD(Colors.grey, 0.2);
      var rowitem = Container(
//        height: SSDefines.nodeFieldRowHeight,
//         color: color,
        child : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon:Icon(MaterialCommunityIcons.minus_box_outline , color: Colors.red,),
              tooltip: "删除",
              onPressed: (){
                lst.removeAt(i);
                onSubmitted?.call(lst);
              },
            ),
            w.widget,
            Draggable(
              child:Icon(MaterialCommunityIcons.drag),
              feedback:Icon(MaterialCommunityIcons.drag,color:Colors.red),
              childWhenDragging:Icon(MaterialCommunityIcons.drag,color:Colors.green),
              data: ListDragData()..list = lst ..index = i,
            ),

//            Expanded(child: w.widget,),


          ],
        ),
      );
      var dragItem = rowitem;//
//      var dragItem = Draggable(
//        child: rowitem,
//        feedback: Icon(MaterialCommunityIcons.drag , color:Colors.red),
//        childWhenDragging:Container(height: SSDefines.nodeFieldRowHeight,),
//        data: ListDragData()..list = lst ..index = i,
//      );
      var dragTarget = DragTarget<ListDragData>(
        onAcceptWithDetails: (e){
          if (e.data.list != lst) return;
          var oldI = e.data.index;
          var newI = i;
          if (oldI != newI){
            var val = lst.removeAt(oldI);
            lst.insert(newI, val);
            onSubmitted?.call(lst);
          }
        },
        onWillAccept: (e)=> true,
        builder: (context, candidateData, rejectedData){
          return dragItem;
        },
      );
      ws.add(dragTarget);
    }


    var fullWidth = levelInfo.lineWidth - 8 ;//+ (bOpen?63.5:0.0) ;//+ ((bOpen && isObjRef)?levelInfo.spaceStep+2:0);

//    var dc = new BoxDecoration(
//      color:maincolor,
//      border: Border(
//
////        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
////          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
////          bottom: Divider.createBorderSide(context, color: Colors.indigo, width: 2),
//        left: BorderSide(width: 2,color: maincolor),
//        right: BorderSide(width: 2,color: maincolor),
//      ),
////        color: Colors.indigo, // 底色
//    ); // 圆角度
//    return EditorHolder()..widget = table..height = SSDefines.nodeFieldRowHeight * (ws.length + 1);
    var leftPadding = EdgeInsets.fromLTRB(4, 0, 0, 0);
    return EditorHolder()..widget = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//      decoration: dc,
      color:maincolor,
//      color: CommonUtil.alphaColor(Colors.redAccent, 15),
//            height: levelInfo.lineHeight,
//            width: levelInfo.lineWidth,// + (bOpen?levelInfo.spaceStep+2:0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
//            padding: EdgeInsets.fromLTRB(0, 0 , 0, 2),
//            height: levelInfo.lineHeight,
//            width: levelInfo.lineWidth + (bOpen?levelInfo.spaceStep+2:0.0),
            width: fullWidth,
            height:levelInfo.lineHeight,
            padding: leftPadding,
            // color: maincolor,
            child:Row(
              children: [

                onVisible!= null?IconButton(
                  icon:Icon(bOpen?MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.square_edit_outline , color: bOpen?Colors.redAccent : Colors.indigoAccent),
                  onPressed: (){
                    onVisible?.call(!bOpen);
                  },
                ):SizedBox(width: 0,),

                Expanded(child : showInfo??Text(getTypeShowString())),
              ],
            ),
          ),
          bOpen?Container(
            padding: leftPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ws,
            ),
          ):SizedBox(height: 0,),
          SizedBox(height : bOpen?2:0),
          bOpen?Container(
            width: fullWidth,
            height:levelInfo.lineHeight,
//            height: levelInfo.lineHeight,
//            width: levelInfo.lineWidth + (bOpen?levelInfo.spaceStep+2:0.0),
              padding: leftPadding,
            // color: maincolor,
              child:Row(
                children: [

//                  Expanded(child : showInfo??Text("")),
                  IconButton(
                    icon:Icon(MaterialCommunityIcons.plus_box_outline , color: Colors.green),
                    tooltip: "添加",
                    onPressed: (){
                      var df = innerType0.parseValue(null);
                      lst.add(df);
                      onSubmitted?.call(lst);
                    },
                  ),
                ],
              ),
          ):SizedBox(height: 0,),
        ],
      ),
    )..height = bOpen?SSDefines.nodeFieldRowHeight * (ws.length + 2):SSDefines.nodeFieldRowHeight;

  }

  @override
  Color getCanvasEditBgColor(){
    return null;
  }
  @override
  EdgeInsets getCanvasEditPadding(){
    return EdgeInsets.fromLTRB(0,0,0,0);
  }

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){

    // if (innerType0)
    // var edtCon = SSListEditor(
    //   itemExtent: innerType0.getListItemHeight(),
    //   key: ValueKey("${gci?.fieldInfo?.guid??""}_table"),
    //   initValue: initValue,
    //   onChanged: onChanged,
    //   onSubmitted: onSubmitted,
    //   // separateFrame: true,
    //   gci: gci,
    //   innerType0: innerType0,
    //   name : gci?.name??'',
    // );
    var itmHeight =innerType0.getListItemHeight(gci:gci);
    var tbl = LayoutBuilder(
      builder: (a,size){
        var edtCon = SSListEditor(
          cacheExtent: (size.maxHeight /itmHeight) * 2,
          itemExtent: itmHeight,
          key: ValueKey("${gci?.fieldInfo?.guid??""}_table"),
          initValue: initValue,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          separateFrame: true,
          useBuilder: true,
          gci: gci,
          innerType0: innerType0,
          name : gci?.name??'',
          noContent: gci.isObjectTableEditMode,
        );
        return edtCon;
      }
    );
    return EditorHolder()..widget = tbl;
    // return EditorHolder()..widget = Center(
    //   child: ThemeCenter.iconBtn(
    //     MaterialCommunityIcons.square_edit_outline,
    //     width: 24 , height: 24,
    //     onPressed: (){
    //       showDialog(
    //         context: context,
    //         // barrierDismissible: false,
    //         builder: (BuildContext context) {
    //           // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
    //           return Dialog(child: edtCon);
    //         },
    //       );
    //     }
    //   ),
    // );
  }

  @override
  List<dynamic> parseValue(value){
    List<dynamic> v = [];
    if (value is List<dynamic> ){
      v = value;
    }

    if (value is Map ){
      value.forEach((key, value) {
        v.add(value);
      });
    }
    return v;
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {

    List<dynamic> lst = parseValue(v);
    bw.writeUint32(lst.length,"list length");
    int iCount = 0;
    var node = prms!= null? prms["node"] as StateScriptNode:null;
    var fi = prms!= null?prms["field"] as FieldInfo:null; //levelInfo.fi;
    bool withDynamicOutPort = fi.withDynamicOutPort();
    bool withDynamicInParam = fi.withDynamicInParam();
    bool withDn = withDynamicOutPort || withDynamicInParam;
    String dtId;
    String dtName;

    for(var t in lst){
      if (prms != null && prms["dynamicMode"] == true){
        bw.writeUint8(innerType0.exportId??0,"类型: ${innerType0.exportId??0}");
      }
      innerType0.export(bw, t);



      if (withDn) {
        var dtInfo = node.fieldValues[fi.guid].getOrCreateDynamicTriggerInfo(iCount);
        dtId = dtInfo?.id;
        dtName = dtInfo?.name;
      }

      // var maincolor = CommonUtil.scaleColor(Colors.redAccent, 0.16);

      if (withDynamicOutPort){
        var dynamicOutPorts = node.dynamicFieldOutPorts[fi.guid];
        if (dynamicOutPorts == null){
          dynamicOutPorts = node.dynamicFieldOutPorts[fi.guid] = Map<String , OutPort>();
        }

        var op = dynamicOutPorts[dtId];
        if (op == null){
          op = dynamicOutPorts[dtId] = OutPort();
          // dynamicOutPorts.add(op);
          node.getDynamicOutPortMap()[op.guid ] = op;
          node.buildDynamicOutPortId();
        }
        op.export(bw,node);
        // if (iCount>=dynamicOutPorts.length){
        //   var op = OutPort();
        //   dynamicOutPorts.add(op);
        //   node.getDynamicOutPortMap()[op.guid ] = op;
        //   node.buildDynamicOutPortId();
        //   op.export(bw,node);
        // }
        // else {
        //   dynamicOutPorts[iCount].export(bw,node);
        // }
      }


      if (withDynamicInParam){
        var dynamicInParams = node.dynamicFieldInParams[fi.guid];
        if (dynamicInParams == null){
          dynamicInParams = node.dynamicFieldInParams[fi.guid] = Map<String , InParam>();
        }

        var ip = dynamicInParams[dtId];
        if (ip == null){
          ip = dynamicInParams[dtId] = InParam();
          node.getDynamicInParamsMap()[ip.guid ] = ip;
          node.buildDynamicInParamId();
        }
        ip.export(bw,node);
        // if (iCount>=dynamicInParams.length){
        //   var op = InParam();
        //   op.fieldId = fi.guid;
        //   dynamicInParams.add(op);
        //   node.getDynamicInParamsMap()[op.guid ] = op;
        //   node.buildDynamicInParamId();
        //   op.export(bw,node);
        // }
        // else {
        //   dynamicInParams[iCount].export(bw,node);
        // }
      }

      ++iCount;

    }
  }

  @override
  String getFilterString(v) {
    List<dynamic> lst = parseValue(v);
    var res = "";
    for(var t in lst){
      var i = innerType0.getFilterString(t);
      res = "$res`$i";
    }
    return res;
  }

  @override
  dynamic exportValue(v) {
    List<dynamic> lst = parseValue(v);
    List<dynamic> out = List<dynamic>();
    for(var t in lst){
//      innerType0.export(bw, t);
      var v = innerType0.exportValue(t);
      var expVal = ExportMappingConfig.instance.mappingFieldValue(innerType0.name, v , {"type":innerType0.getExportInfo()});
      out.add(expVal);
    }
    // print(out);
    return out;
  }


  @override
  dynamic getExportDefault(dynamic defaultValue){
    return [];
  }

//  @override
//  String getExportType(){
//    return "List<${innerType0.name}>";
//  }
  @override
  clone(){
    var t = SSList();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }
}