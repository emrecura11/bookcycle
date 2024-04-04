import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookcycle/pages/home_page.dart';
import 'package:bookcycle/pages/profile_page.dart';
import 'package:bookcycle/pages/addingBook_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;




  @override
  void initState() {
    super.initState();
    _loadIndex();
  }

  _loadIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = (prefs.getInt('selectedIndex') ?? 0);
    });
  }

  _saveIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _saveIndex(index);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    AddBookPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: kToolbarHeight + 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildIcon(Icons.home_outlined, Icons.home, 0),
              _buildIcon(Icons.messenger_outline, Icons.messenger, 1),
              _buildIcon(Icons.add_circle_outline, Icons.add_circle, 2, size: 30),
              _buildIcon(Icons.favorite_border_outlined, Icons.favorite, 3),
              _buildIcon(Icons.person_2_outlined, Icons.person_2, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData outlineIcon, IconData solidIcon, int index, {double size = 24.0}) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: Icon(_selectedIndex == index ? solidIcon : outlineIcon, size: size),
    );
  }
}
