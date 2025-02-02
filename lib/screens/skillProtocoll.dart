import 'dart:async';
import 'package:dbt4c_rebuild/helpers/stringUtil.dart';
import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:dbt4c_rebuild/helpers/sProtPreview.dart';
import 'package:dbt4c_rebuild/screens/skillProtocollTemplate.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class SkillProtocollMenu extends StatelessWidget {
  const SkillProtocollMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkillProtocollMenuState(),
    );
  }
}

class SkillProtocollMenuState extends StatefulWidget {
  const SkillProtocollMenuState({super.key});

  @override
  _SkillProtocollMenuState createState() => _SkillProtocollMenuState();
}

class _SkillProtocollMenuState extends State<SkillProtocollMenuState> {
  EventList<Event> eventList = EventList(events: {
    DateTime.now(): [Event(date: DateTime.now())]
  });
  DateTime? selectedDate;

  String skillOfTheWeek = "";
  String numSkillsUsed = "";
  String mindfulness = "";
  String bestSkill = "";
  String bestValue = "";

  // Wir entfernen den globalen _computedRingColor – stattdessen berechnen wir für jeden Tag individuell.

  /// Hilfsfunktion zur Berechnung des Farbwertes (Ringfarbe) für einen bestimmten Tag
  Future<Color> computeRingColorForDate(DateTime date) async {
    // Hole die Daten für diesen Tag aus der DB
    String dateKey = DateFormat('dd.MM.yyyy').format(date);
    Map<String, String> data = await AbstractDatabaseService.directRead("SkillProtocoll", dateKey);
    if (data.isEmpty) {
      // Kein Eintrag – verwende z. B. einen Default-Wert (hier grün)
      return Colors.green;
    }

    // Skill of the Week wird hier nicht zur Farb-Berechnung genutzt.
    // Wir iterieren über alle anderen Felder:
    int notNullValues = 0;
    int tempMax = 0;
    String tempName = "";
    data.forEach((key, value) {
      // Überspringe spezielle Felder
      if (key != "skillOfTheWeek" && key != "mindfulness") {
        if (value.isNotEmpty && value != "0") {
          notNullValues++;
          int val = int.tryParse(value) ?? 0;
          if (val >= tempMax) {
            tempMax = val;
            tempName = key;
          }
        }
      }
    });

    int points = 0;
    // Punkte für den besten Skill
    if (tempMax >= 67) {
      points += 2;
    } else if (tempMax >= 34) {
      points += 1;
    }
    // Punkte für Achtsamkeit
    if (data["mindfulness"] != null && data["mindfulness"]!.toLowerCase() == "ja") {
      points += 1;
    }
    // Punkte für Anzahl der Skills
    if (notNullValues >= 3) {
      points += 2;
    } else if (notNullValues >= 1) {
      points += 1;
    }
    // Gesamtpunkte (max. 5) → Lineare Interpolation von Rot (0 Punkte) zu Grün (5 Punkte)
    double factor = points / 5.0;
    int red = (255 * (1 - factor)).round();
    int green = (255 * factor).round();
    return Color.fromRGBO(red, green, 0, 1);
  }

  /// Angepasster Icon-Generator, der den übergebenen Farbwert nutzt
  Widget markedIconGenerator(Color ringColor) => Container(
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(width: 3, color: ringColor)),
  );

  /// Lese die Vorschau-Daten für den aktuell gewählten Tag aus
  Future<bool> getPreviewData() async {
    // Lade zunächst alle Daten (und somit eventList) neu
    await getDates();
    if (eventList.events.containsKey(selectedDate!)) {
      Map<String, String> data = await AbstractDatabaseService.directRead(
          "SkillProtocoll", DateFormat('dd.MM.yyyy').format(selectedDate!));
      skillOfTheWeek = data["skillOfTheWeek"].toString();

      int tempInt = 0;
      int notNullValues = 0;
      int tempMax = 0;
      String tempName = "";
      data.forEach((key, value) {
        if (value != "" && value != "0") {
          notNullValues++;
          tempInt = int.tryParse(value) ?? 0;
          if (tempInt >= tempMax) {
            tempMax = tempInt;
            tempName = key;
          }
        }
      });
      numSkillsUsed = notNullValues.toString();
      bestSkill = tempName;
      bestValue = tempMax.toString();

      // Diese Berechnung erfolgt hier nur für die Vorschau (den aktuell gewählten Tag).
      int points = 0;
      if (tempMax >= 67) {
        points += 2;
      } else if (tempMax >= 34) {
        points += 1;
      }
      if (data["mindfulness"] != null && data["mindfulness"]!.toLowerCase() == "ja") {
        points += 1;
        mindfulness = "Ja";
      } else {
        mindfulness = "Nein";
      }
      if (notNullValues >= 3) {
        points += 2;
      } else if (notNullValues >= 1) {
        points += 1;
      }

      // Berechne den Farbwert für den aktuell gewählten Tag:
      double factor = points / 5.0;
      int red = (255 * (1 - factor)).round();
      int green = (255 * factor).round();
      Color newRingColor = Color.fromRGBO(red, green, 0, 1);
      // Aktualisiere die Vorschau (falls gewünscht)
      setState(() {
        // Hier könnte man _computedRingColor nur für selectedDate setzen, wenn benötigt.
        // Für die Kalenderansicht wird die Farbe pro Tag in getDates() berechnet.
      });
      return true;
    }
    return false;
  }

  /// Lese alle Datumseinträge aus der DB für das Skill-Protokoll und berechne jeweils den individuellen Farbwert.
  Future<bool> getDates() async {
    List<String> dateStrings = [];
    Map<DateTime, List<Event>> temp = {};
    await AbstractDatabaseService.getFullColumn("SkillProtocoll", "PrimaryKey")
        .then((value) => dateStrings = value!);
    for (String date in dateStrings) {
      DateTime converted =
      DateTime.parse(StringUtil.getRetardedDateFormat(date));
      // Berechne den individuellen Farbwert für dieses Datum:
      Color ringColor = await computeRingColorForDate(converted);
      List<Event> event =
      [Event(date: converted, icon: markedIconGenerator(ringColor))];
      temp.putIfAbsent(converted, () => event);
    }
    eventList = EventList(events: temp);
    return true;
  }

  @override
  void initState() {
    super.initState();
    // Stelle sicher, dass selectedDate initialisiert wird.
    selectedDate ??= DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  @override
  Widget build(BuildContext context) {
    // Falls selectedDate noch nicht gesetzt ist, initialisiere auf heute.
    selectedDate ??= DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
          backgroundImage: AssetImage("lib/resources/WallpaperProtocoll.png"),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: getDates(),
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 1.86,
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
                          markedDatesMap: eventList,
                          markedDateShowIcon: true,
                          markedDateIconMaxShown: 1,
                          markedDateIconMargin: 0,
                          selectedDayButtonColor:
                          Color.fromRGBO(255, 255, 255, .2),
                          todayButtonColor:
                          Color.fromRGBO(50, 50, 50, .45),
                          todayTextStyle:
                          TextStyle(fontSize: 14, color: Colors.white),
                          weekendTextStyle: TextStyle(
                              color: Colors.black, fontSize: 14),
                          markedDateIconBuilder: (event) {
                            return event.icon;
                          },
                          onDayPressed: (date, events) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          selectedDateTime: selectedDate,
                        ),
                      );
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.height / 1.86,
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
                        markedDatesMap: EventList<Event>(
                            events: <DateTime, List<Event>>{}),
                        selectedDayButtonColor:
                        Color.fromRGBO(255, 255, 255, .2),
                        todayButtonColor:
                        Color.fromRGBO(50, 50, 50, .45),
                        todayTextStyle:
                        TextStyle(fontSize: 14, color: Colors.white),
                        weekendTextStyle: TextStyle(
                            color: Colors.black, fontSize: 14),
                        markedDateIconBuilder: (event) {
                          return event.icon;
                        },
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
                InkWell(
                  child: FutureBuilder(
                    future: getPreviewData(),
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data == true) {
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
                          Text(
                            "Neues Skill-Protokoll Erstellen",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SkillProtocollTemplate(
                          selectedDate:
                          DateFormat('dd.MM.yyyy').format(selectedDate!),
                        ),
                      ),
                    );
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
