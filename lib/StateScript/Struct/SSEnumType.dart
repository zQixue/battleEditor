

import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSEnumItem.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/ColorUtils.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:theme_provider/theme_provider.dart';

//这里不得已得获取 需要拿到默认的全局的命名空间
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';

part 'SSEnumType.g.dart';

@JsonSerializable()
class SSEnumType extends SSFieldType{

  @JsonKey(defaultValue: <SSEnumItem>[])
  List<SSEnumItem> items = <SSEnumItem>[];

  @JsonKey(defaultValue: false)
  bool exportSolver = false;
  @JsonKey(defaultValue: true)
  bool needExport = true;
  @JsonKey(defaultValue: "")
  String solveCompName = "";

  @JsonKey(defaultValue: "")
  String staticDataName = "";

  @JsonKey(defaultValue: false)
  bool isBehavicEnum = false;

  @JsonKey(defaultValue: "")
  String namespace = "";
  @JsonKey(defaultValue: "")
  String desc = "";

  @JsonKey(defaultValue: "")
  String group = "";

  @JsonKey(defaultValue: true)
  bool needExportCode = true;


  SSEnumItem addItem(){
    SSEnumItem tmp = new SSEnumItem();
    items.add(tmp);
    buildItemMap();
    return tmp;
  }

  @override
  Widget getTypeShowWidget({SSFieldType? fieldType , FunctionStringCallback? onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.alpha_e_box_outline),
        SizedBox(width: 4,),
//        Text(getTypeShowString()),
        Expanded(child:Text(getTypeShowString() , style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }

  bool itemExists(String guid){
    if (guid2Item == null) buildItemMap();

    return guid2Item!.containsKey(guid);
    // for(var i in items){
    //   if (i.guid == guid){
    //     return true;
    //   }
    // }
    //
    // return false;
  }

  @JsonKey(ignore: true)
  Map<String,SSEnumItem>? guid2Item ;
  @JsonKey(ignore: true)
  Map<String,SSEnumItem>? name2Item ;

  @JsonKey(ignore: true)
  Map<int,SSEnumItem>? val2Item ;

  @JsonKey(ignore: true)
  Map<String,int>? guid2Index ;

  void buildItemMap(){
    if (guid2Item == null) {
      guid2Item = Map<String, SSEnumItem>();
      name2Item = Map<String, SSEnumItem>();
      guid2Index = Map<String,int>();
      val2Item = Map<int,SSEnumItem>();
    }
    guid2Item!.clear();
    name2Item!.clear();
    guid2Index!.clear();
    int iCount = 0;
    items.forEach((element) {
      guid2Item![element.guid] = element;
      name2Item![element.name] = element;
      guid2Index![element.guid] = iCount++;
      val2Item![element.enumValue??element.exportId??0] =  element;
    });

    hintInfo = "";
  }

  int indexOf(String guid){
    if (guid2Index == null) buildItemMap();

    return guid2Index![guid]??-1;
    // for(int i = 0 ; i < items.length ; ++i){
    //   if (items[i].guid == guid){
    //     return i;
    //   }
    // }
    //
    // return -1;
  }

  SSEnumItem? findItem(String guid){
    if (guid2Item == null) buildItemMap();

    return guid2Item![guid]??null;
    // for(var i in items){
    //   if (i.guid == guid){
    //     return i;
    //   }
    // }
    // return null;
  }

  SSEnumItem? findItemByName(String name){
    if (name2Item == null) buildItemMap();
    return name2Item![name]??null;
    // for(var i in items){
    //   if (i.name == name){
    //     return i;
    //   }
    // }
    //
    // return null;
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget? showInfo,bool bOpen = false, FunctionBoolCallback? onVisible , EditorLevelInfo? levelInfo , BuildContext? context} ) {
    if (items.length <=0){
      return EditorHolder()..height = SSDefines.nodeFieldRowHeight..widget = const Text("请至少定义一个枚举选项值");
    }
    var v = items[0].guid;
    if (initValue is String && itemExists(initValue)){
      v = initValue;
    }


    List<PopupMenuEntry<String>> itemWidgets =  <PopupMenuEntry<String>>[];

    for(var i in items){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child : getGridLabelWidget(i.guid , size: 18 , color : Color(0xFF1b1e26) , withHint:true , borderColor: Colors.black) ,//,style: TextStyle(fontSize: 18,  fontWeight: FontWeight.w400,color: ColorUtils.StdColors[iCount
      );
      itemWidgets.add(item);
    }


    var con = getGridLabelWidget(v, size: 12  , borderColor: Colors.black , leftAlign: true);//Center(child: getValueLabelWidget(v));
    var res = PopupMenuButton<String>(
      color: Colors.black,
      tooltip: getHintInfo(),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: con,
      // child: Row(children: [con],).
      initialValue:v,
      onSelected: (String result) { onSubmitted?.call(result); },
      itemBuilder: (BuildContext context) => itemWidgets,
    );
    var holder = EditorHolder()..widget = ThemeProvider(child: res);
    holder.height = baseHeight;
    return holder;


//     List<PopupMenuEntry<String>> itemWidgets =  <PopupMenuEntry<String>>[];
//     for(var i in items){
//       var item = PopupMenuItem<String>(
//         value: i.guid,
//         child: Text(i.getTypeShowString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.brown),),
//       );
//       itemWidgets.add(item);
//     }
//
//     var iIndex = indexOf(v);
//     if (iIndex >=0){
//       SSDefines.lastEnumValue =items[iIndex].enumValue??iIndex;
//     }
//
//     var res = PopupMenuButton<String>(
//       padding: EdgeInsets.all(0),
//       icon : const Icon(MaterialCommunityIcons.menu , size: SSDefines.iconButtonSize,),
//       initialValue:v,
//       onSelected: (String result) { onSubmitted?.call(result); },
//       itemBuilder: (BuildContext context) => itemWidgets,
//     );
// //    return res;
//     bool disabled = levelInfo?.fi?.disabled??false;
//      Widget con = Row(
//        // mainAxisAlignment: MainAxisAlignment.center,
//          children:[
//            Expanded(child:Container(
//              color: CommonUtil.scaleColor(Colors.grey , 0.25),
//              // height : 32,
//              alignment: Alignment.center,
//              child: getValueLabelWidget(v , style : SSDefines.lineContentStyle),//fi.getShowWidget(),
//            )),
//            if (!disabled) SSDefines.IBC(
//              child: res,//Icon(MaterialCommunityIcons.menu),
//            ),
//            // SizedBox(width: 10,)
// //            res,
//          ]
//      );
//      // if (isGroup){
//      //   con = IgnorePointer(
//      //     child: con,
//      //   );
//      // }
//     var holder = EditorHolder()..widget = con;
//     holder.height = baseHeight;
//     return holder;
  }
    @override
  EditorHolder getEditWidget(initValue , onChanged , onSubmitted  , {Widget? showInfo , bool bOpen = false, FunctionBoolCallback? onVisible , EditorLevelInfo? levelInfo, BuildContext? context}){
      if (items.length <=0){
        return EditorHolder()..height = SSDefines.nodeFieldRowHeight..widget = const Text("请至少定义一个枚举选项值");
      }
      var v = items[0].guid;
      if (initValue is String && itemExists(initValue)){
        v = initValue;
      }


      List<PopupMenuEntry<String>> itemWidgets =  <PopupMenuEntry<String>>[];

      for(var i in items){
        var item = PopupMenuItem<String>(
          value: i.guid,
          child : getGridLabelWidget(i.guid , size: 18 , color : Color(0xFF1b1e26) , withHint:true),//,style: TextStyle(fontSize: 18,  fontWeight: FontWeight.w400,color: ColorUtils.StdColors[iCount
        );
        itemWidgets.add(item);
      }


      var con = getGridLabelWidget(v, size: 18);//Center(child: getValueLabelWidget(v));
      var res = PopupMenuButton<String>(
        tooltip: getHintInfo(),
        child: Center(child:Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, 0), child:SizedBox(height: 26,child: con ))),
        initialValue:v,
        onSelected: (String result) { onSubmitted?.call(result); },
        itemBuilder: (BuildContext context) => itemWidgets,
      );
      var holder = EditorHolder()..widget = res;
      return holder;
    //     if (items.length <=0){
//       return EditorHolder()..height = SSDefines.nodeFieldRowHeight..widget = const Text("请至少定义一个枚举选项值");
//     }
//     var v = items[0].guid;
//     if (initValue is String && itemExists(initValue)){
//       v = initValue;
//     }
//
//     List<PopupMenuEntry<String>> itemWidgets = new  List<PopupMenuEntry<String>>();
//     for(var i in items){
//       var item = PopupMenuItem<String>(
//         value: i.guid,
//         child: Text(i.getTypeShowString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrangeAccent),),
//       );
//       itemWidgets.add(item);
//     }
//
//
//     var res = PopupMenuButton<String>(
//       icon : Icon(MaterialCommunityIcons.menu),
//       initialValue:v,
//       onSelected: (String result) { onSubmitted?.call(result); },
//       itemBuilder: (BuildContext context) => itemWidgets,
//     );
// //    return res;
//     var holder = EditorHolder()..widget = Container(
//         width: levelInfo?.lineWidth,
//         height : levelInfo?.lineHeight,
//         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//         child:Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:[
//               Expanded(flex: 2, child:Container(
//                 color: ThemeCenter.mainTextStepColor(1),
//                 height : 32,
//                 alignment: Alignment.center,
//                 child: getValueLabelWidget(v),//fi.getShowWidget(),
//               )),
//               Container(
//                 width: 30,
//                 child: res,
//               ),
//               SizedBox(width: 10,)
// //            res,
//             ]
//         )
//
//     );
//     holder.height = SSDefines.nodeFieldRowHeight;
//     return holder;
  }

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo? gci , BuildContext? context}){
    if (items.length <=0){
      return EditorHolder()..height = SSDefines.nodeFieldRowHeight..widget = const Text("请至少定义一个枚举选项值");
    }
    var v = items[0].guid;
    if (initValue is String && itemExists(initValue)){
      v = initValue;
    }


    List<PopupMenuEntry<String>> itemWidgets =  <PopupMenuEntry<String>>[];

    for(var i in items){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child : getGridLabelWidget(i.guid , size: 18 , color : Color(0xFF1b1e26) , withHint:true),//,style: TextStyle(fontSize: 18,  fontWeight: FontWeight.w400,color: ColorUtils.StdColors[iCount
      );
      itemWidgets.add(item);
    }


    var con = getGridLabelWidget(v);//Center(child: getValueLabelWidget(v));
    var res = PopupMenuButton<String>(
      tooltip: "选择",//getHintInfo(),
      child: Center(child:Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, 0), child:SizedBox(height: 22,child: con ))),
      initialValue:v,
      onSelected: (String result) { onSubmitted?.call(result); },
      itemBuilder: (BuildContext context) => itemWidgets,
    );
    var holder = EditorHolder()..widget = res;
    return holder;
  }

  @override
  Widget getValueLabelWidget(initValue, {TextStyle? style}){
      var v = parseValue(initValue);
    var item = findItem(v);
    Widget txt ;
    if (item == null){
      txt = Text("[ 无效 ]" , style: TextStyle(fontSize: 14,  fontWeight: FontWeight.w400,color: Colors.redAccent));
    }
    var idVal = item!.enumValue??item.exportId??0;
    var style2 = TextStyle(fontSize: 14,  fontWeight: FontWeight.w400,color: ColorUtils.StdColors[idVal %ColorUtils.StdColors.length]);
    txt = Text(item.getTypeShowString(),style: style??style2 );
    return txt;
  }

  Widget getGridLabelWidget(initValue, {double? size, Color? color, bool withHint = false , Color? borderColor , bool leftAlign = false}){
    var v = parseValue(initValue);
    var item = findItem(v);
    Widget txt ;
    if (item == null){
      txt = Text("[ 无效 ]" , style: TextStyle(fontSize: size??13,  fontWeight: FontWeight.w400,color: Colors.redAccent));
    }
    var idVal = item!.enumValue??item.exportId??0;
    var clr = ColorUtils.StdColors[idVal %ColorUtils.StdColors.length];
    var style2 = TextStyle(fontSize: size??13,  fontWeight: FontWeight.w400,color: clr);
    txt = Text(item.getTypeShowString(),style: style2 );
    // return txt;
    var con = Center(child: txt);

    var dc = new BoxDecoration(
        // border : new Border.all(color: ColorUtils.StdColors[item.enumValue %ColorUtils.StdColors.length], width: 1.5),
        border :Border(
          bottom: BorderSide(width: 1.0, color: borderColor??clr ),
        ),
          // color : color,//(0xFF1b1e26),
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
        // borderRadius: new BorderRadius.circular((6))
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 2.5),
        child : Container(
      // height: 100,

        decoration: dc,
        // child :con,
        child: (withHint && !DartCommon.isEmpty(item.hint))?Row(
          children: [
            // Icon(MaterialCommunityIcons.tag_heart_outline , size: 12, color: ColorUtils.StdColors[item.enumValue %ColorUtils.StdColors.length],),
            if (!leftAlign) Expanded(child: con),
            if (leftAlign) txt,
            if (leftAlign) const Expanded(child: const SizedBox(width: 1,),),
              Tooltip(
              message: item.hint,
              child: Icon(MaterialCommunityIcons.help_circle , size: 20, color: clr,),
            ),
          ],
        ):Row(
          children: [
            // Icon(MaterialCommunityIcons.tag_heart_outline , size: 12, color: ColorUtils.StdColors[item.enumValue %ColorUtils.StdColors.length],),
            if (!leftAlign) Expanded(child: con),
            if (leftAlign) txt,
            if (leftAlign) const Expanded(child: const SizedBox(width: 1,),),
          ],
        ),
    ));
  }

  @override
  dynamic parseValue(value){
    if (items.length <=0){
      return "";
    }
    String v = items[0].guid;
    if (value is String && itemExists(value)){
      v = value;
    }
    return v;
  }
  @override
  dynamic otParseValue(v) {
    return exportValue(v);
  }
  @override
  dynamic otImportValue(dynamic v) {
    if (v is String){
      v =  int.tryParse(v)??0;
    }
    var itm = getItemByValue(v);
    if (itm != null) return itm.guid;
    return "";
  }
  @JsonKey(ignore:true)
  String hintInfo = "";
  String getHintInfo() {
    if (hintInfo.isEmpty) {
      var res = "请选择枚举值";
      items.forEach((element) {
        res += "\n\t${element.name} ${element.alias}";
      });
      hintInfo = res;
      return res;
    }

    return hintInfo;
  }

  SSEnumItem? getItemByValue(int val) {
    if (val2Item == null) buildItemMap();
    var res = val2Item![val];
    if (res != null) return res;
    if (items.length>0) return items[0];
    return null;
  }
  @override
  dynamic parseFinalValue(value){
    var itemValue = findItem(value);
    var res = "${name}.${itemValue!.name}";
    String ns = realNamespace();
    if (!DartCommon.isEmpty(ns)){
      res = "$ns.$res";
    }
    return res;
  }
  @override
  dynamic parseShortShowName(value){
    if (!(value is String)){
      return "无效的枚举ID";
    }
    var itemValue = findItem(value);
    var res = "${itemValue?.getTypeShowString()}";
    return res;
  }

  void removeItem(SSEnumItem item){
    items.remove(item);
    buildItemMap();
  }
  @override
  void export(ByteDataWriter bw, v , {Map? prms}) {
    var index = findItem(parseValue(v));
    if (index!= null && index.enumValue != null){
      bw.writeInt32(index.enumValue , exportFlag);
      return ;
    }
    bw.writeInt32(index?.exportId??0,exportFlag);

  }

  int getItemValue(v) {
    var index = findItem(parseValue(v));

    if (index!= null && index.enumValue != null){
      return index.enumValue! ;
    }
    return index?.exportId??0;
  }

  @override
  dynamic exportValue(v) {
    var index = findItem(parseValue(v));

    if (index!= null && index.enumValue != null){
      return index.enumValue ;
    }

    return index?.exportId??0;
  }

  @override
  String getFilterString(v) {
    // print(name);
    var item = findItem(v);
    if (item != null){
      return "${item.name}`${item.alias}";
    }
    return "$v";
  }

  SSEnumType(){
    flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD;
  }
  //此处与类名一致，由指令自动生成代码
  factory SSEnumType.fromJson(Map<String, dynamic> json) =>
      _$SSEnumTypeFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSEnumTypeToJson(this);

  ///这里实际上就是写的field["Type"] 所包含的信息 导出代码时会用上
  ///上层调用是在NodeStructData中的exportCodeData方法
  @override
  getExportInfo({Map<String,dynamic>? extra}){
    var res = super.getExportInfo();
    var realNamespaceStr = this.realNamespace();
    var exportType = res["exportType"];
    res["namespace"] =  realNamespaceStr;
    res["name"] = name;
    res["exportType"] =   "$realNamespaceStr.$exportType";  //带上命名空间
    res["fullName"] =   "$realNamespaceStr.$exportType _$name"; 
    res["needExport"] = needExport??true; 
    res['isEnum'] = "1";
    return res;
  }

  //获取实际的Namespace
  String realNamespace(){
    return DartCommon.isEmpty(namespace) ? ExportMappingConfig.instance!.enumnamespace: namespace;
  }

  void buildItemId() {
    int iCount = 0 ;
    for(var i in items){
      i.exportId = iCount ++;
    }
  }

  @override
  dynamic getTagValue(dynamic v) {
    var guid = parseValue(v);
    var item = findItem(guid);
    return item?.getTypeShowString()??"无效枚举值";
  }


  @override
  String syncSerialize(dynamic value){
    var index = findItem(parseValue(value));
    if (index!= null && index.enumValue != null){
      return index.enumValue.toString();
    }
    return (index?.exportId??0).toString();
  }
  @override
  dynamic syncDeserialize(String serStr){
    var res = int.tryParse(serStr);
    var item = getItemByValue(res??0);
    if (item != null){
      return item.guid;
    }
    return items[0]?.guid??"";
  }


}