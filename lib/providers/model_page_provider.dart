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
}
