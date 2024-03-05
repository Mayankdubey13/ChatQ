import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/model/firebase_user_model/firebase_user_model.dart';
import 'package:chat_application/resources/app_color.dart';
import 'package:chat_application/resources/app_style.dart';
import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:chat_application/view_model/homeScreenProvider.dart';
import 'package:chat_application/view_model/signupScreenProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
 }

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState()
  {
    SystemChannels.lifecycle.setMessageHandler((message) async
    {
      debugPrint(message);
      if(message.toString().contains("pause")) {
        debugPrint("Updating offline");
        HomeScreenProvider.setUserStatus(false);
      }
      else if(message.toString().contains('resume')){
        debugPrint("Updating Online");
        HomeScreenProvider.setUserStatus(true);
      }
      return Future.value(message);
    });
    super.initState();
  }
  @override
  // ignore: override_on_non_overriding_member
  final databaseStore = FirebaseFirestore.instance.collection("user").snapshots();
  // final userId = FirebaseAuth.i
  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Consumer<HomeScreenProvider>(
            builder: (context,value,child) {
              return
                Row(
                  children: [
                    Expanded(child: Text("Chats",style:TextStyle(fontSize: 30,color: AppColors.blueAccent,fontWeight: FontWeight.bold) , )),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, RoutesName.personalProfileScreen,
              arguments: {
                    "user":value.currentUser
              }),

                        child: Icon(Icons.menu,size: 27,color: AppColors.blueAccent,))

                  ],
                );
            }
        ),
      ),
       body: Stack(
         children: [
           Container(
             color: AppColors.blackFade,
             child: Column(
               children: [
                 Expanded(
                     child:Consumer<HomeScreenProvider>(
                         builder: (context, value, child) {
                           return StreamBuilder<List<FirebaseUserDetailModel>>(
                             stream: value.getAllUsers(),
                             builder: (BuildContext context, AsyncSnapshot<List<FirebaseUserDetailModel>> snapshot) {
                               List<FirebaseUserDetailModel>? users = snapshot.data;
                               if (snapshot.connectionState == ConnectionState.waiting) {
                                 return const CircularProgressIndicator();
                               }
                               if (snapshot.hasError) {
                                 return const Text("Error");
                               }
                               return ListView.builder(
                                   itemCount : users!.length,
                                   itemBuilder: (context,index){
                                     if(users[index].uid==value.currentUser!.uid) {
                                       return const SizedBox(height: 0,width: 0,);
                                     }
                                     return Container(
                                       height: 94,
                                       width: 85,
                                       child: InkWell(
                                         onTap:(){  Navigator.pushNamed(context, RoutesName.chatRoomScreen, arguments: {"user":users[index]});},
                                         child: Column(
                                           children: [
                                             Padding(
                                               padding: const EdgeInsets.all(15),
                                               child: Row(
                                                 children: [
                                                   InkWell(
                                                     onTap: (){
                                                       userProfileAlertBox(users[index]);
                                                       //    Navigator.pushNamed(context, RoutesName.chatRoomScreen,arguments: users[index]);
                                                     },
                                                     child: SizedBox(
                                                       width: 60,
                                                       height: 60,
                                                       child: ClipOval(
                                                         child: CachedNetworkImage(
                                                           imageUrl: users[index].image.toString(),
                                                           fit: BoxFit.fill,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                   SizedBox(width: 20,),
                                                   Text(users[index].name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 22),)

                                                 ],
                                               ),
                                             ),
                                             Divider(height: 4,color: Colors.black,)
                                           ],
                                         ),
                                       ),
                                     );
                                   });
                             },);
                         }
                     ) )
               ],
             ),
           ),
           Align(
             alignment: Alignment.bottomRight,
             child: SizedBox(
               height: 80,
               width: 80,
               child: InkWell(
                 onTap: (){
                   Navigator.pushNamed(context, RoutesName.contactListScreen);
                 },
                 child: Padding(
                   padding: const EdgeInsets.only(bottom: 40,right: 20),
                   child: CircleAvatar(
                     backgroundColor: AppColors.blueAccent,
                       radius:25,
                       child: Icon(Icons.add,color: AppColors.white,size: 40,)),
                 ),
               ),
             ),
           )
         ],
       )
    );
  }
   userProfileAlertBox(FirebaseUserDetailModel user){
    return  showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                     width: 350,
                      height: 350,
                      child: CachedNetworkImage(imageUrl: user.image, fit: BoxFit.fill,)),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.blackFade
                      ),
                      height: 50,
                      width: double.infinity,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                              child: const Icon(Icons.chat,color: AppColors.blueAccent,),
                          onTap: (){
                               Navigator.pushNamedAndRemoveUntil(context, RoutesName.chatRoomScreen, arguments: { "user":user} ,(route) => route.isFirst) ;
                          },),

                          const Icon(Icons.block,color: AppColors.blueAccent,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.blackFade
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text(user.name,style: AppStyle.BlueAccrentBoldNormal14(),)),
                    // InkWell(
                    //   onTap: (){
                    //     BottomSheet(user);
                    //   },
                    //     child: Text("Edit",style: AppStyle.BlueAccrentBoldNormal14(),))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  // BottomSheet(FirebaseUserDetailModel user){
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Consumer<SignUpScreenProvider>(builder: (context, value,  child) {
  //         return Container(
  //           height: 240,
  //           color: AppColors.blackFade,
  //           child: Center(
  //             child: Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Row(
  //                     children: [
  //                       const Expanded(child: Text("Edit Profile Picture",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)),
  //                       InkWell(onTap:()=>Navigator.pop(context),child: const Icon(Icons.cancel_outlined,color: AppColors.blueAccent,size: 35,))
  //                     ],
  //                   ),
  //                   SizedBox(height: 30,),
  //                   SizedBox(
  //                     height: 60,
  //                     child: Card(
  //                       color: AppColors.blackFade,
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 10),
  //                         child: InkWell(
  //                           onTap: (){
  //                             value.requestPermission();
  //                           },
  //                           child: Row(
  //                             children: [
  //                               Expanded(child: Text("Choose Photo",style: TextStyle(fontSize: 18,color: Colors.white),)),
  //                               Icon(Icons.photo_album,color: Colors.blueAccent,size: 25,)
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 60,
  //                     child: Card(
  //                       color: AppColors.blackFade,
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 10),
  //                         child: InkWell(
  //                           onTap: (){
  //
  //                           },
  //                           child: Row(
  //                             children: [
  //                               Expanded(child: Text("Delete Photo",style: TextStyle(fontSize: 18,color: Colors.white),)),
  //                               Icon(Icons.delete,color: Colors.red,size: 30,)
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //
  //
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },);
  //     },
  //   );
  // }
}

