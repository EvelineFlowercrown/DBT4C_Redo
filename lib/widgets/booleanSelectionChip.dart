import 'package:flutter/material.dart';

class BooleanSelectionChip extends StatefulWidget {
  final String text;
  bool? isPressed;
  final IconData? icon;
  final IconData? iconPressed;
  ValueChanged<bool> onChanged;
  BooleanSelectionChip ({super.key, required this.text, required this.icon, required this.iconPressed, required this.onChanged, this.isPressed});

  @override
  _BooleanSelectionChipState createState() => _BooleanSelectionChipState();
}

class _BooleanSelectionChipState extends State<BooleanSelectionChip> {
  String? text;

  @override
  void initState() {
    super.initState();
    text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.isPressed = !widget.isPressed!;
        widget.onChanged(widget.isPressed!);
        setState(() {/*print("${widget.text} is now ${widget.isPressed.toString()}");*/});
      },
      child: widget.isPressed == false
      ?Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, .2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon),
                Padding(padding: EdgeInsets.all(2)),
                Text(widget.text,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333F49)
                    )
                ),
              ],
            )
        ),
      )
      :Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, .35),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.iconPressed),
                Padding(padding: EdgeInsets.all(2)),
                Text(widget.text,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333F49)
                    )
                ),
              ],
            )
        ),
      ),
    );
  }
}
