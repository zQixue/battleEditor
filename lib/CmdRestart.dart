
import 'dart:async';
import 'dart:io';
// import 'package:cli_util/cli_logging.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:path/path.dart';
import 'package:system_tasks_dart/system_tasks_dart.dart';

// late Logger logger;
void main(List<String> args) async {
  // logger = Logger.standard() ;
  var dirName = dirname(Platform.resolvedExecutable);
  var launcherPath = PathUtil.join(dirName , "battleEditor.exe");

  // var tasks =  await SystemTasks.tasks();
  // tasks.forEach((element) {
  //   logger.stdout(element.p.toString());
  // });

  var task = await SystemTasks.getRunningTaskByPath(launcherPath);

  if (task != null){
    // logger.stdout("launcher is running , kill it! ${task.pid}");

    // String command ='taskkill /PID ${task.pid} /F';
    // await runExecutableArguments(command, []);


    // var selfTask = await SystemTasks.getRunningTaskByPath(Platform.resolvedExecutable);
    // String command ='taskkill /PID ${task.pid} /FI PID ne ${selfTask!.pid} /F';
    // var prms = [
    //   "/PID" ,
    //   "${task.pid}",
    //   "/FI",
    //   "PID ne ${selfTask!.pid}",//命令中有空格，必须放 [] list
    //   "/F",
    //   "/T",
    // ];
    // logger.stdout(command);
    // await runExecutableArguments("taskkill", prms);
    // if (selfTask == null){
    //   await task.kill();
    // }
    // else{
    //   await task.killExcept(selfTask!.pid);
    // }

    await task.kill(killChildren: false);

  }

  await Future.delayed(const Duration(seconds: 2));

  // logger.stdout("rerun launcher!");
  var workingDirectory = dirname(launcherPath);
  var exeName = basename(launcherPath);
  Process.start(exeName, ["restart"], runInShell: false , workingDirectory: workingDirectory ,mode: ProcessStartMode.detached);
}