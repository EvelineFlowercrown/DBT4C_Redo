import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';


// ignore: must_be_immutable
class CalendarWidget extends StatefulWidget{
  bool selectedDone = false;
  final bool showStatus;
  CalendarWidget({super.key, this.showStatus = false});
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<DateTime>? newDates;
  void addThing(List<DateTime> times) => createState().addDCardEventList(times);
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

List<DateTime> listDates = [];
class _CalendarWidgetState extends State<CalendarWidget>{

  //DateTime _currentDate = DateTime.now(); not important yet
  final EventList<Event> _markedDate = EventList<Event>(
    events: {},
  );
  static Widget _testIcon(String day) => Container(
    decoration: BoxDecoration(
      color: Colors.greenAccent,
      borderRadius: BorderRadius.all(Radius.circular(1000)),
    ),
    child: Center(
      child: Text(
        day,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
  void addDCardEventList(List<DateTime> times){
    listDates = times;
  }
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < listDates.length; i++){
      _markedDate.add(
        listDates[i],
        Event(
          date: listDates[i],
          title: 'Event1',
          icon: _testIcon(
            listDates[i].day.toString(),
          ),
        ),
      );
    }
    return CalendarCarousel<Event>(
      locale: "de",
      headerTextStyle: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
      weekdayTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      iconColor: Colors.white,
      markedDatesMap: _markedDate,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,
      markedDateIconBorderColor: Colors.red,
      selectedDayButtonColor: Colors.green,
      markedDateIconBuilder: (event){
        return event.icon;
      },
      onDayPressed: (date, events){
        setState(() {
          widget.selectedDate = date;
          if(listDates.contains(date)){
            widget.selectedDone = true;
          }
          else {
            widget.selectedDone = false;
          }
        });
      },
      selectedDateTime: widget.selectedDate,
    );
  }
}