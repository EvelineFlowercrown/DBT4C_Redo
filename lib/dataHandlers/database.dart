import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dbt4c_rebuild/helpers/DebugPrint.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static Database? _database;

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Database.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {},
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<bool> _checkTableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  static Future<void> setupTable({
    required Database db,
    required String tableName,
    List<String> stringColums = const [],
    List<String> integerColums = const [],
    List<String> booleanColums = const [],
  }) async {

    debugCalledWithParameters("DatabaseProvider.setupTable", [
      "tableName: $tableName",
      "stringCols: ${stringColums.length}",
      "integerCols: ${integerColums.length}",
      "booleanCols: ${booleanColums.length}",
    ]);

    final tableExists = await _checkTableExists(db, tableName);

    if (!tableExists) {
      debugPrint("DatabaseProvider.setupTable", "Table '$tableName' does not exist. Creating...");
      await _createTable(
        db: db,
        tableName: tableName,
        stringColums: stringColums,
        integerColums: integerColums,
        booleanColums: booleanColums,
      );
    } else {
      debugPrint("DatabaseProvider.setupTable", "Table '$tableName' exists. Updating...");
      await _updateTable(
        db: db,
        tableName: tableName,
        stringColums: stringColums,
        integerColums: integerColums,
        booleanColums: booleanColums,
      );
    }
  }
  static Future<void> _createTable({
    required Database db,
    required String tableName,
    List<String> stringColums = const [],
    List<String> integerColums = const [],
    List<String> booleanColums = const [],
  }) async {
    debugPrint("DatabaseProvider._createTable", "Creating table '$tableName'...");
    final columns = [];
    if (stringColums.contains("date")){
      stringColums.remove("date");
    }
    switch(tableName){
      case "DiaryCardEvents":
        columns.add('id TEXT PRIMARY KEY');
        columns.add('date TEXT');
        break;
      case "DiaryCardEntries":
        columns.add('date TEXT PRIMARY KEY');
        break;
    }


    // Add other fields
    for (final field in stringColums) {
      columns.add('$field TEXT');
      debugAddElement("DatabaseProvider._createTable", field, "TEXTcolumns");
    }
    for (final slider in integerColums) {
      columns.add('$slider INTEGER');
      debugAddElement("DatabaseProvider._createTable", slider, "INTEGERcolumns");
    }
    for (final chip in booleanColums) {
      columns.add('$chip BOOLEAN');
      debugAddElement("DatabaseProvider._createTable", chip, "BOOLEANcolumns");
    }

    final createSql = 'CREATE TABLE $tableName (${columns.join(', ')})';
    await db.execute(createSql);
    debugFinished("DatabaseProvider._createTable");
  }

  static Future<List<String>> getTableColumns(Database db, String tableName) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    return columns.map((c) => c['name'] as String).toList();
  }

  static Future<void> directDelete(Future<Database> database, tableName, String primaryKey) async{
    final db = await database;
    await db.delete(tableName, where: "id = ?", whereArgs: [primaryKey]);
  }

  static Future<void> _updateTable({
    required Database db,
    required String tableName,
    required List<String> stringColums,
    required List<String> integerColums,
    required List<String> booleanColums,
  }) async {
    final existingColumns = await getTableColumns(db, tableName);
    debugPrint("DatabaseProvider._updateTable", "Updating table '$tableName'...");
    if (!stringColums.contains("date")){
      stringColums.add("date");
    }
    if (tableName == "DiaryCardEvents"){
      stringColums.add('id');
    }

    for (final field in stringColums) {
      if (!existingColumns.contains(field)) {
        await db.execute('ALTER TABLE $tableName ADD COLUMN $field TEXT');
      }
    }
    for (final slider in integerColums) {
      if (!existingColumns.contains(slider)) {
        await db.execute('ALTER TABLE $tableName ADD COLUMN $slider INTEGER');
      }
    }
    for (final chip in booleanColums) {
      if (!existingColumns.contains(chip)) {
        await db.execute('ALTER TABLE $tableName ADD COLUMN $chip BOOLEAN');
      }
    }
    debugFinished("DatabaseProvider._updateTable");
  }

  static Future<List<String>> getColumns(String tableName, String column) async {
    final db = _database;
    List<String> output = [];
    var result = await db?.rawQuery("SELECT $column FROM $tableName");
    if (result!.isNotEmpty) {
      for(int i = 0; i <result.length; i++){
        for (int e = 0; e < result[i].keys.length; e++) {
          output.add(result[i].values.elementAt(e).toString());
        }
      }
      return output;
    }
    else {
      print("Column is empty. Returning new empty List");
      return [""];
    }
  }

  static Future<void> yeetDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "Database.db");
    await deleteDatabase(path);
    debugFinished("DatabaseProvider.yeetDB");
  }

  static Future<List<String>> getFullColumn(String tableName, String column) async {
    final db = _database;
    List<String> output = [];
    var result = await db?.rawQuery("SELECT $column FROM $tableName");
    if (result!.isNotEmpty) {
      for(int i = 0; i <result.length; i++){
        for (int e = 0; e < result[i].keys.length; e++) {
          output.add(result[i].values.elementAt(e).toString());
        }
      }
      return output;
    }
    else {
      print("Column is empty. Returning new empty List");
      return [""];
    }
  }
}