import 'package:ecomadmin/providers/admin_panel_provider.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/login_provider.dart';
import 'package:ecomadmin/views/admin_panel.dart';
import 'package:ecomadmin/views/error_page.dart';
import 'package:ecomadmin/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : provider.auth.fold(
            (e) => e == 401
                ? ChangeNotifierProvider(
                    create: (context) => LoginProvider(),
                    child: Consumer<LoginProvider>(
                      builder: (context, loginProvider, child) => LoginPage(
                        authProvider: provider,
                        loginProvider: loginProvider,
                      ),
                    ),
                  )
                : ErrorPage(
                    message: e.toString(),
                    onRefresh: () => widget.authProvider.getAuth(),
                  ),
            (auth) => ChangeNotifierProvider(
                  create: (context) => AdminPanelProvider(),
                  child: Consumer<AdminPanelProvider>(
                    builder: (context, adminPanelProvider, child) => AdminPanel(
                      panelProvider: adminPanelProvider,
                      authProvider: provider,
                    ),
                  ),
                ));
  }
}
