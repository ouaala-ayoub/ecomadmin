import 'package:dartz/dartz.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:flutter/material.dart';

class ModelPostProvider extends ChangeNotifier {
  //the helpers could be the same object through the whole app

  ModelPostProvider({required this.helper});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  bool loading = false;
  Map<String, dynamic> body = {};
  Helper helper;

  addModel(Map<String, dynamic> body,
      {required Function(dynamic) onSuccess,
      required Function(dynamic) onFail}) async {
    loading = true;
    notifyListeners();
    final Either<dynamic, dynamic> res = await helper.postElement(body);
    res.fold((e) => onFail(e), (res) => onSuccess(res));
    loading = false;
    notifyListeners();
  }
}
