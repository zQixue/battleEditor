//@dart=2.11

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/Struct/FieldGroup.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/ZoomCanvas.dart';

class OTDefines{
  static const double fieldIconSize = 16;
  // static int interfaceMaxCount = 8;
  static const double nodeWidth = 200;
  static const double editFactor = 1.5;
  static const double innerHPadding = 4;
  static const double nodeHeight = 200;
  static const double nodeHeaderHeight = 22;
  static const double nodePortHeight = 16;
  static const double nodeParamHeight = 16;
  static const double nodeInParamHeight = 16;


  static const double objectHeaderHeight = 40;
  static const double groupHeaderHeight = 24;

  static const double fieldViewWidth = 320;


  static const double fieldViewIntervalY = 2;

  static double fieldViewMinWidth = 24;
  static double fieldViewMinHeight = 24;

  static const double fieldHeadTitleViewHeight = 14;
  static const double fieldShowHeadTitleViewHeight = fieldHeadTitleViewHeight + 26 ;
  static const double fieldViewHeight = fieldShowHeadTitleViewHeight;

  static const double frameBorderSize = 8;
  static bool editMode = false;

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

  static const double fixPosX = 8;//fixPowerX/10;
  static const double fixPosY = 8;//fixPowerY/10;

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
  static const TextStyle lineContentStyle = TextStyle(fontSize: 12);

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

  static bool inloading = false;

  static CanvasHolder mainCanvas;

  static ObjectClazz copyObjectClazz;

  static FieldGroup crtFocusGroup;



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

  static Offset fixPosition(Offset off) {
    var x = ((off.dx ) / fixPosX).floor() * fixPosX ;//- BTDefines.nodeWidth/2 * viewZoom;
    var y  = ((off.dy )/ fixPosY ).floor()* fixPosY ;//- BTDefines.nodeHeight/2 * viewZoom;
    return Offset(x,y);
  }
}

enum DecorationType{
  label ,
  image ,
  icon ,
}

