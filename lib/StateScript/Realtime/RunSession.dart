//@dart=2.11


import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/protos/transition.pb.dart';
// import 'package:statemachine/statemachine.dart';
import 'package:udp/udp.dart';
import 'package:path/path.dart' as PathUtil;

typedef void CmdSolver(OPack pack);
class RunSession {

  static RunSession _instance ;
  UDP receiver;
  UDP sender ;
  bool _isRunning = false;
  bool _isSaveRunningResult = false;

  bool remoteIsPlaying = false;

  bool inStepping = false;
  String currentBreakPoint;
  bool isBreakPointActive = false;
  bool isStepMode = false;
  bool isFocusFrameMode = false;
  bool isShowVars = false;

  bool isFocusStateMode = false;

  bool get isRunning => _isRunning??false;

bool get isSaveRunningResult =>_isSaveRunningResult;
  set isSaveRunningResult(bool v){
    _isSaveRunningResult = v;
  }

  bool _isEditorMode = false;
  bool get isEditorMode => _isEditorMode??false;
  set isEditorMode(bool v){
    _isEditorMode = v;
  }

  static RunSession get instance  {
    if (_instance == null){
      _instance = RunSession();

    }
    return _instance;
  }

  // Machine _machine;
  RunSession(){
    // initMachine();
  }

//   CmdSolver _solver ;
//   Map<String , State> _states = Map<String , State>();
//   void initMachine(){
//     _machine = Machine();
//     var startState = _machine.newState();
//     {
//       var name = 'waitUnity';
//       var state = _machine.newState(name);
//       state.onEntry(waitUnityEntry);
//       _states[name] = state;
//     }
//
//     {
//       var name = 'running';
//       var state = _machine.newState(name);
//       state.onEntry(runningEntry);
//       _states[name] = state;
//     }
//
//     _machine.start();
// //    _states["waitUnity"].enter();
//   }
  /// running
  ///
  Map<int , ONodeState> activeNodeStates = Map<int , ONodeState>();
  Map<String , int> prtTriggerCount = Map<String , int>();
  Map<String , int> prmTriggerCount = Map<String , int>();

  Map<String , bool> prtFlashing = Map<String , bool>();
  Map<String , bool> prmFlashing = Map<String , bool>();
  String activeScriptName = "";
  int activeScriptId = -1 ;
  void runningSolver(OPack pack){
//     if (pack.type == PackType.nodeStates){
//       NodeStates ns = NodeStates.fromJson(pack.parseJson());
//       activeScriptName = ns.scriptName;
//       activeNodeStates.clear();
//       for(var n in ns.nodes){
//         activeNodeStates[n.id] = n;
//       }
//
//       if (!_isEditorMode){
//         EventCenter.eventBus.fire(GlobalRefreshEvent());
//       }
//     }
//     if (pack.type == PackType.unityEmptyScript){
//       activeScriptName = "";
//       activeNodeStates.clear();
//       if (!_isEditorMode){
//         EventCenter.eventBus.fire(GlobalRefreshEvent());
//       }
//     }
//
//     if (pack.type == PackType.unityReady){
// //      _states["running"].enter();
//     }
  }
  // void runningEntry(){
  //   print("enter running");
  //   _solver = runningSolver;
  //
  // }

  /// waitUnity
  // void waitUnitySolver(OPack pack){
  //   // if (pack.type == OPackType.unityReady){
  //   //   _states["running"].enter();
  //   // }
  //   // if (pack.type == OPackType.unityConnect){
  //   //   _states["running"].enter();
  //   // }
  // }
  // void waitUnityEntry(){
  //   // print("enter waitUnity");
  //   // _receiveMaxId = 0;
  //   // sendData(PackType.requestReload);
  //   // _solver = waitUnitySolver;
  // }

  // void sendData(PackType tp , {dynamic obj}){
  //   JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  //   String json = obj!= null?encoder.convert(obj):"";
  //   APack pk = new APack();
  //   pk.type = tp;
  //   pk.data = json;
  //   String sdata = encoder.convert(pk);
  //   sender.send(sdata.codeUnits, Endpoint.unicast(InternetAddress('127.0.0.1'),port: Port(65001)));
  // }

  static int _receiveMaxId = 0;
  Future start() async{
    activeScriptName = "";
    activeScriptId = -1;
    activeNodeStates.clear();
//     sender = await UDP.bind(Endpoint.any());
//     receiver = await UDP.bind(Endpoint.any(port: Port(65002)));
//
//     bool listenResult = await receiver.listen((datagram) {
//       var str = String.fromCharCodes(datagram.data);
// //      print("receive $str");
//       processCommand(str);
//     });
//     print("listen result $listenResult");
//     _states["waitUnity"].enter();
    _isRunning = true;
    EventCenter.eventBus.fire(GlobalRefreshEvent());
  }

  void processCommand(String data){
//     var mp = jsonDecode(data);
//     var apack = APack.fromJson(mp);
// //    print("${apack.guid} $_receiveMaxId");
//     if (apack.type == PackType.unityConnect) {
//       _receiveMaxId = 0;
//     }
//     if (apack.guid <= _receiveMaxId) return ;
//     _receiveMaxId = max(apack.guid , _receiveMaxId);
//     _solver?.call(apack);
  }



  void stop(){
//    print("stop");
//     if (receiver == null) return ;
//     receiver.close();
//     sender.close();
//     sender = null;
//     receiver = null;
    if(isSaveRunningResult){
      sendDebugInfoData();  
      return;
    } 
    activeScriptName = "";
    activeScriptId = -1;
    activeNodeStates.clear();
    _isRunning = false;
    EventCenter.eventBus.fire(GlobalRefreshEvent());
  }

  void clear(){
    activeScriptName = "";
    activeScriptId = -1;
    activeNodeStates.clear();
    _isRunning = false;
    EventCenter.eventBus.fire(GlobalRefreshEvent());
  }

  bool isActive(int exportId) {
    if (activeNodeStates == null) return false;
    var n = activeNodeStates[exportId];
    if (n == null) return false;
    return n.isActive;
  }

  bool isFlashing(int exportId) {
    if (activeNodeStates == null) return false;
    var n = activeNodeStates[exportId];
    if (n == null) return false;
    return n.flashing;
  }
    bool isEndNode(int exportId) {
    if (activeNodeStates == null) return false;
    var n = activeNodeStates[exportId];
    if (n == null) return false;
    return n.isEndNode;
  }

  // bool isOutFlashing(int exportId) {
  //   if (activeNodeStates == null) return false;
  //   var n = activeNodeStates[exportId];
  //   if (n == null) return false;
  //   return n.outFlashing;
  // }

  // int getTriggerCount(int exportId){
  //   if (activeNodeStates == null) return 0;
  //   var n = activeNodeStates[exportId];
  //   if (n == null) return 0;
  //   return n.triggerCount;
  // }

  String getInParamRealTimeValue(int exportId , int paramId){
    if (activeNodeStates == null) return null;
    var n = activeNodeStates[exportId];
    if (n == null||n.inParamValues==null) return null;
    // print("paramId = ${paramId} , ${n.inParamValues}");
    var res = n.inParamValues[paramId];

    return res;
  }

  String getNodeDebugString(int exportId){
    if (activeNodeStates == null) return null;
    var n = activeNodeStates[exportId];
    if (n == null) return null;
    // print("exportId = ${exportId} , ${n.inParamValues}");
    var res = n.debugInfo;
    return res;
  }

  void flushModify() {
    // sendData(PackType.requestReload);
    Transport.instance.sendUdpData(OPackType.O2U_ReloadScript, null);
  }

  void sendRuntimeRefreshNodeData(int scriptHash , int  nodeIndex , StateScriptNode node) {



    if (ScriptInfo.current.scriptData.nodeAddDelete){
      BotToast.showText(text: "检测到存在结点添加删除，请尝试刷新整个脚本");
      return;
    }
    StateScript.exportingScript = ScriptInfo.current.scriptData;
    if (StateScript.exportingScript == null){
      BotToast.showText(text: "当前脚本无效，无法实时修改参数到Unity");
      return;
    }

    StateScriptProject.instance.debugExport = true;
    try {
      StateScript.exportingScript.prepareBinaryExport();
      print("----- send node data 1");
      var nd = NodeDataRTRefresh();
      ByteDataWriter bw = ByteDataWriter();
      print("----- send node data 2");
      node.export(bw);
      // print("----- send node data 3");
      nd.scriptHashId = scriptHash;
      print("----- refresh ${node.exportId}");
      nd.nodeIndex = node.exportId;
      nd.data = bw.toBytes();
      print("----- send node data");
      Transport.instance.sendUdpData(OPackType.O2U_RTRefreshNodeData, nd);
    }
    catch(e){
      BotToast.showText(text: "尝试实时修改Unity运行数据是失败，请尝试刷新整个脚本");
      return;
    }
  }
  void sendDebugInfoData() {
    BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_debug");
    var nd = DebugInfos();
    print("-------------------------- 自动聚焦 ${ScriptInfo.current.exportId}");
    nd.debugScriptGuids.add(ScriptInfo.current.exportId??0);
    // for(var si in StateScriptProject.instance.scripts){
    //   if (si.debugFocus){
    //     nd.debugScriptGuids.add(si.guid.hashCode);
    //   }
    //
    //   if (si.stepDebug){
    //     nd.stepDebugScriptGuids.add(si.guid.hashCode);
    //   }
    // }
    Transport.instance.sendUdpData(OPackType.O2U_DebugInfos, nd);
  }


  void sendEmptyDebugInfoData() {

    var nd = DebugInfos();
    // nd.debugScriptGuids.add();
    // for(var si in StateScriptProject.instance.scripts){
    //   if (si.debugFocus){
    //     nd.debugScriptGuids.add(si.guid.hashCode);
    //   }
    //
    //   if (si.stepDebug){
    //     nd.stepDebugScriptGuids.add(si.guid.hashCode);
    //   }
    // }
    Transport.instance.sendUdpData(OPackType.O2U_DebugInfos, nd);
  }

  void sendClearBreakPoint(){
    Transport.instance.sendUdpData(OPackType.O2U_ClearBreakPoints, null);
  }

  void sendDebugForward() {
    // var nd = DebugBlocked();
    // nd.isBlocked = false;
    Transport.instance.sendUdpData(OPackType.O2U_StepForward, null);
  }

  void sendDebugForwardAndStop() {
    // var nd = DebugBlocked();
    // nd.isBlocked = false;
    Transport.instance.sendUdpData(OPackType.O2U_StepForwardAndStop, null);
  }

  void sendDebugMode(bool block) {
    var nd = DebugBlocked();
    nd.isBlocked = block;
    Transport.instance.sendUdpData(OPackType.O2U_StepMode, nd);
  }

  void sendAddBreakPoint(String bpKey){
    if (!remoteIsPlaying) return;
    var bp = BreakPoint();
    bp.breakPointKey = bpKey;
    Transport.instance.sendUdpData(OPackType.O2U_AddBreakPoint, bp);
  }

  void sendRemoveBreakPoint(String bpKey){
    if (!remoteIsPlaying) return;
    var bp = BreakPoint();
    bp.breakPointKey = bpKey;
    Transport.instance.sendUdpData(OPackType.O2U_RemoveBreakPoint, bp);
  }

  void sendActiveBreakPoint(bool active){
    if (!remoteIsPlaying) return;
    Transport.instance.sendUdpData(active?OPackType.O2U_EnableBreakPoints:OPackType.O2U_DisableBreakPoints, null);
  }

  void sendStepMode(bool active){
    if (!remoteIsPlaying) return;
    Transport.instance.sendUdpData(active?OPackType.O2U_FrameStepMode:OPackType.O2U_ExitFrameStepMode, null);
  }

  void sendFrameMode(bool active){
    if (!remoteIsPlaying) return;
    Transport.instance.sendUdpData(active?OPackType.O2U_FocusFrameMode:OPackType.O2U_ExitFocusFrameMode, null);
  }

  void sendReFreshFunction(String path) {
    var nd = RefreshFunction();
    nd.path = path;
    Transport.instance.sendUdpData(OPackType.O2U_RefreshFunction, nd);
  }

  void sendRuntimeRefreshScriptData(ScriptInfo tgtScript) {
    // sendData(PackType.requestReload);
    // print(sendRuntimeRefreshNodeData);
    if (tgtScript.exportId == null) return ;
    StateScriptProject.instance.debugExport = true;

    var nd = ScriptDataRTRefresh();
    ByteDataWriter bw = ByteDataWriter();
    var script = tgtScript.scriptData;
    StateScript.exportingScript = script;

    script.prepareBinaryExport();

    var oldCurrent = ScriptInfo.current;
    ScriptInfo.setCurrentOnly(tgtScript);

    var binaryVersionCode = 0;
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    var savePath = PathUtil.join(basePath, "BinaryVersionCode.txt");
    // Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
    if(File(savePath).existsSync()){
      var code = File(savePath).readAsStringSync();
      binaryVersionCode = int.tryParse(code);

      if (binaryVersionCode == null){
        binaryVersionCode = 0;
        return;
      }
    }

    bw.writeUint32(binaryVersionCode , "binary version code : $binaryVersionCode");
    script.export(bw , hash: tgtScript.guid.hashCode);
    nd.scriptHashId = tgtScript.exportId;//.guid.hashCode;
    nd.data = bw.toBytes();

    // File("c:/text.log").writeAsStringSync(bw.debugOut.join("\n"));
    // Transport.instance.sendUdpData(OPackType.O2U_SigleObject, info);
    Transport.instance.sendUdpData(OPackType.O2U_RTRefreshScriptData, nd);
    tgtScript.scriptData.nodeAddDelete = false;
    ScriptInfo.setCurrentOnly(oldCurrent);


    for(var s in StateScriptProject.instance.scripts){
      if (s.scriptData == null){
        s.loadScript();
      }

      for(var subs in s.scriptData.subScripts){
        // print("---------------------- ${subs.scriptId} ${tgtScript.guid}");
        if (subs.scriptId == tgtScript.guid){

          s?.scriptData?.loadSubScripts(s?.guid);
          s?.scriptData?.initConnectionCount();

          sendRuntimeRefreshScriptData(s);

          break;
        }
      }
    }
  }


//Runtime通知节点输出信息
void sendRuntimeLogNodePortData(int nodeScriptId, int nodeExportId, bool needLog)
{
    var data = OT_LogNodePortData(scriptId: nodeScriptId, nodeExportId : nodeExportId,needLog: needLog);
    Transport.instance.sendUdpData(OPackType.O2U_LOG_NODE_PORT_DATA, data);
}


  Map<int , ONodeState> lastNodeStates = Map<int , ONodeState>();

  void receiveData(ONodeStates nodeStates) {
    // print("--------------- receiveData(ONodeStates nodeStates)");

    activeScriptId = nodeStates.id;
    lastNodeStates.clear();
    for(var key in activeNodeStates.keys){
      lastNodeStates[key] = activeNodeStates[key];
    }
    activeNodeStates.clear();

    prtTriggerCount = nodeStates.prtTriggerCount;
    prmTriggerCount = nodeStates.prmTriggerCount;

    prtFlashing = nodeStates.prtFlashing;
    prmFlashing = nodeStates.prmFlashing;

    //设置 timeline 光标
    EventCenter.eventBus.fire(TimelineCursorRefresh()..time = nodeStates.timelineTime);

    for(var n in nodeStates.nodes){
      activeNodeStates[n.id] = n;
      
      if (!_isEditorMode){
        var nOld = lastNodeStates[n.id];
        if (nOld == null){
          EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..exportId = n.id);
          continue;
        }

        if (nOld.isActive != n.isActive ||nOld.flashing != n.flashing ){
          EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..exportId = n.id);
        }

        if(n.isEndNode !=  nOld.isEndNode)
         EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..exportId = n.id);
      }

    }

    var varsDatas = nodeStates.varData;
    EventCenter.eventBus.fire(VarsDataRefreshEvent()..varData = varsDatas);


    if (!_isEditorMode){
      // EventCenter.eventBus.fire(GlobalRefreshEvent());
      EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    }
  }
}