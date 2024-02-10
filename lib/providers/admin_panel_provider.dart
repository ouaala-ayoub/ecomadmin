import 'package:ecomadmin/main.dart';
import 'package:flutter/material.dart';

class AdminPanelProvider extends ChangeNotifier {
  int index = 0;

  setIndex(int newIndex) {
    index = newIndex;
    logger.i(index);
    notifyListeners();
  }
}
