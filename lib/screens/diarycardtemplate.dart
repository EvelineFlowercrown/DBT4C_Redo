import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';
import 'package:dbt4c_rebuild/generators/diaryCardGenerator.dart';

class DiarycardTemplate extends StatelessWidget{
  final String? selectedDate;
  const DiarycardTemplate({super.key, required this.selectedDate});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: DiaryCardTemplateState(selectedDate: selectedDate),
    );
  }
}

class DiaryCardTemplateState extends StatefulWidget{
  final String? selectedDate;
  const DiaryCardTemplateState({super.key, this.selectedDate});
  @override
  _DiaryCardTemplateState createState() => _DiaryCardTemplateState();
}

class _DiaryCardTemplateState extends State<DiaryCardTemplateState>{

  //Initializes this Classes State and Calls initMap()
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultSubAppBar(
        appBarLabel: "Diary Card",
        backGroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: MainContainer(
        backgroundImage: AssetImage("lib/resources/WallpaperDCard.png"),
        child: FutureBuilder<List<Widget>>(
          future: DiaryCardGenerator.buildDiaryCardLayout(widget.selectedDate.toString(), context),
          builder: (context, AsyncSnapshot<List<Widget>> snapshot){
            if(snapshot.data != null){
              return SingleChildScrollView(
                child: Column(
                  children: snapshot.data!,
                ),
              );
            }

            return Center(child: Text("Loading..."));
          },
        ),
      ),
    );
  }
}
