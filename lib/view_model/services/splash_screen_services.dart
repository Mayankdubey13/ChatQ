import 'dart:async';
import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SplashServices{
  void login(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

      if(user !=null) {
        Timer(const Duration(seconds: 2), () =>
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.homeScreen, (route) => false)
        );
      }
     else{
        Timer(const Duration(seconds: 2), () =>
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.signIn, (route) => false)
        );
      }
  }
}