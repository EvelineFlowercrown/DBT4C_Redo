import 'configHandler.dart';

abstract class diaryCardDataHandler{
  static Map<String,String> textFieldData = {};
  static Map<String,int> sliderData = {};
  static Map<String,String> eventTextFieldData = {};
  static Map<String,bool> eventChipData = {};

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

}