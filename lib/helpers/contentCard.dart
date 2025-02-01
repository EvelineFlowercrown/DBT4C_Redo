import 'package:flutter/material.dart';

class ContentCard extends StatefulWidget {
  final List<Widget> children;
  final doubleX;
  final doubleY;
  const ContentCard({Key? key, required this.children, required this.doubleX, this.doubleY = 0}) : super(key: key);

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  @override
  Widget build(BuildContext context) {
    if(widget.doubleY > 0){
      return Container(
        width: MediaQuery.of(context).size.width/widget.doubleX,
        height: MediaQuery.of(context).size.height/widget.doubleY,
        child: Card(
          color: Color.fromRGBO(255, 255, 255, .2),
          shadowColor: Colors.transparent,
          child: Padding(padding: EdgeInsets.all(10),
              child: Column(
                  children: widget.children
              )
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width/widget.doubleX,
      child: Card(
        color: Color.fromRGBO(255, 255, 255, .2),
        shadowColor: Colors.transparent,
        child: Padding(padding: EdgeInsets.all(10),
            child: Column(
              children: widget.children
          )
        ),
      ),
    );
  }
}


