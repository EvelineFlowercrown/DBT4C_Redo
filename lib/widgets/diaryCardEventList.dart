import 'package:flutter/material.dart';
import '../dataHandlers/database.dart';
import 'contentCard.dart';
import 'diaryCardEventDisplay.dart';
import '../screens/diaryCardNewEvent.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';

class DiaryCardEventList extends StatefulWidget {
  final String date;

  const DiaryCardEventList({super.key, required this.date});

  @override
  _DiaryCardEventListState createState() => _DiaryCardEventListState();
}

class _DiaryCardEventListState extends State<DiaryCardEventList> {
  late Future<List<Map<String, Object?>>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _loadEvents();
  }

  Future<List<Map<String, Object?>>> _loadEvents() async {
    final db = await DatabaseProvider().database;
    final results = await db.query(
      'DiaryCardEvents',
      where: 'date = ?',
      whereArgs: [widget.date],
    );
    print("DiaryCardEventList.loadEvents: $results");
    print(await DatabaseProvider.getFullColumn("DiaryCardEvents","title"));
    return results;
  }

  void _refresh() {
    setState(() {
      _futureEvents = _loadEvents();
    });
  }

  Future<void> _deleteEvent(String eventKey) async {
    await ConfigHandler.diaryCardDataHandler.deleteEntry(eventKey);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: _futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(padding: EdgeInsets.all(5));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(padding: EdgeInsets.all(5));
        }

        final eventWidgets = snapshot.data!.map((event) {
          final key = event["id"].toString();
          return DiaryCardEventDisplay(
            eventName: event["title"].toString(),
            shortDescription: event["shortDescription"].toString(),
            trashCallback: () => _showDeleteConfirmation(context, key),
            editCallback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryCardNewEvent(
                    primaryKey: key,
                    date: widget.date,
                  ),
                ),
              ).then((_) => _refresh());
            },
          );
        }).toList();

        return ContentCard(
          doubleX: 1.1,
          children: eventWidgets,
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String eventKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bist du sicher?"),
        content: const Text("Willst du dieses Ereignis wirklich löschen?"),
        actions: [
          TextButton(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Löschen"),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteEvent(eventKey);
            },
          ),
        ],
      ),
    );
  }
}
