import 'package:dartz/dartz.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:flutter/material.dart';

class ModelPageProvider extends ChangeNotifier {
  final Helper helper;
  bool loading = true;
  late Either<dynamic, dynamic> model;

  ModelPageProvider({required this.helper});

  fetshModelById(String id) async {
    loading = true;
    model = await helper.getElement(id);
    loading = false;
    notifyListeners();
  }

  updateModel(String id,
      {required Function(dynamic) onFail,
      required Function(dynamic) onSuccess}) async {
    loading = true;
    notifyListeners();
    final req = await processData();
    // logger.i('body is $req');
    final Either<dynamic, dynamic> res = await helper.putElement(id, req);
    res.fold((e) => onFail(e), (res) => onSuccess(res));
    loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> processData() async => {};
}
