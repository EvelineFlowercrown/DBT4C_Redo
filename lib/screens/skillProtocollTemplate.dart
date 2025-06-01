
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';

import '../generators/skillProtocollGenerator.dart';

class SkillProtocollTemplate extends StatelessWidget {
  final String? selectedDate;
  const SkillProtocollTemplate({super.key, required this.selectedDate});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SkillProtocollTemplateState(
        selectedDate: selectedDate,
      ),
    );
  }
}

class SkillProtocollTemplateState extends StatefulWidget {
  final String? selectedDate;
  const SkillProtocollTemplateState({super.key, required this.selectedDate});
  @override
  _SkillProtocollTemplateState createState() => _SkillProtocollTemplateState();
}

class _SkillProtocollTemplateState extends State<SkillProtocollTemplateState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultSubAppBar(
        appBarLabel: "Skill Protokoll",
        backGroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: MainContainer(
        backgroundImage: AssetImage("lib/resources/WallpaperProtocoll.png"),
        child: FutureBuilder<List<Widget>>(
          future: SkillProtocollGenerator.buildSkillProtocollLayout(widget.selectedDate.toString(), context),
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

