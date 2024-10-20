import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Settings'),
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings Option 1'),
            onTap: () {
              // Handle option 1 tap
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Handle about tap
            },
          ),
        ],
      ),
    );
  }
}
