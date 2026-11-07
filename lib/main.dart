//@dart=2.11
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/rendering.dart';

// import 'package:catcher/core/catcher.dart';
// import 'package:catcher/handlers/console_handler.dart';
// import 'package:catcher/mode/dialog_report_mode.dart';
// import 'package:catcher/model/catcher_options.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/behavic_agent_type_view.dart';
import 'package:battlepus/common/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:battlepus/CodeBlocky/function_editor_view.dart';
import 'package:battlepus/ObjectTable/clazz_define_page.dart';
import 'package:battlepus/ObjectTable/enum_define_page.dart';
import 'package:battlepus/ObjectTable/object_table_main.dart';
import 'package:battlepus/ObjectTable/object_table_setting.dart';
import 'package:battlepus/StateScript/EnumTypePage/enum_type_page.dart';
import 'package:battlepus/StateScript/NodeEditor/node_define_page.dart';
import 'package:battlepus/StateScript/ScriptChooser/script_list_view.dart';
import 'package:battlepus/StateScript/project_exporter_page.dart';
import 'package:battlepus/StateScript/project_import_page.dart';
import 'package:battlepus/StateScript/state_script_main.dart';
import 'package:battlepus/StateScript/state_script_setting_page.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter/foundation.dart'; //show kIsWeb;
import 'package:universal_platform/universal_platform.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'StateScript/select_script_module_view.dart';
import 'dart:ui' as ui;
// import 'package:logger/logger.dart';

/// Flutter 3.7 的 Tooltip 在所属子树销毁/重建时序中可能对已卸载的 Theme 元素
/// 调用 Theme.of，抛出 "Null check operator used on a null value"（栈顶为 TooltipState.build）。
/// 这是框架层的卸载竞态，不影响功能，这里识别后只记录日志，不弹错误框。
bool _isTooltipTeardownError(String text) {
  return text.contains("TooltipState.build") &&
      text.contains("Null check operator used on a null value");
}

Future _initLS() async {
//  Hive.registerAdapter(AddResSettingAdapter());
//  Hive.registerAdapter(ADirectoryAdapter());
//  Hive.registerAdapter(AFileAdapter());
//
//  Hive.registerAdapter(PackageCompareSettingAdapter());
//   Hive.registerAdapter(TokenAdapter());
//   var path = GlobalBoard.getWorkingPath();
//   Hive.init(path);

//  await LocalStorage.init();
//  Setting.load();
}

void _init() async {
  // 添加此行以覆盖默认关闭处理程序
  BattlePusGlobal.deviceId = BattlePusGlobal.getUserName().trim();
  await windowManager.setPreventClose(true);
  // setState(() {});
}

void main(List<String> args) async {
  // 在整个应用中禁用语义功能（无障碍功能）

   //args = ['multi_window', '1', '{"route":"/StateScriptMain"}', 'exportScript'];
  BattlePusGlobal.autoExportStateScript = args.contains("exportScript");
  BattlePusGlobal.isRestart = args.contains("restart");
  BattlePusGlobal.openStateScript = args.contains("openStateScript");
  WidgetsFlutterBinding.ensureInitialized();
  RendererBinding.instance.setSemanticsEnabled(false);
  debugPrint('Accessibility enabled: ${ui.PlatformDispatcher.instance.accessibilityFeatures.boldText}');
  // 临时禁用辅助功能层事件分发
  ui.PlatformDispatcher.instance.onSemanticsEnabledChanged = null;

  
  // 禁用Flutter 3.3.0的调试网格覆盖层
  debugPaintSizeEnabled = false;


  DesktopMultiWindow.setMethodHandler(BattlePusGlobal.handleMethodCallback);
  if (args.length > 0 && args[0] == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty ? const {} : jsonDecode(args[2]) as Map<String, dynamic>;
    BattlePusGlobal.windowId = windowId;
    BattlePusGlobal.windowController = WindowController.fromWindowId(windowId);
    MyApp.setMultiWindowInitialRoute(argument["route"] ?? "/");
    // runApp(_ExampleSubWindow(
    //   windowController: WindowController.fromWindowId(windowId),
    //   args: argument,
    // ));
  } else {
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      // size: Size(800, 600),
      center: true,
      title: "战斗编辑器",
      // backgroundColor: Colors.transparent,
      // skipTaskbar: false,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    await _init();
  }

  BattlePusGlobal.prefs = await SharedPreferences.getInstance();

  // var logger = Logger(
  //   printer: PrettyPrinter(),
  // );
  // var loggerNoStack = Logger(
  //   printer: PrettyPrinter(methodCount: 0),
  // );
  // logger.d('Log message with 2 methods');
  //
  // loggerNoStack.i('Info message');
  //
  // loggerNoStack.w('Just a warning!');
  //
  // logger.e('Error! Something bad happened', 'Test Error');
  //
  // loggerNoStack.v({'key': 5, 'value': 'something'});
  //
  // Logger(printer: SimplePrinter(colors: true)).v('boom');

  // TableManager.initReaders();
  // var tbl = TableManager.getTable("H:/ShowMessage.csv");
  // TableManager.writeTable(tbl, "H:/ShowMessage2.csv");
  // var l = TableManager.getTable("H:/mlml/Assets/Document/AllLanguageCN.csv");
  // // print(l);
  // TableManager.writeTable(l, "H:/mlml/Assets/Document/AllLanguageCN2.csv");
  // print(ZhCnUtils.isCnZnChar('好'));
  // var zhCnUtils = ZhCnUtils('你好,Light Hello,亮');
  // print(zhCnUtils.isAllChZnInStr());
  // print(zhCnUtils.isHaveChZnInStr());
  // print(zhCnUtils.getLenIsZhCnInStr());
  // print(zhCnUtils.getLenInStrByZhCn());
  // print(zhCnUtils.getLenInStrByNotZhCn());
  // print(zhCnUtils.getZhCnList());
//  Future.delayed(Duration.zero).then((finish) async {
//    if (Platform.isWindows) {
//      // * FULL SCREEN
//      PlatformWindow window = await getWindowInfo();
//      setWindowFrame(Rect.fromLTWH(0, 0, window.screen.visibleFrame.width, window.screen.visibleFrame.height));
//    }
//  });

  // var str = "⁣UI_BattleTimeB_PM";
  // print("str length : ${str.length}");
  // print(str.codeUnitAt(0));
  // str = str.trim();
  // print("str length trim : ${str.length}");
  // print(str.codeUnitAt(0));
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {}

  Directory appDocDir = await getApplicationDocumentsDirectory();
  print(appDocDir.path);
  GlobalBoard.docDir = appDocDir;

  if (!kIsWeb) {
    var exePath = PathUtil.dirname(Platform.resolvedExecutable);
    Directory.current = Directory(exePath);

    GlobalBoard.tryLoadRelativeWorkingPath();
    await _initLS();
  }
//  Size uiSize = Size(1920/2.0, 1080/2.0);

//  if(kIsWeb){// && UniversalPlatform.isAndroid || UniversalPlatform.isIOS){
//    runFxApp(MyApp(), uiSize: uiSize);
//    return;
//  }

  // /// STEP 1. Create catcher configuration.
  // /// Debug configuration with dialog report mode and console handler. It will show dialog and once user accepts it, error will be shown   /// in console.
  // CatcherOptions debugOptions =
  // CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  //
  // // /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  // // CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
  // //   EmailManualHandler(["support@email.com"])
  // // ]);
  //
  // /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  // Catcher(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: debugOptions);

  // var clipb =           ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
  //     color: Colors.redAccent,
  //     onPressed: (){
  //       cFun?.call();
  //     }
  // );

  var path = PathUtil.join(GlobalBoard.docDir.path, "battlepus"); //, name+".json");
  var d = Directory(path);
  if (!d.existsSync()) d.createSync();

  FlutterError.onError = (FlutterErrorDetails details) {
    // reportErrorAndLog(details);
    var dstr = details.toString();
    if (_isTooltipTeardownError(dstr)) {
      print("已忽略 Tooltip 卸载竞态错误: ${details.exception}");
    } else if (dstr.indexOf("A RenderFlex overflowed by") < 0 && dstr.indexOf("errno = 11001") < 0 && dstr.indexOf("MissingPluginException") < 0) {
      print(details.toString());
      ThemeCenter.botRaiseDialog(
        "${details.exception.toString()}\n${details.stack.toString()}",
        headTitle: "FlutterError 出错啦",
      );
      var f = File(PathUtil.join(path, "error.log"));
      f.writeAsStringSync("${details.exception.toString()}\n${details.stack.toString()}");

      // Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZonedGuarded( () async {
    WidgetsFlutterBinding.ensureInitialized();
      runApp(MyApp());
    }, (Object e, StackTrace stack){
            var dstr = e.toString();
      // 添加对辅助功能崩溃的特殊处理
      if (_isTooltipTeardownError("$dstr\n$stack")) {
        print("已忽略 Tooltip 卸载竞态错误: ${e.toString()}");
      } else if (dstr.indexOf("A RenderFlex overflowed by") < 0 &&
          dstr.indexOf("errno = 11001") < 0 &&
          dstr.indexOf("MissingPluginException") < 0 &&
          dstr.indexOf("AXTree") < 0 &&
          dstr.indexOf("accessibility") < 0) {
        ThemeCenter.botRaiseDialog(
          "${e.toString()}\n${stack.toString()}",
          headTitle: "runApp 出错啦",
        );
        var f = File(PathUtil.join(path, "error.log"));
        f.writeAsStringSync("${stack.toString()}\n${e.toString()}");
      } else {
        // 对于辅助功能相关的错误，只记录日志，不显示对话框
        print("辅助功能相关错误已忽略: ${e.toString()}");
        var f = File(PathUtil.join(path, "accessibility_error.log"));
        f.writeAsStringSync("${DateTime.now()}: ${stack.toString()}\n${e.toString()}\n\n");
      }
    });

  // runZoned(
  //   () async {
  //     runApp(MyApp());
  //   },

  //   onError: (dynamic e, StackTrace stack) {
  //     // var details = makeDetails(obj, stack);
  //     // reportErrorAndLog(details);
  //     // dynamic e
  //     print(e.toString());
  //     print(stack.toString());
  //     var dstr = e.toString();
  //     if (dstr.indexOf("A RenderFlex overflowed by") < 0 && dstr.indexOf("errno = 11001") < 0 && dstr.indexOf("MissingPluginException") < 0) {
  //       ThemeCenter.botRaiseDialog(
  //         "${e.toString()}\n${stack.toString()}",
  //         headTitle: "runApp 出错啦",
  //       );
  //       var f = File(PathUtil.join(path, "error.log"));
  //       f.writeAsStringSync("${stack.toString()}\n${e.toString()}");
  //     }
  //   },
  // );


}

// void collectLog(String line){
//
// }
// void reportErrorAndLog(FlutterErrorDetails details){
//   details.toString();
// }
//
// FlutterErrorDetails makeDetails(Object obj, StackTrace stack){
//
// }

class MyApp extends StatelessWidget with WindowListener {
  static String _initialRoute = "/";

  // This widget is the root of your application.
  static setMultiWindowInitialRoute(String route) {
    _initialRoute = route;
  }

  static BuildContext mainContext;

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: CommonUtil.getGlobalContex(),
        builder: (_) {
          return AlertDialog(
            title: Text('确定要关闭战斗编辑器吗?'),
            actions: [
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(CommonUtil.getGlobalContex()).pop();
                },
              ),
              TextButton(
                child: Text('确定'),
                onPressed: () async {
                  try {
                    final subWindowIds = await DesktopMultiWindow.getAllSubWindowIds();
                    for (final windowId in subWindowIds) {
                      // DesktopMultiWindow.invokeMethod(
                      //   windowId,
                      //   'broadcast',
                      //   'Broadcast from main window',
                      // );
                      WindowController.fromWindowId(windowId).close();
                    }
                  } catch (e) {}

                  Navigator.of(CommonUtil.getGlobalContex()).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    windowManager.addListener(this);
    // Map<int, String> ext = Map<int, String>();
    // int crash = 0;
    // int runcount = 30000000;
    // for(int i = 0 ; i <runcount ; ++i){
    //   var uuid = Uuid().v4();
    //   var hash = uuid.hashCode;
    //   // print("哈希 id ${uuid} = ${hash}");
    //   // if (ext[hash] != null){
    //   //   print("!!! error !!! 哈希 碰撞 ${uuid} ${ext[hash]} ,  ${hash}");
    //   //   crash++;
    //   // }
    //   // ext[hash] = uuid;
    //   if (hash > 0x7FFFFFFF.toInt()){
    //     print("!!! error !!! 哈希 id 溢出 ${uuid}.hash = ${hash}");
    //   }
    // }
    //
    // print("碰撞次数  ${crash} , 百分比 ${crash*100.0/runcount}");
    mainContext = context;
    // if(true){//}kReleaseMode) {
    //   FlutterError.onError = (FlutterErrorDetails details) async {
    //     FlutterError.dumpErrorToConsole(details);
    //     // BotToast.showText(text: details.toString() , duration: Duration(hours: 1));
    //     ThemeCenter.showTextDialog(context, details.toString());
    //     Zone.current.handleUncaughtError(details.exception, details.stack);
    //   };
    // }
    // Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
    //   ThemeCenter.raiseErrorDialog(context, pair);
    // }).sendPort);
    // var d;
    // d.hh = 0;
    // 打开后直接进入脚本编辑界面（不再经过 Splash 启动页）
    _initialRoute = "/StateScriptMain";
    var initRoutes = {
      // '/': (context) => ThemeConsumer(child : Splash()),
      '/StateScriptMain': (context) => StateScriptMain(), //ThemeConsumer(child : StateScriptMain()),
      '/StateScriptSettingPage': (context) => ThemeConsumer(child: StateScriptSettingPage()),
      '/NodeDefinePage': (context) => ThemeConsumer(child: NodeDefinePage()),
      '/ScriptListView': (context) => ThemeConsumer(child: ScriptListView()),
      '/EnumTypePage': (context) => ThemeConsumer(child: EnumTypePage()),
      '/ObjectTableMain': (context) => ThemeConsumer(child: ObjectTableMain()),
      '/ObjectTableSettingPage': (context) => ThemeConsumer(child: ObjectTableSettingPage()),
      '/ClazzDefinePage': (context) => ThemeConsumer(child: ClazzDefinePage()),
      '/EnumDefinePage': (context) => ThemeConsumer(child: EnumDefinePage()),
      '/ProjectImportPage': (context) => ProjectImportPage(),
      '/ProjectExporterPage': (context) => ProjectExporterPage(),
      '/FunctionEditorView': (context) => ThemeConsumer(child: FunctionEditorView()),
      "/setting": (context) => ThemeConsumer(child: SettingPage()), //SettingPage(),
      "/BehavicAgentTypeView": (context) => ThemeConsumer(child: BehavicAgentTypeView()),
      "/SelectScriptModuleView": (context) => ThemeConsumer(child: SelectScriptModuleView()),


    };

    Widget homePage = ThemeConsumer(child: Splash());
    if (_initialRoute != "/") {
      homePage = null; //initRoutes[_initialRoute](context);
      // initRoutes.remove(_initialRoute);
    }

    var theme = AppTheme(
      id: "as_theme", // Id(or name) of the theme(Has to be unique)
      description: "", // Description of theme
      data: ThemeData(
        // Real theme data
        brightness: Brightness.dark,
        primaryColor: Color(0xFF3c3f41),
        accentColor: Color(0xFF5896a6),
        scaffoldBackgroundColor: Color(0xFF2b2b2b),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(fontSize: 16 ,color: Colors.black),
        ),
        fontFamily: UniversalPlatform.isWindows ? 'FiraCode' : null,
      ),
    );
    ThemeCenter.activeTheme = ThemeCenter(theme.data, "dark", inAreaBorderColor: Color(0xFF323232));
    // ThemeCenter.activeTheme = ThemeCenter(theme.data , "dark" , inAreaBorderColor: Color(0xFF222222));
    var app = MaterialApp(
      title: 'battleEditor',
      navigatorKey: CommonUtil.navigatorKey,
      checkerboardOffscreenLayers: false,  // 禁用调试网格
      debugShowMaterialGrid: false,        // 禁用Material网格
      builder: BotToastInit(),
      //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: _initialRoute,
      routes: initRoutes,
      debugShowCheckedModeBanner: false,
      theme: theme.data,
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or simply save your changes to "hot reload" in a Flutter IDE).
      //   // Notice that the counter didn't reset back to zero; the application
      //   // is not restarted.
      //   primarySwatch: Colors.indigo,
      //   // This makes the visual density adapt to the platform that you run
      //   // the app on. For desktop platforms, the controls will be smaller and
      //   // closer together (more dense) than on mobile platforms.
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //   fontFamily: UniversalPlatform.isWindows ? 'FiraCode' : null,
      // ),
      // theme:ThemeData.dark(),
      home: homePage,
    );

    // var theme = AdaptiveTheme(
    //   light: ThemeData(
    //     brightness: Brightness.light,
    //     primarySwatch: Colors.red,
    //     accentColor: Colors.amber,
    //   ),
    //   dark: ThemeData(
    //     brightness: Brightness.dark,
    //     primarySwatch: Colors.red,
    //     accentColor: Colors.amber,
    //   ),
    //   initial: AdaptiveThemeMode.dark,
    //   builder: (theme, darkTheme) => app,
    // );

    // return app;
    return ThemeProvider(
      defaultThemeId: "as_theme",
      themes: [theme, AppTheme.dark(), AppTheme.light()],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => app,
        ),
      ),
    );

    // return ThemeProvider(
    //   defaultThemeId: "as_theme",
    //     themes:[
    //       theme,
    //       AppTheme.dark(),
    //       AppTheme.light()
    //     ],
    //   child: ThemeConsumer(
    //     child: Builder(
    //       builder: (themeContext) => app,
    //     ),
    //   ),
    // );
    // return BotToastInit(
    //   child: app,
    // );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
