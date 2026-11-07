//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {

    Widget chs = ModalRoute.of(context).settings.arguments as Widget;
    var dc = new BoxDecoration(
        // border: new Border.all(color: bgColor, width: 1.2),
        // color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: Colors.grey, offset:Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],

    );
    var con = ThemeCenter.area(
      padding: EdgeInsets.all(4),
      // decoration: dc,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border : Border(
                    right: BorderSide(width: 3 ,color: ThemeCenter.activeTheme.areaBorderColor ),
              )),
            width: 200,
            alignment: Alignment.topCenter,
            child : Column(
              children: [
                SizedBox(height: 40,),
                Icon(MaterialCommunityIcons.settings , size: 120, color: ThemeCenter.systemTheme.accentColor,),
              ],
            )
          ),
          Expanded(flex : 6 , child : chs)
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          // leading: Icon(MaterialCommunityIcons.bulletin_board , color: Colors.white,),
            title: Text("设置"),
            toolbarHeight: 40,
        ),
        body: Container(
          padding: EdgeInsets.all(4),
          child: con,
        )
    );
  }
}