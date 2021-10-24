import 'package:flutter/material.dart';
import 'package:messenger/Widgets/widgets.dart';
import 'package:messenger/database/storage.dart';
import 'package:messenger/database/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search_screen.dart';

class ChatScreen extends StatefulWidget {
  final String collectionId;

  const ChatScreen({Key? key, required this.collectionId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  dataBase db = dataBase();
  TextEditingController messageController = TextEditingController();

  Stream? messageStream;

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      db.createMessege(widget.collectionId, messageMap);
      messageController.text = '';
    }
  }

  Widget chatList() {
    return StreamBuilder<dynamic>(
      stream: messageStream,
        builder: (context,snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data?.docs.length != null ? snapshot.data.docs.length : 0,
            itemBuilder: (context, index) {
              dynamic temp = snapshot.data.docs[index]['message'];
              return MessageContainer(
                message: snapshot.data.docs[index]['message'],
              );
              print(temp);
            },
          ) : Container();
        }
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    db.getMessage(widget.collectionId).then((value) {
      setState(() {
        messageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messenger',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Stack(
        children: [
          chatList(),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: textStyleFunc(),
                    decoration: textFieldFiller('Send Messege'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  final String message;

  const MessageContainer({Key? key, this.message = 'sample text'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: Colors.white),
    );
  }
}
