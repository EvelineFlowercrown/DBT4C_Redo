import 'package:flutter/material.dart';

final Map<String, IconData> iconMap = {
  'calendar_today_outlined': Icons.calendar_today_outlined,
  'arrow_downward': Icons.arrow_downward,
  'assignment_rounded': Icons.assignment_rounded,
  'assignment_turned_in_rounded': Icons.assignment_turned_in_rounded,
  'check_box_outline_blank': Icons.check_box_outline_blank,
  'check_box_outlined': Icons.check_box_outlined,
  'emoji_events_sharp': Icons.emoji_events_sharp,
  'emoji_emotions_sharp': Icons.emoji_emotions_sharp,
  'mood_bad_sharp': Icons.mood_bad_sharp,
  'equalizer_sharp': Icons.equalizer_sharp,
  'delete': Icons.delete,
  'edit': Icons.edit,
  'share': Icons.share,
  'photo': Icons.photo,
  'photo_library': Icons.photo_library,
  'photo_camera': Icons.photo_camera,
  'camera_alt': Icons.camera_alt,
  'person': Icons.person,
  'cake': Icons.cake,
  'email': Icons.email,
  'supervisor_account_sharp': Icons.supervisor_account_sharp,
  'add': Icons.add,
  'location_on': Icons.location_on,
  'info': Icons.info,
  'remove_red_eye_outlined': Icons.remove_red_eye_outlined,
  'summarize_outlined': Icons.summarize_outlined,
};

IconData? getIcon(String iconName) {
  return iconMap[iconName];
}