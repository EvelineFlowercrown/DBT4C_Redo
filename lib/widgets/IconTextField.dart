import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/IconLibrary.dart';

class Icontextfield extends StatelessWidget {
  final String icon;
  final String prefill;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const Icontextfield({super.key, required this.icon, required this.prefill, required this.controller, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    return TextField(
        cursorColor: Colors.white,
        controller: controller,
        decoration: InputDecoration(
            icon: Icon(getIcon(icon)),
            hintText: prefill
        ),
        onChanged: (txt) {
          onChanged?.call(txt);
        }
    );
  }
}