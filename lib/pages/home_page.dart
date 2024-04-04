import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/bottomnavbar.dart';
import '../widgets/filtering_widget.dart';
import 'my_advertisements.dart';
class HomePage extends StatelessWidget {
  final List<Book> books = [
    Book("Emre Cura","Book 1", "Emre Cura", "Biography", "07/2023", 'images/book.jpg',true),
    Book("Gamze Gül Uçar","Hayattan Hikayeler", "Gamze Gül Uçar", "Historical", "07/2023", 'images/book1.jpg',false),
    Book("Emre Cura","Book 3", "Emre Cura", "Biography", "07/2023", 'images/book2.jpg',true),
    Book("Emre Cura","Book 4", "Dilara Aksoy", "Biography", "07/2023", 'images/book3.jpg',false),
    Book("Emre Cura","Book 5", "Dilara Aksoy", "Biography", "07/2023", 'images/book4.png',false),
    Book("Emre Cura","Book 1", "Emre Cura", "Biography", "07/2023", 'images/book.jpg',true),
    Book("Emre Cura","Book 2", "Dilara Aksoy", "Historical", "07/2023", 'images/book1.jpg',true),
    Book("Emre Cura","Book 3", "Emre Cura", "Biography", "07/2023", 'images/book2.jpg',true),
    Book("Emre Cura","Book 4", "Dilara Aksoy", "Biography", "07/2023", 'images/book3.jpg',true),
    Book("Emre Cura","Book 5", "Dilara Aksoy", "Biography", "07/2023", 'images/book4.png',true),

  ];

  final List<List<Color>> colorPairs = [
    /*[Color(0xFFFFBA78), Colors.white],
    [Color(0xFFFFCC84), Colors.white],
    [Color(0xFFFFD991), Colors.white],
    [Color(0xFFFFE69E), Colors.white],*/

    [Color(0xFFee8959), Colors.white],
    [Color(0xFFf4a261), Colors.white],
    [Color(0xFFdda15e), Colors.white],
    [Color(0xFFf26b21), Colors.white],
  ];


  void _showFilterDialog(BuildContext context) {
    double height=MediaQuery.of(context).size.height*0.04;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {

        return Container(
          decoration: BoxDecoration(
          color: Color(0xFFFDFDFD),
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
                  'Filtreleme',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SingleChildScrollView(
                  child: FilterWidget(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade300,
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: Text(
                        'İptal',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: height),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade300,
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                      child: Text(
                        'Uygula',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {

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
                          hintText: 'Kitap Ara...',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {

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
              'Tüm Kitaplar',
              style: TextStyle(fontFamily: 'LexendExa',fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
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

              return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Horizontal ve vertical margin
              elevation: 5, // gölge efekti
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
              decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(10), // Köşe yarıçapı
              ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.horizontal(left: Radius.circular(8), right:Radius.circular(8)),
                            child: Image.asset(
                              books[index].imagePath,
                              fit: BoxFit.cover, // Görseli kutuya sığdır
                            ),
                          ),
                        ),
                        flex: 1, // Görselin genişlik payını ayarla
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    books[index].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if(books[index].isAskida)
                                    Icon(Icons.volunteer_activism, color: Color(0xFF76C893),)
                                  else
                                    Icon(Icons.volunteer_activism_outlined, color: Color(0xFF76C893),)
                                ],
                              ),
                              Text("Yazar: ${books[index].author}"),
                              Text("Kategori: ${books[index].category}"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Kullanıcı: ${books[index].user}"),
                                  Text("Tarih: ${books[index].date}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        flex: 3, // Metinlerin genişlik payı
                      ),
                    ],
                  ),
                ),
                ),
              );
            },
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
