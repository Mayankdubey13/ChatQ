import 'package:chat_application/view_model/homeScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/firebase_user_model/firebase_user_model.dart';
import '../resources/app_color.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.user});
  final FirebaseUserDetailModel user;
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
      Navigator.pop(context);
    },
    icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.blueAccent,size: 30,),
        ),
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Profile", style: TextStyle(color: AppColors.blueAccent,fontSize: 30,fontWeight: FontWeight.bold),),

          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column (
            children: [
              const SizedBox(height: 30),
              Flexible(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage( widget.user.image.toString()),
                  )

              ),
              const SizedBox(height: 30,),
              ListTile(
                leading:const Icon(Icons.person, color: AppColors.blueAccent,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name", style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18),),
                    Text(widget.user.name.toString(), style:const TextStyle(color: AppColors.blackFade,fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
              ),
              const ListTile(
                leading:Icon(Icons.info_outline_rounded, color: AppColors.blueAccent),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About", style:TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18),),
                    Text("ChatQ", style: TextStyle(color: AppColors.blackFade,fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
              ),
              ListTile(
                leading:const Icon(Icons.email_outlined, color:AppColors.blue),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Contact", style:TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18) ),
                    Text(widget.user.email.toString(), style: const TextStyle(color: AppColors.blackFade,fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
             Consumer<HomeScreenProvider>(builder: (context,value, child) {
                return   InkWell(
                  onTap:(){
                    value.logout(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.login_outlined,color: Colors.red,size: 25,),
                    title: Text("Sign-Out",style: TextStyle(fontSize: 22,color: Colors.red,fontWeight: FontWeight.bold),),
                  ),
                );
              },)

            ],
          ),
        ),
      ),
    );
  }
}