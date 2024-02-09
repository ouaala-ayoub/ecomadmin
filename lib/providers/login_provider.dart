import 'package:dartz/dartz.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/helpers/auth_helper.dart';
import 'package:ecomadmin/models/helpers/function_helpers.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final stateController = MaterialStatesController();

  Either<dynamic, Admin> loginRes = const Left(401);
  String? loginError;
  bool loading = false;

  checkState() {
    stateController.update(MaterialState.disabled,
        usernameController.text.isEmpty || passwordController.text.isEmpty);
  }

  setError(int? value) {
    loginError = errorFromStatusCode(value);
  }

  login(Admin admin, {required Function(Admin) onSuccess}) async {
    loading = true;
    notifyListeners();
    loginRes = await AuthHelper.login(admin.username!, admin.password!);
    loginRes.fold((e) => setError(e), (admin) => onSuccess(admin));
    loading = false;
    notifyListeners();
  }
}
