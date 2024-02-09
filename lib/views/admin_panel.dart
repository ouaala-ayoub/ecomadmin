import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:ecomadmin/models/helpers/model_helper.dart';
import 'package:ecomadmin/providers/admin_panel_provider.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:ecomadmin/views/filterable_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Holder {
  final dynamic Function(dynamic) converter;
  final Widget Function(BuildContext, dynamic) builder;
  final String route;
  Holder({required this.converter, required this.builder, required this.route});
}

class AdminPanel extends StatelessWidget {
  final AuthProvider authProvider;
  final AdminPanelProvider panelProvider;
  static const titles = ['Produits', 'Commandes', 'Categories', 'Admins'];
  final widgets = [
    Holder(
        converter: (res) => Admin.fromMap(res),
        builder: (context, data) => Text(data.toString()),
        route: 'admins'),
  ]
      .map(
        (element) => ChangeNotifierProvider(
          create: (context) => FilterableListProvider(
            ModelHelper(
                converterMethod: element.converter, route: element.route),
          ),
          child: Consumer<FilterableListProvider>(
            builder: (context, provider, child) => FilterableListWidget(
                itemBuilder: element.builder, provider: provider),
          ),
        ),
      )
      .toList();
  // static List<Widget> widgets = [Admin]
  //     .map((type) => ChangeNotifierProvider(
  //         create: (context) => FilterableListProvider<>()))
  //     .toList();
  AdminPanel(
      {required this.authProvider, super.key, required this.panelProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[panelProvider.index])),
      body: widgets[0],
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
              children: titles.map((element) {
                final index = titles.indexOf(element);
                return ListTile(
                  title: Text(element),
                  onTap: () {
                    panelProvider.setIndex(index);
                    context.pop();
                  },
                );
              }).toList(),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () => authProvider.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
