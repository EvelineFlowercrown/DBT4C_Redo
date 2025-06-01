

import 'package:dbt4c_rebuild/dataHandlers/dataHandler.dart';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

import '../dataHandlers/configHandler.dart';
import '../widgets/IconTextField.dart';
import '../widgets/chipPanel.dart';
import '../widgets/contentCard.dart';
import '../widgets/dCardSlider.dart';
import '../widgets/diaryCardEventList.dart';
import '../widgets/prefilledDateField.dart';
import '../screens/diaryCardNewEvent.dart';

abstract class LayoutGenerator{

  static Map<String,TextEditingController> textEditingControllers = {};

  static void getTextEditingControllers(DataHandler dataHandler){
    for(String key in dataHandler.getTextData().keys){
      textEditingControllers.putIfAbsent(key, () => TextEditingController());
    }
  }

  static Future<List<Widget>> buildBlueprint(String date, String? primaryKey,context, DataHandler dataHandler, yamlString)async {
    getTextEditingControllers(dataHandler);
    final blueprint = loadYaml(yamlString);
    final layout = blueprint["Layout"];
    List<Widget> children = [Padding(padding: EdgeInsets.all(10))];
    for (final element in layout) {
      if (element is YamlMap && element.containsKey("type")) {
        final String type = element["type"];

        switch (type) {
          case "dCardEventList":
            children.addAll(generateEventList(date, context, dataHandler));
            break;

          case "ChipPanel":
            children.add(generateChipPanel(primaryKey, dataHandler));
            break;

          case "Contentcard":
            children.add(await generateContentCard(element, context, primaryKey, date, dataHandler));
            break;
        }
      }
    }
    return children;
  }

  static List<Widget> generateEventList(String date, context, DataHandler dataHandler){
    final List<Widget> children = [];
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
                  dataHandler.initTextData([]);

                  String primaryKey =  DateTime.now().millisecondsSinceEpoch.toString();
//
                  ConfigHandler.diaryCardEventDataHandler.textFieldData["date"] = date;
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
                  dataHandler.saveData(date);
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
    return children;
  }

  static Widget generateChipPanel(String? primaryKey, DataHandler dataHandler){
    return ChipPanel(
        text: "Wahrgenommene Emotionen",
        chips: dataHandler.getBooleanData(),
        onChanged: (String key){
          ConfigHandler.diaryCardEventDataHandler.saveData(primaryKey);
        }
    );

  }

  static generateContentCard(YamlMap contentCard, context, String? primaryKey, String date, DataHandler dataHandler) {
    final List<Widget> children = [];
    for (final item in contentCard["content"] ?? []) {
      if (item is YamlMap && item.containsKey("type")) {
        final String type = item["type"];
        switch (type) {
          case "textfield":
            textEditingControllers[item["id"]]?.text = dataHandler.getTextData()[item["id"]]!;
            children.add(Text(item["label"],
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333F49))));
            children.add(TextField(
              cursorColor: Colors.white,
              controller: textEditingControllers[item["id"]],
              onChanged: (txt){
                dataHandler.getTextData()[item["id"]] = txt;
                dataHandler.saveData(primaryKey!);
              },
              maxLines: item['maxLines'] != null ? int.tryParse(item['maxLines'].toString()) : null,
              minLines: item['minLines'] != null ? int.tryParse(item['minLines'].toString()) : null,
              maxLength: item['maxchars'] != null ? int.tryParse(item['maxchars'].toString()) : null,
            ));
            break;
          case "slider":
            children.add(DiaryCardSlider(
              initSliderValue: (dataHandler.getIntegerData()[item["id"]] ?? 0).toDouble(),
              sliderText: item['label'],
              fontSize: 16,
              onChanged: (double val){
                dataHandler.getIntegerData()[item["id"]] = val.round();
                dataHandler.saveData(primaryKey!);
              },
            ));
            break;
          case "icontextfield":
            children.add(Icontextfield(
              icon: item['icon'],
              prefill: item['prefill'],
              controller: textEditingControllers[item["id"]],
              onChanged: (String txt) {
                dataHandler.getTextData()[item["id"]] = txt;
                dataHandler.saveData(primaryKey!);
              },
            ));
            break;
          case "prefilleddatefield":
            children.add(PrefilledDateField(date: date));
            break;

        }
      }
    }
    return ContentCard(doubleX: 1.1, children: children,);
  }




}