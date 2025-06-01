import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:flutter/services.dart';

import 'layoutGenerator.dart';

abstract class Diarycardneweventgenerator {

  static Future<List<Widget>> buildDiaryCardNewEventLayout(String? date, String? primaryKey, context) async {
    final yamlString = await rootBundle.loadString(
        'lib/settings/DiaryCard/DiaryCardNewEventBlueprint.yaml');
    ConfigHandler.diaryCardEventDataHandler.textFieldData["date"] = date!;
    await ConfigHandler.diaryCardEventDataHandler.loadData(primaryKey!);
    return await LayoutGenerator.buildBlueprint(date, primaryKey, context, ConfigHandler.diaryCardEventDataHandler, yamlString);
  }


}