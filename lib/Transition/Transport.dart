//@dart=2.11

import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/Struct/SSConfig.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/Transition/PackSolver.dart';
import 'package:battlepus/Transition/MapBuilderPackSolver.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:udp/udp.dart';
import 'package:jaguar/jaguar.dart';

class Transport {
  // int IN_PORT = 65102;
  // int OUT_PORT = 65101;
  // int HTTP_PORT = 65200;

  // 端口基址必须避开 Windows 动态端口范围（49152-65535），
  // 否则浏览器等程序可能把该端口当作本地临时端口占用，导致监听失败。
  int portBase = 45100;
  int mlSkillListenPortBase = 62100;
  UDP _receiver;
  UDP _sender ;
  static Transport _instance;

  bool _isRunning = false;

  bool _started = false;
  bool get isRunning => _isRunning;
  static Transport get instance {
    if (_instance == null) _instance = new Transport();
    return _instance;
  }

  PackSolver _packSolver ;
  MapBuilderPackSolver _mapBuilderPackSolver;

  void forceSolve(Uint8List data){
    if (_packSolver !=null) {
      OPack pk = OPack.fromBuffer(data);
      _packSolver.process(pk);
      if (BattlePusGlobal.windowController == null) {
        _mapBuilderPackSolver.process(pk);
      }
    }
  }

  Map id2Packs = {};

  Future start() async{
    if (_started) return ;
    _started = true;
    bool listenResult = false;
    try {
      _sender = await UDP.bind(Endpoint.any());
      _receiver = await UDP.bind(Endpoint.any(port: Port(portBase + SSConfig.instance.portGroup * 3 + 2)));
      if (_packSolver == null) _packSolver = PackSolver();
      if (_mapBuilderPackSolver == null) _mapBuilderPackSolver = MapBuilderPackSolver();
      listenResult = await _receiver.listen((datagram) {
      // var str = String.fromCharCodes(datagram.data);
      if (datagram != null) {
        // print("receive data");
        OPack pk = OPack.fromBuffer(datagram.data);

        if (pk.packCount <= 0) {
          _packSolver.process(pk);
          _mapBuilderPackSolver.process(pk);
          BattlePusGlobal.broadcast("transport", { "data": datagram.data},);
          // currentPackGuid = pk.guid;
        }
        else{
          var rec = id2Packs[pk.guid];
          if (rec == null) {
            rec = id2Packs[pk.guid] = {};
            Future.delayed(Duration(seconds: 1)).then((value) {
              id2Packs.remove(pk.guid);
            });
          }
          rec[pk.packIndex] = pk;

          if (pk.packCount <= rec.length){
            List<int> fullData = [];
            for(int i = 0 ; i <pk.packCount ;++i){
              fullData.addAll(rec[i].data);
            }

            var finalPack = rec[0];
            finalPack.data = Uint8List.fromList(fullData);
            _packSolver.process(finalPack);
            _mapBuilderPackSolver.process(finalPack);
            id2Packs.remove(pk.guid);
            // currentPackGuid = pk.guid;
          }

          BattlePusGlobal.broadcast("transport", { "data": datagram.data},);



        }
      }
      });
    } catch (e) {
      print("Transport udp start failed: $e");
    }

    if (!listenResult){
      BotToast.showText(text: "初始化udp失败");
    }else{
      BotToast.showText(text: "初始化udp成功");
    }

    if (BattlePusGlobal.windowController == null) {
      var httpPort = portBase + SSConfig.instance.portGroup * 3 + 0;
      try {
        final server = Jaguar(port: httpPort);
        // 断点信息接口，Unity 侧通过 http://127.0.0.1:{httpPort}/bp 获取
        server.get('/bp', (Context ctx) {
          // print("=============================== http receive");
          var bpJson = StateScriptProject.instance.getBreakPoints();
          return bpJson;
        });
        await server.serve();
        print("Transport http server listening on port $httpPort");
      } catch (e) {
        // 端口冲突只影响断点功能，不能阻塞编辑器打开
        print("Transport http server start failed on port $httpPort: $e");
        BotToast.showText(text: "HTTP 端口 $httpPort 启动失败，断点功能不可用");
      }
    }

    // HttpServer
    //     .bind(InternetAddress.anyIPv4, HTTP_PORT)
    //     .then((server) {
    //   server.listen((HttpRequest request) {
    //     if(request.contentLength == -1){
    //       request.response.write("error");
    //     }else{
    //       utf8.decodeStream(request).then((data){
    //         print("http request = $data");
    //       });
    //     }
    //   });
    // });

    _isRunning = listenResult;
  }

  Future<bool> sendUdpData(OPackType tp , obj) async{
    if (!_isRunning && !_started) {
      await start();
      if (!_isRunning){
        return false;
      }
    }
    if (_sender == null) return false;
    OPack pk = OPack();
    pk.type = tp;
    if (obj != null) {
      pk.data = obj.writeToBuffer();
    }
    var packData = pk.writeToBuffer();
    _sender.send(packData, Endpoint.unicast(InternetAddress('127.0.0.1'),port: Port(portBase + SSConfig.instance.portGroup * 3 + 1)));
    return true;
  }

  Future<bool> sendUdpData2MLSkill(OPackType tp , obj) async{
    if (!_isRunning && !_started) {
      await start();
      if (!_isRunning){
        return false;
      }
    }
    if (_sender == null) return false;
    OPack pk = OPack();
    pk.type = tp;
    if (obj != null) {
      pk.data = obj.writeToBuffer();
    }
    var packData = pk.writeToBuffer();
    _sender.send(packData, Endpoint.unicast(InternetAddress('127.0.0.1'),port: Port(mlSkillListenPortBase + SSConfig.instance.portGroup * 3 + 1)));
    return true;
  }
}