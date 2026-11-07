//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/entry_button.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    SSUserData.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicText(
              "battleEditor",
              style: NeumorphicStyle(
                depth: 2,
                color: Colors.blue,
                shadowLightColor: Colors.lightBlue,
                shadowDarkColor: Colors.black,
              ),
              textStyle: NeumorphicTextStyle(
                fontSize: 72,
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            EntryButton(
              size: 100,
              icon: Icon(
                Icons.account_tree,
                color: Colors.blue,
              ),
              title: "战斗编辑器",
              onClick: () {
                Navigator.pushReplacementNamed(context, "/StateScriptMain");
              },
            ),
          ],
        ),
      ),
    );
  }
}
