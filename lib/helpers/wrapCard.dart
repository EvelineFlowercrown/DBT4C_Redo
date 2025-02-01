import 'package:flutter/material.dart';

class WrapCard extends StatefulWidget {
  final List<Widget> children;
  final doubleX;
  final String text;
  const WrapCard({Key? key, required this.children, required this.doubleX, required this.text}) : super(key: key);

  @override
  _WrapCardState createState() => _WrapCardState();
}

class _WrapCardState extends State<WrapCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/widget.doubleX,
      child: Card(
        color: Color.fromRGBO(255, 255, 255, .2),
        shadowColor: Colors.transparent,
        child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(widget.text,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333F49)),
                textAlign: TextAlign.center,
              ),

              Padding(padding: EdgeInsets.all(10)),

              Wrap(
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 5,
                  alignment: WrapAlignment.center,
                  children: widget.children
              )
            ],
          )




        ),
      )
    );
  }
}


