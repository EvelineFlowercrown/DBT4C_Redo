import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/menu_button.dart';
import 'package:flutter/services.dart';
import 'package:dbt4c_rebuild/screens/diarycard.dart';
import 'package:dbt4c_rebuild/screens/settings.dart';
import 'package:dbt4c_rebuild/screens/user.dart';
import 'package:dbt4c_rebuild/screens/skillProtocoll.dart';
//import 'package:dbt4c_rebuild/helpers/notification_service.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      title: "MainMenu",
      home: Scaffold(
        //backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            title: Center(
              child: Text("DBT4C"),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
          ),
        ),
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
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: [
                // Diarycard Button
                MainMenuButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiaryCardMenu()),
                    );
                  },
                  colorProperty: Color.fromRGBO(92, 133, 164, .3),
                  frontImage:
                  AssetImage("lib/resources/DiaryCardNoBackground.png"),
                  bottomText: "Diary Card",
                ),

                // SkillProtocoll Button
                MainMenuButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SkillProtocollMenu()),
                    );
                  },
                  colorProperty: Color.fromRGBO(136, 100, 136, .3),
                  frontImage: AssetImage("lib/resources/SkillProtokollNoBackground.png"),
                  bottomText: "Skill Protokoll",
                ),

                // Psychoedukation Button (Popup)
                MainMenuButton(
                  onPressed: () {
                    showComingSoon(context);
                  },
                  colorProperty: Color.fromRGBO(168, 62, 102, .3),
                  frontImage:
                  AssetImage("lib/resources/PsychoedukationNoBackground.png"),
                  bottomText: "Psychoeducation",
                ),

                // SkillTraining Button (Popup)
                MainMenuButton(
                  onPressed: () {
                    showComingSoon(context);
                  },
                  colorProperty: Color.fromRGBO(206, 126, 129, .3),
                  frontImage:
                  AssetImage("lib/resources/SkillTrainingNoBackground.png"),
                  bottomText: "Skill Training",
                ),

                // SkillFinder Button (Popup)
                MainMenuButton(
                  onPressed: () {
                    showComingSoon(context);
                  },
                  colorProperty: Color.fromRGBO(219, 94, 92, .3),
                  frontImage:
                  AssetImage("lib/resources/SkillfinderNoBackground.png"),
                  bottomText: "Skillfinder",
                ),

                // Kommunikation Button (Popup)
                MainMenuButton(
                  onPressed: () {
                    showComingSoon(context);
                  },
                  colorProperty: Color.fromRGBO(248, 143, 88, .3),
                  frontImage:
                  AssetImage("lib/resources/KommunikationNoBackground.png"),
                  bottomText: "Kommunikation",
                ),

                // Nutzer Button
                MainMenuButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserMenu()));
                  },
                  colorProperty: Color.fromRGBO(243, 165, 126, .3),
                  frontImage: AssetImage("lib/resources/UserNoBackground.png"),
                  bottomText: "Nutzer",
                ),

                // Einstellungen Button
                MainMenuButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingsMenu()));
                  },
                  colorProperty: Color.fromRGBO(252, 190, 71, .3),
                  frontImage:
                  AssetImage("lib/resources/SettingsNoBackground.png"),
                  bottomText: "Einstellungen",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
