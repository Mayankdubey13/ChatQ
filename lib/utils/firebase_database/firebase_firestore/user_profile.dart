import 'dart:async';

import 'package:chat_application/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/firebase_user_model/firebase_user_model.dart';


class UserProfileStore{
  static final databaseStore = FirebaseFirestore.instance.collection("user");


  static Stream<List<FirebaseUserDetailModel>> getAllUsers() {
    final fireStoreStream = databaseStore.snapshots();
    return fireStoreStream.map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<FirebaseUserDetailModel> users = [];
      for (final DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data()!;
        users.add(FirebaseUserDetailModel.fromJson(data));
      }
      return users;
    });
  }

  Future setUserProfileDetail(FirebaseUserDetailModel  userDetailModel ) async {
   await databaseStore.doc(userDetailModel.uid).set(
      userDetailModel.toMap()
    ).then((value){
      Utils.toastMessage("Profile Data Store");
    }).onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
    });
  }
  static Stream<bool> getStatus(String uID) {
    final userDoc = FirebaseFirestore.instance.collection("users").doc(uID);
    final streamController = StreamController<bool>();
    userDoc.snapshots().listen((snapshot) {
      final data = snapshot.data();
      if (data != null && data.containsKey("onLineStatus")) {
        streamController.add(data["onLineStatus"]  == "true"? true: false);
      }
      else
      {
        streamController.add(false);
      }
    });
    return streamController.stream;
  }



  static Stream<List<FirebaseUserDetailModel>> getUsersProfile()
  {
    var datas = databaseStore.snapshots();
    return datas.map((QuerySnapshot<Map<String, dynamic>> snapshot){
      final List<FirebaseUserDetailModel> list = [];
      for(final DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs){
        final Map<String, dynamic> data = doc.data()!;
        list.add(FirebaseUserDetailModel.fromJson(data));
      }
      return list;
    });
  }


  //
  // static Future<void> getAllUserss() async  {
  //   final List<FirebaseUserDetailModel> users = [];
  //   await databaseStore.doc()..then((value){
  //     var data = value as List<Map<String, dynamic>>;
  //     data.map((e){
  //       users.add(FirebaseUserDetailModel.fromJson(e));
  //     });
  //     debugPrint("value is $value");
  //   }).onError((error, stackTrace){});
  // }

  static Stream<FirebaseUserDetailModel?> getCurrentUserProfile(String currentUserUID) {
    final firestoreStream = databaseStore.doc(currentUserUID).snapshots();
    return firestoreStream.map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data()!;
        // debugPrint(data.toString());
        return FirebaseUserDetailModel.fromJson(data);
      } else {
        // If the user profile document doesn't exist, return null.
        return null;
      }
    });
  }

  // Update user's online status to "online" when they log in
  static updateStatus(bool status) async
  {
    int i = status? 1 : 0;
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid.toString();
    databaseStore.doc(currentUserUID).update({"onLineStatus" : i}).then((value){
      debugPrint("Updated!");
    }).onError((error, stackTrace){});

  }

  static Stream<int> getStatusUser(String uid)
  {
    // debugPrint("Added");
    StreamController<int> st = StreamController<int>();
    databaseStore.doc(uid).snapshots().listen((event) {
      final data = event.data();
      if( data != null && data.containsKey("onLineStatus")) {
        Map<String, dynamic> mp  = event.data() as Map<String, dynamic>;
        // debugPrint("${mp["onLineStatus"]}");
        return st.add(mp["onLineStatus"]);

      }else {
        st.add(0);
        // debugPrint("Added");
      }
    });
    // debugPrint("returning data");
    return st.stream;
  }
}
