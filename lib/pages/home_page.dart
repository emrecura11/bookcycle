import 'package:flutter/material.dart';
import '../widgets/bottomnavbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECDC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Ara...',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search), // Arama ikonu
                  onPressed: () {
                    // Arama işlemini başlatmak için bir diyalog veya yeni sayfa açabilirsiniz.
                  },
                ),
              ],
            ),
            Text('Ana Sayfa İçeriği Burada'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}