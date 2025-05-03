import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataHandlers/diaryCardDataHandler.dart';
import 'contentCard.dart';
import 'diaryCardEventDisplay.dart';
import '../screens/diaryCardNewEvent.dart';

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
    _loadEvents();
  }

  void _loadEvents() {
    _futureEvents = DiaryCardDataHandler.loadAllEvents(widget.date);
  }

  void _refresh() {
    setState(() {
      _loadEvents();
    });
  }

  Future<void> _deleteEvent(String eventKey) async {
    await DiaryCardDataHandler.directDelete("DiaryCardEvents", eventKey);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: _futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(padding: EdgeInsets.all(5));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(padding: EdgeInsets.all(5));
        }

        List<Widget> eventWidgets = snapshot.data!.map((event) {
          String key = event["id"].toString();
          return DiaryCardEventDisplay(
            eventName: event["title"].toString(),
            shortDescription: event["shortDescription"].toString(),
            trashCallback: () => _showDeleteConfirmation(context, key),
            editCallback: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => DiaryCardNewEvent(
                  primaryKey: key,
                  date: widget.date,
                ),
              )).then((_) => _refresh());
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
        title: Text("Bist du sicher?"),
        content: Text("Willst du dieses Ereignis wirklich löschen?"),
        actions: [
          TextButton(
            child: Text("Abbrechen"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Löschen"),
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
