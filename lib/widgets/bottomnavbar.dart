import 'package:flutter/material.dart';
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

        backgroundColor: const Color(0xFFD6CB7D) ,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF88C4A8),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),

            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: ClipOval(
              child: Container(
                width: 60,
                height: 60,
                color:  const Color(0xFF88C4A8),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      );
  }}