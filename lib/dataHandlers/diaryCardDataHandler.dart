import 'package:dbt4c_rebuild/dataHandlers/database.dart';
import 'package:sqflite/sqflite.dart';
import 'configHandler.dart';

abstract class DiaryCardDataHandler{
  static Map<String,String> textFieldData = {};
  static Map<String,int> sliderData = {};
  static Map<String,String> eventTextFieldData = {};
  static Map<String,bool> eventChipData = {};
  static Map<String,String> summaryData = {
    "trophy_value":"",
    "happy_value":"",
    "sad_value":"",
    "stats_value":""
  };


  //region Init
  static initTextFieldData(){
    print(ConfigHandler.dCardTextFields);
    for(int i=0; i < ConfigHandler.dCardTextFields.length; i++){
      print(ConfigHandler.dCardTextFields[i]);
      textFieldData.putIfAbsent(ConfigHandler.dCardTextFields[i].toString(), () => "");
      textFieldData.update(ConfigHandler.dCardTextFields[i], (oldValue) => "");
    }
  }

  static initSliderData(){
    for(int i=0; i < ConfigHandler.dCardSliders.length; i++){
      sliderData.putIfAbsent(ConfigHandler.dCardSliders[i].toString(), () => 0);
      sliderData.update(ConfigHandler.dCardSliders[i], (oldValue) => 0);
    }
  }

  static initEventTextFieldData(){
    for(int i=0; i < ConfigHandler.dCardEventTextFields.length; i++){
      eventTextFieldData.putIfAbsent(ConfigHandler.dCardEventTextFields[i].toString(), () => "");
      eventTextFieldData.update(ConfigHandler.dCardEventTextFields[i], (oldValue) => "");
    }
  }

  static initEventChipData(){
    for(int i=0; i < ConfigHandler.dCardEventSliders.length; i++){
      eventChipData.putIfAbsent(ConfigHandler.dCardEventSliders[i].toString(), () => false);
      eventChipData.update(ConfigHandler.dCardEventSliders[i], (oldValue) => false);
    }
  }
  //endregion init

  // region SetupDBTables
  static Future<void> setupDiaryCardDBTables() async {
    final db = await DatabaseProvider().database;
    await DatabaseProvider.setupTable(
        db: db, tableName: 'DiaryCardEntries',
        stringColums: ConfigHandler.dCardTextFields,
        integerColums: ConfigHandler.dCardSliders);
    await DatabaseProvider.setupTable(
        db: db, tableName: 'DiaryCardEvents',
        stringColums: ConfigHandler.dCardEventTextFields,
        integerColums: ConfigHandler.dCardEventSliders);
  }
  // endregion SetupDBTables

  // region Database Operations
  static Future<void> saveDiaryEntry(String dateStr) async {
    final db = await DatabaseProvider().database;

    final data = <String, dynamic>{'date': dateStr};
    ConfigHandler.dCardTextFields.forEach((field) => data[field] = textFieldData[field]);
    ConfigHandler.dCardSliders.forEach((slider) => data[slider] = sliderData[slider]);

    await db.insert(
      'DiaryCardEntries',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> loadDiaryEntry(String dateStr) async {
    final db = await DatabaseProvider().database;

    final results = await db.query(
      'DiaryCardEntries',
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    if (results.isNotEmpty) {
      final row = results.first;
      ConfigHandler.dCardTextFields.forEach((field) => textFieldData[field] = row[field]?.toString() ?? '');
      ConfigHandler.dCardSliders.forEach((slider) => sliderData[slider] = row[slider] as int? ?? 0);
    }
    return true;
  }

  static Future<List<Map<String, Object?>>> loadAllEvents(String dateStr) async {
    final db = await DatabaseProvider().database;
    final results = await db.query(
      'DiaryCardEvents',
      where: 'date = ?',
      whereArgs: [dateStr]);
    return results;
  }

  static Future<void> saveDiaryCardEvent(String date, String id, Map event) async {
    final db = await DatabaseProvider().database;
    // add date to data
    final data = <String, dynamic>{'date': date, 'id': id};
    for(String key in event.keys){
      data.putIfAbsent(key, () => event[key]);
    }
    await db.insert(
      'DiaryCardEvents',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static void directDelete(String tableName, String primaryKey){
    DatabaseProvider.directDelete(DatabaseProvider().database, tableName, primaryKey);
  }

  static Future<Map<String, List<int>>> fetchCalenderData() async {
    // Query to get data from DiaryCardEntries
    final entriesQuery = 'SELECT date, newWaySlider, moodSlider, miserySlider, trustInTherapySlider FROM DiaryCardEntries';
    Database db = await DatabaseProvider().database;
    final entriesResult = await db.rawQuery(entriesQuery);
    Map<String, List<int>> result = {};

    for (var entry in entriesResult) {
      String date = entry['date'] as String;
      List<int> sliders = [
        (entry['newWaySlider'] as int?) ?? -1,
        (entry['moodSlider'] as int?) ?? -1,
        (entry['miserySlider'] as int?) ?? -1,
        (entry['trustInTherapySlider'] as int?) ?? -1,
      ];
      result[date] = (sliders);
    }

    return result;
  }

  static Future<List<String>> fetchEventTitles(String date) async {
    Database db = await DatabaseProvider().database;
    // Query to get up to 3 titles from DiaryCardEvents for the same date
    final eventsQuery = '''
    SELECT title FROM DiaryCardEvents 
    WHERE date = ? 
    ORDER BY id ASC 
    LIMIT 3
  ''';

    final eventsResult = await db.rawQuery(eventsQuery, [date]);

    // Explizite Umwandlung in String und Behandlung von null-Werten
    List<String> titles = eventsResult
        .map((e) => (e['title'] as String?) ?? "") // Null-Werte werden zu ""
        .toList();

    // Falls die Liste leer ist oder das erste Element ein leerer String ist, ersetze es mit "Keine Events vorhanden"
    if (titles.isEmpty || titles[0].isEmpty) {
      titles = ["Keine Events vorhanden"];
    }

    // Falls weniger als 3 Einträge vorhanden sind, mit leeren Strings auffüllen
    while (titles.length < 3) {
      titles.add("");
    }

    return titles;
  }


//static String _formatDate(DateTime date) =>
  //    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
// endregion Database Operations



}