import 'package:dartz/dartz.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/helpers/auth_helper.dart';
import 'package:ecomadmin/models/helpers/cookie_helpers.dart';
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

  setAuth(Admin admin) {
    auth = Right(admin);
    notifyListeners();
  }

  logout() async {
    await deleteSessionCookie();
    getAuth();
  }
}
