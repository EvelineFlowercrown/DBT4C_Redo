import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


/*
Abstrakte Klasse welche Daten für alle ihre Subklassen verwaltet,
Sowie Interaktionen  mit der Datenbank automatisiert.
 */
abstract class AbstractDatabaseService extends StatefulWidget{
  static DatabaseProvider dataBase = DatabaseProvider();
  static String lastTable = "";

  //diary card stuff
  static Map<String,String> diaryCardInstanceData = LinkedHashMap();
  static Map<String,String> diaryCardEventInstanceData = LinkedHashMap();

  //skill protocoll stuff
  static Map<String,String> skillProtocollInstanceData = LinkedHashMap();


  @override
   State<StatefulWidget> createState();

  static bool tableChanged(String tableName){
    if(lastTable == tableName){
      return true;
    }
    return false;
  }

  //Übersetzt die keys einer Hashmap in einen für die Datenbank Lesbaren Sring

  //Bsp. diaryCardEventInstanceData:
  // CREATE TABLE dCardEventEntries(date TEXT PRIMARY KEY, title TEXT, shortDescription TEXT,
  // situation TEXT, judgements TEXT, emotions TEXT, impulses TEXT, thoughts TEXT, actions TEXT)

  static void instanceDataToString(String tableName, Map<String,String> instanceData){
    String output = "CREATE TABLE $tableName(PrimaryKey TEXT PRIMARY KEY";
    for(int i=0; i < instanceData.keys.length; i++){
      output = output + ", " +  instanceData.keys.elementAt(i) + " TEXT";
    }
    dataBase.dataString = output + ")";
    dataBase.tableName = tableName;
  }

  //Initiiert die gegebene map anhand der gegebenen keys.
  static Future<bool> initMap(String tableName,String  primaryKey, Map<String,String> instanceData, List<String> keys) async {
    for(int i=0; i < keys.length; i++){
      instanceData.putIfAbsent(keys[i].toString(), () => "");
      instanceData.update(keys[i], (oldValue) => "");
      print("reset map entry " + keys[i] + " to empty String");
    }

    if(lastTable != tableName){
      print("Table Changed. Generating new DB Datastring...");
      instanceDataToString(tableName, instanceData);
    }

    Map<String,String> fromDB = await dataBase.getEntry(tableName, primaryKey);

    if(fromDB.isNotEmpty){
      for(int i=0; i < fromDB.keys.length; i++) {
        String keyFromDB = fromDB.keys.elementAt(i);
        instanceData.update(keyFromDB, (oldValue) => fromDB[keyFromDB].toString());
        //print("assigned value ${fromDB[keyFromDB].toString()} to key $keyFromDB");
      }
    }
    return true;
  }

  static void refreshDB(String tableName, String primaryKey, Map<String,String> map) async{
    lastTable = tableName;
    await dataBase.insertEntry(tableName,primaryKey,map);
    //print("DB Refreshed");
  }

  static Future<Map<String,String>> directRead(String tableName, String primaryKey){
    return dataBase.directRead(tableName, primaryKey);
  }

  static Future<void> directDelete(String tableName, String primaryKey) async{
    dataBase.directDelete(tableName, primaryKey);
  }

  static Future<void> clearTable(String tableName) async{
    dataBase.clearTable(tableName);
  }

  static Future<List<String>?> getFullColumn(String tableName, String column) async{
    return await dataBase.getFullColumn(tableName,column);
  }

  static Future<void> yeetDB() async {
    dataBase.yeetDB();
  }
}








class DatabaseProvider{
  static Database? _database;
  String dataString = "";
  String tableName = "";

  Future<Database> get database async{
    if(_database != null)
      return _database!;
    _database = await initDB(dataString);
    return _database!;
  }
  initDB(String dataString) async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "Database.db");
    return await openDatabase(
        path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async{
          await db.execute(dataString);
        }
    );
  }

  Future<Map<String,String>> getEntry(String tableName, String primaryKey) async{
    print("DB : GetEntry");
    print("tablename: $tableName");
    print("primarykey: $primaryKey");
    final db = await database;
    var temp = await db.query("sqlite_master", where: "type='table' and name='$tableName'");
    print("DB queried for table");
    print(temp.toString());
    if(temp.isNotEmpty){
      var result = await db.query(tableName, where: "PrimaryKey = ?", whereArgs: [primaryKey]);
      print(result.toString());
      if(result.isNotEmpty){
        Map<String,String> returnMap = LinkedHashMap();
        print(returnMap.toString());
        for(int i = 1; i < result[0].keys.length; i++){
          returnMap.putIfAbsent(result[0].keys.elementAt(i), () => result[0].values.elementAt(i).toString());
        }
        return returnMap;
      }
      else{
        print("database is empty. Returning new Hashmap");
        return new LinkedHashMap<String,String>();
      }
    }
    else{
      db.execute(dataString);
      return new LinkedHashMap<String,String>();
    }
  }

  Future<Map<String,String>> directRead(String tableName, String primaryKey) async{
    print("Db DirectRead($tableName,$primaryKey)");
    final db = await database;
    var temp = await db.query("sqlite_master", where: "type='table' and name='$tableName'");
    if(temp.isNotEmpty){
      var result = await db.query(tableName, where: "PrimaryKey = ?", whereArgs: [primaryKey]);
      print("queried DB");
      print(result.toString());
      if(result.isNotEmpty){
        Map<String,String> returnMap = LinkedHashMap();
        for(int i = 1; i < result[0].keys.length; i++){
          returnMap.putIfAbsent(result[0].keys.elementAt(i), () => result[0].values.elementAt(i).toString());
        }
        return returnMap;
      }
      else{
        print("database is empty. Returning new Hashmap");
      return new LinkedHashMap<String,String>();
      }
    }
    else{
      print("Table does not exist");
      return new LinkedHashMap<String,String>();
    }
  }

  Future<void> insertEntry(String tableName, String primaryKey, Map<String,String> map) async{
    print("insertentry()");
    Map<String,String> entryMap = LinkedHashMap();
    entryMap.putIfAbsent("PrimaryKey", () => primaryKey);
    entryMap.addAll(map);
    print(entryMap.toString());
    final db = await database;
    await db.insert(
      tableName,
      entryMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Database operation complete");
  }

  printEntry(String tableName, String primaryKey) async{
    final db = await database;
    var result = await db.query(tableName, where: "PrimaryKey = ?", whereArgs: [primaryKey]);
    if(result.isNotEmpty) {
      print(result);
    }
    else{print("No entries whith PrimaryKey $primaryKey found in $tableName");}
  }

  Future<void> clearTable(String tableName) async{
    final db = await database;
    db.delete(tableName);
    print("$tableName deleted.");
  }

  Future<void> directDelete(String tableName, String primaryKey) async{
    final db = await database;
    db.delete(tableName, where: "PrimaryKey = ?", whereArgs: [primaryKey]);
    print("Directly deleted $primaryKey from $tableName");
  }

  Future<List<String>> getFullColumn(String tableName, String column) async {
    //print("getfullcolumn");
    final db = await database;
    List<String> output = [];
    //print("getfullcolumm map erstellt");
    var result = await db.rawQuery("SELECT $column FROM $tableName");
    //print("getfullcolumn db quarried");

    if (result.isNotEmpty) {
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

  Future<void> yeetDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "Database.db");
    final file = File(path);
    file.delete();
  }
}