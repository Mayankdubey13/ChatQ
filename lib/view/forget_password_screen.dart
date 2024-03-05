import 'package:chat_application/resources/app_color.dart';
import 'package:chat_application/view_model/forgetPasswordsScreenProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/components/round_button.dart';
import '../utils/utils.dart';

class ForgetPasswordScreen extends StatefulWidget{
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>  {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
          child: Consumer<ForgetPasswordScreenProvider>(
            builder: (context, val, child) {
              return Column(
                children: [
                  TextFormField(
                    controller: val.email,
                    focusNode: val.emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (val1){
                      Utils.fieldFocusNode(context, val.emailFocus,val.loginFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon:  Icon(
                        Icons.email,
                        color: AppColors.blue,
                      ),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: AppColors.black26,

                        ),
                      ),
                      focusedBorder:
                      OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: AppColors.blueAccent,
                              width: 2
                          )
                      ),

                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                    text: "Forgot",
                    focusNode: val.loginFocus,
                    loading: val.loading,
                    onPress: () {
                      val.setLoading(true);
                      _auth
                          .sendPasswordResetEmail(
                          email: val.forgetPassword.text.toString().trim())
                          .then((value) {
                        Utils.toastMessage("CODE SENT IN GIVEN EMAIL");
                        val.setLoading(false);
                      }).onError((error, stackTrace) {
                        Utils.toastMessage(error.toString());
                        val.setLoading(false);
                      });
                    }, color: AppColors.blue,
                  )
                ],
              );
            },
          )),
    );
  }
}