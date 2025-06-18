import 'dart:async';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/dCardPreview.dart';
import 'package:dbt4c_rebuild/widgets/contentCard.dart';
import 'package:dbt4c_rebuild/screens/diarycardtemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:dbt4c_rebuild/widgets/moodRing.dart';
import 'package:dbt4c_rebuild/helpers/calendarEntry.dart';

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
  EventList<CalendarEntry> eventList = EventList(events: {});
  // Aktuell ausgewähltes Datum
  DateTime selectedDate = DateTime.now();
  // Zur Anzeige der Eventtitel (maximal 3)
  List<String> eventTitles = ["Keine Events Vorhanden", "", ""];
  //raw calendar data
  Map<String, (List<int>, List<String>)> rawCalendarData = {};

  // Future, das die Eventtitel lädt.
  late Future<void> _loadCalendarFuture;

  // Fetches raw calendar data and stores it in a class field
  Future<void> fetchRawCalendarData() async {
    rawCalendarData = await ConfigHandler.diaryCardDataHandler.fetchCalendarData(DateFormat('dd.MM.yyyy').format(selectedDate));
  }

  // Generates eventList using the stored raw data (Map<String, (List<int>, List<String>)>)
  Future<void> generateEventList() async {
    // Map of DateTime -> list of CalendarEntry
    Map<DateTime, List<CalendarEntry>> tempEvents = {};

    rawCalendarData.forEach((dateStr, record) {
      try {
        // Parse the key (dd.MM.yyyy)
        DateTime date = DateFormat('dd.MM.yyyy').parse(dateStr);

        // Destructure record: first element is slider ints, second is titles
        List<int> intData = record.$1;
        List<String> stringData = record.$2;

        // Create CalendarEntry with all data
        CalendarEntry entry = CalendarEntry(
          intData: intData,
          stringData: stringData,
          date: date,
          // Optionally set an icon based on mood (second slider)
          icon: Moodring(mood: intData[1]),
        );

        // Add to map
        tempEvents.putIfAbsent(date, () => []).add(entry);
      } catch (e) {
        print('Ungültiges Datum: $dateStr');
      }
    });

    // Update state with new EventList
    setState(() {
      eventList = EventList(events: tempEvents);
    });
  }




  // Wird beim Zurückkehren aus einem anderen Screen aufgerufen, um die Ansicht zu aktualisieren.
  FutureOr onGoBack(dynamic value) async {
    await fetchRawCalendarData();
    await generateEventList();
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    _loadCalendarFuture = () async {
      await fetchRawCalendarData();
      await generateEventList();
    }();
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
                      child: CalendarCarousel<CalendarEntry>(
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
                          });
                        },
                        selectedDateTime: selectedDate,
                      ),
                    );
                  },
                ),
                // Event-Display-Bereich
                InkWell(
                  child: Builder(
                    builder: (context) {
                      final entries = eventList.getEvents(selectedDate);
                      if (entries.isNotEmpty) {
                        final entry = entries.first;

                        return DCardPreview(
                          eventNames: entry.stringData.take(3).toList(), // max 3 Titel
                          newWay: entry.intData.isNotEmpty ? entry.intData[0].toString() : "-",
                          mood: entry.intData.length > 1 ? entry.intData[1].toString() : "-",
                          tension: entry.intData.length > 2 ? entry.intData[3].toString() : "-",
                          misery: entry.intData.length > 3 ? entry.intData[2].toString() : "-",
                        );
                      } else {
                        return ContentCard(
                          doubleX: 1.1,
                          children: [
                            const Padding(padding: EdgeInsets.all(44)),
                            const Text("Neue Diary Card Erstellen",
                                style: TextStyle(fontSize: 16, color: Colors.white)),
                            const Padding(padding: EdgeInsets.all(44)),
                          ],
                        );
                      }
                    },
                  ),
                  onTap: () {
                    ConfigHandler.diaryCardDataHandler.initIntegerData([]);
                    ConfigHandler.diaryCardDataHandler.initTextData([]);
                    ConfigHandler.diaryCardDataHandler.initBooleanData([]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiarycardTemplate(
                          selectedDate: DateFormat('dd.MM.yyyy').format(selectedDate),
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
