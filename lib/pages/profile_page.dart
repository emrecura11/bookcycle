import 'package:bookcycle/pages/bookDetails_page.dart';
import 'package:bookcycle/widgets/basic_button.dart';
import 'package:bookcycle/widgets/drawer_profile.dart';
import 'package:flutter/material.dart';

import '../widgets/bottomnavbar.dart';

void main() {
  runApp(MyApp());
}

class Book {
  final String title;
  final String author;
  final String category;
  final String date;
  final String imagePath;

  Book(this.title, this.author,this.category, this.date, this.imagePath);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Book> books = [
    Book("Book 1", "Emre Cura", "Biyography", "07/2023", 'images/yarının_adamı_1.jpg'),
    Book("Book 2", "Dilara Aksoy", "Biyography", "07/2023", 'images/yarının_adamı_2.jpg'),
    Book("Book 3", "Emre Cura", "Biyography", "07/2023", 'images/yarının_adamı_1.jpg'),
    Book("Book 4", "Dilara Aksoy", "Biyography", "07/2023", 'images/yarının_adamı_2.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ProfileDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/logo_bookcycle.jpeg'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Dilara Aksoy",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.location_on,
                    color: Color(0xFF88C4A8),
                  ),
                  Text(
                    "Antalya",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "My name is Emre. I love to read historical book.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.messenger,
                    color: Color(0xFF88C4A8),
                  ),
                  BasicButton(
                      onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> ProfilePage()),);
                  },
                      buttonText: "Get Contact"
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Divider(
                color: Colors.black,
                height: 1,
                thickness: 0.5,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Advertisements",
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

                                    onPressed:  () {Navigator.push(context, MaterialPageRoute(builder:(context)=> BookDetailsPage()),);},
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
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
