import 'package:flutter/material.dart';

class EntryButton extends StatefulWidget {
  final String title;
  final dynamic onClick;
  final EdgeInsets padding;
  final Widget icon;
  final double size;
  EntryButton({Key? key,
    this.title = "",
    this.onClick,
    this.padding = const EdgeInsets.all(0),
    this.icon = const Icon(Icons.local_taxi_outlined),
    this.size = 160,
  }) : super(key: key);

  @override
  _EntryButtonState createState() => _EntryButtonState();
}

class _EntryButtonState extends State<EntryButton> {
  @override
  Widget build(BuildContext context) {
    var btn = IconButton(padding: widget.padding, icon: widget.icon,iconSize: widget.size, color: Colors.blue,
      // hoverColor: Colors.white,
      //   focusColor: Colors.white,
      //   highlightColor: Colors.white,
      // splashColor: Colors.white,
      onPressed: (){
        widget.onClick?.call();
      }
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: btn,
        ),
        Text(widget.title , style: TextStyle(fontSize: 16),),
      ],
    );
  }
}