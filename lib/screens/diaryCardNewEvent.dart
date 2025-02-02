import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/helpers/chipPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';

class DiaryCardNewEvent extends StatelessWidget{
  final String? primaryKey;

  const DiaryCardNewEvent({super.key, required this.primaryKey});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: DiaryCardNewEventState(primaryKey: primaryKey,),
    );
  }
}

class DiaryCardNewEventState extends StatefulWidget{
  final String? primaryKey;

  const DiaryCardNewEventState({super.key, required this.primaryKey});
  @override
  _DiaryCardNewEventState createState() => _DiaryCardNewEventState();
}



class _DiaryCardNewEventState extends State<DiaryCardNewEventState>{
  //Textfield Controllers
  TextEditingController title = TextEditingController();
  TextEditingController shortDescription = TextEditingController();
  TextEditingController situation = TextEditingController();
  TextEditingController judgements = TextEditingController();
  TextEditingController impulses = TextEditingController();
  TextEditingController thoughts = TextEditingController();
  TextEditingController actions = TextEditingController();

  //Emotions Chip Datastring
  late String emotionsDatastring;

  Map<String,String> instanceData = AbstractDatabaseService.diaryCardEventInstanceData;

  //keySet
  List<String> keySet = [
    "title",
    "shortDescription",
    "situation",
    "judgements",
    "emotions",
    "impulses",
    "thoughts",
    "actions",
  ];

  @override
  void initState() {
    super.initState();
    initMap();
  }

  void updateDB(){
    AbstractDatabaseService.refreshDB("DiaryCardEvents", widget.primaryKey!, instanceData);
  }

  Future<bool> initMap() async {
    return AbstractDatabaseService.initMap("DiaryCardEvents", widget.primaryKey!, instanceData, keySet);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:Scaffold(
          extendBodyBehindAppBar: true,
          appBar: DefaultSubAppBar(
            appBarLabel: "Neues Ereignis",
            backGroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body: MainContainer(
            backgroundImage: AssetImage("lib/resources/WallpaperDCard.png"),
            child: FutureBuilder<bool>(
              future: initMap(),
              builder: (context, AsyncSnapshot<bool> dataAvailable){
                if(dataAvailable.data == true){
                  title.text = instanceData["title"].toString();
                  shortDescription.text = instanceData["shortDescription"].toString();
                  situation.text = instanceData["situation"].toString();
                  judgements.text = instanceData["judgements"].toString();
                  emotionsDatastring = instanceData["emotions"].toString();
                  impulses.text = instanceData["impulses"].toString();
                  thoughts.text = instanceData["thoughts"].toString();
                  actions.text = instanceData["actions"].toString();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.all(10)),
                        Padding(padding: EdgeInsets.all(10)),
                        ContentCard(
                          doubleX: 1.1,
                          children: [
                            Text("Gib dem Ereignis einen Titel",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333F49)),
                              textAlign: TextAlign.center,
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            TextField(
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                maxLength: 45,
                                controller: title,
                                cursorColor: Color(0xFF333F49),
                                maxLines: 1,
                                onChanged: (txt){
                                  AbstractDatabaseService.diaryCardEventInstanceData["title"] = txt;
                                  updateDB();
                                }
                            ),
                            Padding(padding: EdgeInsets.all(15)),

                            Text("Beschreibe das Ereignis in ein bis zwei Sätzen",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333F49)),
                              textAlign: TextAlign.center,
                            ),

                            Padding(padding: EdgeInsets.all(10)),

                            TextField(
                                cursorColor: Color(0xFF333F49),
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                maxLength: 85,
                                controller: shortDescription,
                                minLines: 2,
                                maxLines: 2,
                                onChanged: (txt){
                                  AbstractDatabaseService.diaryCardEventInstanceData["shortDescription"] = txt;
                                  updateDB();
                                }
                            )
                          ],
                        ),

                        ChipPanel(
                            doubleX: 1.1,
                            text: "Welche Emotionen habe ich in dem Moment wahrgenommen?",
                            keyList: ["Freude","Zufriedenheit","Scham","Begeisterung","Zuneigung","Schuld","Leidenschaft","Verwirrung","Reue","Ekel"],
                            dataString: instanceData["emotions"]!,
                            onChanged: (dataString){
                              AbstractDatabaseService.diaryCardEventInstanceData["emotions"] = dataString;
                              updateDB();
                            },
                        ),

                        ContentCard(
                            doubleX: 1.1,
                            children: [
                              Text("Wie war die Ausgangssituation?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF333F49)),
                                textAlign: TextAlign.center,
                              ),

                              TextField(
                                  cursorColor: Color(0xFF333F49),
                                  controller: situation,
                                  minLines: 3,
                                  maxLines: 6,
                                  onChanged: (txt){
                                    AbstractDatabaseService.diaryCardEventInstanceData["situation"] = txt;
                                    updateDB();
                                  }
                              ),

                              Padding(padding: EdgeInsets.all(10)),


                            ]
                        ),

                        ContentCard(
                          doubleX: 1.1,
                          children: [

                            Padding(padding: EdgeInsets.all(15)),

                            Text("Weche Bewertungen sind aufgekommen?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333F49)),
                              textAlign: TextAlign.center,
                            ),

                            Padding(padding: EdgeInsets.all(10)),

                            TextField(
                                cursorColor: Color(0xFF333F49),
                                controller: judgements,
                                minLines: 3,
                                maxLines: 6,
                                onChanged: (txt){
                                  AbstractDatabaseService.diaryCardEventInstanceData["judgements"] = txt;
                                  updateDB();
                                }
                            ),

                            Padding(padding: EdgeInsets.all(15)),

                            Text("Weche Handlungsimpulse waren spürbar?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333F49)),
                              textAlign: TextAlign.center,
                            ),

                            Padding(padding: EdgeInsets.all(10)),

                            TextField(
                                cursorColor: Color(0xFF333F49),
                                controller: impulses,
                                minLines: 3,
                                maxLines: 6,
                                onChanged: (txt){
                                  AbstractDatabaseService.diaryCardEventInstanceData["impulses"] = txt;
                                  updateDB();
                                }
                            ),

                            Padding(padding: EdgeInsets.all(15)),

                            Text("Weche Gedanken konnte ich wahrnehmen?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333F49)),
                              textAlign: TextAlign.center,
                            ),

                            Padding(padding: EdgeInsets.all(10)),

                            TextField(
                                cursorColor: Color(0xFF333F49),
                                controller: thoughts,
                                minLines: 3,
                                maxLines: 15,
                                onChanged: (txt){
                                  AbstractDatabaseService.diaryCardEventInstanceData["thoughts"] = txt;
                                  updateDB();
                                }
                            ),
                          ],
                        ),

                        ContentCard(
                            doubleX: 1.1,
                            children: [

                              Text("Wie habe ich gehandelt?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF333F49)),
                                textAlign: TextAlign.center,
                              ),

                              TextField(
                                  cursorColor: Color(0xFF333F49),
                                  controller: actions,
                                  minLines: 3,
                                  maxLines: 15,
                                  onChanged: (txt){
                                    AbstractDatabaseService.diaryCardEventInstanceData["actions"] = txt;
                                    updateDB();
                                  }
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                            ]
                        ),


                        SizedBox(
                            width: MediaQuery.of(context).size.width/1.1,
                            child:Padding(padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                        onPressed: (){print("Verwerfen");},
                                        child: Text("Verwerfen")),
                                  ),

                                  Expanded(
                                      child: OutlinedButton(
                                          onPressed: (){print("Speichern");},
                                          child: Text("Speichern"))
                                  ),

                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  );


                }
                return Center(
                  child: Text("Loading..."),
                );
              },
            )
          ),
        )
    );
  }
}
