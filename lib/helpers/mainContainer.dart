import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget{
  final Widget child;
  final ImageProvider backgroundImage;
  const MainContainer({super.key, required this.child,
    this.backgroundImage = const AssetImage("lib/resources/WallpaperMainScreen.png"),

  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}