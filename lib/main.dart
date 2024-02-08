import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final logger = Logger();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final config = GoRouter(routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => Consumer<AuthProvider>(
              builder: (context, provider, child) =>
                  HomePage(authProvider: provider),
            ))
  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider())
        ],
        child: MaterialApp.router(
          title: 'Admin panel',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            canvasColor: Colors.transparent,
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: config,
        ));
  }
}
