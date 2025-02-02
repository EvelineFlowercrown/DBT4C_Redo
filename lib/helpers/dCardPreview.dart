import 'package:dbt4c_rebuild/helpers/contentCard.dart';
import 'package:flutter/material.dart';

class DCardPreview extends StatefulWidget {
  final List<String> eventNames;
  final String newWay;
  final String mood;
  final String tension;
  final String misery;
  const DCardPreview({super.key, required this.eventNames, required this.newWay, required this.mood, required this.tension, required this.misery});
  @override
  _DCardPreviewState createState() => _DCardPreviewState();
}

class _DCardPreviewState extends State<DCardPreview> {
  @override
  Widget build(BuildContext context) {
    return ContentCard(doubleX: 1.1,
        children:[
                  Text("Ereignisse des Tages:", style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                      ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(widget.eventNames[0], style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  ),
                  Text(widget.eventNames[1], style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  ),
                  Text(widget.eventNames[2], style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  ),

                  Padding(padding: EdgeInsets.all(5)),
                  Divider(),
                  Padding(padding: EdgeInsets.all(5)),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(Icons.emoji_events_sharp,
                      size: 18,
                      color: Colors.white,
                      ),

                      Padding(padding: EdgeInsets.all(5)),

                      Text("Neuer Weg: ${widget.newWay}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,fontSize: 16),),

                      Padding(padding: EdgeInsets.all(15)),

                      Icon(Icons.emoji_emotions_sharp,
                      size: 18,
                      color: Colors.white,
                      ),

                      Padding(padding: EdgeInsets.all(5)),
                      Text("Stimmung: ${widget.mood}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,fontSize: 16),),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(Icons.mood_bad_sharp,
                        size: 18,
                        color: Colors.white,
                      ),

                      Padding(padding: EdgeInsets.all(5)),

                      Text("Elend: ${widget.misery}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,fontSize: 16),),

                      Padding(padding: EdgeInsets.all(15)),

                      Icon(Icons.equalizer_sharp,
                        size: 18,
                        color: Colors.white,
                      ),

                      Padding(padding: EdgeInsets.all(5)),
                      Text("Anspannung: ${widget.tension}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,fontSize: 16),),
                    ],
                  )
                ]
      );
  }
}
