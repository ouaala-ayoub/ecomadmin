import 'package:ecomadmin/models/core/admin.dart';
import 'package:ecomadmin/models/core/helper.dart';
import 'package:ecomadmin/providers/admin_panel_provider.dart';
import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:ecomadmin/providers/filtrable_list_provider.dart';
import 'package:ecomadmin/views/filterable_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatelessWidget {
  final AuthProvider authProvider;
  final AdminPanelProvider panelProvider;
  static const titles = ['Produits', 'Commandes', 'Categories', 'Admins'];

  // static List<Widget> widgets = [Admin]
  //     .map((type) => ChangeNotifierProvider(
  //         create: (context) => FilterableListProvider<>()))
  //     .toList();
  const AdminPanel(
      {required this.authProvider, super.key, required this.panelProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[panelProvider.index])),
      body: ChangeNotifierProvider(
        create: (context) => FilterableListProvider(Helper()),
        child: Consumer<FilterableListProvider>(
          builder: (context, filterProvider, child) => FilterableListWidget(
            provider: filterProvider,
            itemBuilder: (context, item) => Text(item.toString()),
          ),
        ),
      ),
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
