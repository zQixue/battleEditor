import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/select_script_module_view.dart';
import 'package:theme_provider/theme_provider.dart';

import '../common/CommonUtil.dart';
import '../common/ThemeCenter.dart';

class ScriptModuleSelecter extends StatefulWidget {
  final String moduleGuid;
  final List<Widget>? actions;
  final Function(String guid)? callback;
  const ScriptModuleSelecter({Key? key,
    required this.moduleGuid,
    this.actions,
    this.callback,
  }) : super(key: key);

  @override
  ScriptModuleSelecterState createState() => ScriptModuleSelecterState();
}

class ScriptModuleSelecterState extends State<ScriptModuleSelecter> {
  @override
  Widget build(BuildContext context) {
    var sm = StateScriptProject.instance!.scriptModules![widget.moduleGuid];

    return Container(
      child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  sm == null?Container():
                  ThemeCenter.roundRect(
                    // height: 32,
                      radius: 4,
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: [

                          Text(sm.getTypeShowString() , style: TextStyle(color:CommonUtil.changeColorLightness(Colors.lightGreen,0.5)),),
                        ],
                      ),
                      bgColor: Color(0),
                      borderColor: CommonUtil.changeColorLightness(Colors.lightGreen,0.3),
                      borderWidth: 3
                  )
                ],
              ),
            ),
            ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline,
              width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"编辑脚本分类模块",
              onPressed: (){


                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    var child = ThemeCenter.area(width:800 ,height:600, child: SelectScriptModuleView(currentGuid: widget.moduleGuid,isSelector: true,));
                    return ThemeConsumer(child:Dialog(child: child));
                  },
                ).then((value){
                  widget.callback?.call(value);
                });
              },
            ),
            if (widget.actions != null && widget.actions!.length>0) Row(
              children: widget.actions!,
            )
          ]
      ),
    );
  }
}