import 'package:ecomadmin/firebase_options.dart';
import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/core/order.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/model_page_provider.dart';
import 'package:ecomadmin/providers/product_post_provider.dart';
import 'package:ecomadmin/views/home_page.dart';
import 'package:ecomadmin/views/model_page.dart';
import 'package:ecomadmin/views/model_post.widget.dart';
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

final routes = [
  RouteHolder(
    baseRoute: 'products',
    converterMethod: (res) => Product.fromMap(res),
    widgetBuilder: (product) {
      final productInstance = product as Product;
      return Center(
        child: Text('${productInstance.id}'),
      );
    },
  ),
  RouteHolder(
    baseRoute: 'orders',
    converterMethod: (res) => Order.fromMap(res),
    widgetBuilder: (order) {
      final orderInstance = order as Order;
      return Center(
        child: Text('${orderInstance.id}'),
      );
    },
  ),
  RouteHolder(
    baseRoute: 'categories',
    converterMethod: (res) => Category.fromMap(res),
    widgetBuilder: (category) {
      final categoryInstance = category as Category;
      return Center(
        child: Text('${categoryInstance.id}'),
      );
    },
  ),
  RouteHolder(
    baseRoute: 'admins',
    converterMethod: (res) => Admin.fromMap(res),
    widgetBuilder: (admin) {
      final adminInstance = admin as Admin;
      return Center(
        child: Text('${adminInstance.id}'),
      );
    },
  ),
];
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
      ...routes
          .map(
            (holder) => GoRoute(
              path: '/${holder.baseRoute}/:id',
              builder: (context, state) => ChangeNotifierProvider.value(
                  value: ModelPageProvider(
                    helper: ModelHelper(
                        route: holder.baseRoute,
                        converterMethod: holder.converterMethod),
                  ),
                  child: Consumer<ModelPageProvider>(
                    builder: (context, provider, child) {
                      final id = state.pathParameters['id']!;
                      return ModelPage(
                          modelPageProvider: provider,
                          widgetBuilder: (obj) => holder.widgetBuilder(obj),
                          modelId: id);
                    },
                  )),
            ),
          )
          .toList(),
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
