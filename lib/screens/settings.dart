import 'package:dbt4c_rebuild/helpers/abstactDatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/helpers/mainContainer.dart';
import 'package:dbt4c_rebuild/helpers/default_subAppBar.dart';
//import 'package:dbt4c_rebuild/helpers/notification_service.dart';



class SettingsMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DefaultSubAppBar(
          appBarLabel: "Einstellungen",
        ),
        body: MainContainer(
          backgroundImage: AssetImage("lib/resources/WallpaperSettings.png"),
          child: Column(
            children: [
              Text("10"),
              Text("1337"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Benachrichtigungen erlauben"),
                  TextButton(child: Text("Click!"),
                    onPressed: (){
                      print("NotificationService not implemented");
                      //NotificationService().simpleTextNotification("Test", "Test2");
                    }
                  ),
                ],
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(child: Text("clear event db!"),
                        onPressed: (){
                          AbstractDatabaseService.clearTable("DiaryCardEvents");
                        }
                    ),
                    TextButton(child: Text("clear dcard db!"),
                        onPressed: (){
                          AbstractDatabaseService.clearTable("DiaryCard");
                        }
                    ),
                    TextButton(child: Text("clear skillprot db!"),
                        onPressed: (){
                          AbstractDatabaseService.clearTable("SkillProtocoll");
                        }
                    ),
                  ]
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(child: Text("YEET DB!"),
                      onPressed: (){
                        AbstractDatabaseService.yeetDB();
                      }
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
