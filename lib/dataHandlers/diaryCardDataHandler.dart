import 'package:dbt4c_rebuild/dataHandlers/database.dart';
import 'package:sqflite/sqflite.dart';
import 'dataHandler.dart';
import 'package:dbt4c_rebuild/helpers/DebugPrint.dart';

class DiaryCardDataHandler implements DataHandler{
  Map<String,String> textFieldData = {};
  Map<String,int> sliderData = {};
  Map<String,bool> chipData = {};

  DiaryCardDataHandler(List<String> textFields, List<String> sliders, List<String> chips){
    initIntegerData(sliders);
    initTextData(textFields);
    initBooleanData(chips);
    setupDBTable();
  }

  //region init
  // Initialize all text fields to empty strings
  @override
  initTextData(List<String> textFields){
    debugCalledWithParameters("DiaryCardDataHandler.initTextData", textFields);
    for(int i=0; i < textFields.length; i++){
      final field = textFields[i].toString();
      debugChangedValue("DiaryCardDataHandler.initTextData", field, "empty String");
      textFieldData.putIfAbsent(field, () => "");
      textFieldData.update(field, (oldValue) => "");
    }
    debugFinished("DiaryCardDataHandler.initTextData");
  }

  // Initialize all slider values to zero
  @override
  initIntegerData(List<String> sliders){
    debugCalledWithParameters("DiaryCardDataHandler.initIntegerData", sliders);
    for(int i=0; i < sliders.length; i++){
      final slider = sliders[i].toString();
      debugChangedValue("DiaryCardDataHandler.initIntegerData", slider, "0");
      sliderData.putIfAbsent(slider, () => 0);
      sliderData.update(slider, (oldValue) => 0);
    }
    debugFinished("DiaryCardDataHandler.initIntegerData");
  }

  @override
  initBooleanData(List<String> chips){
    debugCalledWithParameters("DiaryCardDataHandler.initBooleanData", chips);
    for(int i=0; i < chips.length; i++){
      final chip = chips[i].toString();
      debugChangedValue("DiaryCardDataHandler.initBooleanData", chip, "false");
      chipData.putIfAbsent(chip, () => false);
      chipData.update(chip, (oldValue) => false);
    }
    debugFinished("DiaryCardDataHandler.initBooleanData");
  }

  //endregion init

  // Setup database tables for entries and events
  @override
  Future<void> setupDBTable() async {
    final db = await DatabaseProvider().database;

    // Create or update entries table with text and integer columns
    await DatabaseProvider.setupTable(
        db: db,
        tableName: 'DiaryCardEntries',
        stringColums: textFieldData.keys.toList(),
        integerColums: sliderData.keys.toList(),
        booleanColums: chipData.keys.toList()
    );
    debugFinished("DiaryCardDataHandler.setupDBTable");
  }

  //region Diarycard
  // Save the user's diary entry for a specific date
  @override
  Future<void> saveData(String dateStr) async {
    debugCalledWithParameters("DiaryCardDataHandler.saveData", [dateStr]);
    final db = await DatabaseProvider().database;
    final data = <String, dynamic>{'date': dateStr};

    // Add text fields to data map
    for (var field in textFieldData.keys) {
      data[field] = textFieldData[field];
      debugSaveDB("DiaryCardDataHandler.saveData", textFieldData[field]!, field, "DiaryCardEntries");
    }

    // Add slider values to data map
    for (var slider in sliderData.keys) {
      data[slider] = sliderData[slider];
      debugSaveDB("DiaryCardDataHandler.saveData", sliderData[slider]!.toString(), slider, "DiaryCardEntries");
    }

    // Insert or replace entry into database
    await db.insert(
      'DiaryCardEntries',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugFinished("DiaryCardDataHandler.saveData");
  }

  // Load a diary entry into memory, returns true even if nothing found
  @override
  Future<bool> loadData(String dateStr) async {
    debugCalledWithParameters("DiaryCardDataHandler.loadData", [dateStr]);
    final db = await DatabaseProvider().database;

    // Query table for the given date
    final results = await db.query(
      'DiaryCardEntries',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    if (results.isNotEmpty) {
      final row = results.first;
      for (var field in textFieldData.keys) {
        textFieldData[field] = row[field]?.toString() ?? '';
        debugLoadDB("DiaryCardDataHandler.loadData", textFieldData[field]!, field, "DiaryCardEntries");
      }
      for (var slider in sliderData.keys) {
        sliderData[slider] = row[slider] as int? ?? 0;
        debugLoadDB("DiaryCardDataHandler.loadData", sliderData[slider]!.toString(), slider, "DiaryCardEntries");
      }
    } else {
        print('DiaryCardDataHandler.loadData: no entry found for date $dateStr');
      for (var slider in sliderData.keys) {
        sliderData[slider] = 0;
        debugChangedValue("DiaryCardDataHandler.loadData", slider, sliderData[slider].toString());
      }
      for (var field in textFieldData.keys) {
        textFieldData[field] = '';
        debugChangedValue("DiaryCardDataHandler.loadData", field, "empty String");
      }
    }
    return true;
  }
  //endregion Diarycard



  //region chips



  //endregion chips

  // Delete an entry or event directly by primary key
  @override
  Future<void> deleteEntry(String primaryKey) async{
    debugCalledWithParameters("DiaryCardDataHandler.deleteEntry", [primaryKey]);
    await DatabaseProvider.directDelete(DatabaseProvider().database, "DiaryCardEntries", primaryKey);
  }

  @override
  Future<Map<String, (List<int>, List<String>)>> fetchCalendarData(String referenceDate) async {
    debugCalledWithParameters("DiaryCardDataHandler.fetchCalendarData", [referenceDate]);
    // Parse input date (dd.MM.yyyy)
    final parts = referenceDate.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid date format, expected dd.MM.yyyy');
    }
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];

    // Compute previous and next month with rollover
    int m = int.parse(month);
    final prev = (m == 1 ? 12 : m - 1).toString().padLeft(2, '0');
    final next = (m == 12 ? 1 : m + 1).toString().padLeft(2, '0');

    // Build SQL: filter dates by LIKE on dd.MM.yyyy
    final sql = '''
      SELECT
        d.date,
        d.newWaySlider          AS newWay,
        d.moodSlider            AS mood,
        d.miserySlider          AS misery,
        d.tensionSlider1  AS tension1,
        d.tensionSlider2  AS tension2,
        d.tensionSlider3  AS tension3,
        COALESCE(
          (
            SELECT GROUP_CONCAT(title, '||')
            FROM (
              SELECT title
              FROM DiaryCardEvents e
              WHERE e.date = d.date
              ORDER BY e.id ASC
              LIMIT 3
            )
          ),
          ''
        ) AS titles
      FROM DiaryCardEntries d
      WHERE date LIKE '__.$prev.$year'
         OR date LIKE '__.$month.$year'
         OR date LIKE '__.$next.$year'
      ORDER BY
        substr(d.date, 7, 4),
        substr(d.date, 4, 2),
        substr(d.date, 1, 2);
    ''';

    debugPrint("diaryCardDataHandler.fetchCalendarData", "running SQL with month filters $prev.$year, $month.$year, $next.$year");
    final db = await DatabaseProvider().database;
    final rows = await db.rawQuery(sql);
    final result = <String, (List<int>, List<String>)>{};
    for (var row in rows) {
      final date = row['date'] as String;
      final avgTension = (((row['tension1'] as int? ?? 0)+(row['tension2'] as int? ?? 0)+(row['tension3'] as int? ?? 0))/3).floor();
      final sliders = [
        (row['newWay'] as int?) ?? -1,
        (row['mood'] as int?) ?? -1,
        (row['misery'] as int?) ?? -1,
        (avgTension as int?) ?? -1,
      ];

      // Process concatenated titles
      final rawTitles = (row['titles'] as String?) ?? '';
      List<String> titles;
      if (rawTitles.isEmpty) {
        titles = ['Keine Events vorhanden'];
      } else {
        titles = rawTitles.split('||');
        if (titles.isEmpty || titles[0].isEmpty) {
          titles = ['Keine Events vorhanden'];
        }
      }
      while (titles.length < 3) {
        titles.add('');
      }

      print('fetchCalendarData: $date -> sliders=$sliders, titles=$titles');
      result[date] = (sliders, titles);
    }

    print('fetchCalendarData: operation successful');
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

