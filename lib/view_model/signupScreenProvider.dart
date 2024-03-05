import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/firebase_user_model/firebase_user_model.dart';
import '../utils/firebase_database/firebase_firestore/user_profile.dart';
import '../utils/firebase_database/firebase_storage/upload_image_firebase.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreenProvider extends ChangeNotifier{
  final auth = FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conformPassword= TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode conformFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
   conformPassword.dispose();
  }
  FocusNode signUpFocus = FocusNode();
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  bool isObx = false;
  setObs(){
    isObx = !isObx;
    notifyListeners();
  }
  bool isObx1 = false;
  setObs1(){
    isObx1 = !isObx1;
    notifyListeners();
  }

  bool isPicked = false;
  File? pickedImage;
  String _imgUrl = "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=1024x1024&w=is&k=20&c=t1UxKUo5asF5EL4bncWciZwcWfIs9NOf7zfwy1dWl2U=";
  String get imgUrl => _imgUrl;


  fetchImage() async {
    try {
      XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 300);
      if (pickImage == null) return;
      final tmpImage = File(pickImage.path);
      pickedImage = tmpImage;
      isPicked = true;
      debugPrint("Image Picked");
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("Image Picked");
    }
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.camera.request();
    // Check the permission status
    if (status.isGranted) {
      debugPrint("Going to fetch Image");
      await fetchImage();
    } else {
      debugPrint("Going to fetch Image in else");
      await fetchImage();
      debugPrint("Image Fetched now going to upload in else");
      // await uploadImage();
      debugPrint("Image Uploaded $_imgUrl in else");
      // openAppSettings();
    }
    notifyListeners();
  }

  Future<void> uploadImage() async {
    if (!isPicked) {
      return debugPrint("Image not Picked");
    } else {
      await FirebaseImageUpload()
          .uploadProfileImageFile(pickedImage)
          .then((value) {
        debugPrint("Image uploaded on db url: $value");
        _imgUrl = value;
      }).onError((error, stackTrace) {
        debugPrint("Error during Uploading and getting the url \nError:$error");
      });
    }
  }


  void signup(BuildContext context) async {
    String emailText = email.text.toString().trim();
    String nameText = name.text.toString().trim();
    String pass = password.text.toString().trim();
    DateTime now = DateTime.now();
    String joinDate = DateTime(now.year, now.month, now.day).toString().replaceAll("00:00:00.000", "");
    await auth.createUserWithEmailAndPassword(
        email: emailText, password: pass)
        .then((value) async {
      setLoading(false);
      String uid = auth.currentUser!.uid;
  //    debugPrint(_imgUrl.toString());
      await uploadImage();
      debugPrint(_imgUrl.toString());
       await UserProfileStore().setUserProfileDetail(FirebaseUserDetailModel(email: emailText,
          name: nameText,
          uid: uid,
          joinDate: joinDate,
          pass: pass,
          image: _imgUrl));
       email.clear();
       name.clear();
       password.clear();
       conformPassword.clear();
      Navigator.pushNamed(context, RoutesName.signIn);
        }).onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
      setLoading(false);
    });
  }


}