import 'package:dbt4c_rebuild/widgets/booleanSelectionChip.dart';
import 'package:dbt4c_rebuild/widgets/wrapCard.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/dataHandlers/dataHandler.dart';


class ChipPanel extends StatefulWidget {
  final double doubleX;
  final String? text;
  final List<String> keys;
  final DataHandler dataHandler;
  final String? primaryKey;
  const ChipPanel({super.key, this.doubleX  = 1.1, this.text, required this.dataHandler, required this.keys,required this.primaryKey});
  

  @override
  _ChipPanelState createState() => _ChipPanelState();
}

class _ChipPanelState extends State<ChipPanel> {

  List<Widget> generateChildren(){
    List<Widget> output = [];
    for (var key in widget.keys) {
      output.add(
          BooleanSelectionChip(
            text: key,
            icon: Icons.check_box_outline_blank,
            onChanged: (bool){
              widget.dataHandler.getBooleanData()[key] = bool;
              widget.dataHandler.saveData(widget.primaryKey!);
              },
            iconPressed: Icons.check_box_outlined,
            isPressed: widget.dataHandler.getBooleanData()[key]! == true,
          )
      );
    }
    return output;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return WrapCard(
        doubleX: widget.doubleX,
        text: widget.text != null ? widget.text! : "",
        children: generateChildren());
  }
}