import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/model/firebase_user_model/firebase_chat_user_model.dart';
import 'package:chat_application/model/firebase_user_model/firebase_user_model.dart';
import 'package:chat_application/resources/app_color.dart';
import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:chat_application/view_model/chatroomScreenProvider.dart';
import 'package:chat_application/view_model/homeScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ForwardMessageView extends StatefulWidget {
  const ForwardMessageView({super.key, required this.messagesList, required this.receiverData});
  final List<FirebaseChatUserModel> messagesList;
  final FirebaseUserDetailModel receiverData;
  @override
  State<ForwardMessageView> createState() => _ForwardMessageViewState();
}

class _ForwardMessageViewState extends State<ForwardMessageView> {
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
      ),
      body: Container(
        color: AppColors.blackFade,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(
              child: Consumer<HomeScreenProvider>(builder: (context, provider, child){
                return StreamBuilder<List<FirebaseUserDetailModel>>(stream: provider.getAllUser(), builder: (context,AsyncSnapshot<List<FirebaseUserDetailModel>> snapshot)
                {
                  List<FirebaseUserDetailModel>? users =  snapshot.data;

                  if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else
                  {
                    return ListView.builder(itemBuilder: (context, index) {
                      if(users[index].uid != provider.currentUser!.uid){
                        return Consumer<ChatRoomScreenProvider>(
                            builder: (context, providerChat, child) {
                              return Container(
                                height: 80,
                                width: 85,
                                child: InkWell(
                                  onTap: (){
                                    providerChat.forwardMessage(widget.messagesList, users[index].uid);
                                    Future.delayed(const Duration(seconds: 1));
                                    Navigator.pushNamedAndRemoveUntil(context, RoutesName.chatRoomScreen, arguments: {"user": widget.receiverData},(route) => route.isFirst);
                                  },
                                  child: Column(
                                    children: [

                                      Row(
                                        children: [
                                          SizedBox(width: 10,),
                                          Container(
                                            height: 60,
                                            width: 60,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: users![index].image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15,),
                                          Text(users[index].name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 22),),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Divider(height: 4,color: Colors.black,)
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      }
                      else{
                        return SizedBox();
                      }
                    }, itemCount: users!.length,);
                  }
                });
              },),
            ),
          ],
        ),
      ),
    );
  }
}
