import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/model_page_provider.dart';
import 'package:ecomadmin/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RouteHolder {
  final String baseRoute;
  final Widget widget;
  RouteHolder({required this.baseRoute, required this.widget});
}

final routes = [
  RouteHolder(
    baseRoute: 'products',
    widget: Scaffold(
      body: Text('products'),
    ),
  ),
  RouteHolder(
    baseRoute: 'orders',
    widget: Scaffold(
      body: Text('orders'),
    ),
  ),
  RouteHolder(
    baseRoute: 'categories',
    widget: Scaffold(
      body: Text('categories'),
    ),
  ),
  RouteHolder(
    baseRoute: 'admins',
    widget: Scaffold(
      body: Text('admins'),
    ),
  ),
];
final logger = Logger();
void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final config = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => Consumer<AuthProvider>(
                builder: (context, provider, child) =>
                    HomePage(authProvider: provider),
              )),
      ...routes
          .map(
            (holder) => GoRoute(
              path: '/${holder.baseRoute}/:id',
              builder: (context, state) => ChangeNotifierProvider.value(
                  value: ModelPageProvider(),
                  child: Consumer<ModelPageProvider>(
                    builder: (context, value, child) {
                      final id = state.pathParameters['id']!;
                      logger.i('id is $id');
                      return holder.widget;
                    },
                  )),
            ),
          )
          .toList(),
    ],
  );

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
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: config,
        ));
  }
}
