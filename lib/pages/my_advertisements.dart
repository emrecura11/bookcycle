import 'package:bookcycle/widgets/basic_button.dart';
import 'package:bookcycle/widgets/drawer_profile.dart';
import 'package:flutter/material.dart';

import '../widgets/bottomnavbar.dart';

void main() {
  runApp(MyApp());
}

class Book {
  final String user;
  final String title;
  final String author;
  final String category;
  final String date;
  final String imagePath;
  final bool isAskida;

  Book(this.user,this.title, this.author,this.category, this.date, this.imagePath, this.isAskida);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAdvertisements(),
    );
  }
}

class MyAdvertisements extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Book> books = [
    Book("Emre Cura","Book 1", "Emre Cura", "Biyography", "07/2023", 'images/yarının_adamı_1.jpg',true),
    Book("Emre Cura","Book 2", "Dilara Aksoy", "Biyography", "07/2023", 'images/yarının_adamı_2.jpg',true),
    Book("Emre Cura","Book 3", "Emre Cura", "Biyography", "07/2023", 'images/yarının_adamı_1.jpg',true),
    Book("Emre Cura","Book 4", "Dilara Aksoy", "Biyography", "07/2023", 'images/yarının_adamı_2.jpg',true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24.0),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "My Advertisements",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),


              // ListView
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10), // Sağdan ve soldan 5 dp uzaklık
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity, // ListTile'ın genişliği
                          height: 140, // ListTile'ın yüksekliği
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFECDC), // Arka plan rengi
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
