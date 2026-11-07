import 'dart:io';
import 'package:path/path.dart' as PathUtil;
import 'package:universal_platform/universal_platform.dart';

class GlobalBoard{

  static String relativeWorkingPath = "";

  static Directory? docDir;

  static String executablePath(){
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS){
//      Directory appDocDir = await getApplicationDocumentsDirectory();
      return docDir!.path;
    }

    if (UniversalPlatform.isMacOS){
      var res = PathUtil.dirname(Platform.resolvedExecutable);
      var index = res.indexOf(r"/.*\.app");
      if (index >=0){
        return res.substring(0,index);
      }

      return res;
    }
    return PathUtil.dirname(Platform.resolvedExecutable);
  }

  static String? getWorkingPath(){
    if (relativeWorkingPath == null || relativeWorkingPath == "") return executablePath();
    var path = PathUtil.join(executablePath() , relativeWorkingPath);
//    print("path 1 $path");
    if (Directory(path).existsSync()) return path;

    var abs = Directory(relativeWorkingPath);
    if (abs.isAbsolute && abs.existsSync()) return relativeWorkingPath;

    return null;
  }

  static String getTempPath(){
    var wp = getWorkingPath();
    return PathUtil.join(wp! , "temp");
  }

  static void tryLoadRelativeWorkingPath(){
    var filePath = PathUtil.join(executablePath(),"WorkingPath");
    var f = File(filePath);
    if (!f.existsSync()) return ;
    relativeWorkingPath = f.readAsStringSync();
  }

  static bool directoryExist(String path){
    var filePath = PathUtil.join(getWorkingPath()!,path);
    var f = Directory(filePath);
    if (f.existsSync()) return true;
    var abs = Directory(path);
    if (abs.isAbsolute && abs.existsSync()) return true;
    return false;
  }

  static String? getCorrectDirectory(String path, {String? basePath}){
    if (basePath == null) basePath = getWorkingPath()!;
    var filePath = PathUtil.join(basePath,path);
    var f = Directory(filePath);
    if (f.existsSync()) {
      return PathUtil.canonicalize(filePath);
    }
    path = path.replaceAll("\\", "/");
    var abs = Directory(path);
    if (abs.isAbsolute && abs.existsSync()) return PathUtil.canonicalize(filePath);
    return null;

  }

  static String? getCorrectFile(String path, {String? basePath}){
    if (basePath == null) basePath = getWorkingPath();
    var filePath = PathUtil.join(basePath!,path);
    var f = File(filePath);
    if (f.existsSync()) {
      return PathUtil.canonicalize(filePath);
    }
    path = path.replaceAll("\\", "/");
    var abs = File(path);
    if (abs.isAbsolute && abs.existsSync()) return PathUtil.canonicalize(filePath);
    return null;

  }

  static bool tryCreateDirectory(String path , {String? basePath}){
    if (basePath == "") basePath = getWorkingPath();
    var filePath = PathUtil.join(basePath!,path);
    var f = Directory(filePath);
    if (f.existsSync()) return true;
    f.createSync(recursive: true);
    if (f.existsSync()) return true;

    var abs = Directory(path);
    if (abs.isAbsolute ) {
      if (abs.existsSync()) return true;
      abs.createSync(recursive: true);
      if (abs.existsSync()) return true;
    }

    return false;
  }

  static bool showDescription = true;





//  static bool isKeyPressed
}