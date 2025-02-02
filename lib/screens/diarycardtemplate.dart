import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/helpers/diaryCardEventDisplay.dart';
import 'package:dbt4c_rebuild/screens/diaryCardNewEvent.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/helpers/dCardSlider.dart';
import 'package:dbt4c_rebuild/helpers/stringUtil.dart';

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
  int eventCounter = 0;

  Map<String,DiaryCardEventDisplay> eventDisplays = {};

  //direct Database Map access
  Map<String,String> instanceData = AbstractDatabaseService.diaryCardInstanceData;

  //region keySet
  List<String> keySet = [

    //TextFields

    "weeklyGoal",
    "dailyGoal",
    "newWay",
    "physicalActivity",
    "structures",
    "problems",
    "betterBehaviour",
    "drugs",

    //sliders

    "newWaySlider",
    "physicalActivitySlider",
    "structureSlider",
    "selfCareSlider",
    "selfValidationSlider",
    "trustInTherapySlider",
    "miserySlider",
    "dissociationSlider",
    "sudokuSlider",
    "tensionSlider1",
    "tensionSlider2",
    "tensionSlider3",
    "moodSlider",

    //EventData

    "eventData",
  ];
  //endregion keySet

  //region TextEditingControllers
  TextEditingController date = TextEditingController();
  TextEditingController weeklyGoal = TextEditingController();
  TextEditingController dailyGoal = TextEditingController();
  TextEditingController newWay = TextEditingController();
  TextEditingController physicalActivity = TextEditingController();
  TextEditingController structures = TextEditingController();
  TextEditingController problems = TextEditingController();
  TextEditingController betterBehaviour = TextEditingController();
  TextEditingController drugs = TextEditingController();
  //endregion TextEditingControllers

  //region SliderValues
  int newWaySlider = 0;
  int physicalActivitySlider = 0;
  int structureSlider = 0;
  int selfCareSlider = 0;
  int selfValidationSlider = 0;
  int trustInTherapySlider = 0;
  int miserySlider = 0;
  int dissociationSlider = 0;
  int sudokuSlider = 0;
  int tensionSlider1 = 0;
  int tensionSlider2 = 0;
  int tensionSlider3 = 0;
  int moodSlider = 0;
  //endregion SliderValues

  //region Eventdisplay Methods
  Future<bool> getDisplaysFromString() async{
    String input = instanceData["eventData"].toString();
    while(input.contains(",")){
      String key = input.substring(0, input.indexOf(","));
      Map<String,String> currentData = await AbstractDatabaseService.directRead("DiaryCardEvents", key);
      addNewDisplay( key,
          DiaryCardEventDisplay(
            eventName: currentData["title"].toString(),
            shortDescription: currentData["shortDescription"].toString(),
            trashCallback: () => deleteDisplay(key),
            editCallback: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryCardNewEvent(
                primaryKey: key
            )));
            },
          ));

      if(input.indexOf(",") < input.lastIndexOf(",")){
        input = input.substring(input.indexOf(",") + 1);
      }
      else{
        input = "";
      }
    }
    return true;
  }

  void addNewDisplay(String eventKey, DiaryCardEventDisplay event){
    eventDisplays.putIfAbsent(eventKey, () => event);
  }

  void changeDisplay(String eventKey, DiaryCardEventDisplay event) {
    eventDisplays.update(eventKey, (oldValue) => event);
    setState(() {});
  }

  void deleteDisplay(String eventKey) {
    if (eventDisplays.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Bist du Sicher?"),
              content: Text("Möchtest du dieses Event löschen?"),
              actions:<Widget> [
                TextButton(child: Text("Abbrechen"),
                  onPressed: (){Navigator.of(context).pop();},
                ),
                TextButton(child: Text("Bestätigen"),
                  onPressed: (){
                    eventDisplays.remove(eventKey);
                    instanceData.update("eventData", (oldString) => StringUtil.cutFromString(oldString, "$eventKey,"));
                    updateDB();
                    AbstractDatabaseService.directDelete("DiaryCardEvents", eventKey);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

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

  //Initializes this classes Map in the DatabaseService and fills it with the correct data from the Database.
  Future<bool> initMap() async {
    return AbstractDatabaseService.initMap("DiaryCard", widget.selectedDate.toString(), instanceData, keySet);
  }

  //Updates the Database to represent the current state of this classes Data Map.
  void updateDB(){
    AbstractDatabaseService.refreshDB("DiaryCard", widget.selectedDate.toString(), instanceData);
  }

  //Initializes this Classes State and Calls initMap()
  @override
  void initState() {
    super.initState();
    date.text = widget.selectedDate.toString();
    initMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultSubAppBar(
        appBarLabel: "Diary Card",
        backGroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){print("hi");
        },
        child: Icon(Icons.share),
      ),
      body: MainContainer(
        backgroundImage: AssetImage("lib/resources/WallpaperDCard.png"),
        child: FutureBuilder<bool>(
          future: initMap(),
          builder: (context, AsyncSnapshot<bool> dataAvailable){
            if(dataAvailable.data == true){

              //region Load TextFields from DB Map
              weeklyGoal.text = instanceData["weeklyGoal"].toString();
              dailyGoal.text = instanceData["dailyGoal"].toString();
              newWay.text = instanceData["newWay"].toString();
              physicalActivity.text = instanceData["physicalActivity"].toString();
              structures.text = instanceData["structures"].toString();
              problems.text = instanceData["problems"].toString();
              betterBehaviour.text = instanceData["betterBehaviour"].toString();
              drugs.text = instanceData["drugs"].toString();
              //endregion Load TextFields from DB Map

              //region Load SliderValues from DB Map
              newWaySlider = int.tryParse(instanceData["newWaySlider"]!) ??0;
              physicalActivitySlider = int.tryParse(instanceData["physicalActivitySlider"]!) ??0;
              structureSlider = int.tryParse(instanceData["structureSlider"]!) ??0;
              selfCareSlider = int.tryParse(instanceData["selfCareSlider"]!) ??0;
              selfValidationSlider = int.tryParse(instanceData["selfValidationSlider"]!) ??0;
              trustInTherapySlider = int.tryParse(instanceData["trustInTherapySlider"]!) ??0;
              miserySlider = int.tryParse(instanceData["miserySlider"]!) ??0;
              dissociationSlider = int.tryParse(instanceData["dissociationSlider"]!) ??0;
              sudokuSlider = int.tryParse(instanceData["sudokuSlider"]!) ??0;
              tensionSlider1 = int.tryParse(instanceData["tensionSlider1"]!) ??0;
              tensionSlider2 = int.tryParse(instanceData["tensionSlider2"]!) ??0;
              tensionSlider3 = int.tryParse(instanceData["tensionSlider3"]!) ??0;
              moodSlider = int.tryParse(instanceData["moodSlider"]!) ??0;
              //endregion Load SliderValues from DB Map

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    ContentCard(
                      doubleX: 1.1,
                      children: [
                        TextField(
                          controller: date,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today_outlined),
                              hintText: widget.selectedDate
                          ),
                          enabled: false,
                        ),
                        TextField(
                            cursorColor: Colors.white,
                            controller: dailyGoal,
                            decoration: InputDecoration(
                                icon: Icon(Icons.assignment_rounded),
                                hintText: "Tagesziel"
                            ),
                            onChanged: (txt){
                              instanceData["dailyGoal"] = txt;
                              updateDB();
                            }
                        ),
                        TextField(
                          cursorColor: Colors.white,
                          controller: weeklyGoal,
                          decoration: InputDecoration(
                              icon: Icon(Icons.assignment_turned_in_rounded),
                              hintText: "Wochenziel"
                          ),
                            onChanged: (txt){
                              instanceData["weeklyGoal"] = txt;
                              updateDB();
                            }
                        ),
                      ],
                    ),

                    FutureBuilder(
                        future: getDisplaysFromString(),
                        builder: (context, AsyncSnapshot<bool> dataAvailable){
                          if(dataAvailable.data == true){
                            return getDisplays();
                          }
                        return Padding(padding: EdgeInsets.all(5));
                        }),


                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.1,
                      child:Padding(padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child: OutlinedButton(

                                  onPressed: (){

                                    //Der Primary key wird aus datum und index zusammengesetzt.
                                    //sollte die gewählte bezeichnung bereits vergeben sein wird der counter erhöht.
                                    String primaryKey = "${widget.selectedDate!}:${eventCounter.toString()}";
                                    while(instanceData["eventData"].toString().contains(primaryKey)){
                                      eventCounter++;
                                      primaryKey = "${widget.selectedDate!}:${eventCounter.toString()}";
                                    }

                                    //Öffnet den Screen DiaryCardNewEvent mit dem eben generierten PrimaryKey als Parameter,
                                    //wodurch das neue event diesen bekannten key auch zum speichern in die Diary Card benutzt.
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryCardNewEvent(
                                        primaryKey: primaryKey
                                        )
                                      )
                                    );

                                    //Fügt dem eventData String den PrimaryKey des neuen Events hinzu.
                                    instanceData.update("eventData", (oldString) => "$oldString$primaryKey,");
                                    updateDB();
                                    },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(
                                    Color.fromRGBO(255, 255, 255, .2),
                                  ),
                                ),

                                child: Text("Ereignis hinzufügen", style: TextStyle(fontSize: 16, color: Color(0xFF333F49))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ContentCard(
                       doubleX : 1.1,
                       children: [
                         Padding(padding: EdgeInsets.all(10)),
                         DiaryCardSlider(
                           initSliderValue: newWaySlider.toDouble(),
                           sliderText: "Wie weit ist es mir gelungen, dem Neuen Weg zu folgen?",
                           fontSize: 16,
                              onChanged: (double val){
                                newWaySlider = val.toInt();
                                instanceData["newWaySlider"] = newWaySlider.toString();
                                updateDB();
                              },
                         ),

                         Text("Wo ist es mir gut gelungen?",
                             style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF333F49))),

                         TextField(
                             cursorColor: Colors.white,
                             controller: newWay,
                             onChanged: (txt){
                               instanceData["newWay"] = txt;
                               updateDB();
                             }
                         ),
                       ],
                     ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        DiaryCardSlider(
                          initSliderValue: physicalActivitySlider.toDouble(),
                          sliderText: "Wie viel Bewegung hatte ich?",
                          fontSize: 16,
                            onChanged: (double val){
                              physicalActivitySlider = val.toInt();
                              instanceData["physicalActivitySlider"] = physicalActivitySlider.toString();
                              updateDB();
                            },
                        ),

                        Text("Welche Art von Bewegung?",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333F49))),

                        TextField(
                            cursorColor: Colors.white,
                            controller: physicalActivity,
                            onChanged: (txt){
                              instanceData["physicalActivity"] = txt;
                              updateDB();
                            }
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        DiaryCardSlider(
                          initSliderValue: structureSlider.toDouble(),
                          sliderText: "Wie gut funktionieren meine Strukturen im Alltag?",
                          fontSize: 16,
                            onChanged: (double val){
                              structureSlider = val.toInt();
                              instanceData["structureSlider"] = structureSlider.toString();
                              updateDB();
                            },
                        ),

                        Text("Wo ist noch Verbesserungsbedarf?",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333F49))),

                        TextField(
                            cursorColor: Colors.white,
                            controller: structures,
                            onChanged: (txt){
                              instanceData["structures"] = txt;
                              updateDB();
                            }
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        DiaryCardSlider(
                          initSliderValue: selfValidationSlider.toDouble(),
                          sliderText: "Selbstvalidierung",
                          fontSize: 16,
                            onChanged: (double val){
                              selfValidationSlider = val.toInt();
                              instanceData["selfValidationSlider"] = selfValidationSlider.toString();
                              updateDB();
                              },
                        ),
                        DiaryCardSlider(
                          initSliderValue: selfCareSlider.toDouble(),
                          sliderText: "Selbstfürsorge",
                          fontSize: 16,
                            onChanged: (double val){
                              selfCareSlider = val.toInt();
                              instanceData["selfCareSlider"] = selfCareSlider.toString();
                              updateDB();
                              },
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        Text("Welche Problemverhalten sind mir aufgefallen?",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333F49))),

                        TextField(
                            cursorColor: Colors.white,
                            controller: problems,
                            onChanged: (txt){
                              instanceData["problems"] = txt;
                              updateDB();
                            }
                        ),

                        Padding(padding: EdgeInsets.all(10)),
                        Text("Wie hätte ich anders handeln können?",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333F49))),

                        TextField(
                            cursorColor: Colors.white,
                            controller: betterBehaviour,
                            onChanged: (txt){
                              instanceData["betterBehaviour"] = txt;
                              updateDB();
                            }
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        DiaryCardSlider(
                          initSliderValue: miserySlider.toDouble(),
                          sliderText: "Elend",
                          fontSize: 16,
                            onChanged: (double val){
                              miserySlider = val.toInt();
                              instanceData["miserySlider"] = miserySlider.toString();
                              updateDB();
                              },
                        ),
                        DiaryCardSlider(
                          initSliderValue: sudokuSlider.toDouble(),
                          sliderText: "Suizidgedanken",
                          fontSize: 16,
                            onChanged: (double val){
                              sudokuSlider = val.toInt();
                              instanceData["sudokuSlider"] = sudokuSlider.toString();
                              updateDB();
                              },
                        ),
                        DiaryCardSlider(
                          initSliderValue: dissociationSlider.toDouble(),
                          sliderText: "Dissoziation",
                          fontSize: 16,
                            onChanged: (double val){
                            dissociationSlider = val.toInt();
                            instanceData["dissociationSlider"] = dissociationSlider.toString();
                            updateDB();
                            },
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        Text("Habe ich heute Drogen konsumiert?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333F49))),
                        Text("Wenn ja, welche?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333F49))),
                        TextField(
                            cursorColor: Colors.white,
                            controller: drugs,
                            onChanged: (txt){
                              instanceData["drugs"] = txt;
                              updateDB();
                            }
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [

                        DiaryCardSlider(
                          initSliderValue: tensionSlider1.toDouble(),
                          sliderText: "Anspannung Morgens",
                          fontSize: 16,
                          onChanged: (double val){
                            tensionSlider1 = val.toInt();
                            instanceData["tensionSlider1"] = tensionSlider1.toString();
                            updateDB();
                          },
                        ),
                        DiaryCardSlider(
                          initSliderValue: tensionSlider2.toDouble(),
                          sliderText: "Anspannung Mittags",
                          fontSize: 16,
                          onChanged: (double val){
                            tensionSlider2 = val.toInt();
                            instanceData["tensionSlider2"] = tensionSlider2.toString();
                            updateDB();
                          },
                        ),
                        DiaryCardSlider(
                          initSliderValue: tensionSlider3.toDouble(),
                          sliderText: "Anspannung Abends",
                          fontSize: 16,
                          onChanged: (double val){
                            tensionSlider3 = val.toInt();
                            instanceData["tensionSlider3"] = tensionSlider3.toString();
                            updateDB();
                          },
                        ),
                        DiaryCardSlider(
                          initSliderValue: moodSlider.toDouble(),
                          sliderText: "Durchschnittliche Stimmung",
                          fontSize: 16,
                          onChanged: (double val){
                            moodSlider = val.toInt();
                            instanceData["moodSlider"] = moodSlider.toString();
                            updateDB();
                          },
                        ),
                      ],
                    ),


                    ContentCard(
                      doubleX : 1.1,
                      children: [
                        DiaryCardSlider(
                          initSliderValue: trustInTherapySlider.toDouble(),
                          sliderText: "Vertrauen in die Therapie",
                          fontSize: 16,
                          onChanged: (double val){
                            trustInTherapySlider = val.toInt();
                            instanceData["trustInTherapySlider"] = trustInTherapySlider.toString();
                            updateDB();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
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
