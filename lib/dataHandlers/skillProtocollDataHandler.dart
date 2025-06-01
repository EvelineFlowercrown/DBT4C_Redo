import 'package:dbt4c_rebuild/dataHandlers/database.dart';
import 'package:sqflite/sqflite.dart';
import 'dataHandler.dart';
import 'package:dbt4c_rebuild/helpers/DebugPrint.dart';

class SkillProtocollDataHandler implements DataHandler{
  Map<String,String> textFieldData = {};
  Map<String,int> sliderData = {};
  Map<String,bool> chipData = {};

  SkillProtocollDataHandler(List<String> textFields, List<String> sliders, List<String> chips){
    initIntegerData(sliders);
    initTextData(textFields);
    initBooleanData(chips);
    setupDBTable();
  }

  //region init
  // Initialize all text fields to empty strings
  @override
  initTextData(List<String> textFields){
    debugCalledWithParameters("SkillProtocollDataHandler.initTextData", textFields);
    for(int i=0; i < textFields.length; i++){
      final field = textFields[i].toString();
      debugChangedValue("SkillProtocollDataHandler.initTextData", field, "empty String");
      textFieldData.putIfAbsent(field, () => "");
      textFieldData.update(field, (oldValue) => "");
    }
    debugFinished("SkillProtocollDataHandler.initTextData");
  }

  // Initialize all slider values to zero
  @override
  initIntegerData(List<String> sliders){
    debugCalledWithParameters("SkillProtocollDataHandler.initIntegerData", sliders);
    for(int i=0; i < sliders.length; i++){
      final slider = sliders[i].toString();
      debugChangedValue("SkillProtocollDataHandler.initIntegerData", slider, "0");
      sliderData.putIfAbsent(slider, () => 0);
      sliderData.update(slider, (oldValue) => 0);
    }
    debugFinished("SkillProtocollDataHandler.initIntegerData");
  }

  @override
  initBooleanData(List<String> chips){
    debugCalledWithParameters("SkillProtocollDataHandler.initBooleanData", chips);
    for(int i=0; i < chips.length; i++){
      final chip = chips[i].toString();
      debugChangedValue("SkillProtocollDataHandler.initBooleanData", chip, "false");
      chipData.putIfAbsent(chip, () => false);
      chipData.update(chip, (oldValue) => false);
    }
    debugFinished("SkillProtocollDataHandler.initBooleanData");
  }

  //endregion init

  // Setup database tables for entries and events
  @override
  Future<void> setupDBTable() async {
    final db = await DatabaseProvider().database;

    // Create or update entries table with text and integer columns
    await DatabaseProvider.setupTable(
        db: db,
        tableName: 'SkillProtocollEntries',
        stringColums: textFieldData.keys.toList(),
        integerColums: sliderData.keys.toList(),
        booleanColums: chipData.keys.toList()
    );
    debugFinished("SkillProtocollDataHandler.setupDBTable");
  }

  //region Diarycard
  // Save the user's diary entry for a specific date
  @override
  Future<void> saveData(String dateStr) async {
    debugCalledWithParameters("SkillProtocollDataHandler.saveData", [dateStr]);
    final db = await DatabaseProvider().database;
    final data = <String, dynamic>{'date': dateStr};

    // Add text fields to data map
    for (var field in textFieldData.keys) {
      data[field] = textFieldData[field];
      debugSaveDB("SkillProtocollDataHandler.saveData", textFieldData[field]!, field, "SkillProtocollEntries");
    }

    // Add slider values to data map
    for (var slider in sliderData.keys) {
      data[slider] = sliderData[slider];
      debugSaveDB("SkillProtocollDataHandler.saveData", sliderData[slider]!.toString(), slider, "SkillProtocollEntries");
    }

    // Insert or replace entry into database
    await db.insert(
      'SkillProtocollEntries',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugFinished("SkillProtocollDataHandler.saveData");
  }

  // Load a diary entry into memory, returns true even if nothing found
  @override
  Future<bool> loadData(String dateStr) async {
    debugCalledWithParameters("SkillProtocollDataHandler.loadData", [dateStr]);
    final db = await DatabaseProvider().database;

    // Query table for the given date
    final results = await db.query(
      'SkillProtocollEntries',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    if (results.isNotEmpty) {
      final row = results.first;
      for (var field in textFieldData.keys) {
        textFieldData[field] = row[field]?.toString() ?? '';
        debugLoadDB("SkillProtocollDataHandler.loadData", textFieldData[field]!, field, "SkillProtocollEntries");
      }
      for (var slider in sliderData.keys) {
        sliderData[slider] = row[slider] as int? ?? 0;
        debugLoadDB("SkillProtocollDataHandler.loadData", sliderData[slider]!.toString(), slider, "SkillProtocollEntries");
      }
    } else {
      print('DiaryCardDataHandler.loadData: no entry found for date $dateStr');
      for (var slider in sliderData.keys) {
        sliderData[slider] = 0;
        debugChangedValue("SkillProtocollDataHandler.loadData", slider, sliderData[slider].toString());
      }
      for (var field in textFieldData.keys) {
        textFieldData[field] = '';
        debugChangedValue("SkillProtocollDataHandler.loadData", field, "empty String");
      }
    }
    return true;
  }
  //endregion Diarycard


  // Delete an entry or event directly by primary key
  @override
  Future<void> deleteEntry(String primaryKey) async{
    debugCalledWithParameters("SkillProtocollDataHandler.deleteEntry", [primaryKey]);
    await DatabaseProvider.directDelete(DatabaseProvider().database, "SkillProtocollEntries", primaryKey);
  }

  @override
  Future<Map<String, (List<int>, List<String>)>> fetchCalendarData(String referenceDate) async {
    debugCalledWithParameters("SkillProtocollDataHandler.fetchCalendarData", [referenceDate]);
    // Datum parsen (dd.MM.yyyy)
    final parts = referenceDate.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid date format, expected dd.MM.yyyy');
    }
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];

    int m = int.parse(month);
    final prev = (m == 1 ? 12 : m - 1).toString().padLeft(2, '0');
    final next = (m == 12 ? 1 : m + 1).toString().padLeft(2, '0');

    // relevante Spaltennamen
    final skillOfTheWeekColumn = textFieldData.keys.contains('skillOfTheWeek') ? 'skillOfTheWeek' : null;
    final sliderColumns = sliderData.keys.toList();
    final chipColumns = chipData.keys.toList();

    final allColumns = ['date']
      ..addAll(skillOfTheWeekColumn != null ? [skillOfTheWeekColumn] : [])
      ..addAll(sliderColumns)
      ..addAll(chipColumns);

    final columnString = allColumns.map((c) => 's.$c').join(', ');

    final sql = '''
    SELECT $columnString
    FROM SkillProtocollEntries s
    WHERE date LIKE '__.$prev.$year'
       OR date LIKE '__.$month.$year'
       OR date LIKE '__.$next.$year'
    ORDER BY
      substr(s.date, 7, 4),
      substr(s.date, 4, 2),
      substr(s.date, 1, 2);
  ''';

    debugPrint("SkillProtocollDataHandler.fetchSkillProtocolCalendarData", "running SQL with filters: $prev.$year, $month.$year, $next.$year");
    final db = await DatabaseProvider().database;
    final rows = await db.rawQuery(sql);

    final Map<String, (List<int>, List<String>)> result = {};

    for (var row in rows) {
      final date = row['date'] as String;

      final skillOfTheWeek = skillOfTheWeekColumn != null
          ? (row[skillOfTheWeekColumn] as String?) ?? ''
          : '';

      String bestSkill = '';
      int highestValue = -1;
      int usedCount = 0;

      for (final skill in sliderColumns) {
        final value = row[skill] as int? ?? 0;
        if (value > 0) {
          usedCount++;
          if (value > highestValue) {
            highestValue = value;
            bestSkill = skill;
          }
        }
      }

      bool mindfulness = chipColumns.any((chip) => (row[chip] as int? ?? 0) == 1);

      print('fetchSkillProtocolCalendarData: $date -> skillOfTheWeek=$skillOfTheWeek, bestSkill=$bestSkill, used=$usedCount, mindfulness=$mindfulness');
      result[date] = ([usedCount],[skillOfTheWeek, bestSkill, mindfulness.toString()]);
    }

    print('fetchSkillProtocolCalendarData: operation successful');
    return result;
  }

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


}