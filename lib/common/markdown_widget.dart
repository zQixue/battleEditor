//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown_widget/markdown_widget.dart';
import 'package:battlepus/common/markdown_editor.dart';
import 'package:open_url/open_url.dart';

class MarkdownWidgetEx extends StatefulWidget {
  final String data;
  final MarkdownEditorState parent;
  MarkdownWidgetEx({Key key , this.data,  this.parent}) : super(key: key);

  @override
  MarkdownWidgetState createState() => MarkdownWidgetState();
}

class MarkdownWidgetState extends State<MarkdownWidgetEx> {
//  StreamSubscription<RefreshMarkdownEvent> _lis;


  ScrollController controller;
  @override
  void dispose() {
    controller?.dispose();
    // TODO: implement dispose
    super.dispose();
//    _lis?.cancel();
  }

  @override
  void initState() {
    controller = ScrollController();

    // TODO: implement initState
    super.initState();

//    _lis = EventCenter.eventBus.on<RefreshMarkdownEvent>().listen((event) {
//      setState(() {
//
//      });
//    });
  }

  String data ;

  @override
  Widget build(BuildContext context) {

//     var md = MarkdownWidget(
//         data: data == null||data.isEmpty ?widget.data:data ,
// //          controller: controller,
//         styleConfig: StyleConfig(
//             markdownTheme: MarkdownTheme.darkTheme,
//             pConfig: PConfig(
// //                linkStyle: TextStyle(...),
//                 onLinkTap: (url){
//                   _launchURL(url);
//                 }
//             )
//         ),
//
//     );
    var md = Markdown(
      // controller: controller,
      selectable: true,
      data: data == null||data.isEmpty ?widget.data:data,
    );
    if (widget.parent != null) widget.parent.mdWidget = this;
    return md;
    return null;
  }

  _launchURL(String url) async {

    final result = await openUrl(url);
    if (result.exitCode == 0) {
      print("URL should be open in your browser");
    } else {
      print("Something went wrong (exit code = ${result.exitCode}): "
          "${result.stderr}");
    }
  }
}