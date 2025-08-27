import 'dart:async';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/sProtPreview.dart';
import 'package:dbt4c_rebuild/widgets/contentCard.dart';
import 'package:dbt4c_rebuild/screens/skillProtocollTemplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:dbt4c_rebuild/widgets/moodRing.dart';
import 'package:dbt4c_rebuild/helpers/calendarEntry.dart';


class SkillProtocollCalendar extends StatelessWidget {
  const SkillProtocollCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkillProtocollCalendarState(),
    );
  }
}

class SkillProtocollCalendarState extends StatefulWidget {
  const SkillProtocollCalendarState({super.key});

  @override
  _SkillProtocollCalendarState createState() => _SkillProtocollCalendarState();
}

class _SkillProtocollCalendarState extends State<SkillProtocollCalendarState> {
  EventList<CalendarEntry> eventList = EventList(events: {});
  DateTime selectedDate = DateTime.now();
  Map<String, (List<int>, List<String>)> rawCalendarData = {};


  late Future<void> _loadCalendarFuture;

  Future<void> fetchRawCalendarData() async {
    rawCalendarData =
    await ConfigHandler.skillProtocollDataHandler.fetchCalendarData(
        DateFormat('dd.MM.yyyy').format(selectedDate));
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
          icon: Moodring(mood: intData[1]*30),
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
          appBarLabel: "Skill Protokoll",
          backGroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: MainContainer(
          backgroundImage: const AssetImage(
              "lib/resources/WallpaperProtocoll.png"),
          child: SingleChildScrollView(
            child: Column(
              children: [

                // Kalenderbereich
                FutureBuilder(
                  future: _loadCalendarFuture,
                  builder: (context, AsyncSnapshot<void> snapshot) {
                    return SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.1,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 1.86,
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

                        return SProtPreview(
                          skillOfTheWeek: entry.stringData.isNotEmpty ? entry
                              .stringData[0] : "-",
                          bestSkill: ConfigHandler.SkillNames.containsKey(
                              entry.stringData.length > 1 ? entry.stringData[1] : '')
                              ? ConfigHandler.SkillNames[entry.stringData[1]]!
                              : "-",
                          mindfulness: entry.stringData.length > 2 ? entry
                              .stringData[2] : "-",
                          bestValue: entry.intData.isNotEmpty ? entry.intData[0]
                              .toString() : "-",
                          numSkillsUsed: entry.intData.length > 1 ? entry
                              .intData[1].toString() : "-",
                        );
                      }
                      else {
                        return ContentCard(
                          doubleX: 1.1,
                          doubleY: 2.8,
                          children: [
                            Padding(padding: EdgeInsets.all(44)),
                            Text(
                              "Neues Skill-Protokoll Erstellen",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  onTap: () {
                    ConfigHandler.skillProtocollDataHandler.initIntegerData([]);
                    ConfigHandler.skillProtocollDataHandler.initTextData([]);
                    ConfigHandler.skillProtocollDataHandler.initBooleanData([]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SkillProtocollTemplate(
                              selectedDate:
                              DateFormat('dd.MM.yyyy').format(selectedDate),
                            ),
                      ),
                    ).then(onGoBack);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}