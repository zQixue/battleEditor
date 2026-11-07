//@dart=2.11

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:common_utils/common_utils.dart';
import 'package:iso/iso.dart';
import 'package:battlepus/common/IsoEx.dart';
import 'package:battlepus/common/zh_cn_utils/zh_cn_utils.dart';
import 'package:open_url/open_url.dart';
import 'package:path/path.dart' as PathUtil;
// import 'package:crclib/crclib.dart';
// import 'package:crclib/catalog.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:process_run/shell.dart';

class DartCommon{
  static String changedTimeStr(String path){
    var f= File(path);
    if (!f.existsSync()) return "0";
    return "${f.statSync().changed.millisecondsSinceEpoch}_${f.lengthSync()}";
//    var str = f.readAsBytesSync();
//    return _crc32Zlib.convert(str).toString();
  }
  // static int crc32File(String path){
  //   var f= File(path);
  //   if (!f.existsSync()) return 0;
  //   var str = f.readAsBytesSync();
  //   return _crc32Zlib.convert(str);
  // }
  //
  // static Crc32Xz _crc32Zlib = new Crc32Xz();
  // static int crc32(String str){
  //   return _crc32Zlib.convert(utf8.encode(str));
  // }
  static List<String> getFiles(String dir , String ext , {bool onlyName = false}){
    var d = Directory(dir);
    if (!d.existsSync()) return List<String>();
    var fs = d.listSync();
    var res = List<String>();
    for(var f in fs){
      if (f is File){
        if (onlyName)res.add(PathUtil.basename(f.path));
        else res.add(f.path);
      }
    }

    return res;
  }

  static List<String> getDirs(String dir , {bool onlyName = false}){
    var d = Directory(dir);
    if (!d.existsSync()) return List<String>();
    var fs = d.listSync();
    var res = List<String>();
    for(var f in fs){
      if (f is Directory){
        if (onlyName)res.add(PathUtil.basename(f.path));
        else res.add(f.path);
      }
    }
    return res;
  }

  static num fixValue(v , len){
    return NumUtil.getNumByValueDouble(v, len);
  }

  static num fixAngle(v , len){
    while(v>170){
      v-= 360;
    }
    return NumUtil.getNumByValueDouble(v, len);
  }

  static bool isEmpty(String str){
    return str == null || str.trim() == "";
  }

  static double toFloatAsFixed(double val , int fLen){
    var p = pow(10, fLen);
    var res = (val * pow(10, fLen)).round() / p;
    return res;
  }

  static List<double> listToFloatAsFixed(List<double> lst , int fLen){
    List<double> res = List<double>();
    var p = pow(10, fLen);
    lst.forEach((val) {
      var resVal = (val * pow(10, fLen)).round() / p;
      res.add(resVal);
    });
    return res;
  }


  static Map<String , dynamic> getIsolateParams(IsoRunner iso){

    var res = Map<String , dynamic>();
    if (iso == null || !iso.hasArgs) return res;
    List<dynamic> lst = iso.args;
    if (lst == null) return res;
    for(int i = 0 ; i <lst.length ; i+=2){
      if (i +1 < lst.length){
        res[lst[i]] = lst[i+1];
      }
    }
    return res;

  }

  static Future<String> getFileMD5(String filePath) async{
    var f = File(filePath);
    if (!f.existsSync()) return null;

    try {
      var md5 = crypto.md5;
      var hash = await md5.bind(f.openRead()).first;
      var ret = base64.encode(hash.bytes);
      return  ret.toString();
    } catch (exception) {
      print('Unable to evaluate the MD5 sum :$exception');
      return null;
    }

  }

  static void launchURL(String url) async {

    final result = await openUrl(url);
    if (result.exitCode == 0) {
      print("URL should be open in your browser");
    } else {
      print("Something went wrong (exit code = ${result.exitCode}): "
          "${result.stderr}");
    }
  }



  static IsoEx runIsolate( Function(IsoRunner) func , Map<String , dynamic> prms , {IsoOnData onDataOut  , IsoOnData onError}){
    IsoEx iso;

    iso = IsoEx(func , onDataOut: onDataOut , onError:onError);
    if (prms != null){
      List<dynamic> lst = List<dynamic>();
      prms.forEach((key, value) {lst.add(key);lst.add(value);});
      iso.run(lst);
    }
    else{
      iso.run([]);
    }

    return iso;
  }

  static Future<int> runIsolateAsync( Function(IsoRunner) func , Map<String , dynamic> prms , {IsoOnData onDataOut  , IsoOnData onError}) async{
    IsoEx iso;

    iso = IsoEx(func , onDataOut: onDataOut , onError:onError);
    if (prms != null){
      List<dynamic> lst = List<dynamic>();
      prms.forEach((key, value) {lst.add(key);lst.add(value);});
      await iso.run(lst);
    }
    else{
      await iso.run([]);
    }

    return 0;
  }

  static Future rmFile(String filePath) async{
    var shell = Shell(throwOnError : false  , verbose : false);
    var afile = File(filePath);
    if (afile.existsSync()){
      //for windows
      var cmd = 'del /Q "${filePath.replaceAll("/", "\\")}"';
      print(cmd);
      var res = await shell.run(cmd);
      // print(res[0].stdout.toString());
      // print(res[0].stderr.toString());
    }
  }

  static Future rmDir(String dirPath) async{
    var shell = Shell(throwOnError : false  , verbose : false);
    var adir = Directory(dirPath);
    if (adir.existsSync()){
      //for windows
      await shell.run('rmdir /Q /S "${dirPath.replaceAll("/", "\\")}"');
    }
  }


  static ATreeNode<T> buildTree<T>(List<T> srcLst , dynamic onGetTreePath){
    var _root = ATreeNode<T>();
    _root.id = "____root";
    // bool withFilter = widget.onFilter != null && _filterStr!= null && _filterStr.trim() != "";
    // var filters = withFilter?_filterStr.toLowerCase().split(RegExp(r"\s+")):[];
    // print(filters);
    var items = srcLst;
    // print(items);
    List<dynamic> lst = List<dynamic>();

    for(var item in items) {

      List<String> path = onGetTreePath?.call(item);
      lst.add(item);
      if (path == null || path.length<=0){
        path = [];
      }
      // print(path);
      var tgtPath = _root;
      var fullPath = "";
      int iLevelCount = 0;
      for(int i = 0 ; i < path.length ; ++i){
        var dir  = path [i].trim();
        if (dir.trim() == ""){
          continue;
        }
        fullPath = "$fullPath/$dir";
        var subDirs = tgtPath.children.where((element) => element.name == dir).toList();
        // print(subDir);
        var subDir;
        if (subDirs == null || subDirs.length == 0){
          // print(fullPath);
          subDir = ATreeNode<T>()..name = dir .. id =fullPath .. isLeaf = false ;
          // tgtPath.subDirs[dir] = subDir;
          tgtPath.children.add(subDir);
          // print("add $dir");
        }
        else{
          subDir = subDirs[0];
        }


        tgtPath = subDir..level = iLevelCount++;
      }

      tgtPath.children.add(ATreeNode<T>()..path = fullPath..data = item..isLeaf = true..level = iLevelCount++);
      // print("add leaf $item");
    }

    return _root;
  }

  static bool isDirValid(String path) {
    if (DartCommon.isEmpty(path)) return false;
    return Directory(path).existsSync();
  }

  static int codeUnitOfA = "A".codeUnitAt(0);
  static int char2Num(String chars){
    chars= chars.toUpperCase();
    int num = 0;
    for(var i = 0 ; i < chars.length ; ++i){
      var code = chars.codeUnitAt(i) - codeUnitOfA + (i<=chars.length-1?1:0);
      num = num * 26 + code ;
    }

    return num - 1;
  }
  static String num2Char(int num){
    String res = "";
    // num += 1;
    while(num >=0){
      var y = num % 26 + codeUnitOfA;
      num = num ~/ 26;
      var char = String.fromCharCode(res.length>0?y-1:y);
      res = char + res;
      if (num<=0) break;
    }

    return res;
  }

  static String getMD5(String str){
    var md5 = crypto.md5;
    var hash = md5.convert(str.codeUnits).toString();
    var md5str = hash.toString();
    return md5str;
  }

  static parseDouble(x) {
    if (x is double) return x;
    if (x is String) return double.tryParse(x)??0.0;
    if (x is int) return x.toDouble();
    return 0.0;
  }

  static parseInt(x) {
    if (x is int) return x;
    if (x is String) return int.tryParse(x)??0;
    return 0;
  }

  static List<File> getAllFiles(String path , String ext , {bool recursive = true}) {
    var dir = Directory(path);
    if (!dir.existsSync()) return null;
    List<File> res = List<File>();
    var items = dir.listSync(recursive: recursive);
    for(var f  in items){
      if (f is File && PathUtil.extension(f.path).toLowerCase() == ext){
        res.add(f);
      }
    }
    return res;
  }
}

class ATreeNode<T>{
  String id;
  String name;
  int level;
  T data;
  bool isLeaf = false;
  String path;
  List<ATreeNode<T>> children = List<ATreeNode<T>>();
}

var ch2CharLenMap = [
  2,	9,
  4,	13,
  6,	17,
  8,	23,
  10,	27,
  12,	35,
  14,	38,
  16,	44,
  18,	49,
  20,	53,
];

int getTranslateLength(String inString){
  var zhCnUtils = ZhCnUtils(inString);
  var len = zhCnUtils.getLenInStrByNotZhCn();
  for(int i = 0 ; i < 10 ; i+=2){
    if (ch2CharLenMap[i]>=len){
      return ch2CharLenMap[i+1];
    }
  }
  return (len * 2.5).ceil();
  // items[index].maxLength = zhCnUtils.getLenInStrByNotZhCn();
}
