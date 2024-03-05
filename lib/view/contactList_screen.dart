import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/firebase_user_model/firebase_user_model.dart';
import '../resources/app_color.dart';
import '../resources/app_style.dart';
import '../utils/routes/routes_name.dart';
import '../view_model/homeScreenProvider.dart';

class ContactList extends StatefulWidget{
  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
          child: Icon(Icons.arrow_back_ios_rounded,color: AppColors.blueAccent,size: 30,)),
      centerTitle: false,
      title: Text("Users",style: TextStyle(color: AppColors.blueAccent,fontSize: 27,fontWeight: FontWeight.bold),),

    )

     ,body:  Container(
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
                                   onTap: (){
                                     Navigator.pushNamed(context, RoutesName.chatRoomScreen, arguments: {"user":users[index]});
                                   },
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
                                 // child: ListTile(
                                 //   onTap: (){
                                 //       Navigator.pushNamed(context, RoutesName.chatRoomScreen, arguments: {"user":users[index]});
                                 //  },
                                 //   leading: InkWell(
                                 //     onTap: (){
                                 //       userProfileAlertBox(users[index]);
                                 //   //    Navigator.pushNamed(context, RoutesName.chatRoomScreen,arguments: users[index]);
                                 //     },
                                 //     child: SizedBox(
                                 //          width: 60,
                                 //         height: 60,
                                 //       child: ClipOval(
                                 //         child: CachedNetworkImage(
                                 //           imageUrl: users[index].imageUrl.toString(),
                                 //           fit: BoxFit.fill,
                                 //         ),
                                 //       ),
                                 //     ),
                                 //   ),
                                 //   title: Text(users[index].name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 22),)
                                 // ),
                               );
                             });
                       },);
                   }
               ) )
         ],
       ),
     ),
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
}