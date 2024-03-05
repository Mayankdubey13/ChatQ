import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseImageUpload {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Future<String> uploadProfileImageFile(File? pickedImage) async {
    String timeid = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref('/profile_pics/$uid/$timeid');
    UploadTask task = ref.putFile(pickedImage!.absolute);
    await Future.value(task);
    String imUrl = await ref.getDownloadURL();
    return imUrl;

  }
  /// It will take the refrence of the user and delete the profile image as the folder in which the user profile image is present is created using its uid
  Future deleteProfileImage() async {
    Reference ref = FirebaseStorage.instance.ref('/profile_pic/$uid');
    ref.delete();
  }
  static Future<String> sendImageWithSenderAndReceiverChatIDAndTimeOnStorage(String chatID, String time, File? pickedImage) async {
    Reference ref = FirebaseStorage.instance.ref('/chat_images/$chatID/$time');
    UploadTask task = ref.putFile(pickedImage!.absolute);
    await Future.value(task);
    String imUrl = await ref.getDownloadURL();
    debugPrint("Image uploaded $imUrl");
    return imUrl;
  }
}