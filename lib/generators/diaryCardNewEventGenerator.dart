import 'package:dbt4c_rebuild/dataHandlers/diaryCardDataHandler.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/helpers/dCardSlider.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:flutter/services.dart';

abstract class Diarycardneweventgenerator {
  static Map<String,TextEditingController> textEditingControllers = {};
  static Map<String,bool> chipData = {};

  static void getTextEditingControllers(){
    for(String key in DiaryCardDataHandler.eventTextFieldData.keys){
      textEditingControllers.putIfAbsent(key, () => TextEditingController());
    }
  }

  static Future<List<Widget>> contentcardGenerator(String? date, String? primaryKey) async {
    getTextEditingControllers();
    await DiaryCardDataHandler.loadDiaryEventEntry(primaryKey!);
    print(DiaryCardDataHandler.eventTextFieldData.length);
    List<Widget> output = [];
    for(var contentCard in ConfigHandler.dCardEventContentCards){
      List<Widget> children = [];
      for (var item in contentCard['items'] ?? []) {
        print(DiaryCardDataHandler.eventTextFieldData[item["id"]]);
        if (item['type'] == 'slider') {
          children.add(DiaryCardSlider(
            initSliderValue: (DiaryCardDataHandler.sliderData[item["id"]] ?? 0).toDouble(),
            sliderText: item['label'],
            fontSize: 16,
            onChanged: (double val){
              DiaryCardDataHandler.sliderData[item["id"]] = val.round();
              DiaryCardDataHandler.saveDiaryCardEvent(date!, primaryKey);
            },
          ));
        } else if (item['type'] == 'textfield') {
          textEditingControllers[item["id"]]?.text = DiaryCardDataHandler.eventTextFieldData[item["id"]]!;
          print(textEditingControllers[item["id"]]?.text);
          children.add(Text(item["label"],
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333F49))));
          children.add(TextField(
              cursorColor: Colors.white,
              controller: textEditingControllers[item["id"]],
              onChanged: (txt){
                DiaryCardDataHandler.eventTextFieldData[item["id"]] = txt;
                DiaryCardDataHandler.saveDiaryCardEvent(date, primaryKey);
              },
              maxLines: item['maxLines'] != null ? int.tryParse(item['maxLines'].toString()) : null,
              minLines: item['minLines'] != null ? int.tryParse(item['minLines'].toString()) : null,
              maxLength: item['maxchars'] != null ? int.tryParse(item['maxchars'].toString()) : null,
          ));
        }
      }
      output.add(ContentCard(doubleX: 1.1, children: children,));
    }
    return output;
  }

}