//@dart=2.11
import 'dart:async';
import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/Filter/TextFilter.dart';
import 'package:battlepus/common/Filter/filter_line.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:path/path.dart' as PathUtil;
class LogView extends StatefulWidget {
  final double containerWidth;
  final double containerHeight;
  LogView({Key key, this.containerWidth , this.containerHeight}) : super(key: key);

  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {

  TextFilter filter = TextFilter();
  double width = 480;
  double offY = 80;
  // double height = 00;
  StreamSubscription<LogViewState> _lis;
  bool bRebuild = false;
  // bool visible = false;
  @override
  void initState() {
    _lis = EventCenter.eventBus.on<LogViewState>().listen((event) {
      setState(() {
        // visible = event.open;
        // bRebuild = true;
      });
    });
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _lis?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
  List<String> filteredLogs;
  ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    if (!StateScriptProject.openLog) return Container();
    var height = widget.containerHeight - offY;
    // StateScriptProject.logs = new List<String>();
    // StateScriptProject.logs..add("test1")..add("test2")..add("test2")..add("test2")..add("test2")..add("test2")..add("test2")..add("test2")..add("test2");

    filteredLogs = filterLogs(StateScriptProject.logs);
    var right =  Container(
      width: widget.containerWidth/4,
      height : height,
      padding: EdgeInsets.all(0),
      // height: 680.0 + 48,
      child: ThemeCenter.block(
        // padding: EdgeInsets.all(8),
          headHeight: 38,
        // : "结点描述",
          headTitle: "日志",
          padding: EdgeInsets.all(8),
          // height: 200,
          child: Column(
            children: [
              Row(
                children: [
                  Text("过滤 ",style: ThemeCenter.mainTextStyle(step:6 , fontSize: 10)),
                  Expanded(child:FilterLine(
                    filter: filter ,
                    onChanged: (){
                      setState(() {

                      });
                    },
                  )),
                ],
              ),
              Container(height: 8,),
              Expanded(child:DraggableScrollbar.rrect(
                backgroundColor: CommonUtil.alphaColor(Colors.grey, 100),
                alwaysVisibleScrollThumb: true,
                heightScrollThumb: 48,
                controller:  _scrollController ,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredLogs?.length??0,
                  itemBuilder: onBuildItem ,

                ),
              )),
            ],
          ),
          actions: [

            // ThemeCenter.iconBtn(MaterialCommunityIcons.kabaddi,width: 32 ,height:32,
            //     color: Colors.white,
            //     tooltip: "添加log",
            //     onPressed: (){
            //       setState(() {
            //         StateScriptProject.logs.add(Uuid().v4());
            //       });
            //
            //     },
            //
            // ),

            ThemeCenter.iconBtn(MaterialCommunityIcons.file_document,width: 28 ,height:24,
                color: Colors.white,
                tooltip: "文件打开",
                onPressed: (){
                  var path = PathUtil.join(GlobalBoard.docDir.path,"battlepus");//, name+".json");
                  StateScriptProject.logs.join("\n");

                  var f = File(PathUtil.join(path,"bt_log.log"));
                  f.writeAsStringSync(StateScriptProject.logs?.join("\n")??"");
                  DartCommon.launchURL(PathUtil.join(path,"bt_log.log"));
                }
            ),

            ThemeCenter.iconBtn(MaterialCommunityIcons.delete_sweep,width: 32 ,height:32,
                color: Colors.redAccent,
                tooltip: "清理",
                onPressed: (){
                  setState(() {
                    StateScriptProject.logs?.clear();
                    // node.description = node.getFullDesc(ScriptInfo.current.scriptData.collectInParamNameMaps());
                  });
                }
            ),
            Container(width: 4,),
          ]
      )
    );
    // Timer(Duration(milliseconds: 100),
    //         () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));


    // Future.delayed(Duration(milliseconds: 500)).then((value){
    //
    //   _scrollController.animateTo(
    //     1.0, //滚动位置
    //     curve: Curves.easeOut, //动画效果
    //     duration: const Duration(milliseconds: 10), //动画时间
    //   );
    // });
    // bRebuild = false;
    SchedulerBinding.instance.addPostFrameCallback((_) { //build完成后的回调
      if (_scrollController.hasClients) _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,//滚动到底部
      );
    });

    return Positioned(
      left: widget.containerWidth*3/4,
      top: offY,//(widget.containerHeight - height),
      child: right,
    );
    // return Container(
    //   // color: CommonUtil.alphaColor(Colors.white, 0),
    //   child :Row(
    //     children: [
    //       Expanded(child : Container()),
    //       Expanded(child : right),
    //     ],
    //   )
    // );
  }

  List<String> filterLogs(List<String> logs){
    List<String> res = List<String>();
    if (logs == null || logs.length<=0) return res;

    logs.forEach((element) {
      if (filter.passFilter(element)){
        res.add(element);
      }
    });

    return res;
  }

  Widget onBuildItem(BuildContext context, int index) {
    return Text(filteredLogs[index] , style: TextStyle(color:Colors.white, fontSize: 12,backgroundColor: index%2==0?Colors.white12:null),);
    // var item = sortedItems[index];
    // bool isSelected = _selected == item;
    // return InkWell(
    //   onTap: (){
    //     setState(() {
    //       if (_selected != item){
    //         widget.onSelectChange?.call(item);
    //       }
    //       _selected = item;
    //     });
    //   },
    //   child: Container(
    //       padding: EdgeInsets.all(4),
    //       height: 58,
    //       color: isSelected?CommonUtil.alphaColor(Colors.indigo, 32):Colors.white,
    //       child: widget.onGetListItem?.call(item)
    //   ),
    // );
  }
}