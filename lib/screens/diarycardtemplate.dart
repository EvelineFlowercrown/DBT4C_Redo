import 'package:dbt4c_rebuild/dataHandlers/diaryCardDataHandler.dart';
import 'package:dbt4c_rebuild/helpers/diaryCardEventDisplay.dart';
import 'package:dbt4c_rebuild/screens/diaryCardNewEvent.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/helpers/dCardSlider.dart';
import 'package:dbt4c_rebuild/helpers/stringUtil.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:dbt4c_rebuild/helpers/diaryCardGenerator.dart';

class DiarycardTemplate extends StatelessWidget{
  final String? selectedDate;
  const DiarycardTemplate({super.key, required this.selectedDate});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: DiaryCardTemplateState(selectedDate: selectedDate),
    );
  }
}

class DiaryCardTemplateState extends StatefulWidget{
  final String? selectedDate;
  const DiaryCardTemplateState({super.key, this.selectedDate});
  @override
  _DiaryCardTemplateState createState() => _DiaryCardTemplateState();
}

class _DiaryCardTemplateState extends State<DiaryCardTemplateState>{
  List contentCards = ConfigHandler.dCardContentCards;

  Map<String,DiaryCardEventDisplay> eventDisplays = DiaryCardGenerator.eventDisplays;
  Map<String,TextEditingController> textEditingControllers = DiaryCardGenerator.textEditingControllers;
  TextEditingController date = TextEditingController();

  //region Database Map
  Map<String,String> textFieldData = DiaryCardDataHandler.textFieldData;
  Map<String,int> sliderData = DiaryCardDataHandler.sliderData;
  Map<String,String> eventTextFieldData = DiaryCardDataHandler.eventTextFieldData;
  Map<String,bool> eventChipData = DiaryCardDataHandler.eventChipData;
  //endregion Database Map



  void getTextEditingControllers(){
    for(String key in textFieldData.keys){
      textEditingControllers.putIfAbsent(key, () => TextEditingController());
    }
  }

  //region Eventdisplay Methods





  Widget getDisplays() {
    if (eventDisplays.isNotEmpty) {
      List<Widget> output = [];
      for(String key in eventDisplays.keys){
        output.add(eventDisplays[key]!);
      }
      return ContentCard(doubleX: 1.1, children: output);
    }
    else {
      return Padding(padding: EdgeInsets.all(5));
    }
  }
  //endregion Eventdisplay Methods


  //Initializes this Classes State and Calls initMap()
  @override
  void initState() {
    super.initState();
    date.text = widget.selectedDate.toString();
  }

  List<Widget> ScrollViewChildren =  [





  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultSubAppBar(
        appBarLabel: "Diary Card",
        backGroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: (){print("hi");
      //  },
      //  child: Icon(Icons.share),
      //),
      body: MainContainer(
        backgroundImage: AssetImage("lib/resources/WallpaperDCard.png"),
        child: FutureBuilder<bool>(
          future: DiaryCardDataHandler.loadDiaryEntry(date.text),
          builder: (context, AsyncSnapshot<bool> dataAvailable){
            if(dataAvailable.data == true){

              //region Load TextFields from DB Map
              for (String key in textEditingControllers.keys) {
                textEditingControllers[key]?.text = textFieldData[key]!;
              }
              //endregion Load TextFields from DB Map

              return SingleChildScrollView(
                child: Column(
                  children: DiaryCardGenerator.buildDiaryCardLayout(date.text, context),
                ),
              );
            }

            return Center(child: Text("Loading..."));
          },
        ),
      ),
    );
  }
}
