//@dart=2.11

import 'package:lua_dardo/lua.dart';
import 'package:lua_dardo/src/state/lua_state_impl.dart';

class LuaVm {
  LuaState _state;
  bool _init = false;
  static LuaVm newVm() {
    var vm = LuaVm();
    vm.init();
    return vm;
  }

  static int throwException(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var msg = args[0];
    throw Exception(msg);
    return 0 ;//TableManager.getTable(filaPath);
  }



  void init(){
    _init = false;
    _state = LuaState.newState();
    _state.openLibs();
    registerDartFunction("throwException", throwException);


  }

  void setGlobalString(String name , String str){
    _state.pushString(str);
    _state.setGlobal(name);
  }

  void setGlobalDouble(String name , double d){
    _state.pushNumber(d);
    _state.setGlobal(name);
  }

  double getGlobalDouble(String name){
    _state.getGlobal(name);
    return popDouble(_state);
  }

  void setGlobalInt(String name , int d){
    _state.pushInteger(d);
    _state.setGlobal(name);
  }

  void setGlobalBool(String name , bool b){
    _state.pushBoolean(b);
    _state.setGlobal(name);
  }

  void setGlobal(String name , dynamic dval){
    if (dval is bool) setGlobalBool(name, dval);
    else if (dval is double) setGlobalDouble(name, dval);
    else if (dval is int) setGlobalInt(name, dval);
    else if (dval is String) setGlobalString(name, dval);
    else if (dval is Map) {_setTable(dval); _state.setGlobal(name);}
    else if (dval is List) {_setList(dval); _state.setGlobal(name);}
  }
  void _setList(List lst){
    if (lst == null) return ;
    _state.newTable();
    int iCount = lst.length;
    for(int i = 0 ; i < iCount ; ++i){
    // m.forEach((key, val) {
      var val = lst[i];
      if (val is bool){
        _state.pushInteger(i+1);
        _state.pushBoolean(val);
        _state.setTable(-3);
      }
      else if (val is int){
        _state.pushInteger(i+1);
        _state.pushInteger(val);
        _state.setTable(-3);
      }
      else if (val is double){
        // print("set double $key");
        _state.pushInteger(i+1);
        _state.pushNumber(val);
        _state.setTable(-3);
      }
      else if (val is String){
        _state.pushInteger(i+1);
        _state.pushString(val);
        _state.setTable(-3);
      }
      else if (val is Map){
        _state.pushInteger(i+1);
        _setTable(val);
        _state.setTable(-3);
      }
      else if (val is List){
        _state.pushInteger(i+1);
        _setList(val);
        _state.setTable(-3);
      }
    }
  }

  static void setListTo(LuaState ls , List lst){
    if (lst == null) return ;
    ls.newTable();
    int iCount = lst.length;
    for(int i = 0 ; i < iCount ; ++i){
      // m.forEach((key, val) {
      var val = lst[i];
      if (val is bool){
        ls.pushInteger(i+1);
        ls.pushBoolean(val);
        ls.setTable(-3);
      }
      else if (val is int){
        ls.pushInteger(i+1);
        ls.pushInteger(val);
        ls.setTable(-3);
      }
      else if (val is double){
        // print("set double $key");
        ls.pushInteger(i+1);
        ls.pushNumber(val);
        ls.setTable(-3);
      }
      else if (val is String){
        ls.pushInteger(i+1);
        ls.pushString(val);
        ls.setTable(-3);
      }
      else if (val is Map){
        ls.pushInteger(i+1);
        setTableTo(ls, val);
        ls.setTable(-3);
      }
      else if (val is List){
        ls.pushInteger(i+1);
        setListTo(ls , val);
        ls.setTable(-3);
      }
    }
  }

  void pushKey(dynamic key){
    if (key is int){
      _state.pushInteger(key);
    }
    else if (key is double){
      _state.pushNumber(key);
    }
    else if (key is String){
      _state.pushString(key);
    }
    else if (key is bool){
      _state.pushBoolean(key);
    }
  }

  static void pushKeyTo(LuaState ls , dynamic key){
    if (key is int){
      ls.pushInteger(key);
    }
    else if (key is double){
      ls.pushNumber(key);
    }
    else if (key is String){
      ls.pushString(key);
    }
    else if (key is bool){
      ls.pushBoolean(key);
    }
  }

  void _setTable(Map m){
    if (m == null) return ;
    // if (!global) _state.pushString(name);
    _state.newTable();
    m.forEach((key, val) {
      if (val is bool){
        pushKey(key);
        _state.pushBoolean(val);
        _state.setTable(-3);
      }
      else if (val is int){
        pushKey(key);
        _state.pushInteger(val);
        _state.setTable(-3);
      }
      else if (val is double){
        // print("set double $key");
        pushKey(key);
        _state.pushNumber(val);
        _state.setTable(-3);
      }
      else if (val is String){
        pushKey(key);
        _state.pushString(val);
        _state.setTable(-3);
      }
      else if (val is Map){
        pushKey(key);
        _setTable(val);
        _state.setTable(-3);
      }
      else if (val is List){
        pushKey(key);
        _setList(val);
        _state.setTable(-3);
      }
    });
  }
  static void setTableTo(LuaState ls , Map m){
    if (m == null) return ;
    // if (!global) _state.pushString(name);
    ls.newTable();
    m.forEach((key, val) {
      if (val is bool){
        pushKeyTo(ls , key);
        ls.pushBoolean(val);
        ls.setTable(-3);
      }
      else if (val is int){
        pushKeyTo(ls , key);
        ls.pushInteger(val);
        ls.setTable(-3);
      }
      else if (val is double){
        // print("set double $key");
        pushKeyTo(ls , key);
        ls.pushNumber(val);
        ls.setTable(-3);
      }
      else if (val is String){
        pushKeyTo(ls , key);
        ls.pushString(val);
        ls.setTable(-3);
      }
      else if (val is Map){
        pushKeyTo(ls , key);
        setTableTo(ls,val);
        ls.setTable(-3);
      }
      else if (val is List){
        pushKeyTo(ls , key);
        setListTo(ls , val);
        ls.setTable(-3);
      }
    });
  }
  static void pushTable2Stack(LuaState s,Map m){
    if (m == null) return ;
    // if (!global) _state.pushString(name);
    s.newTable();
    m.forEach((key, val) {
      if (val is bool){
        pushKey2(s,key);
        s.pushBoolean(val);
        s.setTable(-3);
      }
      else if (val is int){
        pushKey2(s,key);
        s.pushInteger(val);
        s.setTable(-3);
      }
      else if (val is double){
        // print("set double $key");
        pushKey2(s,key);
        s.pushNumber(val);
        s.setTable(-3);
      }
      else if (val is String){
        pushKey2(s,key);
        s.pushString(val);
        s.setTable(-3);
      }
      else if (val is Map){
        pushKey2(s,key);
        pushTable2Stack(s,val);
        s.setTable(-3);
      }
      else if (val is List){
        pushKey2(s,key);
        pushList2Stack(s,val);
        s.setTable(-3);
      }
    });
  }

  static void pushList2Stack(LuaState s, List lst){
    if (lst == null) return ;
    s.newTable();
    int iCount = lst.length;
    for(int i = 0 ; i < iCount ; ++i){
      // m.forEach((key, val) {
      var val = lst[i];
      if (val is bool){
        s.pushInteger(i+1);
        s.pushBoolean(val);
        s.setTable(-3);
      }
      else if (val is int){
        s.pushInteger(i+1);
        s.pushInteger(val);
        s.setTable(-3);
      }
      else if (val is double){
        // print("set double $key");
        s.pushInteger(i+1);
        s.pushNumber(val);
        s.setTable(-3);
      }
      else if (val is String){
        s.pushInteger(i+1);
        s.pushString(val);
        s.setTable(-3);
      }
      else if (val is Map){
        s.pushInteger(i+1);
        pushTable2Stack(s,val);
        s.setTable(-3);
      }
      else if (val is List){
        s.pushInteger(i+1);
        pushList2Stack(s,val);
        s.setTable(-3);
      }
    }
  }

  static void pushKey2(LuaState s,dynamic key){
    if (key is int){
      s.pushInteger(key);
    }
    else if (key is double){
      s.pushNumber(key);
    }
    else if (key is String){
      s.pushString(key);
    }
    else if (key is bool){
      s.pushBoolean(key);
    }
  }

  void run(String code , {String filePath}){
    // if (filePath != null){
    //   (_state as LuaStateImpl)?.rootSource = filePath;
    // }
    var finalCode = code;//(requireCode??"")+"\n"+code;
    // print(finalCode);
    try{
      _state.doString(finalCode);
    }
    catch(e){
      (_state as LuaStateImpl)?.recordError();
      throw e;
    }
    // _state.call(0, 0);
  }
  void run_file(String path ){
    // if (filePath != null){
    //   (_state as LuaStateImpl)?.rootSource = filePath;
    // }
    // var finalCode = code;//(requireCode??"")+"\n"+code;
    // print(finalCode);
    try{
      _state.doFile(path);
    }
    catch(e){
      (_state as LuaStateImpl)?.recordError();
      throw e;
    }
    // _state.call(0, 0);
  }

  void runGlobalFunc(String code , String func ,{List<dynamic> prms , int iRetCount = 0}){
    var finalCode = code;//(requireCode??"")+"\n"+code;
    // print(finalCode);
    _state.doString(finalCode);

    _state.getGlobal(func);
    if(_state.isFunction(-1)){
      if (prms != null && prms.length>0){
        prms.forEach((element) {
          pushValue(element);
        });
      }
      _state.pCall(prms?.length??0, iRetCount, 0);
    }
    // _state.call(0, 0);
  }

  void runLocalFunc(String code , String func ,{List<dynamic> prms , int iRetCount = 0}){
    var finalCode = code;//(requireCode??"")+"\n"+code;
    if(_init == false){
      _state.doString(finalCode);
      _init = true;
    }
    _state.getGlobal(func);
    if(_state.isFunction(-1)){
      if (prms != null && prms.length>0){
        prms.forEach((element) {
          pushValue(element);
        });
      }
      _state.pCall(prms?.length??0, iRetCount, 0);
    }
    // _state.call(0, 0);
  }


  void pushValue(dynamic dval){
    if (dval is bool) _state.pushBoolean(dval);
    else if (dval is double) _state.pushNumber(dval);
    else if (dval is int) _state.pushInteger(dval);
    else if (dval is String) _state.pushString(dval);
    else if (dval is Map) _setTable(dval);
    else if (dval is List) _setList(dval);
  }

  static void pushValueTo(LuaState ls ,  dynamic dval){
    if (dval is bool) ls.pushBoolean(dval);
    else if (dval is double) ls.pushNumber(dval);
    else if (dval is int) ls.pushInteger(dval);
    else if (dval is String) ls.pushString(dval);
    else if (dval is Map) setTableTo(ls , dval);
    else if (dval is List) setListTo(ls , dval);
  }

  String getError(){
    var ls = _state as LuaStateImpl;
    return ls.getStackTrace();
  }

  // void popTable(){
  //   int index = _state.getTop();
  //   if(!_state.isTable(index)){
  //     throw Exception("getTable: NOT table");
  //   }
  //   _state.pushNil();
  //   while(_state.next(index)){
  //     // _state.pushValue(-2);
  //     print("${_state.toString2(-1)}");
  //     // print("${_state.toString2(-2)}");
  //     // print("${_state.toString2(-3)}");
  //     // print("${_state.toString2(-4)}");
  //
  //     _state.pop(2);
  //     print("${_state.toString2(-1)}");
  //     _state.pop(1);
  //   }
  // }

  static bool popBool(LuaState _state){
    int index = _state.getTop();
    if (_state.isBoolean(index)){
      var res = _state.toBoolean(index);
      _state.pop(1);
      return res;
    }
    throw Exception("popBool type error");
  }

  static int popInt(LuaState _state){
    int index = _state.getTop();
    if (_state.isInteger(index)){
      var res = _state.toInteger(index);
      _state.pop(1);
      return res;
    }
    throw Exception("popInt type error");
  }
  static double popDouble(LuaState _state){
    int index = _state.getTop();
    if (_state.isNumber(index)){
      var res = _state.toNumberX(index);
      _state.pop(1);

      return res;
    }
    throw Exception("popDouble type error");
  }

  Map getGlobalTable(String name){
    _state.getGlobal(name);
    return popTable(_state);
  }

  static String popString(LuaState _state){
    int index = _state.getTop();
    if (_state.isString(index)){

      var res = _state.toString2(index);
      // print("popString $res");
      _state.pop(2);
      return res;
    }
    throw Exception("popString type error");
  }

  static dynamic popNil(LuaState _state){
    int index = _state.getTop();
    if (_state.isNil(index)){
      _state.pop(1);
      return null;
    }
    throw Exception("popString type error");
  }

  static Map popTable(LuaState _state){
    int index = _state.getTop();
    if(!_state.isTable(index)){
      throw Exception("popTable: type error");
    }
    Map res = Map();
    _state.pushNil();
    while(_state.next(index)){
      var val = popDynamicStatic(_state);
      _state.pushValue(-1);
      var key = popDynamicStatic(_state);
      res[key] = val;
      // print("$key = $val");
      // print("${_state.toString2(-1)}");
      // _state.pop(1);
    }
    _state.pop(1);
    return res;
  }

  dynamic popDynamic(){
    // int index = _state.getTop();
    // if (_state.isString(index)) return popString();
    // else if (_state.isBoolean(index)) return popBool();
    // else if (_state.isNumber(index)) return popDouble();
    // else if (_state.isInteger(index)) return popInt();
    // else if (_state.isTable(index)) return popTable();
    // else if (_state.isNil(index)) return popNil();
    return popDynamicStatic(_state);
  }

  static dynamic popDynamicStatic(LuaState _state){
    int index = _state.getTop();

    if (_state.isBoolean(index)) return popBool(_state);
    else if (_state.isInteger(index)) return popInt(_state);
    else if (_state.isNumber(index)) return popDouble(_state);
    else if (_state.isTable(index)) return popTable(_state);
    else if (_state.isNil(index)) return popNil(_state);
    else if (_state.isString(index)) return popString(_state);
  }

  static List getArgs(LuaState _state , int targetCount){
    var args = [];
    // print("=================== $targetCount");
    int realCount = _state.getTop();
    // print("============== == $realCount");
    for(int i = 0 ; i < targetCount ; ++i){
      args.add(null);
    }

    for(int i = 0 ; i < realCount - targetCount; ++i){
      popDynamicStatic(_state);
    }



    for(int i = targetCount ; i>=1 ; --i){
      //print("=================== $i");
      if (i > realCount){
        args[i-1] = null;
        continue;
      }
      args[i-1] = popDynamicStatic(_state);
      //print(args[i-1] );

    }
    //print("=================== all");
    return args;
  }

  void registerDartFunction(String name , func) {
    _state.pushDartFunction(func);
    _state.setGlobal(name);
  }
}