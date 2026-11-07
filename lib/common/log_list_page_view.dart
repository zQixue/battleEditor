//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/Logger.dart';
import 'package:battlepus/common/ThemeCenter.dart';
// import 'package:pluto_grid/pluto_grid.dart';

class LogListPageView extends StatefulWidget {
  final Logger logger;
  final String savePath;
  LogListPageView({Key key,
    this.logger,
    this.savePath,
  }) : super(key: key);

  @override
  _LogListPageViewState createState() => _LogListPageViewState();
}

class _LogListPageViewState extends State<LogListPageView> {

  List<ALog> logs ;
  String _filterStr;
  List<LogType> _types;
  ScrollController scrollController;

  @override
  void dispose() {
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {

    scrollController = ScrollController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var lines = getFilterLogs(_filterStr,_types);

    // var ws = List<Widget>();
    // var dc = new BoxDecoration(
    //   border: Border(
    //     top: Divider.createBorderSide(context, color: CommonUtil.alphaColorD(Colors.grey , 0.3), width: 1),
    //   ),
    // ); // 圆角度
    // for(var s in result){
    //   var txt = Container(
    //     decoration: dc,
    //     child: Text(s , style: ThemeCenter.mainTextStyle(step: 8,fontSize: 12),),
    //   );
    //   ws.add(txt);
    // }
    var finalList = ListView.builder(
      itemExtent: 24,//widget.itemExtent,
      // cacheExtent: widget.cacheExtent,
      // cacheExtent: 500,
      controller: scrollController,
      itemBuilder: (context, i) {
        var color = (i%2 ==1) ? Color(0x4F242730) : null;//Color(0xfF242730);
        var dc = new BoxDecoration(
            color :color,
            borderRadius: new BorderRadius.circular((4))
        );

        var tp = lines[i].type;
        var clr = tp == LogType.error?Colors.redAccent :(tp == LogType.warning?Colors.deepOrangeAccent: Colors.white);
        return Container(
          decoration: dc,
          child: Text(lines[i].message , style: TextStyle(color :clr , fontSize: 13),),
        );
      },
      itemCount: lines.length,
      // itemExtent: widget.it,
      scrollDirection: Axis.vertical,
    );

    // var lv2 = PlutoScrollbar(
    //   verticalController:scrollController,
    //   horizontalController:null,
    //   isAlwaysShown: false,
    //   thickness: 8.0,
    //   thicknessWhileDragging: 10.0,
    //   child:finalList,
    //   // radius: 3,
    //   // radiusWhileDragging: scrollbarConfig.scrollbarRadiusWhileDragging,
    // );
    var lv2 = finalList;

    return ThemeCenter.block(headTitle: "错误告警" ,
      child: Container(padding: EdgeInsets.all(8),
        child: lv2,
      ),
      actions: [
        if (widget.savePath != null)ThemeCenter.iconBtn(MaterialCommunityIcons.file_alert,
          tooltip: "打开文件",
          onPressed: (){
            DartCommon.launchURL(widget.savePath);
          }
        ),
        SizedBox(width: 4,),
      ]
    );
  }

  List<ALog> getFilterLogs(String fstr , List<LogType> tps){
    List<ALog> res = List<ALog>();
    widget.logger.logs.forEach((element) {
      if (!DartCommon.isEmpty(fstr)){
        if (element.message.indexOf(fstr)<0){
          return ;
        }
      }
      if (tps != null){
        if (!tps.contains(element.type)){
          return;
        }
      }

      var lines = element.message.split("\n");
      lines.forEach((line) {
        res.add(ALog()..message = line .. type = element.type);
      });
    });

    return res;
  }
}