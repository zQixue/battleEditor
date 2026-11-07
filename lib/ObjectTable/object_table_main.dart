//@dart=2.11
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/ObjectTable/main_table_view.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/GlobalDoard.dart';

class ObjectTableMain extends StatefulWidget {
  ObjectTableMain({Key key}) : super(
      key: key);

  @override
  _ObjectTableMainState createState() =>
      _ObjectTableMainState(
      );
}

class _ObjectTableMainState extends State<ObjectTableMain> {
  StreamSubscription<InspectorRefreshEvent> _lis;


  static void initExtraType(){
    SSFieldType.registerFieldType("___objref___" , FTObjectReference()..typeGroup = "对象引用"..name = "ref"..alias = "对象引用"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  AObject _inspectorObject;
  FieldInfo _inspectorField;

  @override
  void initState() {
    Transport.instance.start();

//    TypeMapContainer.registerTypeMap();

    SSFieldType.initSystemType();
    initExtraType();
    ObjectTableSetting.load();
    OTGlobalBoard.clear();

    if (!ObjectTableProject.isLoaded()) {
      Future.delayed(Duration(milliseconds: 10)).then((value){
        ObjectTableProject.load();
      });
      // ObjectTableProject.load();
    }
    // ObjectTableProject.instance.registerEnumTypes();
    //


    _lis = EventCenter.eventBus.on<InspectorRefreshEvent>().listen((event) {
      setState(() {
        _inspectorObject = null;
//        _inspectorField = null;
        if (event.object!= null) _inspectorObject = event.object;
        if (event.field != null) _inspectorField = event.field;
      });
    });

    // TODO: implement initState
    super.initState();

  }
  bool _gridMode = false;
  @override
  Widget build(BuildContext context) {

    List<Widget> actions = [];
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    Widget content = Container(
      // padding: EdgeInsets.all(4),

      child: Container(
//        decoration: dc,
        child: getMainContent(),
      ),
    );

    if (ObjectTableSetting.instance.workingPath == null || ObjectTableSetting.instance.workingPath == "" || GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath) == null){
      content = Container( child : Center(
        child : Text("左上角选择或创建工程目录" , style: TextStyle(fontSize: 48 , color: Colors.grey),),
      ));
    }
    else{
//      var openTable = IconButton(icon: Icon(MaterialCommunityIcons.folder_open),iconSize: 36, color: Colors.white, tooltip:"打开表",
//        onPressed: () async {
//          var table = await OTUtils.selectTable(context);
//          if (table != null){
//            OTGlobalBoard.currentObjectClazz = table;
//            setState(() {
//
//            });
//          }
//
//        },
//      );
//      actions.add(openTable);
//       var mode = IconButton(icon: Icon(MaterialCommunityIcons.table),iconSize: 36, color: _gridMode?Colors.lightBlueAccent:Colors.grey, tooltip:"网格模式",
//         onPressed: (){
//           setState(() {
//             _gridMode = !_gridMode;
//           });
//
//           // ObjectTableProject.instance.save(context: context);
//           // BotToast.showText(text: "保存完毕");
//         },
//       );
//       actions.add(mode);

      var save = IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 36, color: Colors.greenAccent, tooltip:"保存",
        onPressed: (){
          ObjectTableProject.instance.save(context: context , saveObject: true);
          // BotToast.showText(text: "保存完毕" , contentColor: Colors.green);
        },
      );
      actions.add(save);

      var load = IconButton(icon: Icon(MaterialCommunityIcons.reload),iconSize: 36, color: Colors.greenAccent, tooltip:"重新加载",
        onPressed: () async {
          // TableImporter.import();
          ObjectTableProject.clearObjects();
          ObjectTableProject.tryLoadObjects();
          EventCenter.eventBus.fire(AObjectTableCleared());
          // BotToast.showText(text: "加载完毕" , contentColor: Colors.green);

          // final window = await DesktopMultiWindow.createWindow(jsonEncode({
          //   'args1': 'Sub window',
          //   'args2': 100,
          //   'args3': true,
          //   'bussiness': 'bussiness_test',
          // }));
          // window
          //   ..setFrame(const Offset(0, 0) & const Size(1280, 720))
          //   ..center()
          //   ..setTitle('Another window')
          //   ..show();
        },
      );
      actions.add(load);

      // if(!ObjectTableProject.withPlugins()){
      {
        var export = IconButton(icon: Icon(MaterialCommunityIcons.export),iconSize: 36, color: Colors.white, tooltip:"导出",
          onPressed: (){
            ObjectTableProject.instance.export();
            BotToast.showText(text: "导出完毕" , contentColor: Colors.green);
          },
        );
        actions.add(export);
      }

      var nodeDefine = IconButton(icon: Icon(MaterialCommunityIcons.alpha_n_box_outline),iconSize: 36, color: Colors.white, tooltip:"对象定义",
        onPressed: (){
          Navigator.pushNamed(context, "/ClazzDefinePage").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
        },
      );
      actions.add(nodeDefine);

      var enumDefine = IconButton(icon: Icon(MaterialCommunityIcons.alpha_e_box_outline),iconSize: 36, color: Colors.white, tooltip:"枚举定义",
        onPressed: (){
          Navigator.pushNamed(context, "/EnumDefinePage").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
        },
      );
      actions.add(enumDefine);


    }

    var setting = IconButton(icon: Icon(Icons.settings),iconSize: 32, color: Colors.white, tooltip:"设置",

      onPressed: (){
        Navigator.pushNamed(context, "/ObjectTableSettingPage").then((value){
          setState(() {
            ///刷新
            EventCenter.eventBus.fire(GlobalRefreshEvent());
          });
        });
      },
    );
    actions.add(setting);

    if(BattlePusGlobal.windowController == null){
      var subWindow = IconButton(icon: Icon(MaterialCommunityIcons.car_multiple),iconSize: 36, color: Colors.lightBlueAccent, tooltip:"独立窗口",
        onPressed: () async {

          Navigator.pop(context);
          await BattlePusGlobal.createSubWindow("对象表",'/ObjectTableMain');
        },
      );
      actions.add(subWindow);
    }

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 48,
            elevation:0,
          title: Text("对象表"),
          actions: actions
        ),
        body: Row(
          children: [
            Expanded(
              child: content
            )
          ],
        )
    );
  }

  Widget getMainContent(){
//    List<Widget> lst = [];
//    lst.add(Expanded(flex : 3 , child: TableView()));
//
//    if (_inspectorObject != null && _inspectorField != null){
//      var insp = Expanded(
//        flex: 1,
//          child:ObjectInspector(object: _inspectorObject, field: _inspectorField)
//      );
//      lst.add(SizedBox(width: 4,));
//      lst.add(insp);
//    }
//    return Row(
//      children: lst
//    );

    return MainTableView(gridMode: _gridMode,);
    // return TableView();

  }
}