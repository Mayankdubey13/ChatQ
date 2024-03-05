import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class LoginScreenProvide extends ChangeNotifier{
  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode loginFocus = FocusNode();

    @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();

  }
  bool _loading = false;

  bool get loading => _loading;

  bool isObx = false;
  setObs(){
    isObx = !isObx;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  void login(BuildContext context) {
    auth.signInWithEmailAndPassword(
        email: email.text.toString(), password: password.text.toString())
        .then((value) {
      Utils.toastMessage(value.user!.email.toString());
           email.clear();
           password.clear();
     Navigator.pushNamedAndRemoveUntil(context, RoutesName.homeScreen, (route)=> false);
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.toastMessage(error.toString());
    });
    notifyListeners();
  }
}