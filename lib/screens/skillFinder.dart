import 'dart:collection';
import 'package:dbt4c_rebuild/helpers/stringUtil.dart';
import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/helpers/dCardPreview.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'diarycardtemplate.dart';

class SkillFinder extends StatelessWidget{
  const SkillFinder();
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: SkillFinderState(),
    );
  }
}

class SkillFinderState extends StatefulWidget{
  const SkillFinderState();
  @override
  _SkillFinderState createState() => _SkillFinderState();
}



class _SkillFinderState extends State<SkillFinderState>{
  EventList<Event> eventList = new EventList(events: {DateTime.now() : [new Event(date: DateTime.now())]});
  DateTime? selectedDate;

  String event1 = "Keine Events Vorhanden";
  String event2 = " ";
  String event3 = " ";

  Widget _testIcon() => Container(
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(
            width: 3,
            color: Colors.green
        )
    ),
  );
/*
  Container(
  margin: EdgeInsets.all(20),
  padding: EdgeInsets.all(10),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(100),
  color: Colors.white,
  border: Border.all(
  width: 2
  )
  ),
  child: Icon(Icons.arrow_downward,color: Colors.white,),
  )
*/
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
    print(eventList.events.keys);
    print("hi");
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
          event1 = "Keine Events Vorhanden";
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

  getDates() async{
    List<String> dateStrings = [];
    Map<DateTime,List<Event>> temp = Map<DateTime,List<Event>>();
    await AbstractDatabaseService.getFullColumn("DiaryCard", "PrimaryKey").then((value) => dateStrings = value!);
    for(String date in dateStrings){
      DateTime converted = DateTime.parse(StringUtil.getRetardedDateFormat(date));
      List<Event> event = [Event(date: converted, icon: _testIcon())];
      temp.putIfAbsent(converted, () => event);
    }
    eventList = EventList(events: temp);
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
    getDates();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
                SizedBox(
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
                  markedDateMoreShowTotal: null,
                  selectedDayButtonColor: Color.fromRGBO(255,255,255, .35),
                  todayButtonColor: Color.fromRGBO(50,50,50, .2),
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
                    return ContentCard(
                        doubleX: 1.1,
                        children: [
                        Padding(padding: EdgeInsets.all(44)),
                        Text("Neue Diary Card Erstellen", style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(44))]
                    );
                  }
                ),
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DiarycardTemplate(
                            selectedDate: DateFormat('dd.MM.yyyy').format(
                                selectedDate!))));
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

