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
  ScrollController _scrollController = ScrollController();

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
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _scrollController,
                  // itemCount: snapshot.data?.docs.length != null
                  //     ? snapshot.data.docs.length
                  //     : 0,
                  itemCount: snapshot.data?.docs.length + 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == snapshot.data?.docs.length) {
                      return Container(
                        height: 80,
                      );
                    } else {
                      return MessageContainer(
                        message: snapshot.data.docs[index]['message'],
                        isSendByMe:
                            snapshot.data.docs[index]['sendBy'] == myName,
                      );
                    }
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
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
      body: Column(
        children: [
          Expanded(child: chatList()),
          Container(
            height: 80,
            color: Color(0xff101f30),
            child: Container(
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
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.bounceOut);
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
          ),
        ],
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageContainer(
      {Key? key, required this.message, required this.isSendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      alignment: isSendByMe ? Alignment.bottomRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  topRight: Radius.circular(16))
              : BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                  topLeft: Radius.circular(22)),
          color: isSendByMe ? const Color(0xff104375) : const Color(0xff2f3b47),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
