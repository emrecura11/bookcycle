import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookcycle/pages/change_location_page.dart';
import 'package:bookcycle/pages/change_password_page.dart';
import 'package:bookcycle/pages/edit_profile_page.dart';
import 'package:bookcycle/pages/login_page.dart';
import 'package:bookcycle/pages/my_advertisements_page.dart';
import 'package:flutter/material.dart';

import 'package:bookcycle/models/User.dart';
import 'package:bookcycle/service/get_user_by_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/delete_user.dart';

class ProfileDrawer extends StatefulWidget {
  final String userId;

  ProfileDrawer({required this.userId});

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {

  Future<User>? userFuture;

  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      setState(() {
        userFuture = getUserInfo(userId);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[

          const SizedBox(height: 20),
          FutureBuilder<User>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                return Row(
                  children: <Widget>[
                    const SizedBox(width: 20),
                    CircleAvatar(
                      backgroundImage: user.userImage != null && user.userImage!.isNotEmpty
                          ? (user.userImage!.startsWith('http')
                          ? NetworkImage(user.userImage!)
                          : MemoryImage(base64Decode(user.userImage!)) as ImageProvider<Object>)
                          : const AssetImage('images/logo_bookcycle.jpeg'),
                      radius: 50,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      user.userName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                );
              }
              return Text("No user data available");
            },

          ),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.black,
            height: 1,
            thickness: 0.5,
          ),

          const SizedBox(height: 20),
          buildDrawerItem(
            icon: Icons.person,
            text: "Profili Düzenle",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
          ),
          buildDrawerItem(
            icon: Icons.security_rounded,
            text: "Güvenlik",
            onTap: () => _showEditProfileBottomSheet(context),
          ),
          buildDrawerItem(
            icon: Icons.book,
            text: "İlanlarım",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyAdvertisementsPage()),
              );
            },
          ),
          buildDrawerItem(
            icon: Icons.logout,

            text: "Çıkış yap",
            onTap: () {
              logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false
              );
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
          color: Colors.deepOrange.shade300,
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

  void _showEditProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Wrap(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Güvenlik',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: Colors.deepOrange.shade300,
                ),
                title: Text('Hesabı Sil'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteAccountDialog(context);
                },
              ),
              const Divider(
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.lock,
                  color: Colors.deepOrange.shade300,
                ),
                title: Text('Şifreyi Değiştir'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hesabı Sil"),
          content: Text("Hesabınızı silmek istediğinizden emin misiniz?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Evet"),
              onPressed: () {
                bool isDeleted = deleteUserAccount(widget.userId) as bool;
                if(isDeleted){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hesap silinemedi!')));
                }

              },
            ),
          ],
        );
      },
    );
  }
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwtoken');
    prefs.remove('userName');
    prefs.remove('userId');
    prefs.remove('email');
    prefs.remove('password');
  }
}

Widget buildDrawerItem({required IconData icon, required String text, required void Function() onTap}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onTap,
  );
}

