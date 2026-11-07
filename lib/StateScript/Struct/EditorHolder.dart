//@dart=2.11

import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:uuid/uuid.dart';

class EditorHolder
{
  Widget widget ;
  double height = 0 ;
  double width = 0;
}

class EditorLevelInfo
{
  String guid;
  int level = 0;
  double spaceStep = 0;
  int deltaLevel = 0;
  double fontSize;
  bool isCircle = false;

  double fullHeight = 0;

  String openGuid = "";

  Map<String, bool> openedMap;
//
//  Map<String, int> levelMap;
//
  Map<String, bool> circleStack = Map<String, bool>();
//  List<String> circleStack ;//= List<String>();

  double lineWidth;

  double lineHeight;
  FieldInfo fi;
  StateScriptNode node;
  int lineCount = 1;
  bool isModule = false;
  bool isObjectTableMode = false;
  String varType;
  String lastVarTypeGuid;
  FieldValueHolder fieldValueHolder;
  dynamic onFocus;
  SSCanvasViewState graph;
  EditorLevelInfo(){
    guid = Uuid().v4();
  }
}