import 'package:ecomadmin/models/helpers/auth_helper.dart';
import 'package:flutter/material.dart';

class InstaLoginProvider extends ChangeNotifier {
  final key = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  instaLogin(username, password,
      {required Function(dynamic) onSuccess,
      required Function(dynamic) onFail}) async {
    loading = true;
    notifyListeners();
    final res = await AuthHelper.instaLogin(username, password);
    res.fold((e) => onFail(e), (res) => onSuccess(res));
    loading = false;
    notifyListeners();
  }
}
