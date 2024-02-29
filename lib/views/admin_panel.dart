import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/core/order.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/admin_panel_provider.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:ecomadmin/views/categories/category_widget.dart';
import 'package:ecomadmin/views/filterable_list_widget.dart';
import 'package:ecomadmin/views/orders/order_widget.dart';
import 'package:ecomadmin/views/products/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Holder {
  final dynamic Function(dynamic) converter;
  final Widget Function(BuildContext, dynamic) builder;
  final String route;
  Holder({required this.converter, required this.builder, required this.route});
}

class AdminPanel extends StatefulWidget {
  final AuthProvider authProvider;
  final AdminPanelProvider panelProvider;
  static const titles = [
    {'title': 'Produits', 'icon': Icon(Icons.shopping_bag_sharp)},
    {'title': 'Commandes', 'icon': Icon(Icons.attach_money)},
    {'title': 'Categories', 'icon': Icon(Icons.category)},
  ];
  static final keys = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
  static final holders = [
    Holder(
        converter: (res) => Product.fromMap(res),
        builder: (context, data) => ProductWidget(product: data),
        route: 'products'),
    Holder(
        converter: (res) => Order.fromMap(res),
        builder: (context, data) => OrderWidget(
              order: data as Order,
            ),
        route: 'orders'),
    Holder(
        converter: (res) => Category.fromMap(res),
        builder: (context, data) => CategoryWidget(category: data as Category),
        route: 'categories'),
    //todo add admin
    // Holder(
    //     converter: (res) => Admin.fromMap(res),
    //     builder: (context, data) => AdminWidget(admin: data as Admin),
    //     route: 'admins'),
  ];

  const AdminPanel(
      {required this.authProvider, super.key, required this.panelProvider});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final widgets = AdminPanel.holders.map(
    (element) {
      final index = AdminPanel.holders.indexOf(element);
      return ChangeNotifierProvider.value(
        value: FilterableListProvider(
          ModelHelper(converterMethod: element.converter, route: element.route),
        ),
        builder: (context, child) => Consumer<FilterableListProvider>(
          builder: (context, provider, child) => FilterableListWidget(
            key: AdminPanel.keys[index],
            itemBuilder: element.builder,
            provider: provider,
            route: element.route,
            canLook: index != 2,
          ),
        ),
      );
    },
  ).toList();

  // final widgets = [Text('0'), Text('1'), Text('2'), Text("3")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AdminPanel.titles[widget.panelProvider.index]['title']
              .toString())),
      body: widgets[widget.panelProvider.index],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              child: widget.authProvider.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : widget.authProvider.auth.fold(
                      (e) => const Center(
                        child: Text('Unexpected error'),
                      ),
                      (admin) => Center(
                          child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: [
                            const TextSpan(text: 'Nom d utilisateur :'),
                            TextSpan(
                              text: ' ${admin.username}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
            ),
            Column(
              children: AdminPanel.titles.map((element) {
                final index = AdminPanel.titles.indexOf(element);
                return ListTile(
                  leading: element['icon'] as Widget,
                  title: Text(element['title'].toString()),
                  onTap: () {
                    widget.panelProvider.setIndex(index);
                    context.pop();
                  },
                );
              }).toList()
                ..add(
                  //todo add instagram picture
                  ListTile(
                    title: Text('Lier avec instagram'),
                    onTap: () => context.push('/insta_login'),
                  ),
                ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Se déconnecter'),
              onTap: () => widget.authProvider.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
