import 'package:dbt4c_rebuild/widgets/contentCard.dart';
import 'package:flutter/material.dart';

class SProtPreview extends StatefulWidget {
  final String skillOfTheWeek;
  final String numSkillsUsed;
  final String mindfulness;
  final String bestSkill;
  final String bestValue;
  const SProtPreview(
      {super.key, required this.skillOfTheWeek,
      required this.numSkillsUsed,
      required this.mindfulness,
      required this.bestSkill,
      required this.bestValue});
  @override
  _SProtPreviewState createState() => _SProtPreviewState();
}

class _SProtPreviewState extends State<SProtPreview> {
  @override
  Widget build(BuildContext context) {
    return ContentCard(doubleX: 1.1, doubleY: 2.8, children: [
      Padding(padding: EdgeInsets.all(10)),
      Text(
        "Skill der Woche",
        style: TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      Padding(padding: EdgeInsets.all(10)),
      Text(
        widget.skillOfTheWeek,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      Padding(padding: EdgeInsets.all(15)),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events_sharp,
            size: 18,
            color: Colors.white,
          ),
          Padding(padding: EdgeInsets.all(5)),
          Text(
            "Bester Skill: ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${widget.bestSkill.toString()} ${widget.bestValue.toString()}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),)
        ],
      ),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mood_bad_sharp,
            size: 18,
            color: Colors.white,
          ),
          Padding(padding: EdgeInsets.all(5)),
          Text(
            "Genutzte Skills: ${widget.numSkillsUsed}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Padding(padding: EdgeInsets.all(15)),
          Icon(
            Icons.equalizer_sharp,
            size: 18,
            color: Colors.white,
          ),
          Padding(padding: EdgeInsets.all(5)),
          Text(
            "Achtsam: ${widget.mindfulness}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      )
    ]);
  }
}
