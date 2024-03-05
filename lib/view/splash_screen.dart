import 'package:chat_application/resources/app_image_url.dart';
import 'package:chat_application/resources/app_string.dart';
import 'package:chat_application/resources/app_style.dart';
import 'package:chat_application/view_model/services/splash_screen_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
     SplashServices().login(context);
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.symmetric(horizontal:30),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Image.asset(AppImageUrl.splashScreen),
           Text(AppString.splashText,style: AppStyle.BlackBoldNormal24()),
           SizedBox(height: 20,),
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text(AppString.splashTitle1,style: AppStyle.GreyNormal16()),
               Text(AppString.splashTitle2,style: AppStyle.GreyNormal16()),
               Text(AppString.splashTitle3,style:  AppStyle.GreyNormal16(),),
             ],
           ),
             SizedBox(height: 70,),
           Container(
             width: 100,
               child: LinearProgressIndicator(color: Colors.white,minHeight: 5,))
         ],
       ),
     )

   );
  }
}