import 'package:chat_application/resources/app_color.dart';
import 'package:flutter/material.dart';

class AppStyle{
  static TextStyle GreyNormal16 (){
    return const TextStyle(
      color: AppColors.grey,
      fontSize: 16,
      fontWeight: FontWeight.normal
    );
  }
  static TextStyle BlackBoldNormal24 (){
    return const TextStyle(
        color: AppColors.black,
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold
    );
  }
  static TextStyle GreyBoldNormal14 (){
    return const TextStyle(
        color: AppColors.grey,
        fontSize: 15,
        fontWeight: FontWeight.bold
    );
  }
  static TextStyle BlackBoldNormal14 (){
    return const TextStyle(
        color: AppColors.black,
        fontSize: 14,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold
    );
  }
  static TextStyle BlueAccrentBoldNormal14 (){
    return const TextStyle(
        color: AppColors.blueAccent,
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold
    );
  }
}