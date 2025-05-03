import 'package:dbt4c_rebuild/dataHandlers/diaryCardDataHandler.dart';
import 'package:dbt4c_rebuild/helpers/diaryCardEventDisplay.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/helpers/dCardSlider.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';

import '../helpers/diaryCardEventList.dart';
import '../screens/diaryCardNewEvent.dart';

abstract class DiaryCardGenerator{


  static Map<String,DiaryCardEventDisplay> eventDisplays = {};
  static Map<String,TextEditingController> textEditingControllers = {};
  static TextEditingController date = TextEditingController();


  static void getTextEditingControllers(){
    for(String key in DiaryCardDataHandler.textFieldData.keys){
      textEditingControllers.putIfAbsent(key, () => TextEditingController());
    }
  }


  static Future<List<Widget>> contentcardGenerator(String date) async {
    await DiaryCardDataHandler.loadDiaryEntry(date);
    getTextEditingControllers();
    List<Widget> output = [];
    for(var contentCard in ConfigHandler.dCardContentCards){
      List<Widget> children = [];
      for (var item in contentCard['content_card_items'] ?? []) {
        if (item['type'] == 'slider') {
          children.add(DiaryCardSlider(
            initSliderValue: (DiaryCardDataHandler.sliderData[item["id"]] ?? 0).toDouble(),
            sliderText: item['label'],
            fontSize: 16,
            onChanged: (double val){
              DiaryCardDataHandler.sliderData[item["id"]] = val.round();
              DiaryCardDataHandler.saveDiaryEntry(date);
            },
          ));
        } else if (item['type'] == 'textfield') {
          textEditingControllers[item["id"]]?.text = DiaryCardDataHandler.textFieldData[item["id"]]!;
          children.add(Text(item["label"],
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333F49))));
          children.add(TextField(
              cursorColor: Colors.white,
              controller: textEditingControllers[item["id"]],
              onChanged: (txt){
                DiaryCardDataHandler.textFieldData[item["id"]] = txt;
                DiaryCardDataHandler.saveDiaryEntry(date);
              }
          ));
        }
      }
      output.add(ContentCard(doubleX: 1.1, children: children,));
    }
    return output;
  }

  static Future<List<Widget>> buildDiaryCardLayout(String date, context) async {
    textEditingControllers["dailyGoal"]?.text = DiaryCardDataHandler.textFieldData["dailyGoal"]!;
    textEditingControllers["weeklyGoal"]?.text = DiaryCardDataHandler.textFieldData["weeklyGoal"]!;
    List<Widget> children = [Padding(padding: EdgeInsets.all(10))];
    children.add(ContentCard(
      doubleX: 1.1,
      children: [
        TextField(
          controller: DiaryCardGenerator.date,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              icon: Icon(Icons.calendar_today_outlined),
              hintText: date
          ),
          enabled: false,
        ),
        TextField(
            cursorColor: Colors.white,
            controller: textEditingControllers["dailyGoal"],
            decoration: InputDecoration(
                icon: Icon(Icons.assignment_rounded),
                hintText: "Tagesziel"
            ),
            onChanged: (txt) {
              DiaryCardDataHandler.textFieldData["dailyGoal"] = txt;
              DiaryCardDataHandler.saveDiaryEntry(date);
            }
        ),
        TextField(
            cursorColor: Colors.white,
            controller: textEditingControllers["weeklyGoal"],
            decoration: InputDecoration(
                icon: Icon(Icons.assignment_turned_in_rounded),
                hintText: "Wochenziel"
            ),
            onChanged: (txt) {
              DiaryCardDataHandler.textFieldData["weeklyGoal"] = txt;
              DiaryCardDataHandler.saveDiaryEntry(date);
            }
        ),
      ],
    ));
    children.add(DiaryCardEventList(date: date));
    children.add(SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width / 1.1,
      child: Padding(padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//
            Expanded(
              child: OutlinedButton(
//
                onPressed: () {
                  DiaryCardDataHandler.initEventTextFieldData();

                  //Der Primary key wird aus datum und index zusammengesetzt.
                  //sollte die gewählte bezeichnung bereits vergeben sein wird der counter erhöht.
                  //todo: primaryKey hashfunktion machen
                  String primaryKey = date + eventDisplays.length.toString();
//
                  //Öffnet den Screen DiaryCardNewEvent mit dem eben generierten PrimaryKey als Parameter,
                  //wodurch das neue event diesen bekannten key auch zum speichern in die Diary Card benutzt.
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      DiaryCardNewEvent(
                        primaryKey: primaryKey,
                        date: date,
                      )
                  )
                  );
//
                  //Fügt dem eventData String den PrimaryKey des neuen Events hinzu.
                  DiaryCardDataHandler.saveDiaryCardEvent(date, primaryKey);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Color.fromRGBO(255, 255, 255, .2),
                  ),
                ),
//
                child: Text("Ereignis hinzufügen",
                    style: TextStyle(fontSize: 16, color: Color(0xFF333F49))),
              ),
            ),
          ],
        ),
      ),
    ));
    for(var child in await contentcardGenerator(date)){
      children.add(child);
    }
    return children;
  }
}

