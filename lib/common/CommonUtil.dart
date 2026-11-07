//@dart=2.11

import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/PopupTreeMenu/popup_tree_menu.dart';
import 'package:battlepus/common/progress_dialog.dart';
import 'package:battlepus/common/searchable_dropdown_ex.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:sprintf/sprintf.dart';
// import 'package:crclib/crclib.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:xml/xml.dart';

typedef SelectDateTimeCallback = void Function(DateTime value);

class CommonUtil{

  static Color changeColorHue(Color color , newHueValue) => HSLColor.fromColor(color).withHue(newHueValue).toColor();
  static Color changeColorSaturation(Color color, newSaturationValue) => HSLColor.fromColor(color).withSaturation(newSaturationValue).toColor();
  static Color changeColorLightness(Color color, newLightnessValue) => HSLColor.fromColor(color).withLightness(newLightnessValue).toColor();

  static Color alphaColor(Color baseColor , int alpha){
    // return baseColor;
    return Color.fromARGB(alpha, baseColor.red, baseColor.green, baseColor.blue);
  }

  static Color alphaColorD(Color baseColor , double alpha){
    return Color.fromARGB( (255 * alpha).floor() , baseColor.red, baseColor.green, baseColor.blue);
    // return baseColor;
  }
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static getGlobalContex(){
    // if (navigatorKey?.currentState == null){
    //   return null;
    // }
    BuildContext context = navigatorKey.currentState.overlay.context;
    return context;
  }


  static Color scaleColor(Color baseColor ,double scale ){
    return Color.fromARGB(baseColor.alpha, (baseColor.red * scale + 0xFF *(1-scale)).toInt(), (baseColor.green * scale+ 0xFF *(1-scale)).toInt(), (baseColor.blue * scale+ 0xFF *(1-scale)).toInt());
    // return baseColor;
  }


  static List<String> getFiles(String dir , String ext , {bool onlyName = false}){
    var d = Directory(dir);
    if (!d.existsSync()) return List<String>();
    var fs = d.listSync();
    var res = List<String>();
    for(var f in fs){
      if (f is File){
        if (onlyName)res.add(PathUtil.basename(f.path));
        else res.add(f.path);
      }
    }

    return res;
  }

  static List<String> getDirs(String dir , {bool onlyName = false}){
    var d = Directory(dir);
    if (!d.existsSync()) return List<String>();
    var fs = d.listSync();
    var res = List<String>();
    for(var f in fs){
      if (f is Directory){
        if (onlyName)res.add(PathUtil.basename(f.path));
        else res.add(f.path);
      }
    }
    return res;
  }

  static void showLoading(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var child = Container(
          padding: EdgeInsets.all(8),
          width: 100,
          height: 200,
          child: Center(child: Container(width : 80 , height : 80 , child : CircularProgressIndicator())),
        );
        return Dialog(child: child);
      },
    );
  }

  static void popupTreeMenu<T>(List<T> datas, BuildContext context,{String title , dynamic onBuildItem , dynamic onBuildGroup , dynamic onResult , double width , double height , List<Widget> actions}){
    var con = PopupTreeMenu(
      key:UniqueKey(),
      title: title,
      datas:datas,
      onBuidItem: onBuildItem,
      onBuidGroup: onBuildGroup,
      actions: actions,
    );
    showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        var child = Container(
          padding: EdgeInsets.all(8),
          width: width??400,
          height: height??600,
          child: con,
        );
        return ThemeConsumer(child : Dialog(child: child));
      },
    ).then((value){
      onResult?.call(value);
    });
  }

  static Future<void> confirm(BuildContext context , String hint, {VoidCallback onOk , VoidCallback onCancel,String ok = "确定" , String cancel = "取消"}) async {
    // BotToast.showAnimationWidget(toastBuilder: null, animationDuration: null)
    BotToast.showWidget(toastBuilder: (CancelFunc cancelFunc){
      var alt = AlertDialog(
        title: new Text(hint, style: new TextStyle(fontSize: 17.0)),
        actions: <Widget>[

          if (onOk!= null )new TextButton(
            autofocus: true,
            child: new Text(ok),
            onPressed: (){
//                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new SecondPage()));
              cancelFunc?.call();
              onOk?.call();
            },
          ),
          new TextButton(

            child: new Text(cancel),
            onPressed: (){
              // Navigator.of(context).pop();
              cancelFunc?.call();
              onCancel?.call();

            },
          ),
        ],
      );

      return Container(
        width: 100000,
        height: 100000,
        color: alphaColorD(Colors.black,0.8),
        child: Center(child :alt),
      );
    });

//     return showDialog<Null>(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return new AlertDialog(
//             title: new Text(hint, style: new TextStyle(fontSize: 17.0)),
//             actions: <Widget>[
//               new FlatButton(
//
//                 child: new Text(cancel),
//                 onPressed: (){
//                   Navigator.of(context).pop();
//                   onCancel?.call();
//                 },
//               ),
//               new FlatButton(
//                 autofocus: true,
//                 child: new Text(ok),
//                 onPressed: (){
// //                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new SecondPage()));
//                   Navigator.of(context).pop();
//                   onOk?.call();
//                 },
//               )
//             ],
//           );
//         }
//     );
  }
  static Future<void> confirm2(BuildContext context , String hint, {VoidCallback onResult1 , VoidCallback onResult2,VoidCallback onResult3,String btn1 = "保存" , String btn2= "不保存" , String btn3 = "取消" }) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(hint, style: new TextStyle(fontSize: 17.0)),
            actions: <Widget>[
              new TextButton(

                child: new Text(btn1),
                onPressed: (){
                  Navigator.of(context).pop();
                  onResult1?.call();
                },
              ),
              new TextButton(
                //
                child: new Text(btn2),
                onPressed: (){
                  Navigator.of(context).pop();
                  onResult2?.call();
                },
              ),
              new TextButton(
                autofocus: true,
                child: new Text(btn3),
                onPressed: (){
                  Navigator.of(context).pop();
                  onResult3?.call();
                },
              ),
            ],
          );
        }
    );
  }
  static Widget selectDate(BuildContext context , DateTime initTime , String hintText , SelectDateTimeCallback cb ){
    //var text = "${initTime.year}-${initTime.month}-${initTime.day}";
    var text = sprintf("%d-%02d-%02d",[initTime.year , initTime.month, initTime.day]);
    var r = Row(
      mainAxisAlignment: MainAxisAlignment.end,
        children: [

      Text(hintText),
      SizedBox(width: 16,),
      Expanded(
          child: TextEditor(
            initValue: text,
            enabled: false,
          )),
      IconButton(
            padding: EdgeInsets.all(0),
        onPressed: () {
          _selectData(context , initTime , cb);
        },
        color: Colors.black,
        iconSize: 32,
        icon: Icon(MaterialCommunityIcons.calendar_week),

      ), // This trailing comma makes auto-formatting nicer for build methods.
    ]);

    return Container(
//      color: Colors.lightGreen,
      child: r,
    );
  }

  static Future<void> _selectData(BuildContext context , DateTime _date, SelectDateTimeCallback cb) async {
    final DateTime picked = await showDatePicker(
        context: context,
//        locale : Locale.fromSubtags(
//            languageCode:"de"
//        ),

        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2100, 8));
    if (picked != null && picked != _date && cb != null) {
      cb?.call(picked);
    }
  }
//   static Crc32Zlib _crc32Zlib = new Crc32Zlib();
//   static int crc32(String str){
//     return _crc32Zlib.convert(utf8.encode(str));
//   }
//
//   static int crc32File(String path){
//     var f= File(path);
//     if (!f.existsSync()) return 0;
//     var str = f.readAsBytesSync();
//     return _crc32Zlib.convert(str);
//   }
//
//   static String changedTimeStr(String path){
//     var f= File(path);
//     if (!f.existsSync()) return "0";
//     return "${f.statSync().changed.millisecondsSinceEpoch}_${f.lengthSync()}";
// //    var str = f.readAsBytesSync();
// //    return _crc32Zlib.convert(str).toString();
//   }
  static getItemByGuid(List<dynamic> items , String guid){
    var t = items.where((element) => element.guid == guid).toList();
    if (t.length>=1) return t[0];
    return null;
  }

  static String getSearchKey(dynamic data) {
    if (data.name == "" || data.name == null){
      return "${data.guid}";
    }
    var pinyin1 = PinyinHelper.getShortPinyin(data.name);
    var pinyin2 = PinyinHelper.getPinyin(data.name);
    bool aliasExists = data.alias != "" && data.alias != null;
    var pinyin3 = aliasExists?PinyinHelper.getShortPinyin(data.alias):"";
    var pinyin4 = aliasExists?PinyinHelper.getPinyin(data.alias):"";

    return "${pinyin1}_${pinyin2}_${pinyin3}_${pinyin4}_${data.exportId}_${data.name}_${data.alias??""}_${data.guid}";
  }

  static Widget getStringDropdown(String hint , dynamic getShowWidgetCallback , List<dynamic> datas , dynamic current ,dynamic onSubmitted , {Widget menuIcon}){
    var crt ;
    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
    for(var i in datas){
      if (i == current){
        crt = i ;
      }
      var w = getShowWidgetCallback(i);
      var item = PopupMenuItem<String>(
        value: i,
        child: w is Widget?w:Text(w , style :TextStyle(color: Colors.black , fontSize: 13)),
      );
      items.add(item);
    }

    if (crt == null && datas!= null && datas.length>0){
      crt = datas[0];
    }

    var res = PopupMenuButton<String>(

      tooltip: hint,
      padding: EdgeInsets.all(0),
      icon : menuIcon??Icon(MaterialCommunityIcons.menu),
      initialValue:crt,
      onSelected: (String result) {
        // onSubmitted?.call(result);
        onSubmitted?.call(result);
        // EventCenter.eventBus.fire(BlockContainerRefresh());
      },
      itemBuilder: (BuildContext context) => items,
    );

    return res;
  }
  static Widget getStringSearchableDropdown(String hint ,  dynamic getSearchKeyCallback , dynamic getShowWidgetCallback , List<dynamic> datas , dynamic current ,dynamic onSubmitted , {bool expanded = true , double fontSize  , double iconSize ,Function getSelectWidgetCallback , Color color}){
    Map<String , dynamic> searchKey2Object = Map<String , dynamic>();
    Map<String , DropdownMenuItem<String>> searchKey2Item = Map<String , DropdownMenuItem<String>>();
    List<DropdownMenuItem<String>> items = new  List<DropdownMenuItem<String>>();
    for(var i in datas){
      var key = getSearchKeyCallback(i);
      searchKey2Object[key] = i;

      var w = getShowWidgetCallback(i);
      var wdg = w is Widget?w:Text(getShowWidgetCallback(i) , overflow: TextOverflow.clip,maxLines: 1,style : TextStyle( fontSize: fontSize??14, fontWeight: FontWeight.w600 , color: current == i ? Colors.indigoAccent : Colors.black ));

      var item = DropdownMenuItem<String>(
        value: key,
        child: wdg,
      );
      searchKey2Item[key] = item;

      items.add(item);
    }

    var itemNone = DropdownMenuItem<String>(
      value: "",
      child: Text("空",style : TextStyle(fontSize: fontSize??14,fontWeight: FontWeight.w600 , color: Colors.red)),
    );
    items.add(itemNone);

    var res = SearchableDropdown.single(
      // menuBackgroundColor:Colors.,
      icon: Icon(MaterialCommunityIcons.menu , size: iconSize??24, color: color,),
      items: items,
      value: current == null ?"":getSearchKeyCallback(current),
      hint: hint,
      searchHint: hint,
      onChanged: (v) async {
        var newValue = searchKey2Object[v];
        if (newValue != null) {
          onSubmitted?.call(newValue.guid);
        }
        else{
          onSubmitted?.call("");
        }
      },
      selectedValueWidgetFn:getSelectWidgetCallback!= null?(key){
        var data = searchKey2Object[key];
        if (data == null){
          return Text("空",style : TextStyle(fontSize: fontSize??14,fontWeight: FontWeight.w600 , color: Colors.red));
        }
        var itemSel = getSelectWidgetCallback?.call(data);
        if (itemSel==null) return searchKey2Item[key];
        return itemSel;
      }:null,
      iconSize:iconSize??24,
      displayClearIcon: false,
      closeButton: "关闭",
      isExpanded: expanded,
      underline: SizedBox(height: 0,),
    );

    return res;
  }
  static Widget roundRect({Widget child , Color borderColor = Colors.indigo , Color bgColor = Colors.white , double radius = 10.0 , EdgeInsetsGeometry padding , double height = 100 , double width = 48 , double borderWidth = 0.5 }){
    var dc = new BoxDecoration(
        border: new Border.all(color: borderColor, width: borderWidth),
        color :bgColor,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
        borderRadius: new BorderRadius.circular((radius))
    );
    return Container(
      decoration: dc,
      height: height,
      padding: padding,
      child: child,
    );
  }

  static String getPathWithBase(String rPath , String basePath){
    var path = PathUtil.join(basePath, rPath);
    path = PathUtil.canonicalize(path);

    return path;
  }
  static Widget getWidgetBlock(String str , Color color , Widget child , double height , {List<Widget> actions}){
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0, 0),    blurRadius: 0.3, spreadRadius: 0.5) , BoxShadow(color: Colors.white)],
    );
    var dc2 = new BoxDecoration(
      // border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
      color: color,//Color(widget.node.getNodeStructType().bgColor),
      // borderRadius: new BorderRadius.circular((5.0))
    );

    var header = Container(
      height :32,
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      decoration: dc2,
      child: Row(
          children:[
            Expanded(child:Text(str ,)),
            actions!= null?Row(children: actions,):SizedBox(width: 0,),
          ]),
    );
    return Container(
      height : height??100,
      decoration: dc,
      child: Column(
        children: [
          header,
          Expanded(child :child)
          //Expanded(child : child)
        ],
      ),
    ) ;
  }
  static var standardDc = new BoxDecoration(
    boxShadow: [ BoxShadow(color: scaleColor(Colors.grey,1.0), offset:Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.6) , BoxShadow(color: Colors.white)],
  );
  static double standardPadding = 4.0;
  static Widget standardContainer({double width , double height , Widget child }){
    // var standardDc2 = new BoxDecoration(
    //   boxShadow: [ BoxShadow(color: scaleColor(Colors.grey,1.0), offset:Offset(0.0, 0.0), blurRadius: 0.0, spreadRadius: 0.6) , BoxShadow(color: Colors.white)],
    // );
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(standardPadding),
      child: Container(
        decoration: standardDc,
        child: child,
      ),
    );
  }

  static Widget getStandardWidgetBlock({EdgeInsetsGeometry containerPadding , EdgeInsetsGeometry padding , bool withHeader = true ,TextStyle style , CrossAxisAlignment crossAxisAlignment, String headStr , Color color = Colors.grey , Widget child , double width , double height , double headHeight, List<Widget> actions}){
    var dc2 = new BoxDecoration(
      // border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
      color: color,//Color(widget.node.getNodeStructType().bgColor),
      // borderRadius: new BorderRadius.circular((5.0))
    );

    var header = Container(
      height : headHeight??32,
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      decoration: dc2,
      child: Row(

         // DartCommon.isEmpty(headStr)
          children:[
            if (!DartCommon.isEmpty(headStr)) Expanded(child:Text(headStr??"" , style: style,)),
            actions!= null?Row(mainAxisAlignment: DartCommon.isEmpty(headStr)?MainAxisAlignment.start:MainAxisAlignment.end,children: actions,):SizedBox(width: 0,),
          ]),
    );
    return Container(
      width: width,
      height : height,
      // decoration: standardDc,
      padding: padding??EdgeInsets.all(standardPadding),
      child: Container(
        decoration: standardDc,

        child: Column(
          crossAxisAlignment:crossAxisAlignment??CrossAxisAlignment.start ,
          children: [
            if (withHeader) header,
            Container(padding: containerPadding, child : child??Container())
            // height == null ?(child??Container()) : Expanded(child :child??Container() )
            //Expanded(child : child)
          ],
        ),
      ),
    ) ;
  }

  static void showProgress(BuildContext context , {dynamic onCancel}){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var child =  ProgressDialog(onCancel: onCancel);
        return ThemeConsumer(child :Dialog(child: child));
      },
    );
  }

  static List<File> getFilesOfDirectory(String path , String namePattern , {bool recursive = false}){
    var res = List<File>();
    var dir = Directory(path);
    if (!dir.existsSync()) return res;
    var fItems = dir.listSync(recursive: recursive);
    var regFile = RegExp(namePattern);
    for(var f in fItems){
      // print("process ${f.path}");
      if (f is File){
        var name = PathUtil.basename(f.path);
        // print("name ${name}");
        if (regFile.hasMatch(name)){
          res.add(f);
          // print("bingo ${name}");
        }
      }
    }

    return res;

  }
  // static DecorationImage getCountryFlag(String country ,{ double width , double height , BoxFit fit}){
  //   Country country = Country.fromJson(countryCodes[94]);
  //   // return Image.asset('icons/flags/cn.png', package: 'country_icons',
  //   //     width:width,height: height,fit : fit
  //   // );
  //   return DecorationImage(image : AssetImage(country.flagUri, package: 'ola_like_country_picker'));
  // }
  static String contactList(List lst , String split){
    StringBuffer sb = StringBuffer();
    for(int i = 0 ; i< lst.length ; ++i){
      if (i>0) sb.write(split);
      sb.write(lst[i].toString());
    }
    return sb.toString();
  }

  static List<String> clone(List<String> lst){
    List<String> res = List<String>();
    res.addAll(lst);
    return res;
  }

  static Map collectMap(XmlNode node , Map<String,ClazzInfo> types ,List<String> treeStack){
    if (! (node is XmlElement || node is XmlDocument || node is XmlComment)){
      return null;
    }
    var name = "document";

    if (node is XmlComment){
      // name = node.name.toString();
      // return null;
      var comment = node.toString().replaceFirst("<!--", "").replaceFirst("-->", "");
      return { "comment" : comment , "isComment" : true};
    }
    if (node is XmlElement){
      name = node.name.toString();
    }
    {
      var ci = types[name] ;
      if (ci == null){

        ci = types[name] = ClazzInfo();
        ci.name = name;
        ci.group = clone(treeStack);
      }
      Map attrs = Map();
      node.attributes.forEach((attr) {
        var attrName = attr.name.toString();
        var attrVal = attr.value;
        attrs[attrName] = attrVal;

        ci.fields[attrName] = {
          "name" : attrName,
          "value" : attrVal,
        };
      });
      List children = List();
      String lastComment = "" ;
      treeStack.add(name);
      node.children.forEach((n) {

        var ch = collectMap(n, types,treeStack);
        if (ch != null) {
          var crtCount = ci.childTypes[ch["name"]]??0;
          ci.childTypes[ch["name"]] = crtCount + 1;
          children.add(ch);
        }
      });
      treeStack.removeLast();
      var resMap = {
        "name": name,
        "attrs": attrs,
        "children": children,
      };

      // lst.add(resMap);
      return resMap;
    }
  }
  static Map xmlToMap(XmlDocument doc){
    Map<String,ClazzInfo> types = Map<String,ClazzInfo>();
    List<String> treeStack = List<String>();
    // Map<String,List<Map>> type2Objects = Map<String,List<Map>>();
    var res = collectMap(doc.root,types , treeStack);
    res["types"] = types;
    return res;
  }
  static Map loadXml(String filaPath){
    var m;
    final file = new File(filaPath);
    try{
      final document = XmlDocument.parse(file.readAsStringSync());
      m = xmlToMap(document);
      m["path"] = PathUtil.canonicalize(filaPath.replaceAll("\\", "/"));
    }
    catch(e){
      // return 0;
      // throw e;
    }

    return m;
  }

  /// 處理點擊按鈕背景顏色
  /// 設置當前按鈕為不可點擊時，設置onPressed回調為null。
  static MaterialStateProperty<Color> createTextBtnBgColor(Color normal , { Color press , Color disable } ) {
    return MaterialStateProperty.resolveWith((states) {
// If the button is pressed, return green, otherwise blue
      if (states.contains(MaterialState.pressed)) {
        return press??normal;
      } else if (states.contains(MaterialState.disabled)) {
        return disable??normal;
      }
      return normal; ///擴展String函數
    });
  }
}

class ClazzInfo{
  String name;
  List<String> group ;
  Map<String,Map> fields = Map<String,Map>();
  Map<String,int> childTypes = Map<String,int>();
}