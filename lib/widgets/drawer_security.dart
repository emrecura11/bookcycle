import 'package:flutter/material.dart';

class SecurityDrawer extends StatefulWidget {
  @override
  _SecurityDrawerState createState() => _SecurityDrawerState();
}

class _SecurityDrawerState extends State<SecurityDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          buildDrawerItem(
            icon: Icons.person,
            text: "Change Password",
            onTap: () {
              // Handle Edit Profile tap
            },
          ),
          buildDrawerItem(
            icon: Icons.security_rounded,
            text: "Change Location",
            onTap: () {
              // Handle Security tap
            },
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem({required IconData icon, required String text, required void Function() onTap}) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF88C4A8),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
