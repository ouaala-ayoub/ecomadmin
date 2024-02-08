import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final stateController = MaterialStatesController();

  checkState() {
    stateController.update(MaterialState.disabled,
        usernameController.text.isEmpty || passwordController.text.isEmpty);
  }
}
