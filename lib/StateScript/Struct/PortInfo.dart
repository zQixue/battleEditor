//@dart=2.11

import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutParam.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutPort.dart';

class OutPortInfo{
  StateScriptNode node;
  OutPort port;
  SubstituteOutPort sop;
  OutPortInfo(StateScriptNode n, OutPort p , SubstituteOutPort soport){
    node= n;
    port = p;
    sop = soport;
  }
}

class InPortInfo{
  StateScriptNode node;
  InPort port;

  InPortInfo(StateScriptNode n, InPort p){
    node= n;
    port = p;
  }
}

class InParamInfo{
  StateScriptNode node;
  InParam port;

  InParamInfo(StateScriptNode n, InParam p){
    node= n;
    port = p;
  }
}
class OutParamInfo{
  StateScriptNode node;
  OutParam port;
  SubstituteOutParam sop;

  OutParamInfo(StateScriptNode n, OutParam p , SubstituteOutParam subop){
    node= n;
    port = p;
    sop = subop;
  }
}