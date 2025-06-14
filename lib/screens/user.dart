import 'package:flutter/material.dart';
import 'package:dbt4c_rebuild/widgets/mainContainer.dart';
import 'package:dbt4c_rebuild/widgets/default_subAppBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class UserMenu extends StatelessWidget{
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyUserMenu(),
    );
  }
}

class MyUserMenu extends StatefulWidget{
  const MyUserMenu({super.key});

  @override
  _MyUserMenuState createState() => _MyUserMenuState();
}
class _MyUserMenuState extends State<MyUserMenu>{
  SharedPreferences? preferences;
  File? _userImage;
  final picker = ImagePicker();
  PermissionStatus? _permissionStatus;
  bool _changingState = false;
  final nameField = TextEditingController();
  final birthField = TextEditingController();
  final emailField = TextEditingController();
  final therapistField = TextEditingController();
  @override
  void initState(){
    super.initState();
    initPreference().whenComplete(
        (){
          setState(() {});
        }
    );
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }
  void onLayoutDone(Duration timeStamp) async{
    _permissionStatus = await Permission.camera.status;
    setState(() {
    });
  }
  void _askPermissions() async {
    await [Permission.camera, Permission.storage].request();
    _permissionStatus = await Permission.camera.status;
    setState(() {});
  }
  Future<void> initPreference() async{
    preferences = await SharedPreferences.getInstance();
    if(preferences!.containsKey("userImage")){
      _userImage = File(preferences!.getString("userImage")!);
    }
    if(preferences!.containsKey("userName")){
      nameField.text = preferences!.getString("userName")!;
    }
    if(preferences!.containsKey("userBirthday")){
      birthField.text = preferences!.getString("userBirthday")!;
    }
    if(preferences!.containsKey("userEmail")){
      emailField.text = preferences!.getString("userEmail")!;
    }
    if(preferences!.containsKey("userTherapist")){
      therapistField.text = preferences!.getString("userTherapist")!;
    }
  }
  Future<void> _cropImage(String filePath) async {
    final ImageCropper cropper = ImageCropper();
    CroppedFile? croppedImage = await cropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedImage != null) {
      setState(() {
        _userImage = File(croppedImage.path);
      });
      preferences?.setString("userImage", croppedImage.path);
    } else {
      print("Image cropping failed!");
    }
  }
  Future getImage({bool fromCamera = false}) async {
    final XFile? pickedFile;
    if (fromCamera) {
      _askPermissions();
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      try {
        await _cropImage(pickedFile.path);
      } catch (e) {
        print("Error processing image: $e");
      }
    } else {
      print("No image selected!");
    }
  }

  void _showPicker(context){
    showModalBottomSheet(context: context,
        builder: (buildContext){
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Center(child: Text("Auswählen von:", style: TextStyle(fontSize: 18))),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Bibliothek"),
                  onTap: (){
                    getImage();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Kamera"),
                  onTap: (){
                    getImage(fromCamera: true);
                    Navigator.of(context).pop();
                  }
                )
              ],
            ),
          );
        },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultSubAppBar(
        appBarLabel: "Nutzer",
      ),
      body: MainContainer(
        backgroundImage: AssetImage("lib/resources/NutzerWallpaper.png"),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
              ),
              InkWell(
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    child: _userImage != null && _userImage!.existsSync()
                      ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(_userImage!)
                          )
                        )
                      )
                      : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                  ),
                ),
                onTap: (){
                  _showPicker(context);
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/1.4,
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                  shadowColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: _changingState,
                          controller: nameField,
                          minLines: 1,
                          maxLines: 2,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'What do people call you?',
                            labelText: 'Name',
                          ),
                          onChanged: (String value){
                            preferences!.setString("userName", value);},
                        ),
                        TextFormField(enabled: _changingState, controller: birthField,
                            minLines: 1,
                            maxLines: 2, decoration: InputDecoration(icon: Icon(Icons.cake), hintText: 'Date format: dd/mm/yyyy', labelText: "Geburtstag",),
                            onChanged: (String value){
                          preferences!.setString("userBirthday", value);
                        }
                        ),
                        TextFormField(
                            enabled: _changingState,
                            controller: emailField,
                            minLines: 1,
                            maxLines: 2,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: "E-mail",
                              hintText: 'E-mail format: YourEmail@example.com',
                            ),
                            onChanged: (String value){
                              preferences!.setString("userEmail", value);
                            }),
                        TextFormField(
                            enabled: _changingState,
                            controller: therapistField,
                            minLines: 1,
                            maxLines: 2,
                            decoration: InputDecoration(
                              icon: Icon(Icons.supervisor_account_sharp),
                              labelText: "Dein Therapeut",
                              hintText: 'Wird später durch QR-code scanner ersetzt',
                            ),
                            onChanged: (String value){
                              preferences!.setString("userTherapist", value);
                            }),
                        ElevatedButton(
                          child: Text("Ändern"),
                          onPressed: (){
                            setState(() {
                              _changingState = !_changingState;
                            });},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

