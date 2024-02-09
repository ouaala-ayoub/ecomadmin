import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/login_provider.dart';
import 'package:flutter/material.dart';

import 'styled_text_field.dart';

class LoginPage extends StatelessWidget {
  final AuthProvider authProvider;
  final LoginProvider loginProvider;
  const LoginPage(
      {required this.authProvider, required this.loginProvider, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginProvider.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : loginBody(),
    );
  }

  Center loginBody() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SelectableText(
            'Se connecter',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 50,
          ),
          StyledTextField(
            onChanged: (value) => loginProvider.checkState(),
            label: "Nom d'utilisateur",
            prefixIcon: const Icon(Icons.person),
            controller: loginProvider.usernameController,
          ),
          const SizedBox(
            height: 15,
          ),
          StyledTextField(
            onChanged: (value) => loginProvider.checkState(),
            prefixIcon: const Icon(Icons.lock),
            label: 'Mot de passe',
            controller: loginProvider.passwordController,
          ),
          loginProvider.loginError != null
              ? Text(
                  '${loginProvider.loginError}',
                  style: const TextStyle(color: Colors.red),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
              onPressed: () {
                final creds = Admin(
                    username: loginProvider.usernameController.text,
                    password: loginProvider.passwordController.text);

                logger.i(creds.toMap());

                loginProvider.login(creds,
                    onSuccess: (admin) => authProvider.setAuth(admin));
              },
              child: const Text('Connexion')),
        ],
      ),
    ));
  }
}
