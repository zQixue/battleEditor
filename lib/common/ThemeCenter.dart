//@dart=2.11

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/Logger.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'dart:math';



class ThemeCenter {

  ///theme name
  String name;
  ///Text
  Color mainTextColor;
  List<Color> _mainTextStepColors;
  static Color mainTextStepColor(int step){
    return activeTheme._mainTextStepColors[step];
  }
  static TextStyle mainTextStyle({int step = 10 , double fontSize = 24 , FontWeight fontWeight = FontWeight.w400 }){
    return TextStyle(
      color : activeTheme._mainTextStepColors[step] ,
      fontSize: fontSize,
      fontWeight:fontWeight,
    );
  }

  ///area border color
  Color areaBorderColor;

  static ThemeData _sysTheme;
  static ThemeData get systemTheme {
    // if (_sysTheme != null) return _sysTheme;
    // _sysTheme = AppTheme.dark().data;//ThemeProvider.themeOf(activeTheme.context).data;// Theme.of(activeTheme.context);
    return _sysTheme;
  }
  static Widget iconBtn(IconData icon ,  {String tooltip,Color color = Colors.white , double width = 18 , double height = 18 , VoidCallback onPressed , EdgeInsetsGeometry padding}){
    return Container(
      width: width,
      height: height,
      child: IconButton(
        padding: padding??EdgeInsets.all(0),
        icon: Icon(icon),
        tooltip: tooltip,
        iconSize: min(width,height),
        color: color,
        onPressed: (){
          onPressed?.call();
        },
      ),
    );
  }
  // static Widget toolbar({ bool dark = false , Widget child , Color panelColor,
  //   EdgeInsetsGeometry padding, double width , double height ,
  //   double leftBorderWidth = _defaultBorderWidth ,
  //   double rightBorderWidth = _defaultBorderWidth,
  //   double topBorderWidth = _defaultBorderWidth ,
  //   double bottomBorderWidth = _defaultBorderWidth,
  // }){
  //   // print(activeTheme.mainTextColor);
  //   return Container(
  //     padding: padding,
  //     width: width,
  //     height: height,
  //     child : child,
  //     decoration: BoxDecoration(
  //         color: panelColor??systemTheme.scaffoldBackgroundColor,//dark?systemTheme.primaryColorDark:systemTheme.primaryColor,
  //         border : Border(
  //           bottom: (bottomBorderWidth>0)? BorderSide(width: bottomBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
  //           top: (topBorderWidth>0)? BorderSide(width: topBorderWidth ,color: activeTheme.areaBorderColor):BorderSide.none,
  //           left: (leftBorderWidth>0)? BorderSide(width: leftBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
  //           right: (rightBorderWidth>0)? BorderSide(width: rightBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
  //         )),
  //   );
  // }
  static Widget area({ bool dark = false , Widget child , Color panelColor,
    EdgeInsetsGeometry padding, double width , double height ,
    double leftBorderWidth = _defaultBorderWidth ,
    double rightBorderWidth = _defaultBorderWidth,
    double topBorderWidth = _defaultBorderWidth ,
    double bottomBorderWidth = _defaultBorderWidth,
  }){
    // print(activeTheme.mainTextColor);
    return Container(
      padding: padding,
      width: width,
      height: height,
      child : child,
      decoration: BoxDecoration(
        color: panelColor??systemTheme.scaffoldBackgroundColor,//dark?systemTheme.primaryColorDark:systemTheme.primaryColor,
          border : Border(
            bottom: (bottomBorderWidth>0)? BorderSide(width: bottomBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            top: (topBorderWidth>0)? BorderSide(width: topBorderWidth ,color: activeTheme.areaBorderColor):BorderSide.none,
            left: (leftBorderWidth>0)? BorderSide(width: leftBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            right: (rightBorderWidth>0)? BorderSide(width: rightBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
          )),
    );
  }
  static const double _defaultBorderWidth = 1.0;
  static Widget block({ String headTitle = "" , double headHeight = 28 , Widget child ,bool expanded = true,
    EdgeInsetsGeometry padding, double width , double height , List<Widget> actions , TextStyle headStyle,
    double leftBorderWidth = _defaultBorderWidth ,
    double rightBorderWidth = _defaultBorderWidth,
    double topBorderWidth = _defaultBorderWidth ,
    double bottomBorderWidth = _defaultBorderWidth,
    Color bgColor ,
  }){
    // print(activeTheme.mainTextColor);
    // print(systemTheme.primaryColor);
    var head = Container(
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      width: width,
      height: headHeight,
      decoration: BoxDecoration(
          color: systemTheme.primaryColor,//dark?systemTheme.primaryColorDark:systemTheme.primaryColor,
          border : Border(
            bottom: (bottomBorderWidth>0)? BorderSide(width: bottomBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            top: (topBorderWidth>0)? BorderSide(width: topBorderWidth ,color: activeTheme.areaBorderColor):BorderSide.none,
            left: (leftBorderWidth>0)? BorderSide(width: leftBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            right: (rightBorderWidth>0)? BorderSide(width: rightBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
          )),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(headTitle??"" , style:headStyle??mainTextStyle(step: 7 , fontSize: 12) , ),
          if (actions != null) Expanded(child: Container(),),
          if (actions != null) Row(children: actions,),
        ],
      )
    );
    var con = Container(
      padding: padding,

      child : child,
      decoration: BoxDecoration(
          color: bgColor?? systemTheme.scaffoldBackgroundColor,//dark?systemTheme.primaryColorDark:systemTheme.primaryColor,
          border : Border(
            bottom: (bottomBorderWidth>0)? BorderSide(width: bottomBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            top: (topBorderWidth>0)? BorderSide(width: topBorderWidth ,color: activeTheme.areaBorderColor):BorderSide.none,
            left: (leftBorderWidth>0)? BorderSide(width: leftBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            right: (rightBorderWidth>0)? BorderSide(width: rightBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
          )),
    );

    return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          head,
          expanded?Expanded(child: con,):con,
        ],
      ),
    );
  }

  static Widget card({ Widget leading ,TextStyle style  , String headTitle = "" , double headHeight = 28 , Widget child , List<Widget> actions,
    EdgeInsetsGeometry padding, double width , double height ,
    double leftBorderWidth = _defaultBorderWidth ,
    double rightBorderWidth = _defaultBorderWidth,
    double topBorderWidth = _defaultBorderWidth ,
    double bottomBorderWidth = _defaultBorderWidth,
  }){
    // print(activeTheme.mainTextColor);
    // print(systemTheme.primaryColor);
    var head = Container(
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      width: width,
      height: headHeight,
      decoration: BoxDecoration(
          color: systemTheme.primaryColor,//dark?systemTheme.primaryColorDark:systemTheme.primaryColor,
          border : Border(
            bottom: (bottomBorderWidth>0)? BorderSide(width: bottomBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            top: (topBorderWidth>0)? BorderSide(width: topBorderWidth ,color: activeTheme.areaBorderColor):BorderSide.none,
            left: (leftBorderWidth>0)? BorderSide(width: leftBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            right: (rightBorderWidth>0)? BorderSide(width: rightBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
          )),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (leading != null) leading,
          if (leading != null) SizedBox(width: 4,),
          Text(headTitle , style:style??mainTextStyle(step: 7 , fontSize: 12) , ),
          if (actions != null) Expanded(child: Container(),),
          if (actions != null) Row(children: actions,),
        ],
      )
    );
    var con = Container(
      padding: padding,
      width: width,
      height: height,
      child : child,
      decoration: BoxDecoration(
          color: systemTheme.scaffoldBackgroundColor,//dark?systemTheme.primaryColorDark:systemTheme.primaryColor,
          border : Border(
            bottom: (bottomBorderWidth>0)? BorderSide(width: bottomBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            top: (topBorderWidth>0)? BorderSide(width: topBorderWidth ,color: activeTheme.areaBorderColor):BorderSide.none,
            left: (leftBorderWidth>0)? BorderSide(width: leftBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
            right: (rightBorderWidth>0)? BorderSide(width: rightBorderWidth,color: activeTheme.areaBorderColor):BorderSide.none,
          )),
    );

    return Container(
      child: Column(
        children: [
          head,
          con,//Expanded(child: con,),
        ],
      ),
    );
  }

  static showLogDialog(BuildContext context , Logger logger){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        StringBuffer str = StringBuffer() ;
        // String text =
        //     r'*_/this is all three*_/ (*{color:red}bold*, _underlined_, and /{color:brown}italicized/). _{push:home;color:blue}clickable hyperlink to home screen_';
        for(var log in logger.logs){
          if (log.type == LogType.error) {
            str.writeln("~{color:redAccent}Error ~${log.message}");
          }
          if (log.type == LogType.warning) {
            str.writeln("~{color:redAccent}Warning ~${log.message}");
          }
          if (log.type == LogType.info) {
            str.writeln("~{color:white}Info ~${log.message}");
          }
        }

        var edt = Directionality(
            child: SimpleRichText(
                str.toString(),style: ThemeCenter.mainTextStyle(step: 8 , fontSize: 12),
            ),
            textDirection: TextDirection.ltr);

        var con = Container(
          child: SingleChildScrollView(child:Row(
            children: [
              Expanded(child: edt,)
            ],
          )),
        );
        var child = ThemeCenter.block(
          padding: EdgeInsets.all(8),
          headTitle: "日志",
            actions: [
              iconBtn(
                  MaterialCommunityIcons.close_box_outline,
                  color: Colors.redAccent,
                  onPressed: (){
                    Navigator.pop(context);
                  }
              )
            ],
            child: con
        );
        return Dialog(child: child);
      },
    );
  }

  static showSimpleDialog(BuildContext context , {String title , Widget child , double width , double height ,dynamic onClose} ){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {

        // var con = Container(
        //   child: SingleChildScrollView(child:Text( title , style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))),
        // );
        var childCon = ThemeCenter.block(
          width: width,
          height : height,
          headTitle: title,
          child: child??Container(),
          actions: [
            iconBtn(
              MaterialCommunityIcons.close_box_outline,
              color: Colors.redAccent,
              onPressed: (){
                Navigator.pop(context);
                // onClose?.call();
              }
            ),
            SizedBox(width: 4,)
          ]
        );
        return Dialog(child: childCon);
      },
    ).then((value){
      onClose?.call();
    });
  }

  // BuildContext context;
  static showTextDialog(BuildContext context , dynamic messageInfo){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        StringBuffer str = StringBuffer() ;
        if (messageInfo is List<dynamic>){
          for(var l in messageInfo) {
            str.writeln(l.toString());
          }
        }
        if (messageInfo is List<String>){
          for(var l in messageInfo) {
            str.writeln(l.toString());
          }
        }
        if (messageInfo is String){
          str.writeln(messageInfo);
        }
        var con = Container(
          child: SingleChildScrollView(child:Text( str .toString() , style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))),
        );
        var child = ThemeCenter.area(
            child: con
        );
        return Dialog(child: child);
      },
    );
  }


  static botRaiseDialog(dynamic messageInfo , {String headTitle , double width , double height , dynamic onCancel}){
    StringBuffer str = StringBuffer() ;
    if (messageInfo is List<dynamic>){
      for(var l in messageInfo) {
        str.writeln(l.toString());
      }
    }

    if (messageInfo is String){
      str.writeln(messageInfo);
    }

    BotToast.showWidget(
        toastBuilder:(cancel) {
          var con = Container(

            child: ListView(
              padding: EdgeInsets.all(8),
                children :[
                  Text( str .toString(),style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))
                ]
            ),
          );
          var child = ThemeCenter.block(
            headHeight: 28,
              width: width,
              height :height,
              headTitle: headTitle??"",
              child: con,
              actions: [
                iconBtn(
                    MaterialCommunityIcons.clipboard_text,
                    color: Colors.white,
                    onPressed: (){
                      Clipboard.setData(ClipboardData(text: str.toString()));
                      BotToast.showText(text: "错误堆栈已拷贝");
                    }
                ),

                iconBtn(
                    MaterialCommunityIcons.close_box_outline,
                    // tooltip: "关闭",
                    color: Colors.redAccent,
                    onPressed: (){
                      cancel?.call();
                    }
                ),
                // iconBtn(
                //     MaterialCommunityIcons.close_box_outline,
                //     tooltip: "Pop关闭",
                //     color: Colors.redAccent,
                //     onPressed: (){
                //       cancel?.call();
                //       Navigator.pop(context);
                //     }
                // ),

                SizedBox(width: 6,),
              ]
          );

          return Dialog(child: child);
        }
    );
    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    //     var con = Container(
    //       child: SingleChildScrollView(child:Text( str .toString(),style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))),
    //     );
    //     var child = ThemeCenter.block(
    //         width: width,
    //         height :height,
    //         headTitle: headTitle??"",
    //         child: con,
    //         actions: [
    //           iconBtn(
    //               MaterialCommunityIcons.close_box_outline,
    //               color: Colors.redAccent,
    //               onPressed: (){
    //               }
    //           )
    //         ]
    //     );
    //     // return child;
    //     return Dialog(child: child);
    //   },
    // );
  }

  // static showBotDialog(dynamic errorInfo,{String title = "", List<Widget> actions}){
  //
  //
  //
  //   BotToast.showWidget(toastBuilder: (cFun){
  //     StringBuffer str = StringBuffer() ;
  //     if (errorInfo is List<dynamic>){
  //       for(var l in errorInfo) {
  //         str.writeln(l.toString());
  //       }
  //     }
  //     if (errorInfo is String){
  //       str.writeln(errorInfo);
  //     }
  //     var con = Container(
  //
  //       child: SingleChildScrollView(child:Text( str .toString(),style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))),
  //     );
  //     if (actions == null) actions = List<Widget>();
  //     actions.add(
  //         ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
  //             color: Colors.redAccent,
  //             onPressed: (){
  //               cFun?.call();
  //             }
  //         )
  //     );
  //     var child =  ThemeCenter.block(
  //       headTitle: title,
  //       child: con,
  //       actions: actions,
  //     );
  //     return child;
  //   });
  //   // showDialog(
  //   //   context: context,
  //   //   barrierDismissible: true,
  //   //   builder: (BuildContext context) {
  //   //     StringBuffer str = StringBuffer() ;
  //   //     if (errorInfo is List<dynamic>){
  //   //       for(var l in errorInfo) {
  //   //         str.writeln(l.toString());
  //   //       }
  //   //     }
  //   //     var con = Container(
  //   //       child: SingleChildScrollView(child:Text( str .toString(),style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))),
  //   //     );
  //   //     var child = ThemeCenter.area(
  //   //         child: con
  //   //     );
  //   //     return Dialog(child: child);
  //   //   },
  //   // );
  // }

  static raiseErrorDialog(BuildContext context , dynamic errorInfo){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        StringBuffer str = StringBuffer() ;
        if (errorInfo is List<dynamic>){
          for(var l in errorInfo) {
            str.writeln(l.toString());
          }
        }
        var con = Container(
          child: SingleChildScrollView(child:Text( str .toString(),style:ThemeCenter.mainTextStyle(step: 7,fontSize: 12))),
        );
        var child = ThemeCenter.area(
          child: con
        );
        return Dialog(child: child);
      },
    );
  }

  static Widget roundRect({Widget child , bool useShadow = true , Color borderColor = Colors.indigo , Color bgColor = Colors.white , double radius = 10.0 , EdgeInsetsGeometry padding , double height , double width , double borderWidth = 0.5,}){
    var dc = new BoxDecoration(
        border: borderWidth>0?new Border.all(color: borderColor, width: borderWidth):null,
        color :bgColor,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: useShadow?[ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)]:null,
        borderRadius: borderWidth>0?new BorderRadius.circular((radius)):null,
    );
    return Container(
      decoration: dc,
      height: height,
      width: width,
      padding: padding,
      child: child,
    );
  }

  ThemeCenter(ThemeData sysTheme , String name , {Color inMainTextColor = Colors.white , Color  inAreaBorderColor = Colors.black}){
    ///name
    name = name;
    ///text
    mainTextColor = sysTheme.textTheme.bodyText1.color;
    _mainTextStepColors = List<Color>();
    for(int i = 0 ; i <=10 ; ++i){
      var clr = CommonUtil.alphaColorD(inMainTextColor, i * (0.1));
      _mainTextStepColors.add(clr);
    }

    ///area border color
    areaBorderColor = inAreaBorderColor;
    // print(areaBorderColor);
    _sysTheme = sysTheme;
  }


  static ThemeCenter activeTheme ;


}