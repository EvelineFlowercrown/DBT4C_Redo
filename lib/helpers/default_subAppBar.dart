import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarLabel;
  final Color statusBarColor;
  final Color backGroundColor;
  final Color shadowColor;

  const DefaultSubAppBar({
    this.appBarLabel = "",
    this.statusBarColor = Colors.transparent,
    this.backGroundColor = Colors.transparent,
    this.shadowColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(appBarLabel),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      backgroundColor: backGroundColor,
      shadowColor: shadowColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(30.0);
}
