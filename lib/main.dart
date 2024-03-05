import 'package:chat_application/utils/routes/routes.dart';
import 'package:chat_application/utils/routes/routes_name.dart';
import 'package:chat_application/view_model/chatroomScreenProvider.dart';
import 'package:chat_application/view_model/forgetPasswordsScreenProvider.dart';
import 'package:chat_application/view_model/homeScreenProvider.dart';
import 'package:chat_application/view_model/loginScreenProvider.dart';
import 'package:chat_application/view_model/signupScreenProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
// import 'dart:js';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (_)=>LoginScreenProvide()),
      ChangeNotifierProvider(create: (_)=>SignUpScreenProvider()),
      ChangeNotifierProvider(create: (_)=>ForgetPasswordScreenProvider()),
      ChangeNotifierProvider(create: (_)=>HomeScreenProvider()),
      ChangeNotifierProvider(create: (_)=>ChatRoomScreenProvider())
      
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    ) ,
    );
  }
}
