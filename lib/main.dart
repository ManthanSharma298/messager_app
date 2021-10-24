import 'package:messenger/database/local_storage.dart';

import '/Pages/sign_up.dart';
import '/Screens/contact_screen.dart';
import 'package:flutter/material.dart';
import '/Pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  dynamic isLogIn;

  @override
  void initState() {
    // TODO: implement initState
    getLoginStatusFunc();
    super.initState();
  }
  getLoginStatusFunc() async{
    await getLoginStatus().then((value){
      setState(() {
        isLogIn = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black12,
      ),
      home: isLogIn != null ? (isLogIn ? ContactScreen() : SignIn()) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
