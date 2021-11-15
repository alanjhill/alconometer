import 'package:alconometer/features/auth/authentication_service.dart';
import 'package:alconometer/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('App Drawer'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              await Provider.of<AuthenticationService>(context, listen: false).logout();
              await Navigator.of(context).pushReplacementNamed('/');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
