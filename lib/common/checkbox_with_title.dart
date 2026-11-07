//@dart=2.11
import 'package:flutter/material.dart';
class CheckboxWithTitle extends StatefulWidget {
   bool value;
   String title;
   TextStyle style;
   ValueChanged<bool> onChanged;
  CheckboxWithTitle({Key key,
    this.value = false,
    this.title = "",
    this.style,
    this.onChanged,
  }) : super(key: key); 

  @override
  _CheckboxWithTitleState createState() => _CheckboxWithTitleState();
}

class _CheckboxWithTitleState extends State<CheckboxWithTitle> {
  //bool value = false;
 // @override
//  void initState() {
 //   value = widget.value;
    //super.initState();
 // }
  @override
  Widget build(BuildContext context) {
    return Row(

      children: [
        Text(widget.title , style: widget.style,),
        Container(
          width: 26,
          height: 24,
          child: Center(
            child:  Checkbox(
              // key:ValueKey(Uuid().v4()),
              activeColor: Colors.green,
              value: widget.value,
              onChanged: (v){
                setState(() {
                  widget.value = v;
                });

                widget.onChanged?.call(v);
              },
            ),
          ),
        ),

      ],
    );
  }
}