import 'dart:async';
import 'package:dbt4c_rebuild/helpers/stringUtil.dart';
import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/helpers/sProtPreview.dart';
import 'package:dbt4c_rebuild/screens/skillProtocollTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class SkillProtocollMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkillProtocollMenuState(),
    );
  }
}

class SkillProtocollMenuState extends StatefulWidget{
  @override
  _SkillProtocollMenuState createState() => _SkillProtocollMenuState();
}

class _SkillProtocollMenuState extends State<SkillProtocollMenuState>{
  EventList<Event> eventList = new EventList(events: {DateTime.now() : [new Event(date: DateTime.now())]});
  DateTime? selectedDate;

  String skillOfTheWeek = "";
  String numSkillsUsed = "";
  String mindfulness = "";
  String bestSkill = "";
  String bestValue = "";

  FutureOr onGoBack(dynamic value){
    setState(() {
    });
  }

  Widget markedIconGenerator() => Container(
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(
            width: 3,
            color: Colors.green
        )
    ),
  );


  Future<bool> getPreviewData() async {
    await getDates();
    print(selectedDate);
    if (eventList.events.containsKey(selectedDate!)) {
      Map<String, String> data = await AbstractDatabaseService.directRead(
          "SkillProtocoll", DateFormat('dd.MM.yyyy').format(selectedDate!));
      skillOfTheWeek = data["skillOfTheWeek"].toString();
      int tempInt = 0;
      int notNullValues = 0;
      int tempMax = 0;
      String tempName = "";
      for (String key in data.keys) {
        if (data[key]! != "" && data[key] != "0") {
          notNullValues++;
          tempInt = int.tryParse(data[key]!) ?? 0;
          if (tempInt >= tempMax) {
            tempMax = tempInt;
            tempName = key;
          }
        }
      }
      numSkillsUsed = notNullValues.toString();
      mindfulness = "Ja";
      bestSkill = tempName;
      bestValue = tempMax.toString();
      return true;
    }
    return false;
  }

  Future<bool> getDates() async{
    print("getdates()");
    List<String> dateStrings = [];
    Map<DateTime,List<Event>> temp = Map<DateTime,List<Event>>();
    await AbstractDatabaseService.getFullColumn("SkillProtocoll", "PrimaryKey").then((value) => dateStrings = value!);
    print("Dates aus DB ausgelesen:");
    print(dateStrings);
    for(String date in dateStrings){
      print(date);
      DateTime converted = DateTime.parse(StringUtil.getRetardedDateFormat(date));
      List<Event> event = [Event(date: converted, icon: markedIconGenerator())];
      temp.putIfAbsent(converted, () => event);
    }
    eventList = EventList(events: temp);
    print(eventList.events.keys.toString());
    return true;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(selectedDate == null){
      selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      print("reset date to today");
    }
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:Scaffold(
          extendBodyBehindAppBar: true,
          appBar: DefaultSubAppBar(
            appBarLabel: "Skill Protokoll",
            backGroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body: MainContainer(
            backgroundImage: AssetImage("lib/resources/WallpaperProtocoll.png"),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: getDates(),
                      builder: (context, AsyncSnapshot<bool> isDone){
                        if(isDone.hasData){
                          return SizedBox(
                              width: MediaQuery.of(context).size.width/1.1,
                              height: MediaQuery.of(context).size.height/1.86,
                              child:

                              CalendarCarousel<Event>(
                                locale: "de",
                                headerTextStyle: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                                weekdayTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                markedDatesMap: eventList,
                                markedDateShowIcon: true,
                                markedDateIconMaxShown: 1,
                                markedDateIconMargin: 0,
                                selectedDayButtonColor: Color.fromRGBO(255,255,255, .2),
                                todayButtonColor: Color.fromRGBO(50,50,50, .45),
                                todayTextStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                ),
                                weekendTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14
                                ),
                                markedDateIconBuilder: (event){
                                  return event.icon;
                                },
                                onDayPressed: (date, events){
                                  this.setState(() {
                                    selectedDate = date;
                                  });},
                                selectedDateTime: selectedDate,
                              )
                          );
                        }
                        return SizedBox(
                            width: MediaQuery.of(context).size.width/1.1,
                            height: MediaQuery.of(context).size.height/1.86,
                            child: CalendarCarousel<Event>(
                              locale: "de",
                              headerTextStyle: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              weekdayTextStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              markedDatesMap: EventList<Event>(events: Map<DateTime,List<Event>>() ),
                              selectedDayButtonColor: Color.fromRGBO(255,255,255, .2),
                              todayButtonColor: Color.fromRGBO(50,50,50, .45),
                              todayTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                              ),
                              weekendTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14
                              ),
                              markedDateIconBuilder: (event){
                                return event.icon;
                              },
                              onDayPressed: (date, events){
                                this.setState(() {
                                  selectedDate = date;
                                });},
                              selectedDateTime: selectedDate,
                            )
                        );
                      }
                  ),

                  InkWell(
                    child: FutureBuilder(
                        future: getPreviewData(),
                        builder: (context, AsyncSnapshot<bool> data){
                          if(data.data == true){
                            //print("newWay: ${data.data!["newWaySlider"].toString()}");
                            return SProtPreview(
                              skillOfTheWeek: skillOfTheWeek,
                              numSkillsUsed: numSkillsUsed,
                              mindfulness: mindfulness,
                              bestSkill: bestSkill,
                              bestValue: bestValue,
                            );
                          }
                          return ContentCard(
                            doubleX: 1.1,
                            doubleY: 2.8,
                            children: [
                              Padding(padding: EdgeInsets.all(44)),
                              Text("Neues Skill-Protokoll Erstellen", style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                              ),
                              ),
                            ]
                          );
                        }
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SkillProtocollTemplate(
                              selectedDate: DateFormat('dd.MM.yyyy').format(
                                  selectedDate!)))).then(onGoBack);
                    },
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}