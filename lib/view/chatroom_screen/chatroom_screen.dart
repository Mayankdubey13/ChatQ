import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/model/firebase_user_model/firebase_user_model.dart';
import 'package:chat_application/resources/app_color.dart';
import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:chat_application/view/chatroom_screen/widget/delete_dailog.dart';
import 'package:chat_application/view_model/chatroomScreenProvider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/firebase_user_model/firebase_chat_user_model.dart';
import '../../resources/app_style.dart';
import '../../utils/firebase_database/firebase_firestore/user_profile.dart';

class ChatRoomScreen extends StatefulWidget{

  FirebaseUserDetailModel receiver;
  ChatRoomScreen({super.key, required this.receiver});
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
   // final databaseStoreChat = FirebaseFirestore.instance.collection("chat-collections").doc(ChatUserStore.getChatRoomId(_auth.currentUser!.uid.toString(), widget.receiver.uid)).collection("messages").snapshots();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: false,
          leading:Consumer<ChatRoomScreenProvider>(builder: (context,value, child) {
            return value.selectedMessages.isEmpty ?
            IconButton(onPressed: () {
              Navigator.pop(context);
            },
            icon:const Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.blueAccent,size: 30,)) :
            IconButton(onPressed: () {
              value.removeAllFromList();
            },
                icon:const Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.blueAccent,size: 30,));
            }
          ),
          title: Consumer<ChatRoomScreenProvider>(builder: (context,value,child) {

            return value.selectedMessages.isEmpty? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(widget.receiver.image?? ""),
                ),
                const SizedBox(width: 15,),
                Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.receiver.name,style: const TextStyle(color: AppColors.blueAccent,fontWeight: FontWeight.w600),),
                    StreamBuilder(stream:  UserProfileStore.getStatusUser(widget.receiver.uid), builder: (context,isActive){
                      int? status = isActive.data;
                      if(isActive.connectionState == ConnectionState.waiting) return const SizedBox();
                      else if(!isActive.hasData) return const SizedBox();
                      return (status ==1)?Text("Online",style: TextStyle(color: Colors.green,fontSize: 18),):Text("Offline",style: TextStyle(color: Colors.grey.shade400,fontSize: 18));
                    }),
                  ],
                ),

              ],
            ):
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: (){
                      value.removeAllFromList();
                    },
                    child: const Icon(Icons.arrow_back),),
                Row(
                  children: [
                    if(value.selectedMessages.length == 1)
                      Row(
                        children: [
                          if(value.isAvailableToStar()) InkWell(onTap:(){
                            value.toggleStar();
                          },
                            child: const Icon(Icons.star,color: AppColors.blueAccent,),),
                          const SizedBox(width: 20,),
                          InkWell(onTap:(){
                            value.copyMessage(context);
                          },
                              child: const Icon(Icons.copy,color: AppColors.blueAccent,)),
                        ],
                      ),
                    const SizedBox(width: 20,),
                    InkWell(
                        onTap: ()
                        {
                          bool deleteAll = value.isAvailableToDeleteForAll();
                          showDialog(context: context, builder: (context)=> DeleteDialog(deleteForMe: value.deleteForMe,deleteForAll: value.deleteForAll,isDeleteForAll:deleteAll,));
                          // provider.deleteMessages();
                        },
                        child: const Icon(Icons.delete, size: 35,color: AppColors.blueAccent,)),
                    const SizedBox(width: 20,),
                    InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, RoutesName.forwardMessageView, arguments: {"messagesList" :value.selectedMessages, "receiverData":widget.receiver});
                        },
                        child: const Icon(Icons.forward, size: 35,color: AppColors.blueAccent,)),
                    const SizedBox(width: 10,),
                  ],
                )
              ],
            );
          },

          )
      ),
       body: Padding(
         padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
         child: Consumer<ChatRoomScreenProvider>(builder: ( context,  value,  child) {
           return Column(
             children: [
               Expanded(
                   child: StreamBuilder<List<FirebaseChatUserModel>>(
                   stream: value.getAllMessage(widget.receiver.uid),
                   builder: (BuildContext context ,  chatsSnapshot)
                   {
                     List<FirebaseChatUserModel>? chatList = chatsSnapshot.data;
                     if (chatsSnapshot.connectionState == ConnectionState.waiting || !chatsSnapshot.hasData) {
                       return const CircularProgressIndicator();
                     }
                     else if (chatsSnapshot.hasError) {
                       return const Text("Error");
                     }
                     else
                     {
                       return ListView.builder
                         (

                         reverse: true,
                            itemCount: chatList!.length,
                            itemBuilder: (context, indexes) {
                              int listLength = chatList!.length;
                              int index = listLength- indexes -1;
                              bool isSender = chatList[index].senderUID == value.auth.currentUser!.uid;
                              bool isImage = chatList[index].img!.isEmpty;
                             if (chatList[index].visibleNo != 0 && ((isSender && chatList[index].visibleNo != 1) || (!isSender && chatList[index].visibleNo != 2)))
                              {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: !(value.isContains(chatList[index]) == -1)? Colors.grey:null,
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 200
                                    ),
                                    child: Row(
                                      mainAxisAlignment: chatList[index].senderUID
                                          .toString() ==
                                          _auth.currentUser!.uid.toString()
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          chatList[index].senderUID.toString() ==
                                              _auth.currentUser!.uid
                                                  .toString()
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            InkWell(

                                              onTap: () {
                                               value.tapToSelect(chatList[index]);
                                              },
                                              onLongPress: (){
                                                showDialog(context: context, builder: (context)=>Dialog(child: InfoDialog( chatList[index],),));
                                              },
                                              child: Card(
                                                  color: AppColors.blackFade,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(
                                                            constraints:
                                                            const BoxConstraints(
                                                                maxWidth:
                                                                270),

                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end
                                                            ,children:[
                                                              if(chatList[index].star == 1) const Icon(Icons.star, color: AppColors.white,),
                                                              if(chatList[index].isForwarded == 1) SizedBox(
                                                                width: 100,
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(Icons.forward_outlined, color: AppColors.white,),
                                                                    Text("Forwarded", style: TextStyle(color: Colors.white,fontSize: 14),)
                                                                  ],),
                                                              ),
                                                              isImage  ? Text(
                                                            chatList[index].message ,
                                                               style: const TextStyle(
                                                                   color: AppColors
                                                                       .white,
                                                                   fontSize:
                                                                   16),
                                                            )
                                                          : CachedNetworkImage(
                                                  imageUrl: chatList[index]
                                                      .img.toString())
                                                            ]
                                                            ),
                                                        )
                                                      ],
                                    )
                                                  )),
                                            ),
                                            Row(
                                              children: [
                                                Text(chatList[index].time
                                                    .substring(11, 16)),
                                                if(chatList[index].senderUID ==
                                                    _auth.currentUser!.uid)Icon(
                                                    (chatList[index].status == 2)
                                                        ? Icons.done_all
                                                        : Icons.check),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                             else {
                               return const SizedBox();
                             }

                            });
                     }

                    }
               )),
               Row(
                 children: [
                   IconButton(onPressed:()
                   {
                      value.requestPermission(widget.receiver.uid);
                   },
                       icon: const Icon(Icons.camera_alt_rounded,size: 35,)),
                   const SizedBox(width: 10,),
                   Expanded(
                     child: TextFormField(
                       controller: value.writeController,
                       focusNode: value.writeFocusNode,
                       keyboardType: TextInputType.text,
                       onFieldSubmitted: (val1){
                         // Utils.fieldFocusNode(context, value.writeFocusNode,value.emailFocus);
                         value.sendMessage(widget.receiver.uid);
                       },

                       decoration: InputDecoration(

                         hintText: 'Write here something...',
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
                   ),
                   const SizedBox(width: 20,),
                   CircleAvatar(
                       backgroundColor: AppColors.blackFade,
                       child:InkWell(
                        onTap: (){
                          value.sendMessage(widget.receiver.uid);
                        },
                           child: const Icon(Icons.send,color: AppColors.blueAccent,))
                   ),
                 ],
               ),

             ],

           );
         },)
       ),
     );


  }
   Widget InfoDialog(FirebaseChatUserModel messageModel){
     bool isUserSeen = messageModel.status == 2;
     String readTime = !(messageModel.readTime == null)?messageModel.readTime!.substring(11,16).toString() : "N/A";
     String sentTime = !(messageModel.sentTime.length < 16)?  messageModel.sentTime!.substring(11,16).toString() : "N/A";

    return  Container(
      decoration: const BoxDecoration(
        color: AppColors.blueAccent,
      ),
      constraints: const BoxConstraints(
          maxHeight: 100
      ),
      child: Column(
        children:
        [
          Text("Message: ${messageModel.message}"),
          Text(
             isUserSeen ? "Seen" : "Unseen",
            style: TextStyle(
              color: isUserSeen ? Colors.black : Colors.white,
            ),
          ),
          Text("ReadTime: $readTime"),
          Text("SentTime: $sentTime"),
        ],
      ),
    );
;
   }



}