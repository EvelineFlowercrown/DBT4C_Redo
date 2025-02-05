import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> setupDatabase() async {
  // 1. Load YAML configuration from assets.
  //    Make sure to add the YAML file to your assets in pubspec.yaml.
  final yamlString = await rootBundle.loadString('assets/diaryCardSettings.yaml');
  final config = loadYaml(yamlString);

  // 2. Extract slider and textfield IDs from the YAML.
  List<String> sliderIds = [];
  List<String> textfieldIds = [];

  for (var card in config['diary_card']) {
    for (var item in card['content_card_items']) {
      if (item['type'] == 'slider') {
        sliderIds.add(item['id']);
      } else if (item['type'] == 'textfield') {
        textfieldIds.add(item['id']);
      }
    }
  }

  // 3. Open (or create) the SQLite database.
  //    The database will be stored in the default location.
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'diary.db');
  Database db = await openDatabase(path, version: 1);

  // Helper function to retrieve existing column names for a table.
  Future<List<String>> getExistingColumns(String tableName) async {
    final List<Map<String, dynamic>> result = await db.rawQuery("PRAGMA table_info($tableName)");
    return result.map((row) => row['name'] as String).toList();
  }

  // 4. Process the "sliders" table.
  final List<Map<String, dynamic>> slidersTableInfo = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='sliders'");
  if (slidersTableInfo.isEmpty) {
    // Table does not exist, so create it with the "date" column and one INTEGER column per slider.
    List<String> columns = ['date TEXT PRIMARY KEY'];
    for (String col in sliderIds) {
      columns.add('$col INTEGER');
    }
    String createSql = "CREATE TABLE sliders (${columns.join(', ')})";
    await db.execute(createSql);
  } else {
    // Table exists: check for missing slider columns and add them if needed.
    List<String> existingColumns = await getExistingColumns('sliders');
    for (String col in sliderIds) {
      if (!existingColumns.contains(col)) {
        await db.execute("ALTER TABLE sliders ADD COLUMN $col INTEGER");
      }
    }
  }

  // 5. Process the "textfields" table.
  final List<Map<String, dynamic>> textfieldsTableInfo = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='textfields'");
  if (textfieldsTableInfo.isEmpty) {
    // Table does not exist, so create it with the "date" column and one TEXT column per textfield.
    List<String> columns = ['date TEXT PRIMARY KEY'];
    for (String col in textfieldIds) {
      columns.add('$col TEXT');
    }
    String createSql = "CREATE TABLE textfields (${columns.join(', ')})";
    await db.execute(createSql);
  } else {
    // Table exists: check for missing textfield columns and add them if needed.
    List<String> existingColumns = await getExistingColumns('textfields');
    for (String col in textfieldIds) {
      if (!existingColumns.contains(col)) {
        await db.execute("ALTER TABLE textfields ADD COLUMN $col TEXT");
      }
    }
  }

  // 6. Close the database when done.
  await db.close();
}