import 'package:messenger/database/local_storage.dart';
import 'package:messenger/database/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  dataBase db = dataBase();
  QuerySnapshot? screenSnapshot;

  searchWord() {
    db.getUserFromName(searchTextEditingController.text).then((value) {
      setState(() {
        screenSnapshot = value;
      });
    });
  }

  Widget contactList() {
    return screenSnapshot != null
        ? ListView.builder(
            itemCount: screenSnapshot?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Contact(
                  userName: screenSnapshot?.docs[index]['name'],
                  userEmail: screenSnapshot?.docs[index]['email'],
                ),
              );
            },
          )
        : Center();
  }

  startConversation(String userName) {
    String collectionId = getChatRoomId(userName, myName);

    List users = [userName, myName];
    Map<String, dynamic> collectionMap = {
      'users': users,
      'roomId': collectionId,
    };
    db.createChat(collectionId, collectionMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  collectionId: collectionId,
                )));
  }

  Widget Contact({required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: Colors.grey[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                userEmail,
                style: textStyleFunc(),
              ),
            ],
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              startConversation(userName);
            },
            child: Text('Chat'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: textStyleFunc(),
                      decoration: textFieldFiller('Search'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchWord();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            contactList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
