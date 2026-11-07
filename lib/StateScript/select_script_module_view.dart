import 'package:bot_toast/bot_toast.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/Tagger/TagSet.dart';
import 'package:battlepus/common/Tagger/tag_set_view.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/directory_picker.dart';
import 'package:battlepus/common/text_editor.dart';

import '../common/GlobalDoard.dart';
import '../common/icon_selecter.dart';
import '../common/line_container.dart';
import 'Struct/ScriptModule.dart';
import 'package:flutter_icons/src/flutter_icon_data.dart';

class SelectScriptModuleView extends StatefulWidget {
  final String? currentGuid;
  final bool isSelector;
  const SelectScriptModuleView({Key? key,
    this.currentGuid = null,
    this.isSelector = false,
  }) : super(key: key);

  @override
  SelectScriptModuleViewState createState() => SelectScriptModuleViewState();
}

class SelectScriptModuleViewState extends State<SelectScriptModuleView> {
  @override
  void initState() {
    if (StateScriptProject.instance?.scriptModules == null){
      StateScriptProject.instance?.scriptModules = Map<String,ScriptModule>();
    }
    var initGuid = widget.currentGuid??StateScriptProject.currentSelectedModule;
    if (initGuid != null ) {
      _currentSelected = StateScriptProject.instance?.scriptModules![initGuid];
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (StateScriptProject.instance?.scriptModules == null){
      StateScriptProject.instance?.scriptModules = Map<String,ScriptModule>();
    }

    List<Widget> wms = <Widget>[];
    wms.add(CreateModule(defaultSm));

    var sms = StateScriptProject.instance?.scriptModules?.values.toList();
    sms!.sort((a,b)=>(a.exportId??0) - (b.exportId??0));
    sms.forEach((sm) {
      var w = CreateModule(sm);
      wms.add(w);
    });


    wms.add(AddModuleButton());
    var con1 = Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: wms,
        ),
      )
    );

    // return ThemeCenter.block(
    //   headTitle: "选择模块",
    //   child: con1,
    // );
    if (widget.isSelector){
      return con1;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("模块选择"),
        actions: [
          // IconButton(icon: Icon(MaterialCommunityIcons.collage),iconSize: 36, color: Colors.white, tooltip:"搜集",
          //   onPressed: (){
          //     StateScriptProject.instance!.resourceLists.forEach((key, value) {
          //       value.collect();
          //     });
          //     BotToast.showText(text: "搜集完毕");
          //   },
          // ),
          IconButton(icon: Icon(MaterialCommunityIcons.camera_switch),iconSize: 36, color: Colors.white, tooltip:"切换所有Function保存路径",
            onPressed: (){
              switchFunctionStorePath();
              BotToast.showText(text: "切换完毕");
            },
          ),
          IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 36, color: Colors.white, tooltip:"保存",
            onPressed: (){
              StateScriptProject.instance!.save();
              BotToast.showText(text: "保存完毕");
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: ThemeCenter.block(
            headTitle: "模块列表",
            // expanded: true,
            child: con1,
          )),
          if (!widget.isSelector)ThemeCenter.block(
            padding: EdgeInsets.all(8),
            width: 380,
            // height: 320,
            headTitle: "详细信息",
            // expanded: true,
            child: createModuleDetail(_currentSelected),
          )

        ],
      ),

    );
  }


  void switchFunctionStorePath(){
    StateScriptProject.cancelWatchProject();
    var scripts = StateScriptProject.instance!.scripts;
    var old = ScriptInfo.current;
    for(var s in scripts){
      ScriptInfo.current = s;
      var script = s.getScriptData();
      if ( script== null){
        s.loadScript();
        script = s.getScriptData();
      }

      script?.nodes?.forEach((node) {
        var st = node.getNodeStructType();
        var fields = st?.getAllFields();
        fields?.forEach((fi) {
          if (fi.typeGuid == "___agentfunction___"){
            var funcId = node.fieldValues[fi.guid]?.value as String;
            if (!DartCommon.isEmpty(funcId)){
              var func = script?.getFunction(funcId);
              if (func != null){
                func.load();
                func.save(s.guid);
              }

            }
          }
        });

      });


    }
    ScriptInfo.current = old;
    StateScriptProject.doWatchProject();
  }
  ScriptModule? _currentSelected;

  Widget createModuleDetail(ScriptModule? sm){
    if (_currentSelected == null){
      return Container();
    }
    var iconData = (sm?.iconCode??0) == 0?Icons.extension:FlutterIconData.materialCommunityIcons(sm?.iconCode);
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    const interval = const SizedBox(height: 8,);
    if (sm!.tagSet == null) sm.tagSet = TagSet();
    var lst = ListView(
      children: [
        // Text(sm!.getTypeShowString()),
        TextEditor(
          hint: "模块名",
          initValue: sm!.name??"",
          onSubmitted: (v){
            setState(() {
              sm!.name = v;
            });
          },
        ),
        interval,
        TextEditor(
          hint: "别名",
          initValue: sm!.alias??"",
          onSubmitted: (v){
            setState(() {
              sm!.alias = v;
            });
          },
        ),
        interval,
        if (defaultSm != sm) LineContainer(
          title: "标签",
          height: 60,
          child: TagSetView(tagSet: sm.tagSet , tagCamp: StateScriptProject.instance!.tagCamp,
            // actions: [
            //   ThemeCenter.iconBtn(MaterialCommunityIcons.ballot_outline,
            //     width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"全组设置",
            //     onPressed: (){
            //       StateScriptProject.instance.nodeStructs.forEach((element) {
            //         if (_selectScript != element && element.group == _selectScript.group){
            //           element.tagSet = _selectScript.tagSet.clone();
            //         }
            //       });
            //
            //       BotToast.showText(text: "全组设置标签完成");
            //     },
            //   ),
            // ],
          ),
        ),
        interval,
        interval,
        interval,
        interval,
        LineContainer(
          title: "选择图标",
          height: 120,
          child: IconSelecter(
            currentIcon: iconData,
            size: 100,
            color: Color(sm.color),
            callback: (v){
              setState(() {
                sm.iconCode = v;
              });
            },
          ),
        ),
        interval,
        LineContainer(
          title: "选择颜色",
          height: 60,
          child: Row(
            children: [
              Container(
                width:100,
                height:24,
                color: Color(sm.color),
              ),
              CustomPopupMenu(
                child: Icon(MaterialCommunityIcons.palette,size: 24, color: Colors.deepPurpleAccent,),
                menuBuilder:   () {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 160,
                      color: const Color(0xFF2C2C2C),
                      child: GridView.count(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        crossAxisCount: 5,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: line_colors.map((item) => ThemeCenter.iconBtn(
                            MaterialCommunityIcons.square,
                            width: 24 , height: 24,
                            color: item,
                            onPressed: (){
                              sm.color = item.value;
                              setState(() {

                              });
                            }
                        )).toList(),
                      ),
                    ),
                  );
                },
                barrierColor: Colors.transparent,
                pressType: PressType.singleClick,
                horizontalMargin: -5,
                // verticalMargin: 25,
              ),
            ],
          )
        ),
        interval,
        if (defaultSm != sm) DirectoryPicker(
          hint: "保存路径",
          iconSize: 20,
          basePath: basePath,
          // tooltip: "保存路径",
          initPath: sm.savePath??"",
          onChanged: (v){
            setState(() {
              sm.savePath = v;
            });
          },
        ),
        interval,
        interval,
        interval,
        if (defaultSm != sm) ElevatedButton(onPressed: (){
          setState(() {
            _currentSelected = null;
            StateScriptProject.instance?.deleteModule(sm);
          });
        }, child: Text("删除"))
      ],
    );
    return lst;
  }


  static var line_colors = [Color(0xFFCC9999),  Color(0xFF666699),
    Color(0xFF0099CC),
    Color(0xFFCCCC99), Color(0xFFCC3399), Color(0xFF99CC00),
    Color(0xFFFF6666),  Color(0xFF3399CC),
    Color(0xFFCC6600), Color(0xFF999999),
    Color(0xFFFFFFCC), Color(0xFF009933),
    Color(0xFF0099CC), Color(0xFFCCCCCC), Color(0xFFFF6666),
    Color(0xFFFF6600), Color(0xFF009966),
    Color(0xFFCC6633), Color(0xFFCC6600),
    Color(0xFFCC0066), Color(0xFF009999),
    Color(0xFF6699CC), Color(0xFF663366), Color(0xFFCCCC99),
    Color(0xFF990033), Color(0xFFCCFF66), Color(0xFFFF9900),
    Color(0xFF666699), Color(0xFF660033), Color(0xFF99CC99),
    Color(0xFF663300),
    Color(0xFF990033), Color(0xFF006633),
    Color(0xFF660033), Color(0xFF999933), Color(0xFF660099),
    Color(0xFF993366), Color(0xFF666633),
    Color(0xFF996600), Color(0xFF666600),
    Color(0xFF009933), Color(0xFFCC9900), Color(0xFF666666),
    Color(0xFF666633),  Color(0xFFCC3366)];

  var defaultSm = ScriptModule()..guid = ""..name="default"..alias ="未分类";
  final double moduleWidth = 160;
  final double moduleHeight = 180;
  final double iconSize = 140;
  Widget CreateModule(ScriptModule sm) {
    var color = _currentSelected == sm? Colors.blueGrey:null;
    var iconData = sm.iconCode == 0?Icons.extension:FlutterIconData.materialCommunityIcons(sm.iconCode);
    var con = Card(
      color: color,
      child: Container(
        width: moduleWidth,
        height: moduleHeight,
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Icon(iconData,size: iconSize,color: Color(sm.color),),
            Text(sm.getTypeShowString()),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: (){
        setState(() {
          // ScriptModule? m = StateScriptProject.instance?.addModule();
          _currentSelected = sm;
        });
      },
      // onDoubleTap: (){
      //   Navigator.pop(context,true);
      // },
      child: _currentSelected == sm?
          Stack(
            children: [
              con,
              Positioned(
                right: 0,
                top: 0,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context,sm.guid);
                  },
                  child: Text("选择"),
                )
              )
            ],
          )
          :con,
    );
  }

  final double addWidth = 120;
  final double addHeight = 140;
  final double addSize = 100;
  Widget AddModuleButton() {
    var con = Card(
      child: Container(
        width: addWidth,
        height: addHeight,
        padding: EdgeInsets.all(4),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(MaterialCommunityIcons.plus_box_outline,size: addSize,),
            Text("添加模块"),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: (){
        setState(() {
          ScriptModule? m = StateScriptProject.instance?.addModule();

          _currentSelected = m;
        });
      },
      child: con,
    );
  }
}