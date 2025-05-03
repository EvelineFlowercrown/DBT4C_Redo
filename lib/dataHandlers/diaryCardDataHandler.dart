import 'package:dbt4c_rebuild/dataHandlers/database.dart';
import 'package:sqflite/sqflite.dart';
import 'configHandler.dart';

abstract class DiaryCardDataHandler{
  static Map<String,String> textFieldData = {};
  static Map<String,int> sliderData = {};

  static Map<String,int> eventSliderData = {};
  static Map<String,String> eventTextFieldData = {};
  static Map<String,bool> eventChipData = {};

  static Map<String,String> summaryData = {
    "trophy_value":"",
    "happy_value":"",
    "sad_value":"",
    "stats_value":""
  };

  //region init
  // Initialize all text fields to empty strings
  static initTextFieldData(){
    print('DiaryCardDataHandler.initTextFieldData: called');
    for(int i=0; i < ConfigHandler.dCardTextFields.length; i++){
      final field = ConfigHandler.dCardTextFields[i].toString();
      print('DiaryCardDataHandler.initTextFieldData: initializing field $field with empty string');
      textFieldData.putIfAbsent(field, () => "");
      textFieldData.update(field, (oldValue) => "");
    }
    print('DiaryCardDataHandler.initTextFieldData: operation successful');
  }

  // Initialize all slider values to zero
  static initSliderData(){
    print('DiaryCardDataHandler.initSliderData: called');
    for(int i=0; i < ConfigHandler.dCardSliders.length; i++){
      final slider = ConfigHandler.dCardSliders[i].toString();
      print('DiaryCardDataHandler.initSliderData: initializing slider $slider with 0');
      sliderData.putIfAbsent(slider, () => 0);
      sliderData.update(slider, (oldValue) => 0);
    }
    print('DiaryCardDataHandler.initSliderData: operation successful');
  }

  // Initialize event text fields to empty strings
  static initEventTextFieldData(){
    print('DiaryCardDataHandler.initEventTextFieldData: called');
    for(int i=0; i < ConfigHandler.dCardEventTextFields.length; i++){
      final field = ConfigHandler.dCardEventTextFields[i].toString();
      print('DiaryCardDataHandler.initEventTextFieldData: initializing event text field $field');
      eventTextFieldData.putIfAbsent(field, () => "");
      eventTextFieldData.update(field, (oldValue) => "");
    }
    print('DiaryCardDataHandler.initEventTextFieldData: operation successful');
  }

  // Initialize event chips (boolean flags) to false
  static initEventChipData(){
    print('DiaryCardDataHandler.initEventChipData: called');
    for(int i=0; i < ConfigHandler.dCardEventSliders.length; i++){
      final chip = ConfigHandler.dCardEventSliders[i].toString();
      print('DiaryCardDataHandler.initEventChipData: initializing event chip $chip to false');
      eventChipData.putIfAbsent(chip, () => false);
      eventChipData.update(chip, (oldValue) => false);
    }
    print('DiaryCardDataHandler.initEventChipData: operation successful');
  }

  //endregion init

  // Setup database tables for entries and events
  static Future<void> setupDiaryCardDBTables() async {
    print('DiaryCardDataHandler.setupDiaryCardDBTables: called');
    final db = await DatabaseProvider().database;

    // Create or update entries table with text and integer columns
    await DatabaseProvider.setupTable(
        db: db,
        tableName: 'DiaryCardEntries',
        stringColums: ConfigHandler.dCardTextFields,
        integerColums: ConfigHandler.dCardSliders
    );
    print('DiaryCardDataHandler.setupDiaryCardDBTables: DiaryCardEntries table ready');

    // Create or update events table with text and integer columns
    await DatabaseProvider.setupTable(
        db: db,
        tableName: 'DiaryCardEvents',
        stringColums: ConfigHandler.dCardEventTextFields,
        integerColums: ConfigHandler.dCardEventSliders
    );
    print('DiaryCardDataHandler.setupDiaryCardDBTables: DiaryCardEvents table ready');
    print('DiaryCardDataHandler.setupDiaryCardDBTables: operation successful');
  }

  //region Diarycard
  // Save the user's diary entry for a specific date
  static Future<void> saveDiaryEntry(String dateStr) async {
    print('DiaryCardDataHandler.saveDiaryEntry: called with parameters dateStr=$dateStr');
    final db = await DatabaseProvider().database;
    final data = <String, dynamic>{'date': dateStr};

    // Add text fields to data map
    for (var field in ConfigHandler.dCardTextFields) {
      data[field] = textFieldData[field];
      print('DiaryCardDataHandler.saveDiaryEntry: adding text field $field = ${textFieldData[field]}');
    }

    // Add slider values to data map
    for (var slider in ConfigHandler.dCardSliders) {
      data[slider] = sliderData[slider];
      print('DiaryCardDataHandler.saveDiaryEntry: adding slider $slider = ${sliderData[slider]}');
    }

    // Insert or replace entry into database
    await db.insert(
      'DiaryCardEntries',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('DiaryCardDataHandler.saveDiaryEntry: operation successful');
  }

  // Load a diary entry into memory, returns true even if nothing found
  static Future<bool> loadDiaryEntry(String dateStr) async {
    print('DiaryCardDataHandler.loadDiaryEntry: called with parameters dateStr=$dateStr');
    final db = await DatabaseProvider().database;

    // Query table for the given date
    final results = await db.query(
      'DiaryCardEntries',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    print('DiaryCardDataHandler.loadDiaryEntry: query returned ${results.length} rows');

    if (results.isNotEmpty) {
      final row = results.first;
      ConfigHandler.dCardTextFields.forEach((field) {
        textFieldData[field] = row[field]?.toString() ?? '';
        print('DiaryCardDataHandler.loadDiaryEntry: loaded textField $field = ${textFieldData[field]}');
      });
      ConfigHandler.dCardSliders.forEach((slider) {
        sliderData[slider] = row[slider] as int? ?? 0;
        print('DiaryCardDataHandler.loadDiaryEntry: loaded slider $slider = ${sliderData[slider]}');
      });
    } else {
      print('DiaryCardDataHandler.loadDiaryEntry: no entry found for date $dateStr');
    }
    return true;
  }
  //endregion Diarycard

  //region Events

  // Load a Event entry into memory, returns true even if nothing found
  static Future<bool> loadDiaryEventEntry(String key) async {
    print('DiaryCardDataHandler.loadDiaryEventEntry: called with parameters dateStr=$key');
    final db = await DatabaseProvider().database;

    // Query table for the given date
    final results = await db.query(
      'DiaryCardEvents',
      where: 'id = ?',
      whereArgs: [key],
    );
    print('DiaryCardDataHandler.loadDiaryEventEntry: query returned ${results.length} rows');

    if (results.isNotEmpty) {
      final row = results.first;
      ConfigHandler.dCardEventTextFields.forEach((field) {
        eventTextFieldData[field] = row[field]?.toString() ?? '';
        print('DiaryCardDataHandler.loadDiaryEventEntry: loaded textField $field = ${eventTextFieldData[field]}');
      });
      ConfigHandler.dCardEventSliders.forEach((slider) {
        eventSliderData[slider] = row[slider] as int? ?? 0;
        print('DiaryCardDataHandler.loadDiaryEventEntry: loaded slider $slider = ${eventSliderData[slider]}');
      });
    } else {
      print('DiaryCardDataHandler.loadDiaryEventEntry: no entry found for date $key');
    }
    return true;
  }

  // Load all event rows for a date
  static Future<List<Map<String, Object?>>> loadAllEvents(String dateStr) async {
    print('DiaryCardDataHandler.loadAllEvents: called with parameters dateStr=$dateStr');
    final db = await DatabaseProvider().database;
    final results = await db.query(
        'DiaryCardEvents',
        where: 'date = ?',
        whereArgs: [dateStr]
    );
    print('DiaryCardDataHandler.loadAllEvents: retrieved ${results.length} events');
    print('DiaryCardDataHandler.loadAllEvents: operation successful');
    return results;
  }

  // Save a single diary card event
  static Future<void> saveDiaryCardEvent(String? date, String? id) async {
    print('DiaryCardDataHandler.saveDiaryCardEvent: called with parameters date=$date, id=$id');
    final db = await DatabaseProvider().database;
    final data = <String, dynamic>{'date': date!, 'id': id!};

    // Potential bug: using wrong map for event data; ensure correct map is referenced
    ConfigHandler.dCardEventTextFields.forEach((field) {
      data[field] = eventTextFieldData[field] ?? '';
      print('DiaryCardDataHandler.saveDiaryCardEvent: adding event text field $field = ${eventTextFieldData[field]}');
    });
    ConfigHandler.dCardEventSliders.forEach((slider) {
      data[slider] = eventSliderData[slider] ?? 0;
      print('DiaryCardDataHandler.saveDiaryCardEvent: adding event slider $slider = ${eventSliderData[slider]}');
    });

    await db.insert(
      'DiaryCardEvents',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('DiaryCardDataHandler.saveDiaryCardEvent: operation successful');
  }
  //endregion Events

  // Delete an entry or event directly by primary key
  static Future<bool> directDelete(String tableName, String primaryKey) async{
    print('DiaryCardDataHandler.directDelete: called with parameters tableName=$tableName, primaryKey=$primaryKey');
    await DatabaseProvider.directDelete(DatabaseProvider().database, tableName, primaryKey);
    print('DiaryCardDataHandler.directDelete: operation successful');
    return true;
  }

  //--------------------------------------------------------------------------------
  // Fetch calendar data for UI rendering: returns map of date->slider list
  static Future<Map<String, (List<int>, List<String>)>> fetchCalendarData(String referenceDate) async {
    print('fetchCalendarData: called with referenceDate=$referenceDate');

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
        d.trustInTherapySlider  AS trust,
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

    print('fetchCalendarData: running SQL with month filters $prev.$year, $month.$year, $next.$year');
    final db = await DatabaseProvider().database;
    final rows = await db.rawQuery(sql);
    print('fetchCalendarData: raw query returned ${rows.length} rows');

    final result = <String, (List<int>, List<String>)>{};
    for (var row in rows) {
      final date = row['date'] as String;
      final sliders = [
        (row['newWay'] as int?) ?? -1,
        (row['mood'] as int?) ?? -1,
        (row['misery'] as int?) ?? -1,
        (row['trust'] as int?) ?? -1,
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
}

