//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/services/keyboard_key.dart';
import 'package:battlepus/common/EventCenter.dart' as EVC;

class KeyEventCenter{

  static RawKeyEvent _keyEvent;
  static Map<int , bool> _downFlags = Map<int , bool>();
  static void updateKeyState(RawKeyEvent ke){

    _keyEvent = ke;

    var lk = ke.logicalKey;

    bool isKeyDown = _keyEvent.isKeyPressed(lk);
    if (_downFlags[lk.keyId]==null||_downFlags[lk.keyId]==false){
      if (isKeyDown){
        EVC.EventCenter.eventBus.fire(EVC.KeyEvent()..event = ke ..key=lk);
      }
    }

    _downFlags[lk.keyId] = isKeyDown ;

  }

  static bool isShiftPressed(){
    if (_keyEvent == null) return false;
    return _keyEvent.isShiftPressed;
  }

  static bool isControlPressed(){
    if (_keyEvent == null) return false;
    return _keyEvent.isControlPressed;
  }

  static bool isAltPressed(){
    if (_keyEvent == null) return false;
    return _keyEvent.isAltPressed;
  }

  static void clearKey(LogicalKeyboardKey delete) {
    _downFlags[delete.keyId] = false;
  }
}