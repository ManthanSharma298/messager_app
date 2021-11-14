import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class dataBase {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future addUser(String? email, String? name) async {
    return await users.add({
      'email': email,
      'name': name,
    });
  }

  Future getUserFromName(String userName) async {
    return await users.where('name', isEqualTo: userName).get();
  }

  Future getUserFromEmail(String userEmail) async {
    return await users.where('email', isEqualTo: userEmail).get();
  }

  createChat(collectionId, collectionMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(collectionId)
        .set(collectionMap);
  }

  createMessege(collectionId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(collectionId)
        .collection('chats')
        .add(messageMap);
  }

  getMessage(collectionId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(collectionId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatList(String userName) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
