import 'dart:async';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/dataHandlers/diaryCardDataHandler.dart';
import 'package:dbt4c_rebuild/helpers/dCardPreview.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/screens/diarycardtemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:dbt4c_rebuild/helpers/moodRing.dart';

class DiaryCardCalendar extends StatelessWidget {
  const DiaryCardCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiaryCardCalendarState(),
    );
  }
}

class DiaryCardCalendarState extends StatefulWidget {
  const DiaryCardCalendarState({super.key});

  @override
  _DiaryCardCalendarState createState() => _DiaryCardCalendarState();
}

class _DiaryCardCalendarState extends State<DiaryCardCalendarState> {
  // Enthält die Events für das CalendarCarousel
  EventList<Event> eventList = EventList(events: {});
  // Aktuell ausgewähltes Datum
  DateTime selectedDate = DateTime.now();
  // Zur Anzeige der Eventtitel (maximal 3)
  List<String> eventTitles = ["Keine Events Vorhanden", "", ""];
  //raw calendar data
  Map<String, List<int>> rawCalendarData = {};

  // Future, das die Eventtitel lädt.
  late Future<void> _loadTitlesFuture;
  late Future<void> _loadCalendarFuture;
  late Future<void> _rawCalendarDataFuture;

  // Fetches raw calendar data and stores it in a class field
  Future<void> fetchRawCalendarData() async {
    rawCalendarData = await DiaryCardDataHandler.fetchCalenderData();
  }

  // Generates eventList using the stored raw data
  Future<void> generateEventList() async {
    Map<DateTime, List<Event>> tempEvents = {};
    rawCalendarData.forEach((dateStr, sliders) {
      try {
        DateTime date = DateFormat('dd.MM.yyyy').parse(dateStr);
        Event event = Event(date: date, icon: Moodring(mood: sliders[1]));
        tempEvents.putIfAbsent(date, () => []).add(event);
      } catch (e) {
        print("Ungültiges Datum: $dateStr");
      }
    });
    setState(() {
      eventList = EventList(events: tempEvents);
    });
  }

  // Lädt die ersten drei Eventtitel für das ausgewählte Datum aus DiaryCardEvents.
  Future<void> loadEventTitles() async {
    String formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate);
    List<String> titles =
    await DiaryCardDataHandler.fetchEventTitles(formattedDate);
    // Falls weniger als 3 Titel zurückkommen, mit leeren Strings auffüllen.
    while (titles.length < 3) {
      titles.add("");
    }
    setState(() {
      eventTitles = titles;
    });
  }

  // Wird beim Zurückkehren aus einem anderen Screen aufgerufen, um die Ansicht zu aktualisieren.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Starte mit dem aktuellen Datum
    selectedDate = DateTime.now();
    _rawCalendarDataFuture = fetchRawCalendarData();
    _loadCalendarFuture = generateEventList();
    _loadTitlesFuture = loadEventTitles();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DefaultSubAppBar(
          appBarLabel: "Diary Card",
          backGroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: MainContainer(
          backgroundImage: const AssetImage("lib/resources/WallpaperDCard.png"),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Kalenderbereich
                FutureBuilder(
                  future: _loadCalendarFuture,
                  builder: (context, AsyncSnapshot<void> snapshot) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.height / 1.86,
                      child: CalendarCarousel<Event>(
                        locale: "de",
                        headerTextStyle: const TextStyle(
                            fontSize: 20.0, color: Colors.white),
                        weekdayTextStyle: const TextStyle(
                            fontSize: 14, color: Colors.white),
                        markedDatesMap: eventList,
                        markedDateShowIcon: true,
                        markedDateIconMaxShown: 1,
                        markedDateIconMargin: 0,
                        selectedDayButtonColor:
                        const Color.fromRGBO(255, 255, 255, .2),
                        todayButtonColor:
                        const Color.fromRGBO(50, 50, 50, .45),
                        todayTextStyle: const TextStyle(
                            fontSize: 14, color: Colors.white),
                        weekendTextStyle: const TextStyle(
                            color: Colors.black, fontSize: 14),
                        markedDateIconBuilder: (event) => event.icon,
                        onDayPressed: (date, events) {
                          setState(() {
                            selectedDate = date;
                            // Aktualisiere das Future, wenn ein neues Datum gewählt wurde.
                            _loadTitlesFuture = loadEventTitles();
                          });
                        },
                        selectedDateTime: selectedDate,
                      ),
                    );
                  },
                ),
                // Event-Display-Bereich
                InkWell(
                  child: FutureBuilder(
                    future: _loadTitlesFuture,
                    builder: (context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Wenn Eventtitel vorhanden sind, zeige diese in DCardPreview
                        if (eventTitles.isNotEmpty &&
                            eventTitles.first.isNotEmpty) {
                          return DCardPreview(
                            eventNames: eventTitles,
                            // Hier können ggf. auch Sliderwerte aus einer DiaryCard geladen werden
                            newWay: "-",
                            mood: "-",
                            tension: "-",
                            misery: "-",
                          );
                        } else {
                          // Fallback, wenn keine DiaryCard vorhanden ist
                          return ContentCard(
                            doubleX: 1.1,
                            children: [
                              const Padding(padding: EdgeInsets.all(44)),
                              const Text("Neue Diary Card Erstellen",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              const Padding(padding: EdgeInsets.all(44)),
                            ],
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiarycardTemplate(
                          selectedDate:
                          DateFormat('dd.MM.yyyy').format(selectedDate),
                        ),
                      ),
                    ).then(onGoBack);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
