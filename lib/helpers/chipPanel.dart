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
  ChipPanel({Key? key, required this.doubleX, required this.text, required this.keyList, String this.dataString = "", this.onChanged}) : super(key: key);
  

  @override
  _ChipPanelState createState() => _ChipPanelState();
}

class _ChipPanelState extends State<ChipPanel> {
  Map<String,String> chipStates = HashMap();

  getChipsAsString(){
    String output = "";
    for(String key in chipStates.keys){
      output = output + "$key=${chipStates[key]},";
    }
    widget.onChanged!(output);
  }

  setChipStatesFromString(String? input){
    //print("turning chip Datastring to Hashmap");
    //print("input string is: $input");
    String _input = input! + "";
    //int debug = 0;
    while(_input.contains(",")){
      //debug++;
      chipStates.update(
          _input.substring(0, _input.indexOf("=") ), (oldValue) =>
          _input.substring(_input.indexOf("=") + 1, _input.indexOf(",")));
      if(_input.indexOf(",") < _input.lastIndexOf(",")){
        _input = _input.substring(_input.indexOf(",") + 1);
        //print("$_input is left after $debug cycles");
      }
      else{
        _input = "";
        //print("Finished with $_input after $debug cycles");
      }
    }
  }
  
  initChipMap(){
    //print("initializing fresh map");
    chipStates = HashMap();
    widget.keyList.forEach((key) {
    chipStates.putIfAbsent(key, () => "false");
    //print(chipStates);
    });
  }

  List<Widget> generateChildren(){
    initChipMap();
    setChipStatesFromString(widget.dataString);
    List<Widget> output = [];
    chipStates.keys.forEach((element) {
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
    });
    return output;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return WrapCard(
        children: generateChildren(),
        doubleX: widget.doubleX,
        text: widget.text);
  }
}