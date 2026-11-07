//@dart=2.11


import 'package:battlepus/common/EventCenter.dart';
class CallbackHistory{
  String id;
  dynamic onUndo;
  dynamic onRedo;
}
class HistoryManager {

  final LIST_MAX = 64;
  List undoList = List();
  List redoList = List();
  dynamic _onRecord;
  dynamic _onUndo;
  HistoryManager(onRecord , onUndo){
    _onRecord = onRecord;
    _onUndo = onUndo;
  }

  void appendHistory({String guid}){
    if (undoList.length>0 && guid != null) {
      var last = undoList.last;
      if (!(last is CallbackHistory) && last["guid"] == guid){
        return;
      }
    }
    // Map<String, dynamic> tmp = obj.toJson();
    var tmp = _onRecord?.call();
    if (guid!= null){
      tmp["guid"] = guid;
    }
    if (tmp!= null) {
      undoList.add(tmp);
    }

    while (undoList.length > LIST_MAX){
      undoList.removeAt(0);
    }

    EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
  }

  void appendCallbackHistory(String id , onUndo , onRedo){

    if (undoList.length>0) {
      var last = undoList.last;
      if (last is CallbackHistory && last.id == id) {
        last.onRedo = onRedo;
        return;
      }
    }

    var tmp = CallbackHistory()..id = id..onUndo =onUndo .. onRedo = onRedo;
    undoList.add(tmp);

    while (undoList.length > LIST_MAX){
      undoList.removeAt(0);
    }

    EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
  }

  dynamic undo(){
    if (undoList.length<=0) return null;
    var tmp = undoList.last;

    if (tmp is CallbackHistory){
      undoList.removeLast();
      tmp.onUndo?.call();
      redoList.add(tmp);
      EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
      EventCenter.eventBus.fire(TimelineCursorInit());
      return;
    }

    var tmpRedo = _onRecord?.call();
    redoList.add(tmpRedo);


    var res = _onUndo?.call(tmp);
    undoList.removeLast();
    EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
    EventCenter.eventBus.fire(TimelineCursorInit());
    return res;
  }

  dynamic redo(){
    if (redoList.length<=0) return null;
    var tmp = redoList.last;

    if (tmp is CallbackHistory){
      redoList.removeLast();
      tmp.onRedo?.call();
      undoList.add(tmp);
      EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
      EventCenter.eventBus.fire(TimelineCursorInit());

      return;
    }

    var tmpUndo = _onRecord?.call();
    undoList.add(tmpUndo);


    var res = _onUndo?.call(tmp);
    redoList.removeLast();
    EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
    EventCenter.eventBus.fire(TimelineCursorInit());
    return res;
  }
  void clear(){
    redoList.clear();
    undoList.clear();
    EventCenter.eventBus.fire(HistoryRefreshEvent()..manager = this);
  }
  static HistoryManager scriptHistory;
  static HistoryManager functionHistory;
  static HistoryManager tempTranslateHistory;

  void setCallback( record, undo,  ) {
    _onRecord = record;
    _onUndo = undo;
  }
  // static HistoryManager get scriptHistory {
  //   // if (_scriptHistory == null) _scriptHistory = new HistoryManager();
  //   return _scriptHistory;
  // }
  // HistoryManager scriptHistory;

}