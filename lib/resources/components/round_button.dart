import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget{
  final text;
   bool  loading ;
   FocusNode? focusNode;
  final  onPress;
  final color;
  RoundButton({
    required this.text ,
    this.loading = false,
    this.focusNode,
    required this.onPress,
    required this.color
});
  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: onPress,
     focusNode: focusNode,
     child: Container(
       height: 60,
       width: 200,

       decoration:BoxDecoration(
           color: color,
          borderRadius: BorderRadius.circular(30)
       ) ,
       child: Center(
           child: loading? CircularProgressIndicator(color: Colors.white,) : Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
     ),
   );
  }

}