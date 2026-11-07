//@dart=2.11
import 'package:flutter/material.dart';

class IntSlider extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final dynamic onChanged;
  IntSlider({Key key,
    this.onChanged,
    this.value,
    this.max,
    this.min
  }) : super(key: key);

  @override
  _IntSliderState createState() => _IntSliderState();
}

class _IntSliderState extends State<IntSlider> {
  int crtV;
  @override
  void initState() {
    crtV = widget.value;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (crtV == null) crtV = widget.min;

    if (crtV < widget.min)  crtV = widget.min;
    if (crtV > widget.max)  crtV = widget.max;

    var slider = Slider(
      // label: "$crtV",
      activeColor: Colors.green,
      min: widget.min.toDouble(),
      max:widget.max.toDouble(),
      value: crtV.toDouble(),
      onChanged: (v){
        setState(() {
          crtV = v.floor();
          // print("slider ${widget.min} ${widget.max} ${v}");
          widget.onChanged?.call(crtV);
        });
      },
    );

    return Row(
      children: [
        Container (

          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(4, 0.5, 4, 2),
          decoration: BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1),
              // color : Colors.grey,
              //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
              // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
              borderRadius: new BorderRadius.circular((6)),
          ),
          width: 40,
          height : 20,
          // child : IntEditor(
          //   initValue: crtV,
          //   noBorder: true,
          //   textStyle: TextStyle(fontSize: 14 , color: Colors.white , fontWeight: FontWeight.w300),
          //   onChanged: (v){
          //     setState(() {
          //       crtV = v;
          //       if (crtV < widget.min)  crtV = widget.min;
          //       if (crtV > widget.max)  crtV = widget.max;
          //       // print("slider ${widget.min} ${widget.max} ${v}");
          //       widget.onChanged?.call(crtV);
          //     });
          //   },
          // ),
          child : Text("$crtV",
            style: TextStyle(fontSize: 12 , color: Colors.white , fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(child:slider),
      ],
    );
  }
}