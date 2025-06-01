import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:dbt4c_rebuild/generators/layoutGenerator.dart';
import 'package:flutter/services.dart';


abstract class DiaryCardGenerator{

  static Future<List<Widget>> buildDiaryCardLayout(String date, context) async {
    await ConfigHandler.diaryCardDataHandler.loadData(date);
    final yamlString = await rootBundle.loadString(
        'lib/settings/DiaryCard/DiaryCardBlueprint.yaml');
    return await LayoutGenerator.buildBlueprint(date, date, context, ConfigHandler.diaryCardDataHandler, yamlString);
  }
}

