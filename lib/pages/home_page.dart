import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/filtering_widget.dart';
import 'my_advertisements.dart';
class HomePage extends StatelessWidget {
  final List<Book> books = [
    Book("Book 1", "Emre Cura", "Biography", "07/2023", 'images/book.jpg'),
    Book("Book 2", "Dilara Aksoy", "Historical", "07/2023", 'images/book1.jpg'),
    Book("Book 3", "Emre Cura", "Biography", "07/2023", 'images/book2.jpg'),
    Book("Book 4", "Dilara Aksoy", "Biography", "07/2023", 'images/book3.jpg'),
    Book("Book 5", "Dilara Aksoy", "Biography", "07/2023", 'images/book4.png'),

  ];

  final List<List<Color>> colorPairs = [
    [Color(0xFFF8BBD0), Colors.white],
    [Colors.white, Color(0xFF80cbc4)],

    [Color(0xFF81c784), Colors.white],
    [Colors.white, Color(0xFFFFCDD2)],

    [Color(0xFFFF7043), Colors.white],
    [Colors.white, Color(0xFFFFA726)],

    [Colors.white, Color(0xFF80cbc4)],
    [Color(0xFFA5D6A7), Colors.white],
    [Colors.white, Color(0xFF9ccc65)],


  ];


  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {

        return Container(
          decoration: BoxDecoration(
          color: Color(0xFFFDFDFD), // Arka plan rengi olarak açık mavi kullanıldı
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
          padding: EdgeInsets.all(16.0),
          height:  MediaQuery.of(context).size.height*0.8 ,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // İçerik boyutuna göre boyutlandır
              children: <Widget>[
                Text(
                  'Filter Books',
                  style: TextStyle(fontFamily: 'LexendExa',
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SingleChildScrollView(
                  child: FilterWidget(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF88C4A8),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // BottomSheet'i kapat
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF88C4A8),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // Filtreleme uygulama işlevi
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 20),
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
                      padding: const EdgeInsets.all(0.0),
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
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () => _showFilterDialog(context),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'All Books',
              style: TextStyle(fontFamily: 'LexendExa',fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (BuildContext context, int index) {
                final gradientColors = colorPairs[index % colorPairs.length];

                final gradient = LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                );

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10), // Sağdan ve soldan 5 dp uzaklık
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity, // ListTile'ın genişliği
                        height: 140, // ListTile'ın yüksekliği
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(8), // Köşe yarıçapı
                        ),
                        child: ListTile(
                          leading: Image.asset(books[index].imagePath, width: 70, height: 100), // Resim boyutu
                          title: Text(books[index].title,
                            style:
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8),
                              Text(
                                "Author: ${books[index].author}",
                              ),
                              SizedBox(height: 4),
                              Text(
                                  "Category: ${books[index].category}"
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const  Color(0xFFBA9999),
                                        padding: const EdgeInsets.symmetric(horizontal: 10,),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),

                                      onPressed:  () {},
                                      child: const Text('See more details'),
                                    ),
                                    Text("Date: ${books[index].date}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.all(10), // İçerik boşluğu
                        ),
                      ),
                      SizedBox(height: 10), // Elemanlar arasında 10 dp boşluk
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
