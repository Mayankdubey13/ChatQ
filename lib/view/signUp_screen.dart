import 'package:chat_application/view_model/signupScreenProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../resources/app_color.dart';
import '../resources/app_string.dart';
import '../resources/app_style.dart';
import '../resources/components/round_button.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget{
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          leading: IconButton(
             onPressed: (){
       Navigator.pop(context);
    },
        icon:Icon(Icons.arrow_back_outlined),
      //replace with our own icon data.
    ),
         ),
          body:  SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(AppString.signUpHeader,style: AppStyle.BlackBoldNormal24(),),
                  SizedBox(height: 5,),
                 Text(AppString.signUpitle1,style: AppStyle.GreyBoldNormal14(),),
                 SizedBox(height: 20,),
                 SizedBox(
                   width: 100,
                   height: 100,
                   child: Consumer<SignUpScreenProvider>(
                     builder: (context,value,child) {
                       return Stack(
                         children: [
                       !value.isPicked?
                       CircleAvatar(
                               radius: 60,
                             backgroundImage: NetworkImage(value.imgUrl),
                             ):
                       CircleAvatar(
                             radius: 60,
                             backgroundImage: FileImage(value.pickedImage!),
                       ),
                           Padding(
                             padding: const EdgeInsets.only(bottom: 5),
                             child: Align(
                               alignment: Alignment.bottomRight,
                                 child:InkWell(
                                      onTap: () async {
                                        await  value.requestPermission();
                                      }
                                    , child: Icon(Icons.camera_alt_rounded))),
                           )
                         ],
                       );
                     }
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                   child: Form(
                     key: _formKey,
                       child:Consumer<SignUpScreenProvider>(builder: (context,value, child) {
                         return Column(
                           children: [
                             TextFormField(
                               controller: value.name,
                               focusNode: value.nameFocus,
                               keyboardType: TextInputType.text,
                               onFieldSubmitted: (val1){
                                 Utils.fieldFocusNode(context, value.nameFocus,value.emailFocus);
                               },
                               decoration: InputDecoration(
                                 prefixIcon:  Icon(
                                   Icons.person,
                                   color: AppColors.blue,
                                 ),
                                 hintText: 'Full Name',
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
                               validator: Utils.isValidName,
                             ),
                             const SizedBox(height: 20,),
                             TextFormField(
                               controller: value.email,
                               focusNode: value.emailFocus,
                               keyboardType: TextInputType.emailAddress,
                               onFieldSubmitted: (val1){
                                 Utils.fieldFocusNode(context, value.emailFocus,value.passwordFocus);
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
                               validator: Utils.isValidEmail,
                             ),
                             const SizedBox(height: 20,),
                             TextFormField(
                                 controller: value.password,
                                 focusNode: value.passwordFocus,

                                 keyboardType: TextInputType.text,
                                 validator: Utils.isValidPass,
                                 onFieldSubmitted: (val1){
                                   Utils.fieldFocusNode(context, value.passwordFocus,value.conformFocus);
                                 },
                                 obscureText: value.isObx,
                                 decoration: InputDecoration(
                                   prefixIcon:  Icon(
                                     Icons.lock,
                                     color: AppColors.blue,
                                   ),
                                   hintText: 'Password',

                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(30),
                                     borderSide: const BorderSide(
                                       color: AppColors.black26,
                                     ),
                                   ),
                                   focusedBorder: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(30),
                                       borderSide: const BorderSide(
                                           color: AppColors.blueAccent,
                                           width: 2
                                       )
                                   ),
                                   suffixIcon: IconButton(onPressed: (){
                                     value.setObs();
                                   }, icon:Icon(Icons.change_circle,color: Colors.purple,)),
                                 )
                             ),
                             const SizedBox(height: 20,),
                             TextFormField(
                                 controller: value.conformPassword,
                                 focusNode: value.conformFocus,

                                 keyboardType: TextInputType.text,
                                 validator: Utils.isValidPass,
                                 onFieldSubmitted: (val1){
                                   Utils.fieldFocusNode(context, value.conformFocus,value.signUpFocus);
                                 },
                                 obscureText: value.isObx1,
                                 decoration: InputDecoration(
                                   prefixIcon:  Icon(
                                     Icons.lock,
                                     color: AppColors.blue,
                                   ),
                                   hintText: 'Conform Password',

                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(30),
                                     borderSide: const BorderSide(
                                       color: AppColors.black26,
                                     ),
                                   ),
                                   focusedBorder: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(30),
                                       borderSide: const BorderSide(
                                           color: AppColors.blueAccent,
                                           width: 2
                                       )
                                   ),
                                   suffixIcon: IconButton(onPressed: (){
                                     value.setObs1();
                                   }, icon:Icon(Icons.change_circle,color: Colors.purple,)),
                                 )
                             ),
                             SizedBox(height: 30,),
                             RoundButton(
                                 loading: value.loading,
                                 focusNode: value.signUpFocus
                                 ,text: AppString.signUpText, onPress: (){
                               Utils.hideKeyboard(context);

                               if (_formKey.currentState!.validate()) {
                                 if(value.password.text.trim().toString() == value.conformPassword.text.trim().toString()){
                                   value.setLoading(true);
                                   value.signup(context);

                                 }
                                 else
                                 {
                                   Utils.toastMessage("Password and conform Passsword not same ");
                                 }
                               }
                             }, color:AppColors.blue),
                             const SizedBox(height: 20,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [

                                 Text(AppString.signUpFooterTitle,style: AppStyle.GreyBoldNormal14(),),
                                 InkWell(
                                     onTap:  (){
                                       Navigator.pushNamed(context, RoutesName.signIn);
                                     },
                                     child: Text(AppString.logIn,style: AppStyle.BlueAccrentBoldNormal14(),)),
                               ],
                             )
                           ],
                         );
                       },)
                   ),
                 )
               ],
              ),
            ),
          ),
    );
  }
}