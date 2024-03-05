import 'package:chat_application/resources/app_color.dart';
import 'package:chat_application/resources/app_image_url.dart';
import 'package:chat_application/resources/app_string.dart';
import 'package:chat_application/resources/app_style.dart';
import 'package:chat_application/resources/components/round_button.dart';
import 'package:chat_application/view_model/loginScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
class SignInScreen extends StatefulWidget{
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> obscurePassword= ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
   return

     Scaffold(
      body: Container(
        height: double.infinity ,
        width: double.infinity,
        color: AppColors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 15),
            child:Form(
              key: _formKey,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImageUrl.loginScreenLogo,scale: 4,),
                Text(AppString.signInHeader,style: AppStyle.BlackBoldNormal24(),),
                const SizedBox(height: 5,),
                Text(AppString.signInTitle1,style: AppStyle.GreyBoldNormal14(),),
                const SizedBox(height: 50,),
                Consumer<LoginScreenProvide>(builder: (context,val,child){
                  return Column(
                    children: [
                      TextFormField(
                          controller: val.email,
                          focusNode: val.emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (val1){
                            Utils.fieldFocusNode(context, val.emailFocus,val.passwordFocus);
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
                          controller: val.password,
                          focusNode: val.passwordFocus,

                          keyboardType: TextInputType.text,
                         validator: Utils.isValidPass,
                          onFieldSubmitted: (val1){
                            Utils.fieldFocusNode(context, val.passwordFocus,val.loginFocus);
                          },
                          obscureText: val.isObx,
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
                              val.setObs();
                            }, icon:Icon(Icons.change_circle,color: Colors.purple,)),
                          )
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(onPressed: (){
                            Navigator.pushNamed(context, RoutesName.forgetPassword);
                          }, child:Text(AppString.forgotPassword,style: AppStyle.BlackBoldNormal14(),))),
                      const SizedBox(height: 10,),
                      RoundButton(
                          loading: val.loading,
                          focusNode: val.loginFocus
                          ,text: AppString.logIn, onPress: (){

                        Utils.hideKeyboard(context);
                        if (_formKey.currentState!.validate()) {
                          val.setLoading(true);
                          val.login(context);
                        }
                      }, color:AppColors.blue),
                    ],
                  );
                }),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(AppString.footerTitle,style: AppStyle.GreyBoldNormal14(),),
                    InkWell(
                        onTap:  (){
                          Navigator.pushNamed(context, RoutesName.signUp);
                        },
                        child: Text(AppString.signUp,style: AppStyle.BlueAccrentBoldNormal14(),)),
                  ],
                )


              ],
            ),

            )
          ),
        )
      ),
   );
  }
}