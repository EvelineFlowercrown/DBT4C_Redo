import 'package:flutter/material.dart';

class Moodring extends StatefulWidget {
  final int mood;
  const Moodring({super.key,required this.mood});
  @override
  _MoodringState createState() => _MoodringState();
}

class _MoodringState extends State<Moodring> {
  @override
  Widget build(BuildContext context) {
    Color ringColor = Color.fromRGBO(255, 255, 255, 1.0);
    if(widget.mood >= 1){
      int mood = widget.mood.clamp(0, 100);
      ringColor = Color.fromRGBO((255 * (1 - (mood / 100))).round(), (255 * (mood / 100)).round(), 0, 1,);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(
          width: 3,
          color: ringColor, // Use the dynamic color here
        ),
      ),
    );
  }}