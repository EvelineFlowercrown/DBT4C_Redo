import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/widgets/contentCard.dart';
import 'package:dbt4c_rebuild/widgets/dCardSlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';

class SkillProtocollTemplate extends StatelessWidget {
  final String? selectedDate;
  const SkillProtocollTemplate({super.key, required this.selectedDate});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SkillProtocollTemplateState(
        selectedDate: selectedDate,
      ),
    );
  }
}

class SkillProtocollTemplateState extends StatefulWidget {
  final String? selectedDate;
  const SkillProtocollTemplateState({super.key, required this.selectedDate});
  @override
  _SkillProtocollTemplateState createState() => _SkillProtocollTemplateState();
}

class _SkillProtocollTemplateState extends State<SkillProtocollTemplateState> {
  Map<String, String> instanceData =
      AbstractDatabaseService.skillProtocollInstanceData;

  // region keyset
  List<String> keySet = [
    "skillOfTheWeek",
    "observing",
    "describingInside",
    "describingOutside",
    "participating",
    "mindfulBreathing",
    "nonjudgemental",
    "focused",
    "effective",
    "distraction",
    "snapBackToReality",
    "calmFiveSenses",
    "changeMoment",
    "proVsCon",
    "breathing",
    "slightSmile",
    "radicalAcceptance",
    "newWay",
    "willingness",
    "antiCraving",
    "watchForTraps",
    "everydayHero",
    "emoProtPresent",
    "emoProtPast",
    "oppositeActions",
    "reduceVulnerability",
    "factCheck",
    "emotionSurfing",
    "challengingCoreBeliefs",
    "stopThink",
    "orientationOnGoal",
    "orientationOnRelationship",
    "orientationOnSelfWorth",
    "sayNo",
    "askForShit",
    "solveProblems",
    "validation",
    "fair",
    "insef",
    "balanceStress",
    "actAgainstBeliefs",
  ];
// endregion keyset

  // region TextEditiongControllers
  TextEditingController date = TextEditingController();
  TextEditingController skillOfTheWeek = TextEditingController();
  // endregion TextEditiongControllers

  // region SliderValues
  int distraction = 0;
  int snapBackToReality = 0;
  int calmFiveSenses = 0;
  int changeMoment = 0;
  int proVsCon = 0;
  int breathing = 0;
  int slightSmile = 0;
  int radicalAcceptance = 0;
  int newWay = 0;
  int willingness = 0;
  int antiCraving = 0;

  int watchForTraps = 0;
  int everydayHero = 0;
  int emoProtPresent = 0;
  int emoProtPast = 0;
  int oppositeActions = 0;
  int reduceVulnerability = 0;
  int factCheck = 0;
  int emotionSurfing = 0;
  int challengingCoreBeliefs = 0;
  int stopThink = 0;

  int orientationOnGoal = 0;
  int orientationOnRelationship = 0;
  int orientationOnSelfWorth = 0;
  int sayNo = 0;
  int askForShit = 0;
  int solvingProblems = 0;
  int validation = 0;

  int fair = 0;
  int insef =
      0; //insel-skill IN wards attention - S elf validation - E xperiment - F ind solutions
  int balanceStress = 0;
  int actAgainstBeliefs = 0;

// endregion SliderValues

  Future<bool> initMap() async {
    return AbstractDatabaseService.initMap(
        "SkillProtocoll", widget.selectedDate.toString(), instanceData, keySet);
  }

  void updateDB() {
    print("updateDB");
    print(instanceData.toString());
    AbstractDatabaseService.refreshDB(
        "SkillProtocoll", widget.selectedDate.toString(), instanceData);
  }

  @override
  void initState() {
    super.initState();
    date.text = widget.selectedDate.toString();
    initMap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: DefaultSubAppBar(
            appBarLabel: "Skill Protokoll",
            backGroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("hi");
            },
            child: Icon(Icons.share),
          ),
          body: MainContainer(
            backgroundImage: AssetImage("lib/resources/WallpaperProtocoll.png"),
            child: SingleChildScrollView(
                child: FutureBuilder(
                    future: initMap(),
                    builder: (context, AsyncSnapshot<bool> dataAvailable) {
                      if (dataAvailable.data == true) {
                        print("first futurebuilder instancedata:");
                        print(instanceData.toString());
                        skillOfTheWeek.text = instanceData["skillOfTheWeek"].toString();

                        distraction = int.tryParse(instanceData["distraction"]!) ??0;
                        snapBackToReality = int.tryParse(instanceData["snapBackToReality"]!) ??0;


                        return Column(
                          children: [


                            Padding(padding: EdgeInsets.all(15)),


                            ContentCard(
                              doubleX: 1.1,
                              children: [
                                TextField(
                                  controller: date,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.calendar_today_outlined),
                                      hintText: widget.selectedDate),
                                  enabled: false,
                                ),
                                TextField(
                                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                    maxLength: 45,
                                    cursorColor: Colors.white,
                                    controller: skillOfTheWeek,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.assignment_rounded),
                                        hintText: "Skill der Woche"),
                                    onChanged: (txt) {
                                      instanceData["skillOfTheWeek"] = txt;
                                      updateDB();
                                    }),
                              ],
                            ),


                            Padding(padding: EdgeInsets.all(10)),


                            //ChipPanel(
                            //  doubleX: 1.1,
                            //  text: "Achtsamkeit: Was?",
                            //  keyList: [
                            //    "observing",
                            //    "Beschreiben Innen",
                            //    "Beschreiben Außen",
                            //    "Teilnehmen",
                            //    "Atemübung"
                            //  ],
                            //  dataString: "",
                            //  onChanged: (dataString) {},
                            //),
//
//
                            //ChipPanel(
                            //  doubleX: 1.1,
                            //  text: "Achtsamkeit: Wie?",
                            //  keyList: [
                            //    "Annehmend",
                            //    "Konzentriert",
                            //    "Wirkungsvoll"
                            //  ],
                            //  dataString: "",
                            //  onChanged: (dataString) {},
                            //),


                            Padding(padding: EdgeInsets.all(10)),


                            ContentCard(
                              doubleX : 1.1,
                              children: [
                                Padding(padding: EdgeInsets.all(5)),
                                Text("Stresstoleranz",
                                    style: TextStyle(fontSize: 18
                                    )),
                                Padding(padding: EdgeInsets.all(15)),
                                DiaryCardSlider(
                                  initSliderValue: distraction.toDouble(),
                                  sliderText: "Ablenkung",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    distraction = val.toInt();
                                    instanceData["distraction"] = distraction.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: snapBackToReality.toDouble(),
                                  sliderText: "Sich zurück holen durch Körperempfindungen",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    snapBackToReality = val.toInt();
                                    instanceData["snapBackToReality"] = snapBackToReality.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: calmFiveSenses.toDouble(),
                                  sliderText: "Beruhigen mithilfe der 5 Sinne",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    calmFiveSenses = val.toInt();
                                    instanceData["calmFiveSenses"] = calmFiveSenses.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: changeMoment.toDouble(),
                                  sliderText: "Den Augenblick verändern",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    changeMoment = val.toInt();
                                    instanceData["changeMoment"] = changeMoment.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: proVsCon.toDouble(),
                                  sliderText: "Pro/Contra",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    proVsCon = val.toInt();
                                    instanceData["proVsCon"] = proVsCon.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: breathing.toDouble(),
                                  sliderText: "Atemübungen",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    breathing = val.toInt();
                                    instanceData["breathing"] = breathing.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: slightSmile.toDouble(),
                                  sliderText: "Leichtes Lächeln",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    slightSmile = val.toInt();
                                    instanceData["slightSmile"] = slightSmile.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: radicalAcceptance.toDouble(),
                                  sliderText: "Radikale Akzeptanz",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    radicalAcceptance = val.toInt();
                                    instanceData["radicalAcceptance"] = radicalAcceptance.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: newWay.toDouble(),
                                  sliderText: "Entscheidung für den neuen Weg",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    newWay = val.toInt();
                                    instanceData["newWay"] = newWay.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: willingness.toDouble(),
                                  sliderText: "Innere Bereitschaft",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    willingness = val.toInt();
                                    instanceData["willingness"] = willingness.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: antiCraving.toDouble(),
                                  sliderText: "Anti Craving Skills",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    antiCraving = val.toInt();
                                    instanceData["antiCraving"] = antiCraving.toString();
                                    updateDB();
                                    },
                                ),
                              ],
                            ),


                            Padding(padding: EdgeInsets.all(10)),


                            ContentCard(
                              doubleX : 1.1,
                              children: [
                                Padding(padding: EdgeInsets.all(5)),
                                Text("Emotionsregulation",
                                    style: TextStyle(
                                        fontSize: 18
                                    )),
                                Padding(padding: EdgeInsets.all(15)),
                                DiaryCardSlider(
                                  initSliderValue: everydayHero.toDouble(),
                                  sliderText: "Held des Alltags",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    everydayHero = val.toInt();
                                    instanceData["everydayHero"] = everydayHero.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: emoProtPresent.toDouble(),
                                  sliderText: "Gefühlsprotokoll Aktuell",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    emoProtPresent = val.toInt();
                                    instanceData["emoProtPresent"] = emoProtPresent.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: emoProtPast.toDouble(),
                                  sliderText: "Gefühlsprotokoll Früher",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    emoProtPast = val.toInt();
                                    instanceData["emoProtPast"] = emoProtPast.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: oppositeActions.toDouble(),
                                  sliderText: "Entgegengesetztes Handeln",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    oppositeActions = val.toInt();
                                    instanceData["oppositeActions"] = oppositeActions.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: reduceVulnerability.toDouble(),
                                  sliderText: "ABC-Gesund",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    reduceVulnerability = val.toInt();
                                    instanceData["reduceVulnerability"] = reduceVulnerability.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: factCheck.toDouble(),
                                  sliderText: "Faktencheck",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    factCheck = val.toInt();
                                    instanceData["factCheck"] = factCheck.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: emotionSurfing.toDouble(),
                                  sliderText: "Emotionssurfing",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    emotionSurfing = val.toInt();
                                    instanceData["emotionSurfing"] = emotionSurfing.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: challengingCoreBeliefs.toDouble(),
                                  sliderText: "Glaubenssätze in Frage stellen",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    challengingCoreBeliefs = val.toInt();
                                    instanceData["challengingCoreBeliefs"] = challengingCoreBeliefs.toString();
                                    updateDB();
                                    },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: stopThink.toDouble(),
                                  sliderText: "Stop! Denk!",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    stopThink = val.toInt();
                                    instanceData["stopThink"] = stopThink.toString();
                                    updateDB();
                                    },
                                ),
                              ],
                            ),


                            Padding(padding: EdgeInsets.all(10)),


                            ContentCard(
                              doubleX : 1.1,
                              children: [
                                Padding(padding: EdgeInsets.all(5)),

                                Text("Emotionsregulation",
                                    style: TextStyle(
                                        fontSize: 18
                                    )),

                                Padding(padding: EdgeInsets.all(15)),

                                DiaryCardSlider(
                                  initSliderValue: everydayHero.toDouble(),
                                  sliderText: "Held des Alltags",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    everydayHero = val.toInt();
                                    instanceData["everydayHero"] = everydayHero.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: emoProtPresent.toDouble(),
                                  sliderText: "Gefühlsprotokoll Aktuell",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    emoProtPresent = val.toInt();
                                    instanceData["emoProtPresent"] = emoProtPresent.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: emoProtPast.toDouble(),
                                  sliderText: "Gefühlsprotokoll Früher",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    emoProtPast = val.toInt();
                                    instanceData["emoProtPast"] = emoProtPast.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: oppositeActions.toDouble(),
                                  sliderText: "Entgegengesetztes Handeln",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    oppositeActions = val.toInt();
                                    instanceData["oppositeActions"] = oppositeActions.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: reduceVulnerability.toDouble(),
                                  sliderText: "ABC-Gesund",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    reduceVulnerability = val.toInt();
                                    instanceData["reduceVulnerability"] = reduceVulnerability.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: factCheck.toDouble(),
                                  sliderText: "Faktencheck",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    factCheck = val.toInt();
                                    instanceData["factCheck"] = factCheck.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: emotionSurfing.toDouble(),
                                  sliderText: "Emotionssurfing",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    emotionSurfing = val.toInt();
                                    instanceData["emotionSurfing"] = emotionSurfing.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: challengingCoreBeliefs.toDouble(),
                                  sliderText: "Glaubenssätze in Frage stellen",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    challengingCoreBeliefs = val.toInt();
                                    instanceData["challengingCoreBeliefs"] = challengingCoreBeliefs.toString();
                                    updateDB();
                                  },
                                ),
                                DiaryCardSlider(
                                  initSliderValue: stopThink.toDouble(),
                                  sliderText: "Stop! Denk!",
                                  fontSize: 16,
                                  onChanged: (double val){
                                    stopThink = val.toInt();
                                    instanceData["stopThink"] = stopThink.toString();
                                    updateDB();
                                  },
                                ),
                              ],
                            ),
                          ]
                        );
                      }
                      return Text("Loading");
                    })),
          ),
        ));
  }
}

/*
Kategorie: Achtsamkeit Was
  "Wahrnehmen"
  "Beschreiben Innen"
  "Beschreiben Außen"
  "Teilnehmen"
  "Atemübung"

Kategorie: Achtsamkeit Wie
  "Annehmend"
  "Konzentriert"
  "Wirkungsvoll"

Kategorie: "Stresstoleranz"
  "Sich ablenken"
  "Sich zurückholen mit Körperempfindungen"
  "Beruhigen durch dir 5 sinne"
  "Den Augenblick verändern"
  "Pro und Contra"
  "Atemübungen"
  "Leichtes Lächeln"
  Achtsamkeitsübungen"
  "Radikale Akzeptanz"
  "Entscheidung für den Neuen Weg"
  "Innere Bereitschaft"
  "Anti Craving Skills"

Kategorie: "Emotionsregulation"
  "Vorsicht Falle"
  "Held des Alltags"
  "Vein A.H.A"
  "Entgegengesetzt handeln"
  "ABC Gesund"
  "Fakten Überprüfen"
  "Emotionssurfing"
  "Glaubenssätze relativieren"
  "STOP Denk"

Katrgorie: "Zwischenmenschliche Fertigkeiten"
  "Orientierung auf das Ziel"
  "Orientierung auf die Beziehung"
  "Orientierung auf die Selbstachtung"
  "Nein! Sagen"
  "Um etwas Bitten"
  "Hindernisse Beseitigen"
  "Validierung"

Kategorie: Selbstwert
  "Fairer Blick"
  "Insel Skill"
  "Frust Ausbalancieren"
  "Gegen Glaubenssätze Handeln"

 */
