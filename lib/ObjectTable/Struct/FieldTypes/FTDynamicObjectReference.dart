//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/object_detail_view.dart';
import 'package:battlepus/ObjectTable/object_editor.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class FTDynamicObjectReference extends SSFieldType{


  static Widget getClazzShowWidget({ObjectClazz clazz}){

    var con = Wrap(
      children: [
        Icon(MaterialCommunityIcons.alpha_z_box_outline , color: Colors.green,),
        SizedBox(width: 4,),
        Text(clazz.getTypeShowString() , style : ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,),
        // Expanded(child:Text("clazz.getTypeShowString()" , overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );

    return con;
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){

    if (true){//fieldType == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.link_box_outline , color: Colors.red,),
          SizedBox(width: 4,),
          Expanded(child:Text(getTypeShowString() , style : ThemeCenter.mainTextStyle(step:9,fontSize: 12),overflow: TextOverflow.clip,maxLines: 1,)),
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
        child: Text(i.getShowName() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 14, fontWeight: FontWeight.w600 , color: Colors.lightBlueAccent)),
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
  static Map<String,ObjectClazz> searchKey2Clazz ;
  static List<DropdownMenuItem<String>> getClazzs(){
    var allClzzes = ObjectClazz.clazzes.values.toList();
    searchKey2Clazz = Map<String,ObjectClazz>();
    List<DropdownMenuItem<String>> items = new  List<DropdownMenuItem<String>>();
    for(var i in allClzzes){
      var key = i.getSearchKey();
      searchKey2Clazz[key] = i;

      var item = DropdownMenuItem<String>(
        value: key,
        child: Text(i.getShowName() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 14, fontWeight: FontWeight.w600 , color: Colors.lightBlueAccent)),
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


  Widget getSearchClazz(ObjectClazz crtClz , onSubmitted , context,{double size}){


    var scripts = ObjectClazz.clazzes.values.toList();//.where((element) => false == element.isModule).toList();
    ATreeNode<ObjectClazz> _compRoot = DartCommon.buildTree<ObjectClazz>(scripts, (item){
      return <String>[];
    });

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ObjectClazz>).data;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<ObjectClazz>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<ObjectClazz>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = crtClz == si;//(_selectedStrings[si.guid] != null);

          var txt = Text(si.getTypeShowString(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : ThemeCenter.systemTheme.scaffoldBackgroundColor,
              // padding: EdgeInsets.fromLTRB(8,0,8,0),
              // height: 32,
              // color: CommonUtil.scaleColor(Colors.grey, 0.15),
              // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color:  ThemeCenter.activeTheme.areaBorderColor),
                      )
                  ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      SizedBox(width : 8),
                      Icon(EvilIcons.sc_instagram , color: Colors.greenAccent),
                      SizedBox(width : 8),
                      highlightPattern == null?Expanded(child : txt):
                      Expanded(child : ParsedText(
                        text: si.getTypeShowString(),
                        style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12),
                        parse: <MatchText>[
                          MatchText(
                            pattern: highlightPattern, // a custom pattern to match
                            regexOptions: RegexOptions(
                                multiLine : true,
                                caseSensitive : false,
                                unicode : true,
                                dotAll : true
                            ),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ), // custom style to be applied to this matched text
                          )
                        ],
                      )),

                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
          // var te = Draggable(
          //   child: con,
          //   feedback: Material(child:con),
          //   childWhenDragging: con,
          //   data: si,
          // );

          return con;
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
          var con = Container(
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 36,
            //CommonUtil.alphaColor(nd.isExpand ? Colors.green : Colors.grey , 50),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                !expanded ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,color: Colors.blueAccent,),
                SizedBox(width: 8,),
                Expanded(child : txt),
              ],
            ),
          );
          // return txt;
          return Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
        }
      },
      onGetChildren: (node){
        return (node as ATreeNode<ObjectClazz>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<ObjectClazz>;
        if (ns != null) {

          if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.alias}";
          // if (ns.isLeaf) return n.//return "${n.name}`${n.defaultValue}";
          // return "${ns.id}";
        }
        return "";
      },

      onSortLeaf: (a,b){
        return (a as ATreeNode<ObjectClazz>).data.name.compareTo((b as ATreeNode<ObjectClazz>).data.name);
      },

      onItemTap: (item){
        var a = item as ATreeNode<ObjectClazz>;
        if (a != null && a.data != null) {
          onSubmitted?.call(a.data);
          Navigator.pop(context, a.data);
        }
      },

      actions: [
        SSDefines.IBC(child :IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.close_box_outline , color: Colors.redAccent,),
          iconSize: SSDefines.iconButtonSize,
          onPressed: (){
            Navigator.pop(context);
          },
          tooltip: "关闭",
        ))

      ],
    );

    var btn = SSDefines.IBC(
      width: size , height : size,
      child :IconButton(
      padding: EdgeInsets.all(0),
      icon : Icon(MaterialCommunityIcons.plus_box_outline),
      iconSize: size??SSDefines.iconButtonSize,
      onPressed: (){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            var child = ThemeCenter.area(width:800 ,height:600, child: con);
            return Dialog(child: child);
          },
        );
      },
      tooltip: "创建对象",
    ));

    return btn;


    // // var allClzzes = ObjectClazz.clazzes.values.toList();
    // var res = SearchableDropdown.single(
    //   selectedValueWidgetFn:(v){
    //     var obj = searchKey2Clazz[v];
    //     if (obj == null){
    //       return Text("空",style : TextStyle(fontSize: 10 , fontWeight: FontWeight.w600 , color: Colors.red));
    //     }
    //     else{
    //       return Text(obj.getShowName() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 10, fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
    //     }
    //   },
    //   underline:SizedBox(height: 0,),
    //   // iconSize: 16,
    //   icon : null,
    //   iconSize: SSDefines.iconButtonSize,
    //   items: getClazzs(),
    //   style: SSDefines.lineContentStyle,// TextStyle(fontSize: 11),
    //   value: crtObj==null?"":crtObj.getSearchKey(),
    //   hint: "选择类型",
    //   searchHint: "选择类型",
    //   onChanged: (v) async {
    //     var newValue = searchKey2Clazz[v];
    //     if (newValue != null) {
    //       onSubmitted?.call(newValue);
    //     }
    //     else{
    //       onSubmitted?.call(null);
    //     }
    //   },
    //   closeButton: "关闭",
    //   isExpanded: true,
    // );
    //
    // return res;
  }

  Widget getSearchObjects(Widget crtObjWdg , AObject crtObj, ObjectClazz crtClz , onSelectObject, context,{double size , dynamic onClear}){

    var scripts = ObjectClazz.allObjects.values.toList();//.where((element) => false == element.isModule).toList();
    ATreeNode<AObject> _compRoot = DartCommon.buildTree<AObject>(scripts, (item){
      // return const <String>[];
      var clzGuid = (item as AObject).clazzGuid;
      var crtObj = ObjectClazz.getClazz(clzGuid);
      if (crtObj != null){
        return <String>[crtObj.getTypeShowString()];
      }

      return <String>[];
    });

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<AObject>).data;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<AObject>;
        if (agent.isLeaf) {
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = (agent as ATreeNode<AObject>).data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();
          bool selected = crtObj == si;//(_selectedStrings[si.guid] != null);

          var txt = Text(si.getTypeShowString(), style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : ThemeCenter.systemTheme.scaffoldBackgroundColor,
              // padding: EdgeInsets.fromLTRB(8,0,8,0),
              // height: 32,
              // color: CommonUtil.scaleColor(Colors.grey, 0.15),
              // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color:  ThemeCenter.activeTheme.areaBorderColor),
                      )
                  ),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      SizedBox(width : 8),
                      Icon(EvilIcons.sc_instagram , color: Colors.greenAccent),
                      SizedBox(width : 8),
                      highlightPattern == null?Expanded(child : txt):
                      Expanded(child : ParsedText(
                        text: si.getTypeShowString(),
                        style: ThemeCenter.mainTextStyle(step: 9 ,fontSize: 12),
                        parse: <MatchText>[
                          MatchText(
                            pattern: highlightPattern, // a custom pattern to match
                            regexOptions: RegexOptions(
                                multiLine : true,
                                caseSensitive : false,
                                unicode : true,
                                dotAll : true
                            ),
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ), // custom style to be applied to this matched text
                          )
                        ],
                      )),

                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
          // var te = Draggable(
          //   child: con,
          //   feedback: Material(child:con),
          //   childWhenDragging: con,
          //   data: si,
          // );

          return con;
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
          var con = Container(
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 36,
            //CommonUtil.alphaColor(nd.isExpand ? Colors.green : Colors.grey , 50),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                !expanded ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,color: Colors.blueAccent,),
                SizedBox(width: 8,),
                Expanded(child : txt),
              ],
            ),
          );
          // return txt;
          return Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
        }
      },
      onGetChildren: (node){
        return (node as ATreeNode<AObject>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<AObject>;
        if (ns != null) {

          if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.alias}";
          // if (ns.isLeaf) return n.//return "${n.name}`${n.defaultValue}";
          // return "${ns.id}";
        }
        return "";
      },

      onSortLeaf: (a,b){
        return (a as ATreeNode<AObject>).data.name.compareTo((b as ATreeNode<AObject>).data.name);
      },

      onItemTap: (item){
        var a = item as ATreeNode<AObject>;
        if (a != null && a.data != null) {
          onSelectObject?.call(a.data);
          Navigator.pop(context, a.data);
        }
      },

      actions: [
        SSDefines.IBC(child :IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.close_box_outline , color: Colors.redAccent,),
          iconSize: SSDefines.iconButtonSize,
          onPressed: (){
            Navigator.pop(context);
          },
          tooltip: "关闭",
        ))

      ],
    );
    var clr = SSDefines.IBC(width:size , height : size ,child :IconButton(
      padding: EdgeInsets.all(0),
      icon : Icon(MaterialCommunityIcons.close ,color: Colors.redAccent,),
      iconSize: size??SSDefines.iconButtonSize,
      onPressed: (){
        onClear?.call();
      },
      tooltip: "清空",
    ));
    var btn = SSDefines.IBC(width:size , height : size ,child :IconButton(
      padding: EdgeInsets.all(0),
      icon : Icon(MaterialCommunityIcons.menu),
      iconSize: size??SSDefines.iconButtonSize,
      onPressed: (){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            var child = ThemeCenter.area(width:800 ,height:600, child: con);
            return Dialog(child: child);
          },
        );
      },
      tooltip: "选择对象",
    ));

    return Row(
      children: [
        Expanded(child:crtObjWdg),
        if (crtObj!= null) clr,
        btn
      ],
    );
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {

    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    var crtObj = ObjectClazz.allObjects[v];
    var clzGuid = crtObj?.clazzGuid;
    var clazz = clzGuid != null?ObjectClazz.getClazz(clzGuid):null;

    bool isCircle = false;//crtObj != null && levelInfo.circleStack.containsKey(crtObj.guid);
    // var res = SearchableDropdown.single(
    //   selectedValueWidgetFn:(v){
    //     var obj = clazz.searchKey2Object[v];
    //     if (obj == null){
    //       return Text("空",style : TextStyle(fontSize: 10 , fontWeight: FontWeight.w600 , color: Colors.red));
    //     }
    //     else{
    //       return Text(obj.getShowName() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 10, fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
    //     }
    //   },
    //   underline:SizedBox(height: 0,),
    //   // iconSize: 16,
    //   icon : null,
    //   iconSize: SSDefines.iconButtonSize,
    //   items: getItems(clazz),
    //   style: SSDefines.lineContentStyle,// TextStyle(fontSize: 11),
    //   value: crtObj==null?"":crtObj.getSearchKey(),
    //   hint: "选择对象",
    //   searchHint: "选择对象",
    //   onChanged: (v) async {
    //     var newValue = clazz.searchKey2Object[v];
    //     if (newValue != null) {
    //       onSubmitted?.call("${clazz.guid}|${newValue.guid}");
    //     }
    //     else{
    //       onSubmitted?.call("");
    //     }
    //   },
    //   closeButton: "关闭",
    //   isExpanded: true,
    // );
    Widget showWdg ;
    if (crtObj == null){
      showWdg = Text("空",style : TextStyle(fontSize: 10 , fontWeight: FontWeight.w600 , color: Colors.red));
    }
    else{
      showWdg = Text(crtObj.getShowName() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 10, fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
    }
    var res = getSearchObjects(showWdg ,crtObj, clazz , (obj){
      var newValue = obj;
      if (newValue != null) {
        onSubmitted?.call(newValue.guid);
      }
      else{
        onSubmitted?.call("");
      }
    } , context , onClear: (){ onSubmitted?.call(""); });


    // var obj = clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);

    // levelInfo.level ++;
//    if (bOpen)levelInfo.level++;
//     var dcl = SizedBox(width: 4,);
//     var rightSpace = SizedBox(width:0);// levelInfo.spaceStep * levelInfo.deltaLevel,);
//    double _objectFullWidth = 640;
//    double _hearWidth = 160;
    var dc = new BoxDecoration(
      border: Border(
//        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
//          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
        bottom: Divider.createBorderSide(context, color: CommonUtil.scaleColor(Colors.grey , 0.6), width: 1.9),
//         left: BorderSide(width: 2,color: Colors.indigo),
//         right: BorderSide(width: 2,color: Colors.indigo),
      ),
//        color: Colors.indigo, // 底色
    ); // 圆角度
    var contextStore = context;
    var content = Container(

//      width : _objectFullWidth + (levelInfo.level) * (_hearWidth + 4),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: dc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: baseHeight,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // color: CommonUtil.alphaColor(Colors.brown, 69),
            child:Row(
//              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // SSDefines.IBC(child:Icon(EvilIcons.sc_instagram , color: Color(clazz.color) ,size: SSDefines.iconButtonSize,),),
                // Icon(EvilIcons.sc_instagram , color: Color(clazz.color) ,size: SSDefines.iconButtonSize,),
                isCircle?Text("!!! 循环引用 !!!" , maxLines: 1, style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.redAccent)):SizedBox(width: 0,),
                // Expanded(child : showInfo??getValueLabelWidget(obj==null?null:obj.guid)),
                SizedBox(width: 4,),
                Expanded(child:res),
                // Container(
                //   width: 30,
                //   child: res,
                // ),

                getSearchClazz(clazz , (clazz){
                  if (clazz != null){
                    var aObj = clazz.table.addObject();
                    onSubmitted?.call(aObj.guid);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  }
                },context),
                // SSDefines.IBC(child :IconButton(
                //   padding: EdgeInsets.all(0),
                //   icon : Icon(MaterialCommunityIcons.plus_box_outline),
                //   iconSize: SSDefines.iconButtonSize,
                //   onPressed: (){
                //     var aObj = clazz.table.addObject();
                //
                //     onSubmitted?.call(aObj.guid);
                //
                //     EventCenter.eventBus.fire(GlobalRefreshEvent());
                //   },
                //   tooltip: "新建",
                // )),

                crtObj != null ?SSDefines.IBC(child :IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: SSDefines.iconButtonSize,
                  icon : Icon(MaterialCommunityIcons.square_edit_outline),
                  onPressed: (){
                    // print(contextStore);
                    OTGlobalBoard.appendFocusItem(crtObj);
                    EventCenter.eventBus.fire(InspectorRefreshEvent()..object = crtObj);
                    showDialog(
                      context: contextStore,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        var child = ObjectDetailView(focusItem: crtObj , allItemCloseThenPop: true, objectTableViewEntry: true,);
                        return Dialog(child: child);
                      },
                    ).then((value){
                      EventCenter.eventBus.fire(GlobalRefreshEvent());
                    });
                  },
                  tooltip: "编辑",
                )):SizedBox(width: 0,),

                // obj != null && !isCircle && onVisible!= null?IconButton(
                //   padding: EdgeInsets.all(0),
                //   icon:Icon(bOpen?MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.square_edit_outline , color: bOpen?Colors.redAccent : Colors.indigoAccent),
                //   tooltip: "关闭",
                //   onPressed: (){
                //     onVisible?.call(!bOpen);
                //   },
                // ):SizedBox(width: 0,),
              ],
            ),
          ),
          // bOpen&&!isCircle?Container(
          //     child: ObjectEditor(targetObject: obj , levelInfo: levelInfo,)
          // ) :SizedBox(height: 0,),
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
    return EditorHolder()..widget = content .. height = baseHeight;

  }
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    // var split = v.split("|");
    // if (split.length>=2){
    //   innerTypeGuid0 = split[0];
    // }
    // var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    // if (clazz == null){
    //   return EditorHolder()..widget = Container(
    //     child: Text("请选择或创建对象"),
    //   );
    // }
    var crtObj = ObjectClazz.allObjects[v];
    var clzGuid = crtObj?.clazzGuid;
    var clazz = clzGuid != null?ObjectClazz.getClazz(clzGuid):null;
    //(levelInfo != null && levelInfo.isCircle);

    // var crtObj = ObjectClazz.allObjects[v];
    // print(levelInfo.circleStack);
    bool isCircle = crtObj != null && levelInfo.circleStack.containsKey(crtObj.guid);
    // var res = SearchableDropdown.single(
    //   underline:SizedBox(height: 0,),
    //   items: getItems(clazz),
    //   value: crtObj==null?"":crtObj.getSearchKey(),
    //   hint: "选择对象",
    //   searchHint: "选择对象",
    //   onChanged: (v) async {
    //     var newValue = clazz.searchKey2Object[v];
    //     if (newValue != null) {
    //       onSubmitted?.call("${clazz.guid}|${newValue.guid}");
    //     }
    //     else{
    //       onSubmitted?.call("");
    //     }
    //   },
    //   closeButton: "关闭",
    //   isExpanded: true,
    // );

    Widget showWdg ;
    if (crtObj == null){
      showWdg = Text("空",style : TextStyle(fontSize: 14 , fontWeight: FontWeight.w600 , color: Colors.red));
    }
    else{
      showWdg = Text(crtObj.getTypeShowString() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 14, fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
    }
    var res = getSearchObjects(showWdg ,crtObj, clazz , (obj){
      var newValue = obj;
      if (newValue != null) {
        onSubmitted?.call(newValue.guid);
      }
      else{
        onSubmitted?.call("");
      }
    } , context,size: 24,onClear: (){ onSubmitted?.call("");});

//    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == initValue , orElse:()=>null);
//     var obj = clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);

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


                if (clazz != null) Icon(EvilIcons.sc_instagram , color: Color(clazz.color)),
                isCircle?Text("!!! 循环引用 !!!" , maxLines: 1, style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.redAccent)):SizedBox(width: 0,),
                // Expanded(child : showInfo??getValueLabelWidget(obj==null?null:obj.guid)),
                SizedBox(width: 4,),
                Expanded(child:res),
                // Container(
                //   width: 30,
                //   child: res,
                // ),

                getSearchClazz(clazz , (clazz){
                  if (clazz != null){
                    var aObj = clazz.table.addObject();
                    onSubmitted?.call(aObj.guid);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  }
                },context,size: 24),

                // IconButton(
                //   padding: EdgeInsets.all(0),
                //   icon : Icon(MaterialCommunityIcons.plus_box_outline),
                //   onPressed: (){
                //     var aObj = clazz.table.addObject();
                //
                //     onSubmitted?.call(aObj.guid);
                //
                //     EventCenter.eventBus.fire(GlobalRefreshEvent());
                //   },
                //   tooltip: "新建",
                // ),
                crtObj != null ?IconButton(
                  padding: EdgeInsets.all(0),
                  icon : Icon(MaterialCommunityIcons.tab_plus),
                  onPressed: (){
                    OTGlobalBoard.appendFocusItem(crtObj);
                    EventCenter.eventBus.fire(InspectorRefreshEvent()..object = crtObj);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  },
                  tooltip: "新标签页打开",
                ):SizedBox(width: 0,),

                crtObj != null && !isCircle && onVisible!= null?IconButton(
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
              child: ObjectEditor(targetObject: crtObj , levelInfo: levelInfo,)
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
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    // var split = v.split("|");
    //     // if (split.length>=2){
    //     //   innerTypeGuid0 = split[0];
    //     // }
    //     // var clazz = ObjectClazz.getClazz(innerTypeGuid0);
    //     // if (clazz == null){
    //     //   return EditorHolder()..widget = Container(
    //     //     child: Text("请选择或创建对象"),
    //     //   );
    //     // }

    var crtObj = ObjectClazz.allObjects[v];
    var clzGuid = crtObj?.clazzGuid;
    var clazz = clzGuid != null?ObjectClazz.getClazz(clzGuid):null;
    //(levelInfo != null && levelInfo.isCircle);

    // var crtObj = ObjectClazz.allObjects[v];
    // bool isCircle = crtObj != null && levelInfo.circleStack.containsKey(crtObj.guid);
    // var res = SearchableDropdown.single(
    //   underline:SizedBox(height: 0,),
    //   items: getItems(clazz),
    //   value: crtObj==null?"":crtObj.getSearchKey(),
    //   hint: "选择对象",
    //   searchHint: "选择对象",
    //   onChanged: (v) async {
    //     var newValue = clazz.searchKey2Object[v];
    //     if (newValue != null) {
    //       onSubmitted?.call("${clazz.guid}|${newValue.guid}");
    //     }
    //     else{
    //       onSubmitted?.call("");
    //     }
    //   },
    //   closeButton: "关闭",
    //   isExpanded: true,
    // );
    Widget showWdg ;
    if (crtObj == null){
      showWdg = Text("空",style : TextStyle(fontSize: 14 , fontWeight: FontWeight.w600 , color: Colors.red));
    }
    else{
      showWdg = Text(crtObj.getShowName() , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle(fontSize: 14, fontWeight: FontWeight.w600 , color: Colors.indigoAccent));
    }
    var res = getSearchObjects(showWdg ,crtObj, clazz , (obj){
      var newValue = obj;
      if (newValue != null) {
        onSubmitted?.call(newValue.guid);
      }
      else{
        onSubmitted?.call("");
      }
    } , context ,size: 24,onClear: (){ onSubmitted?.call("");});
    // var obj = clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);

//     var rightSpace = SizedBox(width:0);// levelInfo.spaceStep * levelInfo.deltaLevel,);
// //    double _objectFullWidth = 640;
// //    double _hearWidth = 160;
//     var dc = new BoxDecoration(
//       border: Border(
// //        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
// //          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
// //          bottom: Divider.createBorderSide(context, color: Colors.indigo, width: 2),
//         left: BorderSide(width: 2,color: Colors.indigo),
//         right: BorderSide(width: 2,color: Colors.indigo),
//       ),
// //        color: Colors.indigo, // 底色
//     ); // 圆角度

//     var dc2 = new BoxDecoration(
//       color: CommonUtil.alphaColor(Colors.brown, 40),
//       border: Border(
// //        top: Divider.createBorderSide(context, color: bgColor, width: 0.5),
// //          right: Divider.createBorderSide(context, color: Colors.black38, width: 0.5),
//         bottom: Divider.createBorderSide(context, color: CommonUtil.scaleColor(Colors.grey , 0.6), width: 1.9),
// //         left: BorderSide(width: 2,color: Colors.indigo),
// //         right: BorderSide(width: 2,color: Colors.indigo),
//       ),
// //        color: Colors.indigo, // 底色
//     ); // 圆角度
    var content = Container(
      // height: levelInfo.lineHeight,
//      width : _objectFullWidth + (levelInfo.level) * (_hearWidth + 4),
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
      // decoration: dc,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            // height: levelInfo.lineHeight,
            // width: levelInfo.lineWidth - 2 + ((bOpen&&!isCircle)?levelInfo.spaceStep+2:0.0),
//
            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            // color: CommonUtil.alphaColor(Colors.brown, 69),
            // decoration: dc2,
            child:Row(
//              mainAxisAlignment: MainAxisAlignment.end,
              children: [


                if (clazz!= null)Icon(EvilIcons.sc_instagram , color: Color(clazz.color)),
                // isCircle?Text("!!! 循环引用 !!!" , maxLines: 1, style : TextStyle(fontWeight: FontWeight.w600 , color: Colors.redAccent)):SizedBox(width: 0,),
                // Expanded(child : showInfo??getValueLabelWidget(obj==null?null:obj.guid)),
                SizedBox(width: 4,),
                Expanded(child:res),
                // Container(
                //   width: 30,
                //   child: res,
                // ),

                getSearchClazz(clazz , (clazz){
                  if (clazz != null){
                    var aObj = clazz.table.addObject();
                    onSubmitted?.call(aObj.guid);
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  }
                },context,size:24),

                // ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline,
                //   width: 24,height :24,
                //   onPressed: (){
                //     var aObj = clazz.table.addObject();
                //     onSubmitted?.call(aObj.guid);
                //     EventCenter.eventBus.fire(GlobalRefreshEvent());
                //   },
                //   tooltip: "新建",
                // ),
                // obj != null ?IconButton(
                //   padding: EdgeInsets.all(0),
                //   icon : Icon(MaterialCommunityIcons.tab_plus),
                //   onPressed: (){
                //     OTGlobalBoard.appendFocusItem(obj);
                //     EventCenter.eventBus.fire(InspectorRefreshEvent()..object = obj);
                //     EventCenter.eventBus.fire(GlobalRefreshEvent());
                //   },
                //   tooltip: "新标签页打开",
                // ):SizedBox(width: 0,),

                if (crtObj != null)ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline,
                  width: 24,
                  height: 24,
                  tooltip: "编辑",
                  onPressed: (){
                    // onVisible?.call(!bOpen);
                    var con = ThemeCenter.block(headTitle: "编辑对象",width: 1024,
                        child:ObjectEditor(
                          targetObject: crtObj , levelInfo: null,
                        ) ,
                        actions: [
                          ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
                              width: 24,height:24,
                              tooltip: "关闭",
                              onPressed: (){
                                Navigator.pop(context);
                              }
                          ),
                        ]
                    );
                    showDialog(
                      context: context,
                      // barrierDismissible: false,
                      builder: (BuildContext context) {
                        // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
                        return Dialog(child: con);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // bOpen&&!isCircle?Container(
          //     child: ObjectEditor(targetObject: obj , levelInfo: levelInfo,)
          // ) :SizedBox(height: 0,),
        ],
      ),
    );

    return EditorHolder()..widget = content;
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
  void export(ByteDataWriter bw, v, {Map prms}) {
    var guid = parseValue(v);
    bw.writeInt32(guid.hashCode , exportFlag);
  }

  @override
  dynamic exportValue(v) {
    var guid = parseValue(v);
    return guid.hashCode;
  }

  @override
  clone(){
    var t = FTDynamicObjectReference();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }
}