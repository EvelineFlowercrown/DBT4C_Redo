import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget{
  final GestureTapCallback onPressed;
  final Color colorProperty;
  final ImageProvider frontImage;
  final String bottomText;
  final double elevation;
  final double fontSize;
  final Color fontColor;
  const MainMenuButton({super.key, required this.onPressed,
    required this.colorProperty,
    required this.frontImage,
    this.bottomText = "",
    this.elevation = 16.0,
    this.fontSize = 16.0,
    this.fontColor = Colors.white,
    });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
          ),
          elevation: WidgetStateProperty.all<double>(
            elevation,
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            colorProperty,
          ),
          shadowColor: WidgetStateProperty.all<Color>(
            colorProperty,
          ),
        ),
        onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: frontImage
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            bottomText,
            style: TextStyle(
              fontSize: fontSize,
              color: fontColor,
            ),
          ),
        ),
      )
    );
  }
}