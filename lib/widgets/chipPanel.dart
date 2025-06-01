import 'package:dbt4c_rebuild/widgets/booleanSelectionChip.dart';
import 'package:dbt4c_rebuild/widgets/wrapCard.dart';
import 'package:flutter/material.dart';

class ChipPanel extends StatefulWidget {
  final double doubleX;
  final String text;
  Map<String,bool> chips;
  ValueChanged<String>? onChanged;
  ChipPanel({super.key, this.doubleX  = 1.1, required this.text, required this.chips, this.onChanged});
  

  @override
  _ChipPanelState createState() => _ChipPanelState();
}

class _ChipPanelState extends State<ChipPanel> {
  List<Widget> generateChildren(){
    List<Widget> output = [];
    for (var key in widget.chips.keys) {
      output.add(
          BooleanSelectionChip(
            text: key,
            icon: Icons.check_box_outline_blank,
            onChanged: (bool){
              widget.chips[key] = bool;
              widget.onChanged!(key);
              },
            iconPressed: Icons.check_box_outlined,
            isPressed: widget.chips[key]! == true,
          )
      );
      //print("adding chip: $key = ${chipStates[key] == "true"}");
    }
    return output;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return WrapCard(
        doubleX: widget.doubleX,
        text: widget.text,
        children: generateChildren());
  }
}