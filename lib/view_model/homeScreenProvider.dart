

import 'package:chat_application/model/firebase_user_model/firebase_user_model.dart';
import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../model/firebase_user_model/firebase_chat_user_model.dart';
import '../utils/firebase_database/firebase_firestore/chat_user.dart';
import '../utils/firebase_database/firebase_firestore/user_profile.dart';

class HomeScreenProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  get userId => _auth.currentUser!.uid.toString().trim();

  logout(BuildContext context) {
    _auth.signOut().then((value) {
      Navigator.pushNamed(context, RoutesName.signIn);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isLogin = false;
    super.dispose();
  }

   FirebaseUserDetailModel ?_currentUser;
    bool _isLogin = false;

  FirebaseUserDetailModel? get currentUser {
    if (!_isLogin) {
      getCurentUserDetail();
      _isLogin = true;
    }
    return _currentUser;
  }


  getCurentUserDetail() {
    UserProfileStore.getCurrentUserProfile(_auth.currentUser!.uid).listen((
        f_user) {
      if (f_user != null) {
        _currentUser = f_user;
      }
      else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }
  updateAllMessage(String receiver) {
    String currentUser = _auth.currentUser!.uid.toString().trim();
    String now = DateTime.now().toString();
    Stream<List<FirebaseChatUserModel>> chats = ChatUserStore.getUsersMessage(currentUser, receiver);
    chats.map((messages) async {
      for(FirebaseChatUserModel message in messages)
      {
        if(message.senderUID != _auth.currentUser!.uid &&  message.status == 0){
          message.deliveredTime = now;
          message.status = 1;
          await ChatUserStore.updateMessageStatus(message).then((value){
            debugPrint("Updation on database is success");
          }).onError((error, stackTrace){
            debugPrint("Updation on database is failed");
          });
        }
      }
    });
    return chats;
  }

  Stream<List<FirebaseUserDetailModel>> getAllUser() {
    // debugPrint("This code is running and fetching the users profile registered in the app");
    Stream<List<FirebaseUserDetailModel>> profiles = UserProfileStore.getAllUsers();
    // debugPrint("Profiles fetched! $profiles");
    profiles.map((List<FirebaseUserDetailModel> usersProfile)async {
      debugPrint("This code is running");
      List<FirebaseUserDetailModel> users = [];
      for(FirebaseUserDetailModel profileModel in usersProfile){
        await updateAllMessage(profileModel.uid);
        if (profileModel.uid != _auth.currentUser!.uid) {
          {
            users.add(profileModel);
          }
        }
      }
      debugPrint(users.length.toString());
      return users;
    });

    return profiles;
  }

  Stream<List<FirebaseUserDetailModel>> getAllUsers()
  {
    var datas = UserProfileStore.getUsersProfile();
    datas.map((event){
      for(var user in event){
        // debugPrint(user.imageUrl.toString());
      }
    });
    return datas;
  }

  // Stream<List<FirebaseUserDetailModel>>? getUserWhomChat() {
  //   String senderUID = FirebaseAuth.instance.currentUser!.uid;
  //
  //   return getAllUsers().asyncMap((usersList) async {
  //     List<FirebaseUserDetailModel> users = [];
  //
  //     for (FirebaseUserDetailModel user in usersList) {
  //       // debugPrint((await ChatUserStore().isChatRoomExist(user.uid, senderUID)).toString());
  //       bool isChatExist = await ChatUserStore().isChatRoomExist(user.uid, senderUID);
  //       if (user.uid != senderUID && isChatExist) {
  //         users.add(user);
  //         debugPrint(user.toString());
  //       }
  //     }
  //     // notifyListeners();
  //
  //     // debugPrint(users.toString());
  //
  //     return users;
  //   });
  // }

  static setUserStatus(bool status)
  {
    try{
      UserProfileStore.updateStatus(status);
    } catch(e){
      debugPrint("Error while updating status $e");
    }
  }
}


