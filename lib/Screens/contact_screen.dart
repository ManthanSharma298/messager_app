import '/Pages/sign_in.dart';
import '/Pages/sign_up.dart';
import '/Screens/search_screen.dart';
import '/database/fire_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/database/local_storage.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Authenticate authenticate = Authenticate();

  @override
  void initState() {
    // TODO: implement initState
    storeUserNameInit();
    super.initState();
  }
  storeUserNameInit() async{
    myName = await getStoredUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messenger',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authenticate.SignOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SignUp(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}
