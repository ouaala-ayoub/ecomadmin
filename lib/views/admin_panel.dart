import 'package:ecomadmin/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  final AuthProvider authProvider;
  const AdminPanel({required this.authProvider, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('admin panel')),
      body: Center(
        child: Text('testing that shite'),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          //todo add admin informations
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Text(
                'to add admin informations',
                style: TextStyle(color: Colors.white),
              )),
          ListTile(
            title: Text('Produits'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Commandes'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Categories'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Admins'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () => authProvider.logout(),
          ),
        ]),
      ),
    );
  }
}
