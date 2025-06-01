import 'package:flutter_calendar_carousel/classes/event.dart';

class CalendarEntry extends Event {
  final List<int> intData;
  final List<String> stringData;

  CalendarEntry({
    required this.intData,
    required this.stringData,
    required super.date,
    super.icon,
  });
}