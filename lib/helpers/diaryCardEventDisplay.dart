import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/expandableWidgetPanel.dart';

class DiaryCardEventDisplay extends StatefulWidget {
  final String eventName;
  final String shortDescription;
  final VoidCallback? trashCallback;
  final VoidCallback? editCallback;
  const DiaryCardEventDisplay({super.key, required this.eventName, required this.shortDescription, this.trashCallback, this.editCallback});
  @override
  _DiaryCardEventDisplayState createState() => _DiaryCardEventDisplayState();
}

class _DiaryCardEventDisplayState extends State<DiaryCardEventDisplay> {
  @override
  Widget build(BuildContext context) {
    return ExpandedWidgetPanel(title: widget.eventName,
      backgroundColor: Color.fromRGBO(255, 255, 255, .2),
      leadingTitle: IconButton(icon: Icon(Icons.delete), onPressed: widget.trashCallback,),
      child: ListTile(
        title: Text("Beschreibung"),
        subtitle: Text(widget.shortDescription),
        trailing: IconButton(icon: Icon(Icons.edit), onPressed: widget.editCallback
          ),
      ),
    );
  }
}

