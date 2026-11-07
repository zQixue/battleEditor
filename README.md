# battleEditor

战斗编辑器（Flutter Windows 桌面应用），启动后直接进入 StateScript 战斗脚本编辑界面，并保留对象表、脚本导入/导出等战斗制作链路。

## 环境

- Flutter 3.7.3（工程内 `.fvmrc` 已固定版本）
- Visual Studio 2022（含“使用 C++ 的桌面开发”）
- 可使用 FVM：`fvm use 3.7.3`

## 构建

```bat
rem Flutter 已在 PATH 时：
build_windows.bat

rem 使用指定 SDK 时：
set FLUTTER_BIN=F:\sdk\flutter\bin\flutter.bat
build_windows.bat
```

脚本会依次执行：

1. `flutter pub get`
2. `flutter build windows --release`
3. 复制 `tools/CoolFormat.exe` 到输出目录（导出 C# 代码时用于格式化）
4. 编译 `lib/CmdRestart.dart` 为 `restart.exe`（编辑器检测到工程外部变化后的“重启”功能）

产物：`build/windows/runner/Release/battleEditor.exe`

## 命令行导出

```bat
battleEditor.exe multi_window 1 "{\"route\":\"/StateScriptMain\"}" exportScript
```

导出依赖工程中配置的模板目录，以及输出目录旁的 `CoolFormat.exe`。

## 目录说明

- `lib/main.dart`：应用入口（窗口、路由、命令行参数）
- `lib/StateScript/`：战斗脚本编辑器与导出逻辑
- `lib/ObjectTable/`：对象表（战斗数据）
- `lib/CodeBlocky/`：函数/代码块编辑器
- `lib/common/`、`lib/Transition/`：公共组件与数据打包
- `lib/protos/`：protobuf 生成代码（源文件在 `protos/transition.proto`）
- `logger/`：本地日志上报包
- `tools/`：protoc 与 CoolFormat 工具

原工程中的 UIMaker、WWiseTool、MultiLans、TableSyncer、TableDiffer、TemplateTranslater、XmlSyncer、PackageCompare、PerformanceReporter、AddResManager 等独立工具模块已移除，仅保留战斗编辑器运行与导出所需代码。
