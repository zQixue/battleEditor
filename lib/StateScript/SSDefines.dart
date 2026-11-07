//@dart=2.11

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';

class SSDefines{
  static const double fieldIconSize = 16;
  // static int interfaceMaxCount = 8;
  static const double nodeWidth = 200;
  static const double editFactor = 1.5;
  static const double innerHPadding = 4;
  static const double nodeHeight = 160;
  static const double nodeHeaderHeight = 22;
  static const double nodePortHeight = 16;
  static const double nodeParamHeight = 16;
  static const double nodeInParamHeight = 16;


  static const double portSize = 16;
  static const double portOffX = 24;

  static const double paramSize = 18;
  static const double paramOffX = 24;

  static const double nodeTypeWidth = 100;
  static const double nodeTypeHeight = 100;

  static const double canvasWidth = 12800 * 8.0 * 4;
  static const double canvasHeight = 7200 * 8.0;

  static const double canvasZeroX = 12800 * 8.0 / 2;
  static const double canvasZeroY = 7200 * 8.0 / 2;

  static const double fixPowerX = nodeWidth/2;
  static const double fixPowerY = nodeHeight/2;

  static const double fixPosX = fixPowerX/10;
  static const double fixPosY = fixPowerY/10;

  static const double sopHeight = 38;
  static const double sopWidth = 280;

  static const double nodeFieldPanelWidth = 520;
  static const double nodeFieldPanelMaxHeight = 640;
  static const double nodeFieldRowHeight = 18;
  static const double nodeFieldNameWidth = 80;
  static const double nodeFieldHeaderHeight = nodeHeaderHeight;

  static const double connection_point_step = 4;

//  static double nodeFieldHeaderWidth = 80;

  static const double nodeFieldPanelOffX2Node = nodeWidth + portOffX + 12;
  static const double nodeFieldPanelOffY2Node = 0;

  static const double lineIconButtonWidth = 16;
  static const double lineIconButtonHeight = 20;
  static const double iconButtonSize = 18;
  static const double lineContentFontSize = 12;
  static const TextStyle lineContentStyle = TextStyle(fontSize: 12 , color: Colors.white);

  static Color breakPointColor = CommonUtil.changeColorLightness(Colors.brown, 0.5);
  static Color breakPointActiveColor = CommonUtil.changeColorLightness(Colors.purpleAccent, 0.5);
  static double breakPointSize = 12.0;

  static const double draw_port_line_off = 24;

  static bool isInDagging = false;

  static const int moduleShift = 5;
  static const int nodeCountShift = 11;

  static const double moduleOffX = 64;
  static const double moduleOffY = 32;
  static const double moduleHeadHeight = 28;

  static String focusNodeType;

  static bool isNodeRef = false;

  static Widget IBC({Widget child , double width , double height}){
    return Container(
      padding: EdgeInsets.all(0),
      width: width??lineIconButtonWidth,
      height: height??lineIconButtonHeight,
      child:child
    );
  }

  static int searchSubIndx = 0;
  static int lastEnumValue = 0;
}

enum InterfaceType {
  InPort,
  OutPort,
  InParam,
  OutParam,
}

Widget emptySOP = Container();

class SSCategory
{
  String id;
  String name;
  IconData icon;
  Color color;

  static List<SSCategory> categories = [
    SSCategory()..id = "default"..name = "未指定"..icon = FontAwesome.question..color = Colors.blueGrey,
    SSCategory()..id = "level"..name = "关卡逻辑"..icon = FontAwesome.fort_awesome..color = Colors.green,
    SSCategory()..id = "player"..name = "角色"..icon = MaterialIcons.face ..color = Color(0xFF6699CC),
    SSCategory()..id = "daemon"..name = "怪物"..icon = MaterialCommunityIcons.ghost ..color = Color(0xFF996699),
    SSCategory()..id = "skill"..name = "技能"..icon = FontAwesome.gamepad..color = Colors.red,
    SSCategory()..id = "bullet"..name = "子弹"..icon = FontAwesome.rocket..color = Color(0xFFCC6666),
    SSCategory()..id = "ai"..name = "AI逻辑"..icon = MaterialCommunityIcons.robot..color = Colors.indigo,
    SSCategory()..id = "tutorial"..name = "新手教程"..icon = FontAwesome.hand_o_up..color = Colors.deepPurple,
    SSCategory()..id = "flow"..name = "流程"..icon = FontAwesome.sitemap..color = Color(0xFFFF9999),
  ];
}