import 'package:bookcycle/pages/change_location_page.dart';
import 'package:bookcycle/pages/change_password_page.dart';
import 'package:bookcycle/pages/edit_profile_page.dart';
import 'package:bookcycle/widgets/drawer_security.dart';
import 'package:flutter/material.dart';


class ProfileDrawer extends StatefulWidget {
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),

          Row(

             children: const <Widget>[
               SizedBox(
                 width: 20,
               ),
               CircleAvatar(
               backgroundImage: AssetImage('images/logo_bookcycle.jpeg'),
                 radius: 50,
               ),
               SizedBox(
                 width: 20,
               ),
                Text(
                "Dilara Aksoy",
                 style: TextStyle(color: Colors.black,
                 fontSize: 18,
                 ),
             ),
             ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.black,
            height: 1,
            thickness: 0.5,
          ),
          const SizedBox(
            height: 20,
          ),

          buildDrawerItem(
            icon: Icons.person,
            text: "Edit Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            }
          ),
          buildDrawerItem(
            icon: Icons.security_rounded,
            text: "Security",
            onTap: () => _showEditProfileBottomSheet(context),
          ),


          buildDrawerItem(
            icon: Icons.book,
            text: "My Advertisement",
            onTap: () {
              // Handle My Advertisement tap
            },
          ),
          buildDrawerItem(
            icon: Icons.logout,
            text: "Logout",
            onTap: () {
              // Handle Logout tap
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
void _showEditProfileBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Security',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(thickness: 2,),

            ListTile(
              leading: const Icon(
                  Icons.location_on,
                  color: Color(0xFF88C4A8)),
              title: Text('Change Location'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ChangeLocation()),
                );
              },
            ),
            const Divider(thickness: 1,),

            ListTile(
              leading: const Icon(
                  Icons.lock,
                  color: Color(0xFF88C4A8)
              ),
              title: Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ChangePassword()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget buildDrawerItem({required IconData icon, required String text, required void Function() onTap}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onTap,
  );
}
