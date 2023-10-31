import 'package:flutter/material.dart';

class SearchBarFilterIcon extends StatelessWidget {
  final VoidCallback onFilterPressed;

  SearchBarFilterIcon({required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Üst Kısım Arama ve Filtreleme'),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: onFilterPressed,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Ara...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
