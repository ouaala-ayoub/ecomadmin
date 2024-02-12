import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/core/category.dart';
import 'package:ecomadmin/models/core/order.dart';
import 'package:ecomadmin/models/core/product.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/admin_panel_provider.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:ecomadmin/views/filterable_list_widget.dart';
import 'package:ecomadmin/views/product_widget.dart';
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
  static const titles = ['Produits', 'Commandes', 'Categories', 'Admins'];
  static final keys = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
  static final holders = [
    Holder(
        converter: (res) => Product.fromMap(res),
        builder: (context, data) => ProductWidget(product: data),
        route: 'products'),
    Holder(
        converter: (res) => Order.fromMap(res),
        builder: (context, data) => Text(
              data.toString(),
            ),
        route: 'orders'),
    Holder(
        converter: (res) => Category.fromMap(res),
        builder: (context, data) => Text(
              data.toString(),
            ),
        route: 'categories'),
    Holder(
        converter: (res) => Admin.fromMap(res),
        builder: (context, data) => Text(
              data.toString(),
            ),
        route: 'admins'),
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
          ),
        ),
      );
    },
  ).toList();

  // final widgets = [Text('0'), Text('1'), Text('2'), Text("3")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AdminPanel.titles[widget.panelProvider.index])),
      body: widgets[widget.panelProvider.index],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //todo add admin informations
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.red),
                child: Text(
                  'to add admin informations',
                  style: TextStyle(color: Colors.white),
                )),
            Column(
              children: AdminPanel.titles.map((element) {
                final index = AdminPanel.titles.indexOf(element);
                return ListTile(
                  title: Text(element),
                  onTap: () {
                    widget.panelProvider.setIndex(index);
                    context.pop();
                  },
                );
              }).toList(),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () => widget.authProvider.logout(),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.panelProvider.index != 1
          ? FloatingActionButton(
              onPressed: () => context.push(
                '/add/${AdminPanel.holders[widget.panelProvider.index].route}',
              ),
              child: const Icon(
                Icons.add_circle_sharp,
                color: Colors.black,
              ),
            )
          : null,
    );
  }
}
