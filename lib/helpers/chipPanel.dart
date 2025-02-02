import 'dart:collection';

import 'package:dbt4c_rebuild/helpers/booleanSelectionChip.dart';
import 'package:dbt4c_rebuild/helpers/wrapCard.dart';
import 'package:flutter/material.dart';

class ChipPanel extends StatefulWidget {
  final doubleX;
  final String text;
  final List<String> keyList;
  ValueChanged<String>? onChanged;
  late String? dataString;
  ChipPanel({super.key, required this.doubleX, required this.text, required this.keyList, String this.dataString = "", this.onChanged});
  

  @override
  _ChipPanelState createState() => _ChipPanelState();
}

class _ChipPanelState extends State<ChipPanel> {
  Map<String,String> chipStates = HashMap();

  getChipsAsString(){
    String output = "";
    for(String key in chipStates.keys){
      output = "$output$key=${chipStates[key]},";
    }
    widget.onChanged!(output);
  }

  setChipStatesFromString(String? input){
    //print("turning chip Datastring to Hashmap");
    //print("input string is: $input");
    String input0 = input!;
    //int debug = 0;
    while(input0.contains(",")){
      //debug++;
      chipStates.update(
          input0.substring(0, input0.indexOf("=") ), (oldValue) =>
          input0.substring(input0.indexOf("=") + 1, input0.indexOf(",")));
      if(input0.indexOf(",") < input0.lastIndexOf(",")){
        input0 = input0.substring(input0.indexOf(",") + 1);
        //print("$_input is left after $debug cycles");
      }
      else{
        input0 = "";
        //print("Finished with $_input after $debug cycles");
      }
    }
  }
  
  initChipMap(){
    //print("initializing fresh map");
    chipStates = HashMap();
    for (var key in widget.keyList) {
    chipStates.putIfAbsent(key, () => "false");
    //print(chipStates);
    }
  }

  List<Widget> generateChildren(){
    initChipMap();
    setChipStatesFromString(widget.dataString);
    List<Widget> output = [];
    for (var element in chipStates.keys) {
      output.add(
          BooleanSelectionChip(
            text: element,
            icon: Icons.check_box_outline_blank,
            onChanged: (bool){
              chipStates[element] = bool.toString();
              getChipsAsString();
              },
            iconPressed: Icons.check_box_outlined,
            isPressed: chipStates[element]! == "true",
          )
      );
      //print("adding chip: $element = ${chipStates[element] == "true"}");
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