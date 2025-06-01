import 'package:flutter/material.dart';

class PrefilledDateField extends StatelessWidget {
  final String date;

  const PrefilledDateField({super.key, required this.date});


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()..text = date,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          icon: Icon(Icons.calendar_today_outlined),
          hintText: date
      ),
      enabled: false,
    );
  }
}