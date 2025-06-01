
abstract class DataHandler<T> {

  //region getter

  // returns the implementing classes Textfield data
  Map<String,String> getTextData(){
    throw UnimplementedError(
        'getTextData() has not been implemented by this DataHandler.');
  }

  // returns the implementing classes Slider data
  Map<String,int> getIntegerData(){
    throw UnimplementedError(
        'getIntegerData() has not been implemented by this DataHandler.');
  }

  // returns the implementing classes Chip data
  Map<String,bool> getBooleanData(){
    throw UnimplementedError(
        'getBooleanData() has not been implemented by this DataHandler.');
  }

  //endregion getter

  //region init

  // initializes the implementing classes Textfield data
  void initTextData(List<String> textFields){
    throw UnimplementedError(
        'initTextData() has not been implemented by this DataHandler.');
  }

  // initializes the implementing classes Slider data
  void initIntegerData(List<String> sliders){
    throw UnimplementedError(
        'initIntegerData() has not been implemented by this DataHandler.');
  }

  // initializes the implementing classes Chip data
  void initBooleanData(List<String> chips){
    throw UnimplementedError(
        'initBooleanData() has not been implemented by this DataHandler.');
  }

  //endregion init


  // set up db table of implementing class
  Future<void> setupDBTable();

  // Saves all data from the implementing classes fields to the database
  Future<void> saveData(String primaryKey);

  // Loads all data from the database into the implementing classes fields
  Future<bool> loadData(String primaryKey);

  // Deletes an entry from the database
  Future<void> deleteEntry(String primaryKey);

  // retrieves Data for display in Calender screen
  // Future<Map<String Date, (List<int> Sliderdata, List<String> TextData)>>
  Future<Map<String, (List<int>, List<String>)>> fetchCalendarData(String date){
    throw UnimplementedError(
        'fetchCalendarData() has not been implemented by this DataHandler.');
  }


}