import 'package:dartz/dartz.dart';
import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/helpers/auth_helper.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  late Either<dynamic, Admin> auth;
  bool loading = false;

  getAuth() async {
    loading = true;
    auth = await AuthHelper.getAuth();
    loading = false;
    notifyListeners();
  }

  login(Admin admin) async {
    loading = true;
    notifyListeners();
    auth = await AuthHelper.login(admin.username!, admin.password!);
    logger.i("auth ${auth.toString()}");
    loading = false;
    notifyListeners();
  }
}
