import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../../model/firebase_user_model/firebase_chat_user_model.dart';

class ChatUserStore {
  static final databaseStore = FirebaseFirestore.instance.collection("chat-collections");

     //  sendMessage(String senderId ,String receiverId ,FirebaseChatUserModel firebaseChatUserModel ) {
     //   String chatroomId = getChatRoomId(senderId, receiverId);
     //  databaseStore.doc("$chatroomId").collection("message").doc(firebaseChatUserModel.time).set(firebaseChatUserModel.toMap());
     //
     // }
     static String getChatRoomId(String senderId ,String receiverId){
       List ids = [senderId, receiverId];
       ids.sort();
       String join = ids.join("ChatQ");
       return join;
     }
  static Future<void> sendMessage(FirebaseChatUserModel message) async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID);
    final messageCollection = databaseStore.doc(chatRoomId).collection("messages");
    messageCollection
        .doc(message.chatID)
        .set(message.toMap())
        .then((value) {
      debugPrint("message sent");
    })
        .onError((error, stackTrace) {
    });
  }
  static Stream<List<FirebaseChatUserModel>> getUsersMessage(String receiverUID, String senderUID)
  {

    var databaseStores = databaseStore.doc(getChatRoomId(receiverUID, senderUID)).collection("messages");
    var datas = databaseStores.snapshots();
    return datas.map((QuerySnapshot<Map<String, dynamic>> snapshot){
      final List<FirebaseChatUserModel> list = [];
      for(final DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs){
        final Map<String, dynamic> data = doc.data()!;
        list.add(FirebaseChatUserModel.fromJson(data));
      }
      return list;
    });
  }



  static Future<void> updateMessageStatus(FirebaseChatUserModel message) async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID); // Extract chatRoomId from chatID

    // debugPrint("ChatRoomId is $chatRoomId");
    final messageCollection = databaseStore.doc(chatRoomId).collection("messages");
    final messageDoc = await messageCollection.doc(message.chatID).get();
    // debugPrint("Message is going to update");
    // debugPrint(messageDoc.exists.toString() + "Is Exist");
    if (messageDoc.exists) {
      // Update the message's status field
      // debugPrint("Doc exist");
      await messageCollection
          .doc(message.chatID)
          .update({ "status": message.status, "readTime": message.readTime, "deliveredTime" : message.deliveredTime}).then((value) async {
        // debugPrint("Message Updated");
      }).onError((error, stackTrace) {
        // debugPrint("Message Updation failed");
      });
    }
  }
  static updateMessageStar(FirebaseChatUserModel message)async {
    final chatRoomId = getChatRoomId(message.senderUID, message.receiverUID);
    final messageCollection = databaseStore.doc(chatRoomId).collection("messages");
    final messageDoc = await messageCollection.doc(message.chatID).get();
    if (messageDoc.exists) {
      await messageCollection
          .doc(message.chatID)
          .update({ "star": message.star}).then((value) async {
        debugPrint("Star Updated");
      }).onError((error, stackTrace) {
        debugPrint("Star Updation failed");
      });
    }
  }
  static Future<void> deleteMessage(String receiver, String sender, String chatID, int code) async {
    final chatRoomId =
    getChatRoomId(sender, receiver); // Extract chatRoomId from chatID
    // debugPrint("ChatRoomId is $chatRoomId");
    final messageCollection = databaseStore.doc(chatRoomId).collection("messages");
    final messageDoc = await messageCollection.doc(chatID).get();
    // debugPrint("Message is going to update");
    if (messageDoc.exists) {
      // Update the message's status field
      // debugPrint("Doc exist");
      await messageCollection
          .doc(chatID)
          .update({"visibleNo": code}).then((value) {
        debugPrint("Message deleted");
      }).onError((error, stackTrace) {
        // debugPrint("Message Updation failed");
      });
    }
  }
  // Future<bool> isChatRoomExist(String receiverUID, String senderUID) async  {
  //    String chatRoomId = getChatRoomId(senderUID, receiverUID);
  //   debugPrint(chatRoomId);
  //
  //   // Get a reference to the chat room document
  //    DocumentSnapshot<Map<String, dynamic>> chatRoomSnapshot = await FirebaseFirestore.instance.collection("chat-collections").doc(chatRoomId.toString()).get();
  //   // final chatRoomDoc =  databaseStore.doc(chatRoomId);
  //   // debugPrint(chatRoomDoc.toString());
  //   // Check if the document exists
  //   //  final chatRoomSnapshot = await chatRoomDoc.get();
  //   // debugPrint((chatRoomSnapshot.data()!.isNotEmpty).toString());
  //   // Return true if the document exists, false otherwise
  //    debugPrint("inside: ${chatRoomSnapshot.exists}");
  //   //  FirebaseFirestore.instance.collection("chat-collections").where("chatroomId",isEqualTo: "c123").snapshots().listen((event) {
  //   //    debugPrint(event.docs.length.toString());
  //   //  });
  //   return chatRoomSnapshot.exists;
  // }

}