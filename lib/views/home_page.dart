import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/views/admin_panel.dart';
import 'package:ecomadmin/views/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final AuthProvider authProvider;
  const HomePage({required this.authProvider, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.authProvider.getAuth();
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.authProvider;
    return provider.loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : provider.auth.fold(
            (e) => e == 'Unauthorized' && e == 'no session cookie'
                ? LoginPage()
                : ErrorWidget(e),
            (auth) => AdminPanel());
  }
}
