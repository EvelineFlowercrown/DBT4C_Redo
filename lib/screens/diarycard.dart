import 'dart:async';
import 'dart:collection';
import 'package:dbt4c_rebuild/helpers/stringUtil.dart';
import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/screens/diarycardtemplate.dart';
import 'package:dbt4c_rebuild/helpers/dCardPreview.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class DiaryCardMenu extends StatelessWidget{
  const DiaryCardMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiaryCardMenuState(),
    );
  }
}

class DiaryCardMenuState extends StatefulWidget{
  const DiaryCardMenuState({super.key});

  @override
  _DiaryCardMenuState createState() => _DiaryCardMenuState();
}

class _DiaryCardMenuState extends State<DiaryCardMenuState>{
  EventList<Event> eventList = EventList(events: {DateTime.now() : [Event(date: DateTime.now())]});

  // Selected Date Variable
  DateTime? selectedDate;

  // Events displayed in the Diary Card Summary
  String event1 = "Keine Events Vorhanden";
  String event2 = " ";
  String event3 = " ";

  // no fucking idea
  FutureOr onGoBack(dynamic value){
    setState(() {
    });
  }


  Widget markedIconGenerator(Color ringColor) => Container(
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(100)),
      border: Border.all(
        width: 3,
        color: ringColor, // Use the dynamic color here
      ),
    ),
  );

  Future<Map<String,String>> getPreviewData() async{

    List<String> neededKeys =[
      "eventData",
      "newWaySlider",
      "moodSlider",
      "tensionSlider1",
      "miserySlider"
    ];

    Map<String,String> returnMap = HashMap<String,String>();
    for(String key in neededKeys){
      returnMap.putIfAbsent(key, () => " - ");}
    await getDates();
    if(eventList.events.containsKey(selectedDate!)) {
      Map<String,String> data = await AbstractDatabaseService.directRead("DiaryCard", DateFormat('dd.MM.yyyy').format(selectedDate!));
      for(String key in returnMap.keys){
        if(data[key]!.isNotEmpty){
          if(key == "eventData"){
            int i = 0;
            for(String event in await getEventsFromString(data[key].toString())){
              i++;
              switch(i){
                case 1 : {event1 = event; break;}
                case 2 : {event2 = event; break;}
                case 3 : {event3 = event; break;}
              }
            }
          }
          else{
            returnMap.update(key, (oldValue) => data[key].toString());
          }
        }
        else if(data["eventData"]!.length < 5){
          event1 = "Keine Ereignisse";
          event2 = " ";
          event3 = " ";
        }
      }
      return returnMap;
    }

    else{
      print("keine diay card vorhanden");
      return returnMap;
    }
  }

  Future<List<String>> getEventsFromString(String input) async{
    List<String> temp = [];
    while(input.contains(",")){
      String key = input.substring(0, input.indexOf(","));
      Map<String,String> currentData = await AbstractDatabaseService.directRead("DiaryCardEvents", key);
      if(currentData["title"] != null && currentData["title"]!.length >= 2){
        temp.add(currentData["title"].toString());
      }
      if(input.indexOf(",") < input.lastIndexOf(",")){
        input = input.substring(input.indexOf(",") + 1);
      }
      else{
        input = "";
      }
    }
    return temp;
  }

  Future<bool> getDates() async {
    List<String> dateStrings = [];
    Map<DateTime, List<Event>> temp = {};

    // Fetching data
    await AbstractDatabaseService.getFullColumn("DiaryCard", "PrimaryKey").then((value) {
      if (value != null) {
        dateStrings = value;
      }
    });

    for (String date in dateStrings) {
      // Default color
      Color ringColor = Color.fromRGBO(255, 255, 255, 1.0);

      DateTime converted = DateTime.parse(StringUtil.getRetardedDateFormat(date));

      // Asynchron den Mood-Wert laden
      var value = await DatabaseProvider().getEntry("DiaryCard", date);
      if (value["moodSlider"] != null && value["moodSlider"].toString().isNotEmpty) {
        double? mood = double.tryParse(value["moodSlider"].toString());
        if (mood != null) {
          mood = mood.clamp(0, 100);
          ringColor = Color.fromRGBO(
            (255 * (1 - (mood / 100))).round(),
            (255 * (mood / 100)).round(),
            0,
            1,
          );
        }
      }

      // Nun den Event mit dem dynamischen ringColor erstellen:
      List<Event> event = [Event(date: converted, icon: markedIconGenerator(ringColor))];
      temp.putIfAbsent(converted, () => event);
    }

    eventList = EventList(events: temp);
    return true;
  }

  @override
  void initState() {
    super.initState();
    getDates();
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
            appBarLabel: "Diary Card",
            backGroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body: MainContainer(
            backgroundImage: AssetImage("lib/resources/WallpaperDCard.png"),
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
                                setState(() {
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
                            markedDatesMap: EventList<Event>(events: <DateTime,List<Event>>{} ),
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
                              setState(() {
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
                        builder: (context, AsyncSnapshot<Map<String,String>> data){
                          if(data.hasData && eventList.events.containsKey(selectedDate)){
                            //print("newWay: ${data.data!["newWaySlider"].toString()}");
                            return DCardPreview(
                              eventNames:[
                                event1,
                                event2,
                                event3
                              ],
                              newWay: data.data!["newWaySlider"].toString(),
                              mood: data.data!["moodSlider"].toString(),
                              tension: data.data!["tensionSlider1"].toString(),
                              misery: data.data!["miserySlider"].toString(),
                            );
                          }
                          return ContentCard(doubleX: 1.1, children: [
                            Padding(padding: EdgeInsets.all(44)),
                            Text("Neue Diary Card Erstellen", style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            ),),
                            Padding(padding: EdgeInsets.all(44)),
                          ]);
                        }
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DiarycardTemplate(
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
