//@dart=2.11
 


import 'package:battlepus/StateScript/Struct/CodeDataExporter.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';


class BinaryExporter{
  void export(ByteDataWriter bw){
//    final writer = new ByteDataWriter();
  }
}


class OutPortLinkData implements BinaryExporter , CodeDataExporter{
  int connectionId;
  int outNodeId;
  int outPortId;

  int inNodeId;
  int inPortId;

  StateScriptNode outNode;
  StateScriptNode inNode;

  OutPort outPort;
  InPort inPort;

  @override
  void export(ByteDataWriter bw) {
    // bw.writeUint32(connectionId , "connection id");
    bw.writeUint32(inNodeId , "node id");
    bw.writeUint32(inPortId , "port id");
  }

  @override
  exportCodeData({int hash}) {
    return {'nodeId' : inNodeId , 'portId':inPortId , 'outNodeId' : outNodeId , "outPortId" : outPortId};
  }
}

class OutPortData implements BinaryExporter , CodeDataExporter{
  int exportId;
  List<OutPortLinkData> links = new List<OutPortLinkData>();

  @override
  void export(ByteDataWriter bw) {
    // bw.writeUint32(links.length>0 ?links[0].outPortId:0,"op id");
    bw.writeUint32(links.length ,"op link count");
    bw.pushIdentLevel();

    for(var l in links){
      // print("${l.inNodeId} , ${l.inPortId}");
      l.export(bw);
    }
    bw.popIdentLevel();
  }

  void addLink(int iNodeIndex, int iInPortId,int iOutNodeIndex, int iOutPortId , int connectionId , StateScriptNode outNode ,StateScriptNode inNode , OutPort op , InPort ip) {
    if (links == null){
      links = List<OutPortLinkData>();
    }

    var l = OutPortLinkData();
    l.inNodeId = iNodeIndex;
    l.inPortId = iInPortId;

    l.outNodeId = iOutNodeIndex;
    l.outPortId = iOutPortId;
    l.connectionId = connectionId;
    l.outNode = outNode;
    l.inNode = inNode;

    l.outPort = op;
    l.inPort = ip;
    links.add(l);

  }

  @override
  exportCodeData({int hash}) {
    List<dynamic> o = List<dynamic>();
    for(var l in links){
      o.add(l.exportCodeData());
    }

    return o;
  }

}

class InParamData implements BinaryExporter , CodeDataExporter{
  int connectionId;
  int nodeId;
  int outParamId;

  int inNodeId;
  int inParamId;

  StateScriptNode outNode;
  StateScriptNode inNode;

  OutParam outParam;

  InParam inParam;

  @override
  void export(ByteDataWriter bw) {
    bw.pushIdentLevel();
    bw.writeInt32(nodeId , "node id");
    print("outParamId = $outParamId");
    bw.writeUint32(outParamId , "param id");
    // bw.writeUint32(connectionId , "connection id");
    bw.popIdentLevel();
  }

  @override
  exportCodeData({int hash}) {
    return {'nodeId' : nodeId , 'paramId':outParamId , "inNodeId" : inNodeId , "inParamId" : inParamId};
  }
}