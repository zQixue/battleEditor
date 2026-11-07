//@dart=2.11
 
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/ObjectTable/a_object_selector.dart';
import 'package:battlepus/ObjectTable/a_ref_object_view.dart';
import 'package:battlepus/ObjectTable/object_editor.dart';
import 'package:battlepus/ObjectTable/object_tag_view.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_dropdown_ex.dart';

class FTStringSpaceObjectReference extends SSFieldType{


  static Widget getClazzShowWidget({ObjectClazz clazz}){

    var con = Row(
      children: [
        Icon(MaterialCommunityIcons.alpha_z_box_outline , color: Colors.redAccent,),
        SizedBox(width: 4,),
        Text(clazz.getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,),
        // Expanded(child:Text("clazz.getTypeShowString()" , overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );

    return con;
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){

    if (fieldType == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.link_box_outline , color: Colors.red,),
          SizedBox(width: 4,),
          Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,)),
          // Expanded(child:Text("" , overflow: TextOverflow.clip,maxLines: 1,)),
//          Row(
//            children: [
//              Text(getTypeShowString()),
//            ],
//          ),
        ],
      );
    }

    var innerType = ObjectClazz.getClazz(fieldType.innerTypeGuid0);
    if (onChange == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.link_box_outline , color: Colors.red,),
          SizedBox(width: 16,),
          Expanded(child : Container(
            color: CommonUtil.alphaColor( Colors.indigo , 30),
            alignment: Alignment.center,
//                width: 200,
            child: innerType != null ? getClazzShowWidget(clazz:innerType) : Text("未选择"),
          )),
//          Expanded(flex : 2 ,child : innerType != null ? innerType.getTypeShowWidget() : Text("未选择")),
        ],
      );
    }

    var lst = ObjectClazz.getClazzes();

    if (ObjectTableProject.withPlugins() && SSDefines.isNodeRef){
      lst = lst.where((element) => (element.forceExportBinary??false) || element.pluginTableRefable ).toList();
    }
    lst.sort((a,b)=>a.name.compareTo(b.name));

    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    for(var i in lst){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: getClazzShowWidget(clazz:i),//.getTypeShowWidget(),
      );
      items.add(item);
    }
    var res = PopupMenuButton<String>(
      initialValue:fieldType.innerTypeGuid0,
      onSelected: (String v) {
        // fieldInfo.innerTypeGuid0 = v;
        // onChange?.call(v);

        var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid ,v , fieldType.innerTypeGuid1);
        // print(v);
        // print(newFT.guid);

        onChange?.call(newFT.guid);
      },
      itemBuilder: (BuildContext context) => items,
    );


    return Container(
//        padding: EdgeInsets.all(4),

        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(MaterialCommunityIcons.link_box_outline , color: Colors.red,),
              SizedBox(width: 16,),
              Expanded(child : Container(
                color: CommonUtil.alphaColor( Colors.indigo , 30),
                alignment: Alignment.center,
//                width: 200,
                child: innerType != null ? getClazzShowWidget(clazz:innerType) : Text("未选择"),
              )),
              Container(
                color: CommonUtil.alphaColor( Colors.indigo , 30),
                width: 30,
                child: res,
              ),
//            res,
            ]
        )

    );
  }

  @override
  EditorHolder getCellEditWidget(initValue , onChanged , onSubmitted ,{ Widget showInfo,FunctionDynamicCallback onExtraEdit}){
    // return EditorHolder()..widget = Container() ..height = SSDefines.nodeFieldRowHeight;
    String v = "";
    if (initValue is String ){
      v = initValue;
    }

    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      return EditorHolder()..widget = Container(
        child: Text("请设置引用对象类型"),
      );
    }


    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    for(var i in clazz.table.objects){
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: Text(i.getShowName()),
      );
      items.add(item);
    }
    var itemNone = PopupMenuItem<String>(
      value: "",
      child: Text("空"),
    );
    items.add(itemNone);

    var res = PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      tooltip: "选择对象",
      icon : Icon(MaterialCommunityIcons.menu),
      initialValue:v,
      onSelected: (String result) {
        onSubmitted?.call(result);
      },
      itemBuilder: (BuildContext context) => items,
    );
//    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var obj = clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    return EditorHolder()..widget = Row(
      children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
        Expanded( flex: 6, child:getValueLabelWidget(obj==null?"空":obj.guid)),
        Container(
          width: SSDefines.iconButtonSize,
          child: res,
        ),
//        SizedBox(width: obj != null?2:0,),
        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box),
          onPressed: (){
            var aObj = clazz.table.addObject();
            onSubmitted?.call(aObj.guid);

            EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
          },
          tooltip: "新建",
        ),
        obj != null?IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.square_edit_outline),
          onPressed: (){
            //TODO , 编辑对象
            onExtraEdit?.call(null);
          },
          tooltip: "编辑",
        ):const SizedBox(width: 0,)
      ],
    )..height = SSDefines.nodeFieldRowHeight;
  }

  static List<DropdownMenuItem<String>> getItems(ObjectClazz clazz){
    List<DropdownMenuItem<String>> items = new  List<DropdownMenuItem<String>>();
    for(var i in clazz.table.objects){
      var key = i.getSearchKey();
      clazz.searchKey2Object[key] = i;

      var item = DropdownMenuItem<String>(
        value: key,
        child: ObjectTagView(object:i),//Text(i.getTag() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 14, fontWeight: FontWeight.w600 , color: Colors.lightBlueAccent)),
      );
      items.add(item);
    }

    var itemNone = DropdownMenuItem<String>(
      value: "",
      child: Text("空",style : TextStyle(fontSize: 14 , fontWeight: FontWeight.w600 , color: Colors.red)),
    );
    items.add(itemNone);
    return items;
  }

  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    // return EditorHolder()..widget = Container() ..height = SSDefines.nodeFieldRowHeight;

    String v = "";
    if (initValue is String ){
      v = initValue;
    }

    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      return EditorHolder()..widget = Container(
        child: Text("请设置引用对象类型"),
      );
    }

    //(levelInfo != null && levelInfo.isCircle);

    var crtObj = ObjectClazz.allObjects[v];
    // print(levelInfo.circleStack);
    bool isCircle = crtObj != null && levelInfo.circleStack.containsKey(crtObj.guid);
    var res = SearchableDropdown.single(
      underline:SizedBox(height: 0,),
      items: getItems(clazz),
      value: crtObj==null?"":crtObj.getSearchKey(),
      hint: "选择对象",
      searchHint: "选择对象",
      onChanged: (v) async {
        var newValue = clazz.searchKey2Object[v];
        if (newValue != null) {
          onSubmitted?.call(newValue.guid);
        }
        else{
          onSubmitted?.call("");
        }
      },
      closeButton: "关闭",
      isExpanded: true,
    );
//    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    var obj = clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);

    levelInfo.level ++;
//    if (bOpen)levelInfo.level++;
//     var dcl = SizedBox(width: 4,);
    var rightSpace = SizedBox(width:0);// levelInfo.spaceStep * levelInfo.deltaLevel,);
//    double _objectFullWidth = 640;
//    double _hearWidth = 160;
    var dc = new BoxDecoration(
      border: Border(
//        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
//          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
//          bottom: Divider.createBorderSide(context, color: Colors.indigo, width: 2),
        left: BorderSide(width: 2,color: Colors.indigo),
        right: BorderSide(width: 2,color: Colors.indigo),
      ),
//        color: Colors.indigo, // 底色
    ); // 圆角度

    var dc2 = new BoxDecoration(
      color: CommonUtil.alphaColor(Colors.brown, 40),
      border: Border(
//        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
//          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
        bottom: Divider.createBorderSide(context, color: CommonUtil.scaleColor(Colors.grey , 0.6), width: 1.9),
//         left: BorderSide(width: 2,color: Colors.indigo),
//         right: BorderSide(width: 2,color: Colors.indigo),
      ),
//        color: Colors.indigo, // 底色
    ); // 圆角度
    var content = Container(
      // height: levelInfo.lineHeight,
//      width : _objectFullWidth + (levelInfo.level) * (_hearWidth + 4),
    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: dc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: levelInfo.lineHeight,
            width: levelInfo.lineWidth - 2 + ((bOpen&&!isCircle)?levelInfo.spaceStep+2:0.0),
//
            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            // color: CommonUtil.alphaColor(Colors.brown, 69),
            decoration: dc2,
            child:Row(
//              mainAxisAlignment: MainAxisAlignment.end,
              children: [


                Icon(EvilIcons.sc_instagram , color: Color(clazz.color)),
                isCircle?Text("!!! 循环引用 !!!" , maxLines: 1, style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.redAccent)):SizedBox(width: 0,),
                // Expanded(child : showInfo??getValueLabelWidget(obj==null?null:obj.guid)),
                SizedBox(width: 4,),
                Expanded(child:res),
                // Container(
                //   width: 30,
                //   child: res,
                // ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon : Icon(MaterialCommunityIcons.plus_box_outline),
                  onPressed: (){
                    var aObj = clazz.table.addObject();

                    onSubmitted?.call(aObj.guid);

                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  },
                  tooltip: "新建",
                ),
                obj != null ?IconButton(
                  padding: EdgeInsets.all(0),
                  icon : Icon(MaterialCommunityIcons.tab_plus),
                  onPressed: (){
                    OTGlobalBoard.appendFocusItem(obj);
                    EventCenter.eventBus.fire(InspectorRefreshEvent()..object = obj);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  },
                  tooltip: "新标签页打开",
                ):SizedBox(width: 0,),

                obj != null && !isCircle && onVisible!= null?IconButton(
                  padding: EdgeInsets.all(0),
                  icon:Icon(bOpen?MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.square_edit_outline , color: bOpen?Colors.redAccent : Colors.indigoAccent),
                  tooltip: !bOpen?"展开编辑":"关闭",
                  onPressed: (){
                    onVisible?.call(!bOpen);
                  },
                ):SizedBox(width: 0,),
              ],
            ),
          ),
          bOpen&&!isCircle?Container(
              child: ObjectEditor(targetObject: obj , levelInfo: levelInfo,)
          ) :SizedBox(height: 0,),
        ],
      ),
    );

//    return EditorHolder()..widget = Container(
////        height: levelInfo.lineHeight,
//        width: levelInfo.lineWidth,
//      child:Row(
//        children: [
//
//          Expanded(child: content,),
//          rightSpace,
//        ],
//      )
//    );
    return EditorHolder()..widget = content;
  }


  @override
  Color getCanvasEditBgColor(){
    // var colorContent = Colors.white;// CommonUtil.changeColorLightness(Color(0x7FFFFFFF),0.3);//clz.color);
    // return colorContent;
    return null;
    // return Colors.red;
  }
  @override
  EdgeInsets getCanvasEditPadding(){
    return EdgeInsets.fromLTRB(0,0,0,0);
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }

    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      return EditorHolder()..widget = Container(
        child: Text("请设置引用对象类型"),
      );
    }

    //(levelInfo != null && levelInfo.isCircle);

    var crtObj = ObjectClazz.allObjects[v];
    var obj = crtObj;//clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);

    // var content = ARefObjectView(
    //   key:ValueKey("${obj?.guid??""}"),
    //   object: crtObj,
    //   clazz: clazz,
    //   isPublic: false ,//levelInfo?.fi?.isPublic??true,
    //   isStatic:false ,//levelInfo?.fi?.isStatic??false,
    //   fieldInfo :levelInfo?.fi,
    //   editMode: false ,//OTDefines.editMode,
    //   onSubmitted: (v) async{
    //     if (!DartCommon.isEmpty(v)) {
    //       onSubmitted?.call(v);
    //     }
    //     else{
    //       onSubmitted?.call("");
    //     }
    //   },
    // );
    var content = AObjectSelector(
      clz: clazz,
      borderColor: Colors.black,
      currentObjectGuid: obj==null?"":obj.guid ,// padding: EdgeInsets.fromLTRB(1,0 ,1,0),
      nodeRef: true,
      spaceRange: true,
      withCreateButton: false,
      forceRefable: true,
      withEditButton:false,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      onChanged: (v) async {
        if (!DartCommon.isEmpty(v)) {
          onSubmitted?.call(v);
        }
        else{
          onSubmitted?.call("");
        }
      },
    );
    // var rt = clazz.getObjectRect();
    return EditorHolder()..widget = content..height = SSDefines.nodeFieldRowHeight;//..height = rt.height;
  }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    // return EditorHolder()..widget = Container() ..height = SSDefines.nodeFieldRowHeight;
    String v = "";
    if (initValue is String ){
      v = initValue;
    }

    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      return EditorHolder()..widget = Container(
        child: Text("请设置引用对象类型"),
      );
    }

    //(levelInfo != null && levelInfo.isCircle);

    var crtObj = ObjectClazz.allObjects[v];
    var obj = crtObj;//clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);

    var content = ARefObjectView(
      // key:ValueKey("${obj?.guid??""}"),
      object: crtObj,
      clazz: clazz,
      isPublic:gci?.fieldInfo?.isPublic??true,
      isStatic:gci?.fieldInfo?.isStatic??false,
      fieldInfo :gci?.fieldInfo,
      editMode: OTDefines.editMode,
      onSubmitted: (v) async{
        if (!DartCommon.isEmpty(v)) {
          onSubmitted?.call(v);
        }
        else{
          onSubmitted?.call("");
        }
      },
    );
    // var rt = clazz.getObjectRect();
    return EditorHolder()..widget = content;//..height = rt.height;
  }

  @override
  double getListItemHeight({GridCellInfo gci}) {
    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      return 32 ;
    }
    // bool isStatic = gci?.fieldInfo?.isStatic??false;
    bool isPublic = gci?.fieldInfo?.isPublic??true;
    if (!isPublic){
      return 32;
    }
    var rt = clazz.getObjectRect();
    return rt.height ;
  }


  @override
  Widget getValueLabelWidget(initValue, {TextStyle style}){
    if(initValue == null || initValue == ""){
      initValue = "空";
      return Text(initValue , maxLines: 1, style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
    }
    var id = parseValue(initValue).toString();
//    print(ObjectClazz.allObjects);
//    print(id);

    var obj = ObjectClazz.allObjects[id];
    return Text(obj.getShowName() , maxLines: 1, style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
  }
  @override
  String parseValue(value){
    String v = "";
    if (value is String){
      v = value;
    }
    return v;
  }
  @override
  dynamic createObject({dynamic para}){
    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      // return EditorHolder()..widget = Container(
      //   child: Text("请设置引用对象类型"),
      // );
      return;
    }
    if (clazz.refable) return null;

    var aObj = clazz.table.addObject();
    aObj.rebuildTag();
    if (para == "comment") aObj.isComment = true;
    return aObj.guid;
  }
  @override
  void deleteObject(dynamic val , {dynamic para}){
    var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    if (clazz == null){
      return;
    }
    if (clazz.refable) return;
    var obj = ObjectClazz.allObjects[val];
    if (obj != null){
      obj.getClazz().table.deleteObject(obj);
    }
  }

  @override
  dynamic getTagValue(dynamic v) {
    var guid = parseValue(v);
    if (guid == null) return "[x]";
    var obj = ObjectClazz.allObjects[guid];
    if (obj == null) return guid;
    obj.rebuildTag();
    return obj.getTag();
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    var guid = parseValue(v);

    var obj = ObjectClazz.allObjects[guid];
    bw.writeString(obj?.getExportSearchID()??"" , exportFlag);
  }

  @override
  String getFilterString(v) {
    if(v == null || v == ""){
      return "";
    }
    var id = parseValue(v).toString();
    var obj = ObjectClazz.allObjects[id];
    return "${obj.name}`${obj.alias}";
  }

  @override
  dynamic exportValue(v) {
    var guid = parseValue(v);
    var obj = ObjectClazz.allObjects[guid];
    // obj.getUniqueIDByField(field)
    return obj?.getExportSearchID()??"" ;
  }
  @override
  bool useComment() {
    return true;
  }

  @override
  clone(){
    var t = FTStringSpaceObjectReference();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }
}