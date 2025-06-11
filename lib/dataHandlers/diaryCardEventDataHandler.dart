import 'package:dbt4c_rebuild/dataHandlers/database.dart';
import 'package:sqflite/sqflite.dart';
import 'dataHandler.dart';
import 'package:dbt4c_rebuild/helpers/DebugPrint.dart';

class DiaryCardEventDataHandler implements DataHandler {
  Map<String, String> textFieldData = {"date": ""};
  Map<String, int> sliderData = {};
  Map<String, bool> chipData = {};

  DiaryCardEventDataHandler(List<String> textFields, List<String> sliders, List<String> chips) {
    initIntegerData(sliders);
    initTextData(textFields);
    initBooleanData(chips);
    setupDBTable();
  }

  //region getter

  @override
  Map<String, bool> getBooleanData() {
    return chipData;
  }

  @override
  Map<String, int> getIntegerData() {
    return sliderData;
  }

  @override
  Map<String, String> getTextData() {
    return textFieldData;
  }

  //endregion getter

  //region init

  @override
  initIntegerData(List<String> sliders) {
    debugCalledWithParameters("DiaryCardEventDataHandler.initIntegerData", sliders);
    if (sliders.isNotEmpty) {
      for (int i = 0; i < sliders.length; i++) {
        final field = sliders[i].toString();
        debugChangedValue("DiaryCardEventDataHandler.initIntegerData", field, "0");
        sliderData.putIfAbsent(field, () => 0);
        sliderData.update(field, (oldValue) => 0);
      }
    } else {
      for (var slider in sliderData.keys) {
        sliderData[slider] = 0;
        debugChangedValue("DiaryCardEventDataHandler.initIntegerData", slider, "0");
      }
    }
    debugFinished("DiaryCardEventDataHandler.initIntegerData");
  }

  @override
  initTextData(List<String> textFields) {
    debugCalledWithParameters("DiaryCardEventDataHandler.initTextData", textFields);
    for (int i = 0; i < textFields.length; i++) {
      final field = textFields[i].toString();
      debugChangedValue("DiaryCardEventDataHandler.initTextData", field, "empty String");
      textFieldData.putIfAbsent(field, () => "");
      textFieldData.update(field, (oldValue) => "");
    }
    debugFinished("DiaryCardEventDataHandler.initTextData");
  }

  @override
  initBooleanData(List<String> chips) {
    debugCalledWithParameters("DiaryCardEventDataHandler.initBooleanData", chips);
    for (int i = 0; i < chips.length; i++) {
      final chip = chips[i].toString();
      debugChangedValue("DiaryCardEventDataHandler.initBooleanData", chip, "false");
      chipData.putIfAbsent(chip, () => false);
      chipData.update(chip, (oldValue) => false);
    }
    debugFinished("DiaryCardEventDataHandler.initBooleanData");
  }

  //endregion init

  //region Database

  @override
  Future<void> setupDBTable() async {
    final db = await DatabaseProvider().database;
    await DatabaseProvider.setupTable(
        db: db,
        tableName: 'DiaryCardEvents',
        stringColums: textFieldData.keys.toList(),
        integerColums: sliderData.keys.toList(),
        booleanColums: chipData.keys.toList());
    debugFinished("DiaryCardEventDataHandler.setupDBTable");
  }

  @override
  Future<bool> loadData(String key) async {
    debugCalledWithParameters("DiaryCardEventDataHandler.loadData", [key]);
    final db = await DatabaseProvider().database;

    final results = await db.query(
      'DiaryCardEvents',
      where: 'id = ?',
      whereArgs: [key],
    );
    debugPrint("DiaryCardEventDataHandler.loadData", "query returned ${results.length} rows");

    if (results.isNotEmpty) {
      final row = results.first;
      for (var field in textFieldData.keys) {
        textFieldData[field] = row[field]?.toString() ?? '';
        debugLoadDB("DiaryCardEventDataHandler.loadData", textFieldData[field]!, field, "DiaryCardEvents");
      }
      for (var slider in sliderData.keys) {
        sliderData[slider] = row[slider] as int? ?? 0;
        debugLoadDB("DiaryCardEventDataHandler.loadData", sliderData[slider]!.toString(), slider, "DiaryCardEvents");
      }
      for (var chip in chipData.keys) {
        try {
          final value = row[chip];
          chipData[chip] = value == 1;
          debugLoadDB("DiaryCardEventDataHandler.loadData", chipData[chip]!.toString(), chip, "DiaryCardEvents");
        } catch (e) {
          debugPrint("DiaryCardEventDataHandler.loadData", 'Error loading chip "$chip": ${row[chip]} (${row[chip]?.runtimeType}) Exception: $e');
        }
      }
    } else {
      debugPrint("DiaryCardEventDataHandler.loadData", "no entry found for key $key");
      for (var slider in sliderData.keys) {
        sliderData[slider] = 0;
        debugChangedValue("DiaryCardDataHandler.loadData", slider, "0");
      }
      for (var field in textFieldData.keys) {
        if (field != "date") {
          textFieldData[field] = '';
          debugChangedValue("DiaryCardDataHandler.loadData", field, "empty String");
        }
      }
      for (var chip in chipData.keys) {
        chipData[chip] = false;
        debugChangedValue("DiaryCardDataHandler.loadData", chip, "false");
      }
    }
    return true;
  }

  @override
  Future<void> saveData(String? id) async {
    if (textFieldData["title"] != "") {
      debugCalledWithParameters("DiaryCardEventDataHandler.saveData", [id ?? "null"]);
      final db = await DatabaseProvider().database;
      final data = <String, dynamic>{'id': id!};
      debugCalledWithParameters("DiaryCardEventDataHandler.saveData", [textFieldData["date"]!, id]);

      for (var field in textFieldData.keys) {
        data[field] = textFieldData[field] ?? '';
        debugSaveDB("DiaryCardEventDataHandler.saveData", textFieldData[field]!, field, "DiaryCardEvents");
      }
      for (var slider in sliderData.keys) {
        data[slider] = sliderData[slider] ?? 0;
        debugSaveDB("DiaryCardEventDataHandler.saveData", sliderData[slider]!.toString(), slider, "DiaryCardEvents");
      }
      for (var chip in chipData.keys) {
        data[chip] = chipData[chip]! ? 1 : 0;
        debugSaveDB("DiaryCardEventDataHandler.saveData", chipData[chip]!.toString(), chip, "DiaryCardEvents");
      }

      await db.insert(
        'DiaryCardEvents',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugFinished("DiaryCardEventDataHandler.saveData");
    } else {
      debugPrint("DiaryCardEventDataHandler.saveData", "no title");
    }
  }

  @override
  Future<void> deleteEntry(String primaryKey) async {
    debugCalledWithParameters("DiaryCardEventDataHandler.deleteEntry", [primaryKey]);
    await DatabaseProvider.directDelete(DatabaseProvider().database, "DiaryCardEvents", primaryKey);
    debugFinished("DiaryCardEventDataHandler.deleteEntry");
  }

  //endregion Database

  @override
  Future<Map<String, (List<int>, List<String>)>> fetchCalendarData(String date) {
    throw UnimplementedError();
  }
}