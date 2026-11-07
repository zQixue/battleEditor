//@dart=2.11

import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/s_s_dic_editor.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
//import 'package:battlepus/StateScript/Struct/FieldTypes/MapPair.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';


class SSMap extends SSFieldType{

  SSMap(){
    exportId = 33;
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    var lst = parseValue(initValue);
//    var maincolor = CommonUtil.scaleColor(Colors.green, 0.16);

    baseHeight = 20.0;
    List<Widget> ws = new List<Widget>();
    double fullHeight = 0;
    for (int i = 0; i < lst.length; ++i) {
      var crt = lst[i];
      var key = innerType1.parseValue(crt["key"]);
      var val = innerType0.parseValue(crt["value"]);

//      crt = innerType0.parseValue(crt);
      var openGuid = "${levelInfo.openGuid}_${i}_$val";
//      bool bIsObjRef = (innerType0 is FTObjectReference);
//      bool opened = levelInfo.openedMap[openGuid] ?? false;

//      var old = levelInfo.lineWidth;


//      crt = innerType0.parseValue(crt);
//      var old = levelInfo.lineWidth;
//      levelInfo.lineWidth = 200;
      var wKey = innerType1.getThinEditWidget(key,
              (v) {
            lst[i]["key"] = v;
            onChanged?.call(lst);
          },
              (v) {
            lst[i]["key"] = v;
            onSubmitted?.call(lst);
          },
          baseHeight,
          levelInfo: levelInfo,
          bOpen: false,
          onVisible: null
      );
//      levelInfo.lineWidth = old;

//      if (!bIsObjRef) {
//        levelInfo.lineWidth = old - 279;
//      }
      var wVal = innerType0.getThinEditWidget(val,
              (v) {
            lst[i]["value"] = v;
            onChanged?.call(lst);
          },
              (v) {
            lst[i]["value"] = v;
            onSubmitted?.call(lst);
          },
          baseHeight,
          levelInfo: levelInfo,
          bOpen: true,
//          onVisible: bIsObjRef ? (v) {
//            EventCenter.eventBus.fire(GlobalRefreshEvent());
//            levelInfo.openedMap[openGuid] = v;
//          } : null
        context: context,
      );
//      levelInfo.lineWidth = old;

      fullHeight += wVal.height + wKey.height + 2 ;

      // var color = (i % 2 == 1) ? CommonUtil.scaleColor(Colors.deepPurpleAccent, 0.05) : CommonUtil.scaleColor(Colors.grey, 0.2);
      var color = (i % 2 ==1) ? Color.fromARGB(255, 40, 40, 40) : Color.fromARGB(255, 35, 35, 35);//CommonUtil.scaleColor(Colors.grey, 0.2);
      var rowitem = Container(
        color: color,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//        height: SSDefines.nodeFieldRowHeight,
      height :wVal.height + wKey.height + 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child : Column(
              children: [
                SizedBox(
                  child:Row(
                    children: [
                      Icon(MaterialCommunityIcons.alpha_k_box_outline, color: Colors.green, size: 16,),
                      Expanded(child:wKey.widget),
                    ],
                  ) ,
                  height: wKey.height,
                )
                ,
                SizedBox(
                  height: wVal.height,
                  child :Row(
                    children: [
                      Icon(MaterialCommunityIcons.alpha_v_box_outline, color: Colors.indigoAccent, size: 16,),
                      Expanded(child:wVal.widget),
                    ],
                  ),
                )
              ],
            )),
//            Expanded(flex : 2 , child : wKey.widget),
//            Icon(MaterialCommunityIcons.arrow_right, color: Colors.indigoAccent,),
//            Expanded(flex : 3 , child : wVal.widget),
            SSDefines.IBC( child :IconButton(
              padding: EdgeInsets.all(0),
              iconSize: SSDefines.iconButtonSize,
              icon: Icon(MaterialCommunityIcons.minus_box_outline, color: Colors.red),
              tooltip: "删除",
              onPressed: () {
                lst.removeAt(i);
                onSubmitted?.call(lst);
              },
            )),
          ],
        ),
      );
      ws.add(rowitem);
    }
//    var fullWidth = levelInfo.lineWidth - 8; //+ (bOpen?63.5:0.0) ;
//    var dc = new BoxDecoration(
//      color:maincolor,
//      border: Border(
//        left: BorderSide(width: 2,color: maincolor),
//        right: BorderSide(width: 2,color: maincolor),
//      ),
//    ); // 圆角度
//    var leftPadding = EdgeInsets.fromLTRB(4, 0, 0, 0);
    return EditorHolder()..widget = Container(
      height: fullHeight + baseHeight,
//        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//      decoration: dc,
//        color: maincolor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//            Container(
////            height: SSDefines.nodeFieldRowHeight,
////              width: fullWidth,
//              height: baseHeight,
////              padding: leftPadding,
//              color: maincolor,
//              //CommonUtil.alphaColor(Colors.green, 25),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
////
////                  onVisible != null ? IconButton(
////                    icon: Icon(bOpen ? MaterialCommunityIcons.close_box_outline : MaterialCommunityIcons.square_edit_outline, color: bOpen ? Colors.redAccent : Colors.indigoAccent),
////                    tooltip: "关闭",
////                    onPressed: () {
////                      onVisible?.call(!bOpen);
////                    },
////                  ) : SizedBox(width: 0,),
//                  Expanded(child: showInfo ?? Text(getTypeShowString())),
//                ],
//              ),
//            ),
            Container(
//              padding: leftPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ws,
              ),
            ) ,

            Container(
//              height: SSDefines.nodeFieldRowHeight,
                height: baseHeight,//levelInfo.lineHeight,
//                width: fullWidth,
//                padding: leftPadding,
//                color: maincolor,
                //CommonUtil.alphaColor(Colors.green, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Expanded(child :showInfo??Text("")),
                  SSDefines.IBC(child :IconButton(
                      iconSize: SSDefines.iconButtonSize,
                      icon: Icon(MaterialCommunityIcons.plus_box_outline, color: Colors.green,),
                      padding: EdgeInsets.all(0),
                      tooltip: "添加",
                      onPressed: () {
                        var dKey = innerType0.parseValue(null);
                        var dVal = innerType1.parseValue(null);
                        lst.add({'key': dKey, 'value': dVal});
                        onSubmitted?.call(lst);
                      },
                    )),
                  ],
                )
            ),
          ],
        ),
      )..height = fullHeight + baseHeight ;
  }
  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){

    if (fieldType == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.arrow_right_bold_box_outline , color: Colors.indigoAccent,),
          SizedBox(width: 8,),
          Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
        ],
      );
    }

    var innerType0 = SSFieldType.getFieldType(fieldType.innerTypeGuid0);
    var innerType1 = SSFieldType.getFieldType(fieldType.innerTypeGuid1);
    if (onChange == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.arrow_right_bold_box_outline , color: Colors.indigoAccent,),
          SizedBox(width: 16),




          Expanded(flex : 2 ,
              child :Container(
//                height: 32,
                color: CommonUtil.alphaColor( Colors.indigo , 30),
                alignment: Alignment.center,
                child: innerType1 != null ? innerType1.getTypeShowWidget(fieldType: innerType0) : Text("未选择"),
              )
          ),
          Icon(MaterialCommunityIcons.arrow_right , color: Colors.indigoAccent,),
          Expanded(flex : 2 ,
              child :Container(
//                height: 32,
                color: CommonUtil.alphaColor( Colors.indigo , 30),
                alignment: Alignment.center,
                child: innerType0 != null ? innerType0.getTypeShowWidget() : Text("未选择"),
              )
          ),
        ],
      );
    }

    var lstValues = SSFieldType.getTypeMap(excludeFlag: SSFieldType.FIELD_FLAG_CONTAINER);
    lstValues.sort((a,b)=>a.priority-b.priority);

    List<PopupMenuEntry<String>> itemValues = new  List<PopupMenuEntry<String>>();
    for(var i in lstValues){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: i.getTypeShowWidget(),
      );
      itemValues.add(item);
    }
    var menuValues = PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      icon: Icon(MaterialCommunityIcons.menu , size: 20,),
      initialValue:fieldType.innerTypeGuid0,

      onSelected: (String v) {

        var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid , v ,fieldType.innerTypeGuid1);
        onChange?.call(newFT.guid);
        // fieldInfo.innerTypeGuid1 = v;
        // onChange?.call(v);
      },
      itemBuilder: (BuildContext context) => itemValues,
    );

    var lstKeys = SSFieldType.getTypeMap(includeFlag: SSFieldType.FIELD_FLAG_KEY);
    lstValues.sort((a,b)=>a.priority-b.priority);

    List<PopupMenuEntry<String>> itemKeys = new  List<PopupMenuEntry<String>>();
    for(var i in lstKeys){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: i.getTypeShowWidget(),
      );
      itemKeys.add(item);
    }
    var menuKeys = PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      icon: Icon(MaterialCommunityIcons.menu , size: 20,),
      initialValue:fieldType.innerTypeGuid1,

      onSelected: (String v) {
        // fieldInfo.innerTypeGuid0 = v;
        // onChange?.call(v);
        var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid ,fieldType.innerTypeGuid0, v);
        onChange?.call(newFT.guid);
      },
      itemBuilder: (BuildContext context) => itemKeys,
    );


    return Container(
//        padding: EdgeInsets.fromLTRB(8, 0, 18, 0),

        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(MaterialCommunityIcons.arrow_right_bold_box_outline , color: Colors.greenAccent,),
              SizedBox(width: 4),
              Expanded(flex : 2 ,child : Container(
                color: CommonUtil.alphaColorD( Colors.indigo , 0.3),
                alignment: Alignment.center,
//                width: 200,
                child :innerType1 != null ? innerType1.getTypeShowWidget() : Text("未选择"),
//                child: Row(
//                  children: [
//                    innerType0 != null ? innerType0.getTypeShowWidget() : Text("未选择"),
//                  ],
//                ),
              )),
              Container(
                color: CommonUtil.alphaColorD( Colors.indigo , 0.3),
                width: 20,
                child: menuKeys,
              ),
              Icon(MaterialCommunityIcons.arrow_right , color: Colors.indigoAccent,),
              Expanded(flex : 5 ,child : Container(
                color: CommonUtil.alphaColorD( Colors.indigo , 0.3),
                alignment: Alignment.center,
//                width: 200,
                child:innerType0 != null ? innerType0.getTypeShowWidget(fieldType: innerType0 , onChange: (v){
                  fieldType.innerTypeGuid0 = v;
                  onChange?.call(fieldType.guid);
                }) : Text("未选择"),
//                child: Row(
//                  children: [
//                    Expanded( child : innerType1 != null ? innerType1.getTypeShowWidget() : Text("未选择")),
//                  ],
//                ),
              )),
              Container(
                color: CommonUtil.alphaColorD( Colors.indigo , 0.3),
                width: 20,
                child: menuValues,
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
          Expanded(child:Text("map")),
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
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
//    List<MapPair> lst = [];
//    if (initValue is List<MapPair> ){
//      lst = initValue;
//    }
    var lst = parseValue(initValue);
    var maincolor = CommonUtil.alphaColorD(Colors.green, 0.16);
    List<Widget> ws = new List<Widget>();
    for(int i = 0 ; i < lst.length ; ++i){
      var crt = lst[i];
      var key = innerType1.parseValue(crt["key"]);
      var val = innerType0.parseValue(crt["value"]);

//      crt = innerType0.parseValue(crt);
      var openGuid = "${levelInfo.openGuid}_${i}_$val";
      bool bIsObjRef =  (innerType0 is FTObjectReference);
      bool opened = levelInfo.openedMap[openGuid]??false;

      var old = levelInfo.lineWidth;


//      crt = innerType0.parseValue(crt);
//      var old = levelInfo.lineWidth;
      levelInfo.lineWidth = 200;
      var wKey = innerType1.getEditWidget(key,
              (v){
            lst[i]["key"] = v;
            onChanged?.call(lst);
          },
              (v){
            lst[i]["key"]  = v;
            onSubmitted?.call(lst);
          },
        levelInfo: levelInfo,
          context:context,
        bOpen: false,
          onVisible:null
      );
      levelInfo.lineWidth = old;

      if (!bIsObjRef){
        levelInfo.lineWidth = old - 279;
      }
      var wVal = innerType0.getEditWidget(val,
              (v){
            lst[i]["value"] = v;
            onChanged?.call(lst);
          },
              (v){
            lst[i]["value"] = v;
            onSubmitted?.call(lst);
          },
          context: context,
          levelInfo: levelInfo,
          bOpen: opened,
          onVisible: bIsObjRef?(v){
            EventCenter.eventBus.fire(GlobalRefreshEvent());
            levelInfo.openedMap[openGuid] = v;
          }:null
      );
      levelInfo.lineWidth = old;

      var color = (i%2 ==1) ? CommonUtil.alphaColorD(Colors.deepPurpleAccent, 0.05) : CommonUtil.alphaColorD(Colors.grey, 0.2);
      var rowitem = Container(
        // color: color,
//        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
//        height: SSDefines.nodeFieldRowHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon:Icon(MaterialCommunityIcons.minus_box_outline , color: Colors.red),
              tooltip: "删除",
              onPressed: (){
                lst.removeAt(i);
                onSubmitted?.call(lst);
              },
            ),
            wKey.widget,
            Icon(MaterialCommunityIcons.arrow_right , color: Colors.indigoAccent,),
            wVal.widget,

          ],
        ),
      );
      ws.add(rowitem);
    }
    var fullWidth = levelInfo.lineWidth - 8 ;//+ (bOpen?63.5:0.0) ;
//    var dc = new BoxDecoration(
//      color:maincolor,
//      border: Border(
//        left: BorderSide(width: 2,color: maincolor),
//        right: BorderSide(width: 2,color: maincolor),
//      ),
//    ); // 圆角度
    var leftPadding = EdgeInsets.fromLTRB(4, 0, 0, 0);
    return EditorHolder()..widget = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//      decoration: dc,
//       color:maincolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
//            height: SSDefines.nodeFieldRowHeight,
            width: fullWidth,
          height:levelInfo.lineHeight,
            padding: leftPadding,
            color: maincolor,//CommonUtil.alphaColor(Colors.green, 25),
            child:Row(
              children: [

                onVisible!= null?IconButton(
                  icon:Icon(bOpen?MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.square_edit_outline , color: bOpen?Colors.redAccent : Colors.indigoAccent),
                  tooltip: "关闭",
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
//              height: SSDefines.nodeFieldRowHeight,
              height:levelInfo.lineHeight,
              width: fullWidth,
              padding: leftPadding,
              // color: maincolor,//CommonUtil.alphaColor(Colors.green, 25),
              child:Row(
                children: [
                  //Expanded(child :showInfo??Text("")),
                  IconButton(
                    icon:Icon(MaterialCommunityIcons.plus_box_outline , color: Colors.green,),
                    tooltip: "添加",
                    onPressed: (){
                      var dKey = innerType0.parseValue(null);
                      var dVal = innerType1.parseValue(null);
                      lst.add({'key':dKey , 'value':dVal});
                      onSubmitted?.call(lst);
                    },
                  ),
                ],
              )
          ):SizedBox(height: 0,),
        ],
      ),
    )..height = bOpen? SSDefines.nodeFieldRowHeight * (ws.length + 2):SSDefines.nodeFieldRowHeight;

  }

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    var lst = parseValue(initValue);
    var edtCon = SSDicEditor(
      initValue: lst,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      gci: gci,
      innerType0: innerType0,
      innerType1: innerType1,
      name : gci.name,
    );

    return EditorHolder()..widget = Center(
      child: ThemeCenter.iconBtn(
          MaterialCommunityIcons.square_edit_outline,
          width: 24 , height: 24,
          onPressed: (){
            showDialog(
              context: context,
              // barrierDismissible: false,
              builder: (BuildContext context) {
                // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
                return Dialog(child: edtCon);
              },
            );
          }
      ),
    );
  }

  @override
  List<Map<String, dynamic>> parseValue(value){
    List<Map<String, dynamic>> v = new List<Map<String, dynamic>>();
    if (value is List){
      value.forEach((e) {
        v.add(e as Map<String, dynamic>);
      });
    }

    if (value is Map){
      value.forEach((key, value) {
        v.add({"key": key, "value": value});
      });
    }
//    else if (value is List){
//      value.forEach((e) {
//        if (e is Map<String, dynamic>){
//          var key = innerType0.parseValue(e["key"]);
//          var val = innerType1.parseValue(e["value"]);
//          v.add(value)
//        }
//      });
//    }
    return v;
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    List<Map<String, dynamic>> lst = parseValue(v);

    var m = {};
    lst.forEach((element) {
      var key = element["key"];
      var val = element["value"];
      if (key != null && val != null) {
        m[key] = val;
      }
    }
    );

    bw.writeUint32(m.length,"map length");
    m.forEach((key, value) {
      if (prms != null && prms["dynamicMode"] == true){
        bw.writeUint8(innerType1.exportId??0,"key类型: ${innerType0.exportId??0}");
      }
      innerType1.export(bw, key);
      if (prms != null && prms["dynamicMode"] == true){
        bw.writeUint8(innerType0.exportId??0,"value类型: ${innerType0.exportId??0}");
      }
      innerType0.export(bw, value);
    });

  }

  @override
  String getFilterString(v) {
    List<Map<String, dynamic>> lst = parseValue(v);

    var m = {};
    lst.forEach((element) {
      var key = element["key"];
      var val = element["value"];
      if (key != null && val != null) {
        m[key] = val;
      }
    }
    );
    var res = "";

    m.forEach((key, value) {
      var a = innerType1.getFilterString(key);
      var b = innerType0.getFilterString(value);
      res = "$res`$a`$b";
    });
    return res;
  }

  @override
  dynamic exportValue(v) {
    List<Map<String, dynamic>> lst = parseValue(v);

    var m = {};
    lst.forEach((element) {
      var key = element["key"];
      var val = element["value"];
      if (key != null && val != null) {
        m[key] = val;
      }
    }
    );
    var out = [];
    m.forEach((key, value) {
      var k = innerType1.exportValue(key);
      k = ExportMappingConfig.instance.mappingFieldValue(innerType1.name, k , {});
      var val = innerType0.exportValue(value);
      val = ExportMappingConfig.instance.mappingFieldValue(innerType0.name, val , {"type":innerType0.getExportInfo()});
      // out[k] = val;
      out.add({"key" : k , "val" : v});
    });

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
    var t = SSMap();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }
}