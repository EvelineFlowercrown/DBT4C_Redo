import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
  }) async {
    final tableExists = await _checkTableExists(db, tableName);

    if (!tableExists) {
      await _createTable(
        db: db,
        tableName: tableName,
        stringColums: stringColums,
        integerColums: integerColums,
      );
    } else {
      await _updateTable(
        db: db,
        tableName: tableName,
        stringColums: stringColums,
        integerColums: integerColums,
      );
    }
  }
  static Future<void> _createTable({
    required Database db,
    required String tableName,
    List<String> stringColums = const [],
    List<String> integerColums = const [],
  }) async {
    final columns = [];

    if (tableName == 'DiaryCardEntries' || tableName == 'SkillProtocollEntries') {
      columns.add('date TEXT PRIMARY KEY');
    } else {
      columns.add('date TEXT NOT NULL');
      columns.add('id TEXT PRIMARY KEY');
    }

    // Add other fields
    for (final field in stringColums) {
      columns.add('$field TEXT');
    }
    for (final slider in integerColums) {
      columns.add('$slider INTEGER');
    }

    final createSql = 'CREATE TABLE $tableName (${columns.join(', ')})';
    await db.execute(createSql);
  }

  static Future<List<String>> _getTableColumns(Database db, String tableName) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    return columns.map((c) => c['name'] as String).toList();
  }

  static Future<void> directDelete(Future<Database> database, tableName, String primaryKey) async{
    final db = await database;
    await db.delete(tableName, where: "PrimaryKey = ?", whereArgs: [primaryKey]);
  }

  static Future<void> _updateTable({
    required Database db,
    required String tableName,
    required List<String> stringColums,
    required List<String> integerColums,
  }) async {
    final existingColumns = await _getTableColumns(db, tableName);

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