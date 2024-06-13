import 'package:bookcycle/pages/chatPartnersPage.dart';
import 'package:bookcycle/pages/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookcycle/pages/home_page.dart';
import 'package:bookcycle/pages/profile_page.dart';
import 'package:bookcycle/pages/addingBook_page.dart';

import '../service/get_user_by_id.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;

  BottomNavBar({required this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: MediaQuery.of(context).size.height*0.08,
      color: Colors.white,
      child: Container(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildIcon(Icons.home_outlined, Icons.home, 0, context),
            _buildIcon(Icons.messenger_outline, Icons.messenger, 1, context),
            _buildIcon(Icons.add_circle_outline, Icons.add_circle, 2, context, size: 30),
            _buildIcon(Icons.favorite_border_outlined, Icons.favorite, 3, context),
            _buildIcon(Icons.person_2_outlined, Icons.person_2, 4, context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData outlineIcon, IconData solidIcon, int index, BuildContext context, {double size = 24.0}) {
    return IconButton(
      onPressed: () {
        if (widget.selectedIndex != index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              switch (index) {
                case 0:
                  return HomePage();
                case 1:
                  return ConversationListPage();
                case 2:
                  return AddBookPage();
                case 3:
                  return FavoritesPage();
                case 4:
                  return FutureBuilder<void>(
                    future: _loadIndex(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ProfilePage(userFuture: getUserInfo(currentUserId!));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                default:
                  return HomePage();
              }
            }),
          );
        }
      },
      icon: Icon(widget.selectedIndex == index ? solidIcon : outlineIcon, size: size),
    );
  }
}
