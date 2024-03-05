import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{
   static fieldFocusNode(BuildContext context , FocusNode currentFocus, FocusNode nextFocus){

     currentFocus.unfocus();
     FocusScope.of(context).requestFocus(nextFocus);
}

  static toastMessage(String message){
    Fluttertoast.showToast(msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void flushBarErrorMessage(String message ,BuildContext context){
    showFlushbar(context: context,
        flushbar: Flushbar(
          message: message,
         forwardAnimationCurve: Curves.decelerate,
          borderRadius: BorderRadius.circular(8),
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          padding: EdgeInsets.all(15),
         duration: Duration(seconds: 3),
          backgroundColor: Colors.purple,
          reverseAnimationCurve: Curves.easeInOut ,
          positionOffset: 20,
          flushbarPosition: FlushbarPosition.TOP,


        )..show(context)
    );

  }
  static snakBar(String message ,BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red  ,
            content: Text(message)));
  }
   static String? isValidEmail(String? email) {
     if (email!.isEmpty) {
       return 'Please enter email';
     }
     if(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email!)){
        return null;
      }
      return "Enter valid email";
   }

   static String? isValidPass(String? value) {
     RegExp regex =
     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
     if (value!.isEmpty) {
       return 'Please enter password';
     } else {
       if (!regex.hasMatch(value)) {
         return 'Enter valid password';
       } else {
         return null;
       }
     }
   }

   static String? isValidName(String? value) {
     RegExp regExp = RegExp('[a-zA-Z]');
     if(value!.isEmpty){
       return 'Enter Your Name';
     }
     else if(value.length < 3) {
       return 'Enter a Valid Name';
     }
     return null;
   }

   static hideKeyboard(context) {
     FocusScopeNode currentFocus = FocusScope.of(context);
     if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
     }
   }
}