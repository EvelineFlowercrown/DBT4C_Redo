import 'package:dbt4c_rebuild/screens/diarycardCalendar.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/widgets/menu_button.dart';
import 'package:dbt4c_rebuild/screens/skillProtocollCalendar.dart';
import 'package:dbt4c_rebuild/dataHandlers/configHandler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConfigHandler.initDiaryCardConfig();
  ConfigHandler.initDiaryCardEventConfig();
  ConfigHandler.initSkillProtocollConfig();
  runApp(MaterialApp(
    title: "DBT4C",
    home: MainMenu(),
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  // Funktion, die das Popup anzeigt
  void showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Coming Soon"),
        content: Text(
            "Coming Soon (when the developer is mentally stable enough to work in it)"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/resources/WallpaperMainScreen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GridView.count(
            crossAxisCount: 1,
            padding: const EdgeInsets.all(46),
            mainAxisSpacing: 110,
            crossAxisSpacing: 4,
            children: [
              MainMenuButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiaryCardCalendar()),
                  );
                },
                colorProperty: Color.fromRGBO(92, 133, 164, .3),
                frontImage: AssetImage("lib/resources/DiaryCardNoBackground.png"),
                bottomText: "Diary Card",
              ),
              MainMenuButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SkillProtocollCalendar()),
                  );
                },
                colorProperty: Color.fromRGBO(136, 100, 136, .3),
                frontImage: AssetImage("lib/resources/SkillProtokollNoBackground.png"),
                bottomText: "Skill Protokoll",
              ),
            ],
          ),
        ),
      ),
    );
  }}
