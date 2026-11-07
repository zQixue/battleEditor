//@dart=2.11
 

import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/common/ListStatck.dart';

class OTGlobalBoard {

//  static ObjectClazz currentObjectClazz;

  static List<AObject> currentObjects = List<AObject>();

  static void appendFocusItem(AObject item){
    if (currentObjects.contains(item)) return;
    currentObjects.add(item);
  }

  static void removeFocusItem(AObject item){
    currentObjects.remove(item);
  }

  static void focusItem(AObject item){
    if (currentObjects.contains(item)) return ;
    if (currentObjects.length == 0){
      currentObjects.add(item);
    }
    else{
      currentObjects[0] = item;
    }
  }
  static ListStack<dynamic> actionNavigator = ListStack<dynamic>();


  static void push(obj){
    actionNavigator.push(obj);
  }

  static dynamic pop(){
    return actionNavigator.pop();
  }

  static void clear(){
    currentObjects.clear();
    actionNavigator.clear() ;
  }
}