import 'package:ecomadmin/firebase_options.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/product_edit_provider.dart';
import 'package:ecomadmin/providers/product_post_provider.dart';
import 'package:ecomadmin/views/home_page.dart';
import 'package:ecomadmin/views/model_page.dart';
import 'package:ecomadmin/views/model_post_widget.dart';
import 'package:ecomadmin/views/products/product_edit_widget.dart';
import 'package:ecomadmin/views/products/product_post_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RouteHolder {
  final String baseRoute;
  final dynamic Function(dynamic) converterMethod;
  final Widget Function(dynamic) widgetBuilder;
  RouteHolder(
      {required this.baseRoute,
      required this.widgetBuilder,
      required this.converterMethod});
}

final logger = Logger();
void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //todo initilise firebase app
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
      GoRoute(
        path: '/products/:id',
        builder: (context, state) => ChangeNotifierProvider.value(
          value: ProductEditProvider(
            helper: ModelHelper(
              route: 'products',
              converterMethod: (res) => Product.fromMap(res),
            ),
          ),
          builder: (context, child) => Consumer<ProductEditProvider>(
            builder: (context, provider, child) => ModelPage(
              modelPageProvider: provider,
              widgetBuilder: (product) => ProductEditWidget(
                modelPageContext: context,
                product: product as Product,
                provider: provider,
              ),
              modelId: state.pathParameters['id']!,
            ),
          ),
        ),
      ),

      //todo change to more clean way
      GoRoute(
        path: '/add/products',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => ProductPostProvider(
            helper: ModelHelper(
              route: 'products',
              converterMethod: null,
            ),
          ),
          child: Consumer<ProductPostProvider>(
            builder: (context, provider, child) => ModelPostWidget(
              formBuilder: (provider) =>
                  ProductPostWidget(provider: provider as ProductPostProvider),
              provider: provider,
            ),
          ),
        ),
      )
      //todo add model/edit/:id
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
