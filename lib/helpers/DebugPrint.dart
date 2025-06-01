import 'package:dbt4c_rebuild/dataHandlers/database.dart';
bool debugMode = true;

void debugChangedValue(String callingmethod, String variable, String value1){
  if(debugMode){
    print("$callingmethod: $variable changed to $value1");
  }
}

void debugCalledWithParameters(String callingmethod, List<String> parameters){
  if(debugMode){
    print("$callingmethod: called with parameters $parameters");
  }
}

void debugFinished(String callingmethod){
  if(debugMode){
    print("$callingmethod: Process finished");
  }
}

void debugAddElement(String callingmethod, String element, String list){
  if(debugMode){
    print("$callingmethod: added $element to $list");
  }
}

void debugSaveDB(String callingmethod, String element,String name, String tablename){
  if(debugMode){
    print("$callingmethod: saved $element as $name to $tablename");
  }
}

void debugLoadDB(String callingmethod, String element,String name, String tablename){
  if(debugMode){
    print("$callingmethod: queried $tablename for $name and recieved $element");
  }
}

void debugPrint(String callingmethod, String text){
  if(debugMode){
    print("$callingmethod: $text");
  }
}

void printColums(String tableName)async{
  if(debugMode){
    final db = await DatabaseProvider().database;
    print("queried DB for Colums of $tableName");
    print(DatabaseProvider.getTableColumns(db, tableName));
  }
}