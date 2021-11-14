import 'package:messenger/Screens/chat_screen.dart';

import '/Pages/sign_in.dart';
import '/Pages/sign_up.dart';
import '/Screens/search_screen.dart';
import '/database/fire_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/database/local_storage.dart';
import 'package:messenger/database/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Authenticate authenticate = Authenticate();
  dataBase db = dataBase();

  Stream? contactListStream;

  @override
  void initState() {
    storeUserNameInit();
    super.initState();
  }

  storeUserNameInit() async {
    myName = await getStoredUserName();
    db.getChatList(myName).then((val) {
      setState(() {
        contactListStream = val;
      });
    });
  }

  Widget contactList() {
    return StreamBuilder<dynamic>(
      stream: contactListStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return ContactContainer(
                    contactName: snapshot.data.docs[index]['roomId'],
                  );
                })
            : Container();
      },
    );
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
      body: contactList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ContactContainer extends StatelessWidget {
  final String contactName;
  const ContactContainer({Key? key, required this.contactName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(collectionId: contactName),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        color: Color(0xff101f30),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('images/user_img.png'),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: 100,
              alignment: Alignment.center,
              child: Text(
                contactName.replaceAll('_', '').replaceAll(myName, ''),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
