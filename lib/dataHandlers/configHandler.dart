import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:dbt4c_rebuild/dataHandlers/diaryCardDataHandler.dart';

abstract class ConfigHandler {
  static List<String> dCardTextFields = [];
  static List<String> dCardSliders = [];
  static List<String> dCardEventTextFields = [];
  static List<String> dCardEventSliders = [];
  static List<String> dCardEmotions = [];
  static List<String> dCardSummary = [];
  static List<String> sProtTextFields = [];
  static List<String> sProtSliders = [];

  static Future<void> initDiaryCardConfig() async {
    final yamlString = await rootBundle.loadString(
        'lib/settings/diaryCardSettings.yaml');
    final diaryCardSettings = loadYaml(yamlString);

    // Für die normalen Content Cards:
    for (var contentcardWrapper in diaryCardSettings['content_cards'] ?? []) {
      // Greife zuerst auf das innere Map zu:
      var contentcard = contentcardWrapper['content_card'];
      for (var item in contentcard['content_card_items'] ?? []) {
        if (item['type'] == 'slider') {
          dCardSliders.add(item['id']);
          print("added slider ${item['id']}");
        } else if (item['type'] == 'textfield') {
          dCardTextFields.add(item['id']);
          print("added textfield ${item['id']}");
        }
      }
    }

    // Für diarycardevents (Beachte: In deiner YAML-Datei heißt der Schlüssel hier "content_cards")
    // Achte außerdem auf den korrekten Schlüssel-Namen ("content_cards" statt "conten_cards").
    var events = diaryCardSettings['diarycardevents'];
    if (events != null) {
      // Perceived Emotions:
      for (var emotion in events['perceived_emotions']['emotions'] ?? []) {
        dCardEmotions.add(emotion);
        print("added emotion $emotion");
      }
      // Content Cards in diarycardevents:
      for (var eventCard in events['content_cards'] ?? []) {
        // In diesem Fall ist in der YAML-Struktur der Schlüssel "items" (nicht "content_card_items")
        for (var item in eventCard['items'] ?? []) {
          if (item['type'] == 'slider') {
            dCardEventSliders.add(item['id']);
            print("added event slider ${item['id']}");
          } else if (item['type'] == 'textfield') {
            dCardEventTextFields.add(item['id']);
            print("added event textfield ${item['id']}");
          }
        }
      }

    }
    diaryCardDataHandler.initSliderData();
    diaryCardDataHandler.initTextFieldData();
    diaryCardDataHandler.initEventChipData();
    diaryCardDataHandler.initEventTextFieldData();
  }
  static Future<void> initSkillProtocollConfig() async {
    final yamlString = await rootBundle.loadString(
        'lib/settings/skillProtocollSettings.yaml');
    final skillProtocollSettings = loadYaml(yamlString);

    for (var contentcard in skillProtocollSettings['content_cards'] ?? []) {
      for (var item in contentcard['content_card_items'] ?? []) {
        if (item['type'] == 'slider') {
          sProtSliders.add(item['id']);
        } else if (item['type'] == 'textfield') {
          sProtTextFields.add(item['id']);
        }
      }
    }
  }
}