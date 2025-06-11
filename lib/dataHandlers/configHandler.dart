//import 'package:dbt4c_rebuild/dataHandlers/skillProtocollDataHandler.dart';
import 'package:dbt4c_rebuild/dataHandlers/skillProtocollDataHandler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:dbt4c_rebuild/dataHandlers/diaryCardDataHandler.dart';
import 'diaryCardEventDataHandler.dart';
import 'package:dbt4c_rebuild/helpers/DebugPrint.dart';

abstract class ConfigHandler {

  static List<String> dCardTextFields = [];
  static List<String> dCardSliders = [];

  static List<String> dCardEventTextFields = [];
  static List<String> dCardEventSliders = [];
  static List<String> dCardEmotions = [];

  static List<String> dCardSummary = [];

  static List<String> sProtTextFields = [];
  static List<String> sProtSliders = [];

  static late DiaryCardDataHandler diaryCardDataHandler;
  static late SkillProtocollDataHandler skillProtocollDataHandler;
  static late DiaryCardEventDataHandler diaryCardEventDataHandler;


  static initDiaryCardConfig() async {
    final yamlString = await rootBundle.loadString(
        'lib/settings/DiaryCard/DiaryCardBlueprint.yaml');
    diaryCardDataHandler = DiaryCardDataHandler(
        extractTextfields(yamlString),
        extractSliders(yamlString),
        extractUniqueChips(yamlString));
    debugFinished("ConfigHandler.initDiaryCardConfig");
  }

  static initDiaryCardEventConfig() async {
    final yamlString = await rootBundle.loadString(
        'lib/settings/DiaryCard/DiaryCardNewEventBlueprint.yaml');
    diaryCardEventDataHandler = DiaryCardEventDataHandler(
        extractTextfields(yamlString),
        extractSliders(yamlString),
        extractUniqueChips(yamlString));
    debugFinished("ConfigHandler.initDiaryCardEventConfig");
  }

  static initSkillProtocollConfig() async {
    final yamlString = await rootBundle.loadString(
        'lib/settings/SkillProtocoll/SkillProtocollBlueprint.yaml');
    skillProtocollDataHandler = SkillProtocollDataHandler(
        extractTextfields(yamlString),
        extractSliders(yamlString),
        extractUniqueChips(yamlString));
    debugFinished("ConfigHandler.initSkillProtocollConfig");
  }

  static List<String> extractTextfields(String yamlString) {
    debugPrint("ConfigHandler.extractTextfields", "Extracting textfields...");
    final blueprint = loadYaml(yamlString);
    final elementList = blueprint["Layout"];

    List<String> textfields = [];

    for (final element in elementList) {
      final content = element['content'];
      if (content is YamlList) {
        for (final item in content) {
          if (item is YamlMap && (item['type'] == 'textfield' || item['type'] == 'icontextfield')) {
            final id = item['id'];
            if (id != null) {
              textfields.add(id.toString());
              debugAddElement("ConfigHandler.extractTextfields", id.toString(), "textfields");
            }
          }
        }
      }
    }

    debugPrint("ConfigHandler.extractTextfields", "Found ${textfields.length} textfields");
    return textfields;
  }

  static List<String> extractSliders(String yamlString) {
    debugPrint("ConfigHandler.extractSliders", "Extracting sliders...");
    final blueprint = loadYaml(yamlString);
    final elementList = blueprint["Layout"];

    List<String> sliders = [];

    for (final element in elementList) {
      final content = element['content'];
      if (content is YamlList) {
        for (final item in content) {
          if (item is YamlMap && item['type'] == 'slider') {
            final id = item['id'];
            if (id != null) {
              sliders.add(id.toString());
              debugAddElement("ConfigHandler.extractSliders", id.toString(), "sliders");
            }
          }
        }
      }
    }

    debugPrint("ConfigHandler.extractSliders", "Found ${sliders.length} sliders");
    return sliders;
  }

  static List<String> extractUniqueChips(String yamlString) {
    debugPrint("ConfigHandler.extractUniqueChips", "Extracting chips...");
    final blueprint = loadYaml(yamlString);
    final elementList = blueprint["Layout"];

    List<String> chipSet = [];

    for (final element in elementList) {
      if (element is YamlMap && element['type'] == 'ChipPanel') {
        final content = element['content'];
        if (content is YamlList) {
          for (final chip in content) {
            chipSet.add(chip.toString());
            debugAddElement("ConfigHandler.extractUniqueChips", chip.toString(), "chipSet");
          }
        }
      }
    }

    debugPrint("ConfigHandler.extractUniqueChips", "Found ${chipSet.length} chips");
    return chipSet.toList();
  }
}