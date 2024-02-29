import 'package:ecomadmin/main.dart';
import 'package:ecomadmin/providers/insta_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstagramLoginPage extends StatelessWidget {
  final InstaLoginProvider instaLoginProvider;
  const InstagramLoginPage({required this.instaLoginProvider, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram login'),
      ),
      body: Form(
        key: instaLoginProvider.key,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: instaLoginProvider.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : LoginBody(
                  instaLoginProvider: instaLoginProvider,
                  buildContext: context,
                ),
        ),
      ),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    required this.instaLoginProvider,
    required this.buildContext,
  });

  final InstaLoginProvider instaLoginProvider;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //todo add instagram icon
          Image.asset(
            "assets/images/Instagram_icon.webp",
            height: 130,
            width: 130,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            decoration: InputDecoration(
              label: const Text('Username'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Entrez une valeur valide";
              } else {
                return null;
              }
            },
            controller: instaLoginProvider.usernameController,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
              label: const Text('Password'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Entrez une valeur valide";
              } else {
                return null;
              }
            },
            controller: instaLoginProvider.passwordController,
            obscureText: true,
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            onPressed: () {
              if (instaLoginProvider.key.currentState!.validate()) {
                instaLoginProvider.instaLogin(
                  instaLoginProvider.usernameController.text,
                  instaLoginProvider.passwordController.text,
                  onSuccess: (res) {
                    logger.i(res);
                    buildContext.pop();
                  },
                  onFail: (e) {
                    const snackBar = SnackBar(
                      content: Text(
                        'Verifiez les informations entrées et votre connexion',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }
            },
            child: const Text('Se connecter'),
          )
        ],
      ),
    );
  }
}
