import 'package:dbt4c_rebuild/dataHandlers/database.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  // Map für Todos – passe diese Einträge nach Bedarf an
  Map<String, bool> todos = {
    "Implement Database Encryption": false,
    "Rewrite Entire Database": false,
    "Implement Notifications": false,
    "Implement some Skill-Wiki like thing": false,
    "experiment with locally hosted LLM as Skillfinder": false,
    "Add PDF export function": false,
    "Develop concepts for Therapist communication": false
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Einstellungen",
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DefaultSubAppBar(
          appBarLabel: "Einstellungen",
          backGroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: MainContainer(
          backgroundImage: AssetImage("lib/resources/WallpaperSettings.png"),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Zwei Buttons nebeneinander in einem flexiblen Layout:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          // Löscht DiaryCardEvents und DiaryCard
                          DatabaseProvider.yeetDB();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text(
                          "Clear DiaryCard & Events DB",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          // Löscht SkillProtocoll
                          DatabaseProvider.yeetDB();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                        ),
                        child: Text(
                          "Clear SkillProtocoll DB",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Scrollbare Liste der Todos als CheckBoxListTile, die nicht anklickbar sind:
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, .3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      children: todos.keys.map((String key) {
                        return IgnorePointer(
                          ignoring: true,
                          child: CheckboxListTile(
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            title: Text(
                              key,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: todos[key],
                            onChanged: (bool? newValue) {
                              setState(() {
                                todos[key] = newValue ?? false;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
