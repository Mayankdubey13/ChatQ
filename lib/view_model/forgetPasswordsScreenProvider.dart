import 'package:flutter/cupertino.dart';

class ForgetPasswordScreenProvider extends ChangeNotifier{
  TextEditingController email = TextEditingController();
  TextEditingController forgetPassword = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode loginFocus = FocusNode();
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

}