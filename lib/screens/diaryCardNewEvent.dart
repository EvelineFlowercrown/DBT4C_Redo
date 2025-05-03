
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
import 'package:dbt4c_rebuild/generators/diaryCardNewEventGenerator.dart';

class DiaryCardNewEvent extends StatelessWidget{
  final String primaryKey;
  final String date;

  const DiaryCardNewEvent({super.key, required this.primaryKey, required this.date});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: DiaryCardNewEventState(primaryKey: primaryKey, date: date,),
    );
  }
}

class DiaryCardNewEventState extends StatefulWidget{
  final String? primaryKey;
  final String? date;
  const DiaryCardNewEventState({super.key, required this.primaryKey, this.date});
  @override
  _DiaryCardNewEventState createState() => _DiaryCardNewEventState();
}



class _DiaryCardNewEventState extends State<DiaryCardNewEventState>{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child:Scaffold(
          extendBodyBehindAppBar: true,
          appBar: DefaultSubAppBar(
            appBarLabel: "Neues Ereignis",
            backGroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          body: MainContainer(
              backgroundImage: AssetImage("lib/resources/WallpaperDCard.png"),
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: Diarycardneweventgenerator.contentcardGenerator(widget.date, widget.primaryKey),
                    builder: (context, AsyncSnapshot<List<Widget>> snapshot){
                      if(snapshot.data != null){
                        return SingleChildScrollView(
                          child: Column(
                          children: snapshot.data!,),);
                      }
                      return Center(child: Text("Loading..."));
                    }
                ),
              )
          )
      ),
    );
  }
}
