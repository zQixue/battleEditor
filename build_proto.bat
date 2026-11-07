@echo off
cd /d "%~dp0"

"./tools/protoc" --proto_path=./protos;./tools/include --dart_out=./lib/protos ./protos/transition.proto
if errorlevel 1 exit /b 1
echo Generated: lib/protos/transition.pb.dart
