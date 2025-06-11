import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:dbt4c_rebuild/generators/layoutGenerator.dart';
import 'package:flutter/services.dart';


abstract class SkillProtocollGenerator{

  static Future<List<Widget>> buildSkillProtocollLayout(String date, context) async {
    await ConfigHandler.skillProtocollDataHandler.loadData(date);
    final yamlString = await rootBundle.loadString(
        'lib/settings/SkillProtocoll/SkillProtocollBlueprint.yaml');
    return await LayoutGenerator.buildBlueprint(date, date, context, ConfigHandler.skillProtocollDataHandler, yamlString);
  }
}

