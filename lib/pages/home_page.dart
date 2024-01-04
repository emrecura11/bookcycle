import 'package:flutter/material.dart';
import '../widgets/bottomnavbar.dart';

class HomePage extends StatelessWidget {
  final List<String> kitapGorselleri = [
    'images/book.jpg',
    'images/book2.jpg',
    'images/book3.jpg',
    'images/book4.png',
    'images/book1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECDC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Books...',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Arama işlemini başlatmak için bir diyalog veya yeni sayfa açabilirsiniz.
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Most Popular',
              style: TextStyle(fontFamily: 'LexendExa',fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kitapGorselleri.length + 1, // Ekstra öğe ekleyin
              itemBuilder: (BuildContext context, int index) {
                if (index == kitapGorselleri.length) {
                  // Ekstra öğe: "View All Books" butonu
                  return Container(
                    width: 135,
                    height: 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Burada "View All Books" butonuna tıklandığında yapılacak işlemi ekleyebilirsiniz.
                          // Örneğin, tüm kitapları gösteren bir sayfaya yönlendirme yapabilirsiniz.
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF88C4A8), // Buton rengi
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity, // Genişlik sınırsız
                          child: Text(
                            'View All Books',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center, // Metni tam ortaya almak için
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Kitap görselleri
                  return Container(
                    width: 135,
                    height: 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Image.asset(
                        kitapGorselleri[index],
                        width: 180,
                        height: 200,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Most Favorite',
              style: TextStyle(fontFamily: 'LexendExa',fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kitapGorselleri.length + 1, // Ekstra öğe ekleyin
              itemBuilder: (BuildContext context, int index) {
                if (index == kitapGorselleri.length) {
                  // Ekstra öğe: "View All Books" butonu
                  return Container(
                    width: 135,
                    height: 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Burada "View All Books" butonuna tıklandığında yapılacak işlemi ekleyebilirsiniz.
                          // Örneğin, tüm kitapları gösteren bir sayfaya yönlendirme yapabilirsiniz.
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF88C4A8), // Buton rengi
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity, // Genişlik sınırsız
                          child: Text(
                            'View All Books',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center, // Metni tam ortaya almak için
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Kitap görselleri
                  return Container(
                    width: 135,
                    height: 200,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Image.asset(
                        kitapGorselleri[index],
                        width: 180,
                        height: 200,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

