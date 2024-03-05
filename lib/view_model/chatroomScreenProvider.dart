import 'dart:io';

import 'package:chat_application/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/firebase_user_model/firebase_chat_user_model.dart';
import '../model/firebase_user_model/firebase_user_model.dart';
import '../utils/firebase_database/firebase_firestore/chat_user.dart';
import '../utils/firebase_database/firebase_firestore/user_profile.dart';
import '../utils/firebase_database/firebase_storage/upload_image_firebase.dart';

class ChatRoomScreenProvider extends ChangeNotifier {
  final writeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    writeController.dispose();
  }

  final writeFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;

  sendMessage(String receiver, {bool isImage = false, String imageUrl = ""}) {
    String mess = writeController.text.toString().trim();
    writeController.clear();
    DateTime now = DateTime.now();
    String time = now.toString();
    String chatID = now.millisecondsSinceEpoch.toString();
    if (mess.isNotEmpty || isImage) {
      ChatUserStore.sendMessage(FirebaseChatUserModel(
        message: !isImage ? mess : "",
        senderUID: auth.currentUser!.uid,
        time: time,
        isForwarded: 0,
        receiverUID: receiver,
        chatID: chatID,
        //  readTime: "u",
        status: 0,
        // sentTime: time,
        visibleNo: 3,
        img: isImage ? imageUrl : "",
        sentTime: time,
      ));
    }
  }

  pickAndSendImage(String receiver) async {
    debugPrint("pick going to upload");
    await requestPermission(receiver);
  }

  static String getChatID(String r, String s) {
    List<String> l = [r, s];
    l.sort();
    debugPrint("returning chat id");
    return l.join("ChatQ");
  }

  Future<void> requestPermission(String receiver) async {
    PermissionStatus status = await Permission.camera.request();

    // Check the permission status
    if (status.isGranted) {
      debugPrint("Permission Granted");
      await fetchImage();
      debugPrint("Image Fetched going to upload");
      await uploadImage(receiver);
      debugPrint("Image Uploaded");
    } else {
      debugPrint("Permission not granted in else");
      debugPrint("Going to fetch image in else");
      await fetchImage();
      debugPrint("Image fetched going to upload in else");
      await uploadImage(receiver);
      debugPrint("Going to upload in else");
      // openAppSettings();
    }
  }

  void addMessage(FirebaseChatUserModel messageModel){
    selectedMessages.add(messageModel);
  }
  void removeMessage(int index){
    selectedMessages.removeAt(index);
  }
  void tapToSelect(FirebaseChatUserModel messageModel) {
    int isContain = isContains(messageModel);
    if(isContain == -1)
    {
      addMessage(messageModel);
      debugPrint("add the message");
      notifyListeners();
    }
    else
    {
      debugPrint("message revome");
      removeMessage(isContain);
      notifyListeners();
    }
    for(var mes in selectedMessages){
      debugPrint(mes.message);
    }
    debugPrint("${selectedMessages.length}");
  }

  bool isUploaded = true;

  bool isPicked = false;

  bool isOnline = false;

  getStatus(String uID) {
    UserProfileStore.getStatus(uID).listen((isActive)
    {
      if(isOnline != isActive)
      {
        isOnline = isActive;
        notifyListeners();
      }
    });
    return UserProfileStore.getStatus(uID);
  }

  List<FirebaseChatUserModel> selectedMessages = [];

  removeAllFromList(){
    selectedMessages.clear();
    notifyListeners();
  }
  bool isAvailableToStar(){
    if(selectedMessages[0].senderUID != auth.currentUser!.uid){
      return true;
    }
    return false;
  }

  toggleStar() {
    if(selectedMessages[0].star  == 1){
      selectedMessages[0].star  = 0;
    }
    else
    {
      selectedMessages[0].star  = 1;
    }
    try{
      ChatUserStore.updateMessageStar(selectedMessages[0]);
      selectedMessages.clear();
    } catch (e){
      debugPrint(e.toString());
    }
    notifyListeners();
  }

   forwardMessage(List<FirebaseChatUserModel> messageModel, String receiver) {
    for(int i = 0; i < messageModel.length; ++i){
      DateTime now = DateTime.now();
      String time = now.toString();
      String chatID = now.millisecondsSinceEpoch.toString();
      messageModel[i].chatID = chatID;
      messageModel[i].time = time;
      messageModel[i].sentTime = time;
      messageModel[i].isForwarded = 1;
      messageModel[i].senderUID = auth.currentUser!.uid;
      messageModel[i].receiverUID = receiver;
      messageModel[i].visibleNo = 3;
      messageModel[i].status = 0;
      messageModel[i].star = 0;
      ChatUserStore.sendMessage(messageModel[i]);
    }


  }

  Future<void> copyMessage(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: selectedMessages[0].message)).then((value){
      selectedMessages.clear();
      Utils.toastMessage("Text Copied");
     // CustomToast(context: context, message: "Text Copied");
      notifyListeners();
    }).onError((error, stackTrace){

    });
  }
  deleteMessage(FirebaseChatUserModel messageModel, int code) {
    ChatUserStore.deleteMessage(messageModel.receiverUID, messageModel.senderUID,
        messageModel.chatID, code)
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  bool isAvailableToDeleteForAll() {
    String sender = auth.currentUser!.uid.toString();
    for(int i = 0; i < selectedMessages.length; ++i){
      if(selectedMessages[i].senderUID != sender){
        return false;
      }
    }
    return true;
  }

  void deleteForMe(){
    deleteMessages(code:1);
  }
  void deleteForAll() {
    deleteMessages(code: 0);
  }

  void deleteMessages({int code = 0}){
    if(code == 0)
    {
      // Delete for all for sender Message only
      for(int i = 0; i < selectedMessages.length; ++i)
      {
        deleteMessage(selectedMessages[i], 0);
      }
    }
    else
    {

      for(int i = 0; i < selectedMessages.length; ++i)
      {
        // If there exist any receiver message
        if(selectedMessages[i].senderUID != auth.currentUser!.uid) {
          if(selectedMessages[i].visibleNo != 3) {
            deleteMessage(selectedMessages[i], 0);
          }
          else {
            deleteMessage(selectedMessages[i], 2);
          }
        }
        else {
          if(selectedMessages[i].visibleNo != 3) {
            deleteMessage(selectedMessages[i], 0);
          }
          else {
            deleteMessage(selectedMessages[i], 1);
          }
        }
      }
    }
    removeAllFromList();
  }

  uploadImage(String receiver) async {
    if (!isPicked) return;
    User user = auth.currentUser!;
    String timeId = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    String url = await FirebaseImageUpload
        .sendImageWithSenderAndReceiverChatIDAndTimeOnStorage(
        getChatID(receiver, user.uid.toString()), timeId, pickedImage);
    sendMessage(receiver, isImage: true, imageUrl: url);
    // await UsersChat.sendMessage(MessageModel(message: "", senderUID: user.uid, time: timeId, receiverUID: receiver, chatID: timeId, status: 0, sentTime: timeId, img: url)).then((value){
    // debugPrint("Success uploading image on database");
    //
    // }).onError((error, stackTrace){
    // debugPrint("Error while uploading image on database");
    // });
    isPicked = false;
    pickedImage = null;
  }

  File? pickedImage;

  fetchImage() async {
    try {
      XFile? pickImage = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxHeight: 200, maxWidth: 300);

      if (pickImage == null) return;
      final tmpImage = File(pickImage.path);
      pickedImage = tmpImage;
      isPicked = true;
      debugPrint("image fetched $pickedImage");
    } on Exception catch (_) {}
  }

  int isContains(FirebaseChatUserModel messageModel){
    for(int i = 0; i < selectedMessages.length; ++i){
      if(selectedMessages[i].chatID == messageModel.chatID){
        return i;
      }
    }
    return -1;
  }

  Stream<List<FirebaseChatUserModel>> getAllMessage(String receiver) {
    String currentUser = auth.currentUser!.uid;
    String now = DateTime.now().toString();

    Stream<List<FirebaseChatUserModel>> chats = ChatUserStore.getUsersMessage(currentUser, receiver).map((messages) {
      // debugPrint(messages.toString());
      return messages.map((message) {
        // debugPrint(message.message.toString());
        if (message.senderUID != currentUser && message.status < 2) {
          message.readTime = now.toString();
          message.status = 2;
          if (message.deliveredTime != "")
            message.deliveredTime = now.toString();
          // debugPrint(now.toString() + message.chatID);
          ChatUserStore.updateMessageStatus(message)
              .then((value) {})
              .onError((error, stackTrace) {});
        }
        return message;
      }).toList();
    });
    // debugPrint(chats.toString());
    return chats;
  }


  Stream<Map<String, dynamic>?> getCurrentStatus(String receiverUID)
  {
    // UserProfileStore.getStatusUser(receiverUID)?.map((event){
    // });
    return UserProfileStore.getCurrentUserProfile(receiverUID).map((event){
      // debugPrint(event!.onLineStatus == 0? "Offline" : "Online");
      // debugPrint(event.toString() + "is the data");
    });
  }

}
