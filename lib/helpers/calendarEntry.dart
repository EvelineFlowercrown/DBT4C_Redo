import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter/widgets.dart';

class CalendarEntry extends Event {
  final List<int> intData;
  final List<String> stringData;

  CalendarEntry({
    required this.intData,
    required this.stringData,
    required DateTime date,
    Widget? icon,
  }) : super(
    date: date,
    icon: icon,
  );
}