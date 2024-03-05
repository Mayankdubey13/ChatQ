import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:chat_application/view/chatroom_screen/chatroom_screen.dart';
import 'package:chat_application/view/contactList_screen.dart';
import 'package:chat_application/view/forget_password_screen.dart';
import 'package:chat_application/view/home_screen.dart';
import 'package:chat_application/view/personal_profile_screen.dart';
import 'package:chat_application/view/signIn_screen.dart';
import 'package:chat_application/view/signUp_screen.dart';
import 'package:flutter/material.dart';
import '../../view/forward_message.dart';
import '../../view/splash_screen.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name){
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (BuildContext context)=>SplashScreen());
      case RoutesName.signIn:
        return MaterialPageRoute(builder: (BuildContext context)=>SignInScreen());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (BuildContext context)=>HomeScreen());
      case RoutesName.signUp:
        return MaterialPageRoute(builder:(BuildContext context)=>SignUpScreen());
      case RoutesName.forgetPassword:
        return MaterialPageRoute(builder: (BuildContext context)=>ForgetPasswordScreen());

      case RoutesName.chatRoomScreen:
             Map<String,dynamic> user = settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(builder: (BuildContext context)=>ChatRoomScreen(receiver:user["user"]));
      case RoutesName.personalProfileScreen:
        Map<String,dynamic> personal = settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(builder: (BuildContext context)=>UserProfileView(user:personal["user"]));
      case RoutesName.contactListScreen:
        return MaterialPageRoute(builder: (BuildContext context)=>ContactList());
      case RoutesName.forwardMessageView:
        Map<String, dynamic> r = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ForwardMessageView(messagesList: r["messagesList"],receiverData:r["receiverData"]));
      default:
        return MaterialPageRoute(builder: (_){
          return  const Scaffold(
            body: Center(
              child: Text("No routes are there"),
            ),
          );
        });
    }

  }
}