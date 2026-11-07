//@dart=2.11

import 'dart:io';

// import 'package:file_chooser/file_chooser.dart';
import 'package:file_picker/file_picker.dart';

class FileUtils {
  static Future<String> pickPath({String initDir}) async {
    String selectedDirectory = await FilePicker.platform.getDirectoryPath(initialDirectory: initDir);
    return selectedDirectory;
  }

  static Future<String> pickFile(String label , List<String> extensions , {String initDir}) async {
    if (true){//(Platform.isIOS || Platform.isAndroid){
      var f = await FilePicker.platform.pickFiles(
        initialDirectory :initDir ,
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: extensions,
      );
      if (f == null) return null;
      return f.count>0?f.paths[0]:null;
    };
  }

  static Future<String> saveFile(String label , List<String> extensions,  {String initDir}) async {
    if (true){//(Platform.isIOS || Platform.isAndroid){
      var f = await FilePicker.platform.pickFiles(
        initialDirectory :initDir ,
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: extensions,
      );
      return f.count>0?f.paths[0]:null;
    };
  }

  static void ClearDirectory(String path){
    var dir = Directory(path);

    if (!dir.existsSync()) return ;
    var newdir = dir.absolute;
    try{
      dir.deleteSync(recursive: true);
      newdir.createSync(recursive: true);
    }
    catch(e){}
  }

  static void clearDirectoryFiles(String path){
    var dir = Directory(path);

    if (!dir.existsSync()) return ;
    var fs = dir.listSync(recursive: true);
    for(var f in fs){
      if (f is File){
        f.deleteSync();
      }
    }
  }

  static void tryCreateDirectory(String path){
    var dir = Directory(path);
    if (dir.existsSync()) return ;
    dir.createSync(recursive: true);
  }

}