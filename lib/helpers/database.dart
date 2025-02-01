import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
//This is just the Database Class for Diary Cards. Every new Class needs a new Database Class. Should be Copy Paste and we should rename the file...
class DiaryCardDatabaseEntry{
  String? date;
  String? tagesziel;
  String? wochenziel;
  int? newWaySlider;
  int? sportSlider;
  int? structureSlider;
  int? selfValSlider;
  int? selfCareSlider;
  int? trustSlider;
  int? miserySlider;
  int? sudokuSlider;
  int? dissociationSlider;
  int? tension1Slider;
  int? tension2Slider;
  int? tension3Slider;
  int? moodSlider;
  String? wellDone;
  String? moveKind;
  String? improvNeeded;
  String? problemAg;
  String? diffAct;
  String? whichDrugs;


  DiaryCardDatabaseEntry({
    required this.date,
    required this.tagesziel,
    required this.wochenziel,
    this.newWaySlider = 0,
    this.sportSlider= 0,
    this.structureSlider= 0,
    this.selfValSlider= 0,
    this.selfCareSlider= 0,
    this.trustSlider= 0,
    this.miserySlider= 0,
    this.sudokuSlider= 0,
    this.dissociationSlider= 0,
    this.moodSlider= 0,
    this.tension1Slider= 0,
    this.tension2Slider= 0,
    this.tension3Slider= 0,
    this.wellDone = "",
    this.moveKind = "",
    this.improvNeeded = "",
    this. problemAg = "",
    this.diffAct = "",
    this.whichDrugs = "",
  });
  DiaryCardDatabaseEntry.fromMap(Map<String, dynamic> map){
    date = map["date"];
    tagesziel = map["tagesziel"];
    wochenziel = map["wochenziel"];

    newWaySlider = map["newWaySlider"];
    sportSlider = map["sportSlider"];
    structureSlider = map["structureSlider"];
    selfValSlider = map["selfValSlider"];
    selfCareSlider = map["selfCareSlider"];
    trustSlider = map["trustSlider"];
    miserySlider = map["miserySlider"];
    sudokuSlider = map["sudokuSlider"];
    dissociationSlider = map["dissociationSlider"];
    moodSlider = map["moodSlider"];
    tension1Slider = map["tension1Slider"];
    tension2Slider = map["tension2Slider"];
    tension3Slider = map["tension3Slider"];
    wellDone = map["wellDone"];
    moveKind = map["moveKind"];
    improvNeeded = map["improvNeeded"];
    problemAg = map["problemAg"];
    diffAct = map["diffAct"];
    whichDrugs = map["whichDrugs"];
  }
  Map<String, dynamic> toMap(){
    return{
      'date' : date,
      'tagesziel' : tagesziel,
      'wochenziel' : wochenziel,
      'newWaySlider':newWaySlider,
      'sportSlider':sportSlider,
      'structureSlider':structureSlider,
      'selfValSlider':selfValSlider,
      'selfCareSlider':selfCareSlider,
      'trustSlider':trustSlider,
      'miserySlider':miserySlider,
      'sudokuSlider':sudokuSlider,
      'dissociationSlider':dissociationSlider,
      'moodSlider':moodSlider,
      'tension1Slider':tension1Slider,
      'tension2Slider':tension2Slider,
      'tension3Slider':tension3Slider,
      'wellDone':wellDone,
      'moveKind':moveKind,
      'improvNeeded':improvNeeded,
      'problemAg':problemAg,
      'diffAct':diffAct,
      'whichDrugs':whichDrugs,
    };
  }
  @override
  String toString(){
    return 'DCard:{date: $date, tagesziel: $tagesziel, wochenziel: $wochenziel}';
  }
}

class DatabaseProvider{
  static Database? _database;

  Future<Database> get database async{
    if(_database != null)
      return _database!;
    _database = await initDB();
    return _database!;
  }
  initDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "DCDatabase.db");
    return await openDatabase(
      path, version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async{
        await db.execute(
          "CREATE TABLE DCEntries(date TEXT PRIMARY KEY, tagesziel TEXT, wochenziel TEXT,"
              "newWaySlider INTEGER, sportSlider INTEGER, structureSlider INTEGER, selfValSlider INTEGER,"
              "selfCareSlider INTEGER, trustSlider INTEGER, miserySlider INTEGER, sudokuSlider INTEGER,"
              "dissociationSlider INTEGER, moodSlider INTEGER, tension1Slider INTEGER, tension2Slider INTEGER,"
              "tension3Slider INTEGER, wellDone TEXT, moveKind TEXT, improvNeeded TEXT, problemAg TEXT,"
              "diffAct TEXT, whichDrugs TEXT)"
        );
      }
    );
  }
  Future<List<DiaryCardDatabaseEntry>> DCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('DCEntries');
    return List.generate(maps.length, (i) {
      return DiaryCardDatabaseEntry(
        date: maps[i]['date'],
        tagesziel: maps[i]['tagesziel'],
        wochenziel: maps[i]['wochenziel'],
        newWaySlider: maps[i]['newWaySlider'],
        sportSlider: maps[i]['sportSlider'],
        structureSlider: maps[i]['structureSlider'],
        selfValSlider: maps[i]['selfValSlider'],
        selfCareSlider: maps[i]['selfCareSlider'],
        trustSlider: maps[i]['trustSlider'],
        miserySlider: maps[i]['miserySlider'],
        sudokuSlider: maps[i]['sudokuSlider'],
        dissociationSlider: maps[i]['dissociationSlider'],
        moodSlider: maps[i]['moodSlider'],
        tension1Slider: maps[i]['tension1Slider'],
        tension2Slider: maps[i]['tension2Slider'],
        tension3Slider: maps[i]['tension3Slider'],
        wellDone: maps[i]['wellDone'],
        moveKind: maps[i]['moveKind'],
        improvNeeded: maps[i]['improvNeeded'],
        problemAg: maps[i]['problemAg'],
        diffAct: maps[i]['diffAct'],
        whichDrugs: maps[i]['whichDrugs'],
      );
    });
  }
  printCards() async{
    print(await DCards());
  }
  Future<void> updateCard(DiaryCardDatabaseEntry entry) async{
    final db = await database;
    await db.update(
      'DCEntries',
      entry.toMap(),
      where: 'date = ?',
      whereArgs: [entry.date],
    );
  }
  getCard(String date) async{
    final db = await database;
    var result = await db.query("DCEntries", where: "date = ?", whereArgs: [date]);
    if(result.isNotEmpty){
      //print(DiaryCardDatabaseEntry.fromMap(result.first));
      return DiaryCardDatabaseEntry.fromMap(result.first);
    }
    else
      return null;
  }
  Future<void> insertDCard(DiaryCardDatabaseEntry entry) async{
    final db = await database;
    await db.insert(
      'DCEntries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}